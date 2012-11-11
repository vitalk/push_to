# push to

Script that push existing git repos to predefined location. For example, it
allow to create a new github repository remotely or create a bare copy of repos
on your Dropbox folder.

## Walkthrough

The basic idea that script looking for executables on `'to'` directory and then
execute it if it filename passed as script param. For example, `push_to
dropbox` executes the `'to/dropbox'` script that actually do all work.

Use `'to/sample'` as example of extension file.

### Usage

Source `'push_to_compl'` somewhere on your `'.bashrc'`. It create an alias and
shell completion for the script:

```bash
# to list avaliable commands
pust_to [Tab]
# to list avaliable options
push_to -[Tab]
```

To create a new github repository run:

```bash
cd my/git/repos
push_to github
```


## About

My name is Vital Kudzelka <vital.kudzelka@gmail.com>. Fell free to get in
touch.
