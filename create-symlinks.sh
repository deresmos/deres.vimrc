#!/bin/bash

set -x
dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
nvim_dir=$HOME/.config/nvim
nvim_dein_dir=$nvim_dir/dein

# vim/deinディレクトリ作成
[ -d $nvim_dein_dir ] || mkdir -p $nvim_dein_dir

# オリジナルのvimrcを退避
[ -f $HOME/.vimrc ] && ([ -f $HOME/.vimrc.ORIG ] || cp $HOME/.vimrc $HOME/.vimrc.ORIG)

# シンボリックリンク貼り貼り
ln -sf ${dir}/basic.vim $HOME/
ln -sf ${dir}/.ideavimrc $HOME/
ln -sf ${dir}/init.vim $nvim_dir/
ln -sf ${dir}/my.vim $nvim_dir/
ln -sf ${dir}/dein/dein.toml $nvim_dein_dir/
ln -sf ${dir}/dein/dein_lazy.toml $nvim_dein_dir/
