#!/bin/bash
# Collection of useful functions

function loggy {
    # Prints a message in green with lots of space around it.
    # If the 2nd parameter is error, message is red, warn slightly less so.
    # http://misc.flogisoft.com/bash/tip_colors_and_formatting

    case "$2" in
        error)
            # Red text
            echo -e $'\e[1m\e[31m'
            ;;
        warn)
            # Red text
            echo -e $'\e[33m'
            ;;
        *)
            # Green text
            echo -e $'\e[32m'
            ;;
    esac

    echo -e $1
    echo -e $'\e[0m'
}



function confirm {
    # Call with a prompt string. The user may type "yes" or "no".
    # The default is no.
    # If a second argument is provided, the default is yes instead.
    
    if [ -z "$2" ]; then
        defaults="[y/N]"
    else
        defaults="[Y/n]"
    fi
    
    read -r -p "${1:-Are you sure?} $defaults " response
    
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        [nN][oO]|[nN])
            false
            ;;
        *)
            if [ -z "$2" ]; then
                false
            else
                true
            fi
            ;;
    esac
}

function prompt {
    # Call with a question for the user like name=$(prompt "what is your name?")
    # A default value can also be provided as a 2nd arg.

    if [ -z "$2" ]; then
        read -r -p "$1 " response
    else
        read -r -p "$1 [$2] " response
        if [ -z "$response" ]; then
            response=$2
        fi
    fi
    echo $response
}

function failif {
    # If the command immediately prior returned a non-zero exit status,
    # then print the provided message and exit.
    if [ $? -gt 0 ]; then
	    loggy "${1:-Error!}" "error"
	    exit 1
    fi
}

# Call with a filename to remove global permissions
function secure {
    chmod o-rwx $1
    failif "Failed to remove global permissions on $1"
}

function generateRandomString {
    # This could be a suitable string for a Django secret key
    # Requires Python.
    python -c 'import random, string; print "".join([random.SystemRandom().choice(string.digits + string.letters) for i in range(100)])'
}

function buffer_fail {
    # Run a command but only print the output if it returns a non-zero exit status
    # e.g. buffer_fail "wget something.com"
    outfile=/tmp/buffer_fail.out
    errfile=/tmp/buffer_fail.err

    set +e
    echo "    $1"
    bash -c "$1" 2> $errfile > $outfile
    if [ $? -ne 0 ]; then
        if [ -s "$outfile" ]; then
            loggy "-----stdout-----" "error"
            cat "$outfile"
        fi
        if [ -s "$errfile" ]; then
            loggy "-----stderr-----" "error"
            cat "$errfile"
        fi
        loggy "----------------\n\n$2" "error"
        rm -f $outfile $errfile
        exit 1
    fi
    set -e
    echo "    Success."
}

function in_array {
    # Return true if the first argument is present in the remainder of the arguments
    # e.g. in_array "key" "$@"
    needle=$1
    for item in "${@:2}"; do
        if [[ "$item" = "$needle" ]]; then
            return 0
        fi
    done
    return 1
}
