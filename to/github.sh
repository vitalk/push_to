#!/usr/bin/env bash
# The script that push existing repository to github through github API.

# Copyright © 2012 Vital Kudzelka.
# Use it for Good not Evil.

GITHUB='git@github.com'
GITHUB_API_URL='https://api.github.com'

ABS_PATH=`dirname "$0"`
source "${ABS_PATH}/extra_stuff.sh"

ORIGINAL=`pwd`
TMP="/tmp/push_to.$(randstr 8)"

function github() {
    # ask github credentials or read from config
    github_username=$(git config --global github.user || ask "What is your github username?")
    # ask repos name, description or get from config
    repos_name=$( ask "Enter your repository name(${ORIGINAL##*/} by default):" ${ORIGINAL##*/} )
    repos_description=$( ask "Enter your repository description(empty by default):" )

    # check exists that name or not on github and cache that value
    echo "Checking exists that name or not on your github account. This may take awhile..."
    curl --silent --output $TMP $GITHUB_API_URL/users/$github_username/repos
    # ask unique repository name
    while grep -e "\"name\": \"$repos_name\"" $TMP > /dev/null; do
        echo "Repository with that name already exists on your github account!"
        repos_name=$( ask "Please, select another name:" )

        # not empty name
        # just for fun
        local i=0
        while [[ -n $repos_name ]]; do
            if [[ -n $repos_name && i -eq 0 ]]; then
                let "i += 1"
                repos_name=$( ask "Please provide not empty name:" )
            elif [[ -n $repos_name && i -eq 1 ]]; then
                let "i += 1"
                repos_name=$( ask "Please provide not EMPTY name:" )
            elif [[ -n $repos_name && i -eq 2 ]]; then
                let "i += 1"
                repos_name=$( ask "Please provide NOT EMPTY name:" )
            else
                repos_name=$( ask "DAMN, NOT EMPTY NAME:" )
            fi
        done
    done

    # if not exists create new one
    echo "Creating new repository on github..."
    echo "Please wait, this may take a few seconds..."
    github_password=$( git config --global github.token || ask "What is your github password:" )
    curl --silent --output $TMP -u "$github_username:$github_password" $GITHUB_API_URL/user/repos \
        -d "{\"name\": \"$repos_name\", \"description\": \"$repos_description\"}"
    echo "New repository created successfully."

    # then push and add new remote
    remote_name=$( ask "Enter remote name for github(origin by default):" origin )
    cd "$ORIGINAL" && add_remote $remote_name "$GITHUB:$github_username/$repos_name.git"
    echo "Pushing the last changes to github..."
    git push -u $remote_name master
    echo "Well done."

    # cleanup
    rm -f $TMP
}

# git and curl required
require curl
require git

# actually do it
github
