# push to

Script that push existing git repos to predefined location. For example, to
create a bare copy of repos on Dropbox folder.

## Usage

To easy use add some extra stuff to your `.bashrc`(don't forgot to replace
'path/to/push_to' with actual path):

```bash
# add alias to script
alias push_to="path/to/push_to.sh"
# add tab completion for avaliable destinations
function __push_to_completion() {
    local cur

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}

    case "$cur" in
        -*)
            COMPREPLY=( $(compgen -W '-h --help' -- $cur) )
            ;;
        *)
            COMPREPLY=( $(compgen -W "$(for f in `ls path/to/push_to/to | grep .sh$`; do echo ${f%.sh}; done)" -- $cur) )
            ;;
    esac

    return $SUCCESS
}
complete -o nospace -F __push_to_completion push_to
```

And usage example:

```bash
$ cd my/git/repos
$ push_to dropbox
```

### Walktrought

The basic idea that script looking for executables on `to` directory and then
execute it if it filename passed as script param(without extension). For
example, `push_to dropbox` executes the `to/dropbox.sh` script that actually do
all work.

Use `to/sample.sh` as example of extension file.

## About

My name is Vital Kudzelka <vital.kudzelka@gmail.com>. Fell free to get in
touch.
