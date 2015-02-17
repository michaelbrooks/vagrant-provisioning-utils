#!/bin/bash

# Run this script to provision a VM.
# This accepts a list of sub-commands to decide which features to install.
# For example, you might call:
#
#    ./provision.sh mysql phpmyadmin
#
# Subcommands are simply the scripts in the "packages" subfolder.

DEFAULT_TO_INSTALL=(\
#    update \
)

function provision_script_dir {
    cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd
}

PROVISION_SCRIPT_DIR=$(provision_script_dir)
source "$PROVISION_SCRIPT_DIR/libs/io.sh"
source "$PROVISION_SCRIPT_DIR/libs/sys.sh"

install_order=(\
    update \
    mysql \
    require_npm \
)

to_install=(${DEFAULT_TO_INSTALL[@]} $@)

loggy "Running package scripts: ${to_install[@]}"
for package in "${install_order[@]}"; do
    if in_array $package ${to_install[@]}; then
        source "$PROVISION_SCRIPT_DIR/packages/$package.sh"
    fi
done
