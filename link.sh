#!/bin/bash

set -x
script_dir=$(pwd $(cd $(readlink $0)))

# vim/deinディレクトリ作成
if [ ! -d $HOME/.config/vim/dein ]; then
	mkdir -p ~/.config/vim/dein
fi

# オリジナルのvimrcを退避
if [ -f $HOME/.vimrc ]; then
	if [ ! -f $HOME/.vimrc.ORIG ]; then
		cp $HOME/.vimrc $HOME/.vimrc.ORIG
	fi
fi

# シンボリックリンク貼り貼り
# vim, neovim用
ln -sf ${script_dir}/.vimrc $HOME/
ln -sf ${script_dir}/.ideavimrc $HOME/
ln -sf ${script_dir}/.vimrc $HOME/.config/nvim/init.vim
ln -sf ${script_dir}/dein/dein.toml $HOME/.config/vim/dein/
ln -sf ${script_dir}/dein/dein_lazy.toml $HOME/.config/vim/dein/


