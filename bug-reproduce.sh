#!/bin/bash
rm -rf node_modules/
npm install
npm install sw-bug --save
git checkout -- npm-shrinkwrap.json
npm install
