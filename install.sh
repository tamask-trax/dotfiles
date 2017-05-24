#!/bin/bash

set -euo pipefail

dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
olddir=~/dotfiles_old
files="bashrc vimrc fonts.conf tmux.conf"    # list of files/folders to symlink in homedir

echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dotfiles_dir directory"
cd $dotfiles_dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
    if [ -f "${HOME}/.${file}" ]; then
        mv "${HOME}/.${file}" ~/dotfiles_old/
    fi
    echo "Creating symlink to $file in home directory."
    ln -s "$dotfiles_dir/$file" ~/.$file
done

function install_vim {
    echo
    read -p "Install vim plugins now [Yy]?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        vundle_dir="${HOME}/.vim/bundle/Vundle.vim"
        if [ ! -d "$vundle_dir" ]; then
            git clone https://github.com/VundleVim/Vundle.vim.git "$vundle_dir"
        fi
        vim +PluginInstall +qall
    fi
}

install_vim
