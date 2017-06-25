#!/bin/bash

set -x
dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
nvim_dir=$HOME'/.config/nvim'
nvim_dein_dir=$nvim_dir'/dein'

# vim/deinディレクトリ作成
if [ ! -d $nvim_dein_dir ]; then
	mkdir -p $nvim_dein_dir
fi

# オリジナルのvimrcを退避
if [ -f $HOME/.vimrc ]; then
	if [ ! -f $HOME/.vimrc.ORIG ]; then
		cp $HOME/.vimrc $HOME/.vimrc.ORIG
	fi
fi

# シンボリックリンク貼り貼り
ln -sf ${dir}/.ideavimrc $HOME/
ln -sf ${dir}/init.vim $nvim_dir'/'
ln -sf ${dir}/my.vim $nvim_dir'/my.vim'
ln -sf ${dir}/dein/dein.toml $nvim_dein_dir'/'
ln -sf ${dir}/dein/dein_lazy.toml $nvim_dein_dir'/'
