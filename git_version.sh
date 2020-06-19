#!/bin/zsh
SHA1=$(git rev-parse --short HEAD 2> /dev/null); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi
VERSION=$(git describe --tags 2> /dev/null); if [ $VERSION ]; then echo $VERSION; else echo 'unknown'; fi
echo "version: $VERSION" > journeyctrl_version.yml
echo "revision: $SHA1" >> journeyctrl_version.yml
#chmod +x ./journeyctrl_version.yml