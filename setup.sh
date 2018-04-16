#!/usr/bin/env bash

set -e
set -o pipefail
set -o errtrace
set -o nounset

# To be run within the root of the dotfiles repo.  Install the 

# If $1 is a link, remove it.  Otherwise mv it to $1.old (after
# removing $1.old if it exists).
save_old() {
    if [ -L "$1" ]; then
	rm -f "$1"
    elif [ -e "$1" ]; then
	OLD="${1}.old"
	if [ -d "$OLD" -a ! -L "$OLD" ]; then
	    rm -rf "$OLD"
	elif [ -e "$OLD" ]; then
	    rm -f "$OLD"
	fi
	mv -- "$1" "$OLD"
    fi
}

symlink_replace() {
    save_old "$HOME/$2"
    ln -s "$PWD/$1" "$HOME/$2"
}

symlink_replace bash_profile .bash_profile
symlink_replace bash_profile .bashrc
symlink_replace bash_profile .profile
symlink_replace gitconfig .gitconfig
symlink_replace pystartup .pystartup
symlink_replace screenrc  .screenrc
mkdir -p $HOME/.emacs.d
# move any existing .emacs out of the way, so as not to conflict with init.el
if [ -e "$HOME/.emacs" ]; then
    save_old "$HOME/.emacs"
fi
symlink_replace emacs/init.el .emacs.d/init.el
symlink_replace emacs/config  .emacs.d/config
