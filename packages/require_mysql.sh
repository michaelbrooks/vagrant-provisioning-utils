#!/bin/bash

# Make sure the machine is updated
loggy "Installing mysql..."

if exists 'mysql'; then
    MYSQL_EXE=$(which mysql)
else
    loggy "ERROR: MySQL not installed.\nPlease install MySQl on your machine." "error"
    exit 1
fi
echo "Using mysql at $MYSQL_EXE"
