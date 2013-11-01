#!/bin/sh

set -eu
set -x

sudo apt-get update
sudo apt-get install -y --force-yes puavo-devscripts aptirepo-upload

puavo-build-debian-dir
sudo puavo-install-deps debian/control
puavo-dch $(cat VERSION)
puavo-debuild

aptirepo-upload -b "git-$(echo "$GIT_BRANCH" | cut -d / -f 2)" ../aptirepo*.changes
