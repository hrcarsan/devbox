#!/bin/bash

{ # Prevent execution if this script was only partially downloaded

bash <(curl -fsSL https://raw.githubusercontent.com/hrcarsan/devbox/master/devbox-installer.sh)
source $HOME/.ink/devbox/bash/bashrc > /dev/null 2>&1

} # End of wrapping
