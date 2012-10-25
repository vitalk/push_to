#!/usr/bin/env bash
# Some globals and useful functions

# Copyright © 2012 Vital Kudzelka.
# Use it for Good not Evil.


GIT=git
SUCCESS=0
E_BAD_PARAMS=1
E_INVALID_REPOS=2

# replace home dir to tilde(~) on path
function tilde() {
    if [[ $# -ne 1 ]]; then
        echo "Usage error: provide only one param"
        exit $E_BAD_PARAMS
    fi
    local HOME=`cd ~; pwd`
    echo "~${1#$HOME}"
}

# do some checks: on git repos?
function prepare() {
    if [[ ! -d ".git" ]]; then
        echo "Usage error: current dir is not git repos"
        exit $E_INVALID_REPOS
    fi
}

# stylized output
function pretty_print() {
    echo "# ---------------------------------------------------------------------------- #"
    echo "# $1"
    echo "# ---------------------------------------------------------------------------- #"
}

# add new remote to git repos
function add_remote() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: add_remote <name> <url>"
        exit $E_BAD_PARAMS
    fi
    for remote in `$GIT remote`; do
        if [[ $remote == $1 ]]; then
            local dropbox=`$GIT remotes | grep dropbox | cut -d ' ' -f1 | uniq`
            echo "Remote $(echo $dropbox | cut -d ' ' -f1) already exists at '`tilde $(echo $dropbox | cut -d ' ' -f2)`'"
            read -n 1 -p "Do you want to overwrite it? (y/[N]) "
            echo
            if [[ $REPLY =~ ^[yY]$ ]]; then
                $GIT remote rm $1
            else
                echo "You can add remote repository later:"
                pretty_print "$GIT remote add dropbox $(tilde $2)"
                noremote=
            fi
            break
        fi
    done
    if [[ ${noremote=1} ]]; then
        $GIT remote add $1 "$2"
        echo "New remote repository named $1 added"
    fi
}
