#!/bin/bash

# Make sure the machine is updated
loggy "Updating system..."

UPDATE="$(sys.package.manager) update -y"

if [ "$(sys.package.manager)" == 'apt-get' ]; then
    # apt-get uses update to update the package database
    # while upgrade actually installs new packages.
    UPDATE="$UPDATE && apt-get upgrade -y"
fi

buffer_fail "${UPDATE}" "ERROR: failed to update system packages"
