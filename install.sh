#!/bin/bash

set -euo pipefail

dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
olddir="${HOME}/.dotfiles-old"

files="bashrc vimrc tmux.conf toprc Xresources"    # list of files/folders to symlink in homedir

echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -vp $olddir

echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
    if [ -f "${HOME}/.${file}" ] && [ ! -f "$olddir/.${file}" ]; then
        mv -v "${HOME}/.${file}" "$olddir/"
    fi
done
echo "...done"
echo

# Create symlinks
echo "Creating symlinks for dotfiles"
for file in $files; do
    if [ ! -L "${HOME}/.${file}" ]; then
        ln -vs "$dotfiles_dir/$file" "${HOME}/.${file}"
    fi
done
echo "...done"

function install_vim {
    echo
    read -p "install vim plugins now [Yy]?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        vundle_dir="${HOME}/.vim/bundle/Vundle.vim"
        if [ ! -d "$vundle_dir" ]; then
            git clone https://github.com/VundleVim/Vundle.vim.git "$vundle_dir"
        fi
        vim +PluginInstall +qall
    fi
}

function install_tpm {
    echo
    read -p "install tmux plugins now [Yy]?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        tpm_dir="${HOME}/.tmux/plugins/tpm"
        if [ ! -d "$tpm_dir" ]; then
            git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        fi
        ~/.tmux/plugins/tpm/bin/install_plugins
        ~/.tmux/plugins/tpm/bin/update_plugins all
    fi
}

install_vim
install_tpm
