#! /bin/bash

if hash nodebrew 2>/dev/null; then
	nodebrew selfupdate &&
	nodebrew install latest &&
	nodebrew use latest
fi
