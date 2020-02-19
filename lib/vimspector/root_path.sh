#! /bin/bash

echo $(git rev-parse --show-toplevel 2>/dev/null || pwd)
