#!/bin/bash
# ACTION: Install Atom text editor
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

atom_url="https://atom.io/download/deb"
t=$(mktemp -d)
wget -P "$t" "$atom_url"  
if [ $? -eq 0 ]; then
  apt-get install gvfs-bin
  dpkg -i "$t/"*
fi 
rm -rf "$t"
