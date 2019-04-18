#!/bin/bash
# ACTION: Install pack of popular fonts
# DESC: Popuar fonts: Droid Sans, Open Sans, Roboto, Microsoft fonts, Oswald, Overpass, Profont, and others.
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

base_dir="$(dirname "$(readlink -f "$0")")"

[ ! -d /usr/share/fonts/extra ] && mkdir /usr/share/fonts/extra/
unzip -o "$base_dir"/fonts.zip -d /usr/share/fonts/extra/
