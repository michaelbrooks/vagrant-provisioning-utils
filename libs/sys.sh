#!/bin/bash

# Functions that query the system status.

function am_user {
    # Returns true if the given user is the current user.
    return `[ "$USER" == "$1" ]`
}

function exists {
    # Checks if a command exists, returns a status code
    command -v $1 &> /dev/null
    return $?
}

function started {
    # Checks if a service is running
    service $1 status | grep "running" &> /dev/null
    return $?
}

function service_exists {
    # Use the `service` command to check if the service exists.
    service $1 status &> /dev/null
    return $?
}

function sys.package.manager {
    # Get the system package manager
    if exists 'apt-get'; then
        echo 'apt-get'
    elif exists 'yum'; then
        echo 'yum'
    fi
}

function sys.npm {
    # Get the npm command
    echo $(which npm)
}

function sys.python {
    echo $(which python)
}
