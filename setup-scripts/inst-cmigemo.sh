#! /bin/bash

if [ ! -d ./cmigemo ]; then
	git clone https://github.com/koron/cmigemo
fi

cd cmigemo

if [ "$(uname)" == 'Darwin' ]; then
	if ! hash nkf 2>/dev/null; then
		if ! hash brew 2>/dev/null; then
			echo 'You must install brew'
			exit 1
		fi
		brew install nkf
	fi

	./configure &&
	make osx &&
	make osx-dict &&
	sudo make osx-install
else
	./configure &&
	make gcc &&
	make gcc-dict &&
	sudo make gcc-install
fi

echo 'Installed cmigemo'
