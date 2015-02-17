#!/bin/bash
# Fail if npm doesn't exist

loggy "Checking for npm"

if exists 'npm'; then
    loggy "npm exists at $(which npm)"
    exit 0
else
    loggy "ERROR: Node package manager (npm) not available.\nPlease install node.js on your machine." "error"
    loggy "See: https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager"
    exit 1
fi
