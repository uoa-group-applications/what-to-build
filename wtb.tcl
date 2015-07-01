#!/usr/bin/tclsh

namespace eval util {

	proc cls {} {
		puts [exec clear]
	}

	proc banner {bannerText} {
		puts [exec figlet -w 120 $bannerText]
	}

	#
	#	retrieve all file lines
	#
	proc get_all_lines {fp} {
		lappend lines
		while {![eof $fp]} {
			gets $fp line
			lappend lines $line
		}
		return $lines
	}

	#
	#	Get index of the first line after $start_at to mention $content
	#
	proc get_idx_of_first_line_with {lines content {start_at 0}} { 
		set idx $start_at

		foreach line [lrange $lines $start_at end] {
			if {[string first $content $line] != -1} then {
				return $idx
			}

			incr idx
		}

		return -error "no such content found"
	}

	#
	#	Get content of first line that matches $content 
	#
	proc get_first_line_with {lines content {start_at 0}} { 
		return [lindex $lines [get_idx_of_first_line_with $lines $content $start_at]]
	}

	#
	#	Extracts the tag content
	#
	proc get_tag_content {line} {
		set tag_regexp {>(.*?)</}	
		set matches [regexp -inline $tag_regexp $line]
		if {[llength $matches] > 0} then {
			return [lindex $matches 1]
		}
		return {}
	}

}


namespace eval git {

	proc update_module {module} {
		cd $module

		util::cls
		util::banner "UPDATE IN PROGRESS\n.. $module"

		exec -ignorestderr git pull origin master 
		after 500
		exec -ignorestderr git pull origin develop
		after 500
		cd ..
	}

}

namespace eval maven {

	proc get_modules {} {
		lappend modules
		set files [glob "*"]
		foreach file $files {
			if {[file isdirectory $file] && [file exists "$file/pom.xml"] && [file exists "$file/.git"]} then {
				lappend modules $file
			}
		}
		return $modules
	}


	#
	#	get the current pom.xml version
	#
	proc get_version {module} {
		set file "./$module/pom.xml"

		set fp [open $file "r"]

		set lines [util::get_all_lines $fp]
		set parent_end_tag_line [util::get_idx_of_first_line_with $lines "</parent>"]
		set version_line [util::get_first_line_with $lines "<version>" $parent_end_tag_line]
		set version_number [util::get_tag_content $version_line]

		close $fp

		return $version_number
	}

	#
	#	get the current pom.xml version
	#
	proc get_artifact_id {module} {
		set file "./$module/pom.xml"

		set fp [open $file "r"]

		set lines [util::get_all_lines $fp]
		set parent_end_tag_line [util::get_idx_of_first_line_with $lines "</parent>"]
		set artifact_line [util::get_first_line_with $lines "<artifactId>" $parent_end_tag_line]
		set artifactId [util::get_tag_content $artifact_line]

		close $fp

		return $artifactId
	}

	proc module_needs_release {module} {
		cd $module
		set output [exec git show-ref refs/heads/master refs/heads/develop]
		cd ..

		lappend refs
		foreach line [split $output \n] {
			lassign $line sha from
			lappend refs $sha
		}

		return [expr {([lindex $refs 0] != [lindex $refs 1]) ? "yes" : "no"}]
	}


}

set all_modules [maven::get_modules]
puts "All modules:\n  * [join $all_modules "\n  * "]\n\n"

foreach module $all_modules {
	git::update_module $module
}

util::cls
util::banner "What To Release:"

puts "\n"

puts [format "%-30s%-20s%-5s" {ArtifactId} {Version} {Needs release}]
puts "------------------------------------------------------------------------------------"

foreach module [maven::get_modules] {

	puts -nonewline [format "%-30s" [maven::get_artifact_id $module]] 
	puts -nonewline [format "%-20s" [maven::get_version $module]]
	puts -nonewline [format "%-5s" [maven::module_needs_release $module]]
	puts ""

}

puts ""





