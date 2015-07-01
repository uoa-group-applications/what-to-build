# Useful scripts to help manage git/gerrit/release interactions

This repository contains some convenience scripts to help your happy flow flow more happily!

Contained within:

* `wtb.tcl`: What to build - a simple script that helps you discover which artifacts could do with a release.
* `gbi.tcl`: Go build it! - script that performs the mundane tasks of releasing your module to gerrit and merging to master.
* `gerrit-init`: A quick bash script you run on a repository to get your remotes setup properly.

## How to use

Just put all these scripts in `$HOME/bin` (if that's on your PATH) or otherwise `/usr/local/bin` is a good place for this kind of thing.

## Assumes

Your repository is setup in a way congruent to UoA standards

* Gerrit
* Git

## Requires

* Tcl
* Git
* Maven 
* Figlet (for cool graphics!)

## Scripts

### gerrit-init

Initializes a git repository to have the proper remotes for gerrit interactions. Just run the script in the root folder of your git repository.

### wtb.tcl

It updates all the maven modules it can find in the folder you're executing the script in.

It then pulls down master and develop branches to determine if they are out of synch.

To use this script, just change to the folder your maven modules live in and run the command.

### gbi.tcl

This script will help you build an artifact without too much hassle using the instructions found at: 

	https://wiki.auckland.ac.nz/pages/viewpage.action?pageId=65015035#SoftwareDevelopmentusingGit/Stash/Gerrit-Release.

There are two parts to the script, one part that takes care of the work up until the release reviews that go to gerrit. And then, from the point at which the reviews have been merged to the merging of the functionality into master.

