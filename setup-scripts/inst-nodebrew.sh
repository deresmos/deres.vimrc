#! /bin/bash

curl https://raw.githubusercontent.com/hokaccha/nodebrew/master/nodebrew | perl - setup &&
echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> $HOME/.bash_profile &&
source $HOME/.bash_profile &&
nodebrew selfupdate
