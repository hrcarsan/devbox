#!/bin/sh

{ # Prevent execution if this script was only partially downloaded

wget -O devbox-installer.sh https://raw.githubusercontent.com/hrcarsan/devbox/master/devbox-installer.sh
bash devbox-installer.sh
rm devbox-installer.sh

} # End of wrapping
