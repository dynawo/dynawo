#!/bin/bash

if [ -z "$1" ]; then
  echo "You need to give the path for xerces-c install."
  exit 1
fi

install_path="$1"

for file in `find "$install_path"/lib -type f -name "libxerces*.dylib"`; do
  install_name_tool -add_rpath $install_path/lib $file 2> /dev/null || echo -n
done
for file in `find "$install_path"/lib -type f -name "libxerces*.dylib"`; do
  install_name_tool -id @rpath/$(basename $file) $file 2> /dev/null || echo -n
done
