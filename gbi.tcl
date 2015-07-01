#!/usr/bin/tclsh

#
# Go build it.
#
# Based on: https://wiki.auckland.ac.nz/pages/viewpage.action?pageId=65015035#SoftwareDevelopmentusingGit/Stash/Gerrit-Release
#


namespace eval util {

	proc cls {} {
		puts [exec clear]
	}

	proc banner {bannerText} {
		puts [exec figlet -w 120 $bannerText]
	}

}

proc go_build_it! {module step} {

	util::cls

	util::banner "releasing\n$module"

	cd $module

	if {$step == "review"} {
		step1 $module 
	} elseif {$step == "merged"} {
		step2 $module
	} else {
		error "Expected one of these steps: review, merged"
	}

	cd ..
}

# step 1. make a review
proc step1 {module} {

	util::banner "Release and push for review"

	# update to latest
	exec -ignorestderr git checkout develop
	exec -ignorestderr git pull origin develop

	# do release
	exec mvn --batch-mode release:prepare release:perform

	# perform push for review and new tag
	exec -ignorestderr git push for-review

}

proc step2 {module} {

	util::banner "Merge into master"

	# step 2. merge +2'ed thing into master
	exec -ignorestderr git push --tags
	exec -ignorestderr git pull origin develop

	exec -ignorestderr git checkout master
	exec -ignorestderr git merge develop
	exec -ignorestderr git push origin master
	exec -ignorestderr git push --tags

	# step 4. get back to develop
	exec -ignorestderr git checkout develop
}


if {$argc == 2} then {
	go_build_it! {*}$argv
} else {
	util::banner "?ERROR."
	puts "Usage: $argv0 modulename <review, merged>\n"
}
