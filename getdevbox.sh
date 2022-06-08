#!/bin/sh

{ # Prevent execution if this script was only partially downloaded

wget -H 'Cache-Control: no-cache, no-store' -qO \
  devbox-installer.sh https://raw.githubusercontent.com/hrcarsan/devbox/master/devbox-installer.sh
bash devbox-installer.sh
rm devbox-installer.sh

} # End of wrapping
