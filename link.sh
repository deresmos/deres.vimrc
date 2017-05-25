#!/bin/bash

set -x
script_dir=$(pwd $(cd $(readlink $0)))

# vim/deinディレクトリ作成
if [ ! -d $HOME/.config/nvim/dein ]; then
	mkdir -p ~/.config/nvim/dein
fi

# オリジナルのvimrcを退避
if [ -f $HOME/.vimrc ]; then
	if [ ! -f $HOME/.vimrc.ORIG ]; then
		cp $HOME/.vimrc $HOME/.vimrc.ORIG
	fi
fi

# シンボリックリンク貼り貼り
ln -sf ${script_dir}/.ideavimrc $HOME/
ln -sf ${script_dir}/.vimrc $HOME/.config/nvim/init.vim
ln -sf ${script_dir}/my.vim $HOME/.config/nvim/my.vim
ln -sf ${script_dir}/dein/dein.toml $HOME/.config/nvim/dein/
ln -sf ${script_dir}/dein/dein_lazy.toml $HOME/.config/nvim/dein/
