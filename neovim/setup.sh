#!/bin/bash

set -x
dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
vim_dir=$HOME/.vim
vim_lib_dir=$vim_dir/lib
vim_conf_dir=$vim_dir/conf.d
conf_dir=$dir/conf.d
nvim_dir=$HOME/.config/nvim
nvim_dein_dir=$nvim_dir/dein

# vim/deinディレクトリ作成
[ -d $nvim_dein_dir ] || mkdir -p $nvim_dein_dir

# オリジナルのvimrcを退避
[ -f $HOME/.vimrc ] && ([ -f $HOME/.vimrc.ORIG ] || cp $HOME/.vimrc $HOME/.vimrc.ORIG)

# シンボリックリンク貼り貼り
ln -sf ${dir}/init.lua $nvim_dir/
ln -sf ${dir}/lua $nvim_dir/
ln -sf ${dir}/lsp $nvim_dir/
ln -sf ${dir}/nlsp-settings $nvim_dir/
ln -sf ${dir}/vimrc $nvim_dir/
