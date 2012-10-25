#!/usr/bin/env bash
# Push the existing git repository to endpoint location

# Copyright © 2012 Vital Kudzelka.
# Use it for Good not Evil.


ABS_PATH=`dirname "$0"`
source "$ABS_PATH/extra_stuff.sh"

# print usage help
function usage() {
    cat <<HELP
Usage: $(basename "$0") [-h|--help] dropbox
Copy exsisting git repos to predefined destination.

  -h, --help            display this help and exit
HELP
}

# main loop
function loop() {
    while (($#)); do
        case "$1" in
            -h|--help)
                usage;
                exit $SUCCESS;
                ;;
            *)
                to="$ABS_PATH/to/$1.sh"
                if [[ -e $to && -r $to ]]; then
                    prepare && source $to
                    exit $SUCCESS;
                fi
                [ "$1" == "--" ] && shift;
                if (($#)); then
                    echo "Usage error: unrecognized option" && usage;
                    exit $E_BAD_PARAMS;
                fi;
        esac
    done
}

loop $@

exit $SUCCESS;
