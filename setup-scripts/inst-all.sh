#! /bin/bash

# php python2 npm qkc nkf
dir=$(pwd)
mkdir -p $dir/tmp/nvim
cd $dir/tmp/nvim

function install_soft () {
	if hash $1 2>/dev/null; then
		echo 'Already installed '$1
	else
		bash $dir'/inst-'$1'.sh'
	fi
}

install_soft nodebrew

source $HOME/.bash_profile
install_soft npm

install_soft composer

install_soft cmigemo

bash $dir'/inst-pip-package.sh'
bash $dir'/inst-npm-package.sh'
