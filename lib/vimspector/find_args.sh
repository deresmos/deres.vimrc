#! /bin/bash

readonly rootPath=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cat $rootPath/.vimspector_args 
