#!/bin/bash

set -u
set -e

function main {
    if [ "$(uname)" == "Darwin" ]; then
        # Mac OS X platform
        /bin/bash install_macos.sh "$@"  
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # GNU/Linux platform
        /bin/bash install_linux.sh "$@" 
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # 32 bit Windows NT platform
        echo "ERROR: This script does not support windows yet!"
        exit 2
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        # 64 bit Windows NT platform
        echo "ERROR: This script does not support windows yet!"
        exit 2
    fi
}

# Run the main entrypoint
main "$@"
