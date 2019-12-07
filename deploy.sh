#!/bin/bash

set -e

hexo clean

hexo generate

git submodule update --recursive --remote

git add .
git save
git push origin develop -f

rm -rf ../public
mv public/ ..

cd ../public

git init

git save

git remote add origin https://git.coding.net/Dev4mobile/dev4mobile.git

git push -u origin master -f


