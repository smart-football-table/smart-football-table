#!/bin/sh

find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && [ -e build.sh ] && ./build.sh" \;
# find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && [ -r Dockerfile ] && docker build ." \;

