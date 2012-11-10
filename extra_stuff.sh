#!/usr/bin/env bash
# Some globals and useful functions

# Copyright © 2012 Vital Kudzelka.
# Use it for Good not Evil.


SUCCESS=0
E_BAD_PARAMS=1
E_INVALID_REPOS=2
E_UNSATISFIED_REQUIREMENT=3

# replace home dir to tilde(~) on path if possible
function tilde() {
    if [[ $# -ne 1 ]]; then
        echo "Usage error: provide only one param"
        exit $E_BAD_PARAMS
    fi
    RELATIVE_PWD=${1/#$HOME/\~}
    echo -e ${RELATIVE_PWD%/}
}

# generate alphanumeric random string
function randstr() {
    cat /dev/urandom | tr -cd "[:alnum:]" | head -c ${1:-32}
}

# do some checks: we are on git repos now?
function prepare() {
    if [[ ! -d .git ]]; then
        echo "Usage error: current dir is not git repos"
        exit $E_INVALID_REPOS
    fi
}

# check for require
function require() {
    which $1 > /dev/null 2>&1 || { echo "$0 require '$1'"; exit $E_UNSATISFIED_REQUIREMENT; }
}

# ask user input or use default answer
function ask() {
    read -p "$1 "
    [[ -z $REPLY ]] && echo "${2:- }" || echo "$REPLY"
}

# stylized output
function pretty_print() {
    echo "# ---------------------------------------------------------------------------- #"
    echo "# $1"
    echo "# ---------------------------------------------------------------------------- #"
}

# add new remote to git repos
function add_remote() {
    require git

    if [[ $# -ne 2 ]]; then
        echo "Usage: add_remote <name> <url>"
        exit $E_BAD_PARAMS
    fi

    local remote noremote name reply

    for remote in `git remote`; do
        if [[ $remote == $1 ]]; then
            name=`git remotes | grep $1 | cut -d ' ' -f1 | uniq`
            echo "Remote $(echo $name | cut -d ' ' -f1) already exists at '`tilde $(echo $name | cut -d ' ' -f2)`'"
            reply=$( ask "Do you want to overwrite it? (y/[N])" )
            if [[ $reply =~ ^[yY] ]]; then
                git remote rm $1
            else
                echo "You can add remote repository later:"
                pretty_print "git remote add $1 $(tilde $2)"
                noremote=
            fi
            break
        fi
    done
    if [[ ${noremote=1} ]]; then
        git remote add $1 "$2"
        echo "New remote repository named $1 added"
    fi
}
