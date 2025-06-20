#!/bin/bash
set -ex

git clone -b introduce-cmake https://github.com/mszabo-wikia/mcrouter.git
cd mcrouter
git config user.name "mcrouter buildbot"
git config user.email "build@example.com"
git remote add upstream https://github.com/facebook/mcrouter.git
git pull --rebase upstream main
