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
[ -d $vim_conf_dir ] || mkdir -p $vim_conf_dir
[ -d $vim_lib_dir ] || mkdir -p $vim_lib_dir

# オリジナルのvimrcを退避
[ -f $HOME/.vimrc ] && ([ -f $HOME/.vimrc.ORIG ] || cp $HOME/.vimrc $HOME/.vimrc.ORIG)

# シンボリックリンク貼り貼り
ln -sf ${conf_dir}/basic.vim $vim_conf_dir/
ln -sf ${conf_dir}/basic.vim $HOME/.vimrc
ln -sf ${conf_dir}/color.vim $vim_conf_dir/
ln -sf ${conf_dir}/filetype.vim $vim_conf_dir/
ln -sf ${dir}/.vimspector.json $HOME/
ln -sf ${dir}/coc-settings.json $nvim_dir/
ln -sf ${dir}/.ideavimrc $HOME/
ln -sf ${dir}/init.vim $nvim_dir/
ln -sf ${dir}/dein/dein.toml $nvim_dein_dir/
ln -sf ${dir}/dein/dein_ft.toml $nvim_dein_dir/
ln -sf ${dir}/dein/dein_lazy.toml $nvim_dein_dir/
ln -sf ${dir}/dein/pluginrc $nvim_dein_dir/
ln -sf ${dir}/lib/* $vim_lib_dir/
