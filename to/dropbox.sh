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
    ORIGINAL=`pwd`
    HOME=`cd ~; pwd`
    # home-relative path to repos
    TAIL="${ORIGINAL#$HOME/}"
    # exclude top repos dir
    TO="${TAIL%/*}"
    # path to cloned repos
    TO_CLONE="$HOME/$DROPBOX/$TAIL.git"

    if [[ -d "$TO_CLONE" ]]; then
        echo "Repository '$(tilde ${TO_CLONE#$HOME})' already exists"
        exit $SUCCESS
    fi

    # create dir hierarchy on dropbox dir
    mkdir -p "$HOME/$DROPBOX/$TO" && cd "$HOME/$DROPBOX/$TO"

    # clone to bare repos
    git clone --bare "$ORIGINAL"
    echo "New bare repository created at '$(tilde ${TO_CLONE#$HOME})'"

    # then add as remote to original repos
    cd "$ORIGINAL" && add_remote dropbox "$TO_CLONE"
}

require git

# actually do it
dropbox
