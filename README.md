# what-to-build

Simple script that helps you discover which artifacts could do with a release.

It updates all the maven modules it can find in the folder you're executing the script in.

It will then proceed to pull down master and develop branches to determine if they are out of synch.

## Assumes

Your repository is setup in a way congruent to UoA standards

* Gerrit
* Git

## Requires

* Git
* Figlet (for cool graphics!)

## How to use

Go to the folder your maven modules live in, run the command.

You can put it in your `$HOME/bin` folder or somewhere in `/usr/local/bin`.


