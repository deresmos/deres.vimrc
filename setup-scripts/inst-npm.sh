#! /bin/bash

[ ! -d ~/softs ] && \mkdir -p ~/softs

git clone https://github.com/hokaccha/nodebrew ~/softs/nodebrew &&
  ~/softs/nodebrew/nodebrew setup

export PATH=$HOME/.nodebrew/current/bin:$PATH
if hash nodebrew 2>/dev/null; then
	nodebrew selfupdate &&
	nodebrew install-binary latest &&
	nodebrew use latest
fi
