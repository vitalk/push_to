#!/usr/bin/env bash
# Duplicate existing git repository to dropbox folder

# Copyright © 2012 Vital Kudzelka.
# Use it for Good not Evil.


# dropbox sync folder name
DROPBOX=Dropbox

ABS_PATH=`dirname "$0"`
source "${ABS_PATH}/extra_stuff.sh"

# duplicate existing git repository to dropbox folder
function dropbox() {
    local original tail to to_clone
    original=`pwd`
    # home-relative path to repos
    tail="${original#$HOME/}"
    # exclude top repos dir
    to="${tail%/*}"
    # path to new bare repos
    to_clone="$HOME/$DROPBOX/$tail.git"

    if [[ -d "$to_clone" ]]; then
        echo "Repository '$(tilde $to_clone)' already exists"
        exit $SUCCESS
    fi

    # create dir hierarchy on dropbox dir
    mkdir -p "$HOME/$DROPBOX/$to" && cd "$HOME/$DROPBOX/$to"

    # clone to bare repos
    git clone --bare "$original"
    echo "New bare repository created at '$(tilde $to_clone)'"

    # then add as remote to original repos
    cd "$original" && add_remote dropbox "$to_clone"
}

require git

# actually do it
dropbox
