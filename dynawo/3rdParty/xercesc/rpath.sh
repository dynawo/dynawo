#!/bin/bash

if [ -z "$1" ]; then
  echo "You need to give the path for xerces-c install."
  exit 1
fi

if [ -z "$2" ]; then
  echo "You need to give a version for xerces-c."
  exit 1
fi

install_path="$1"
version="${2%??}"

rm -rf $install_path/lib/pkgconfig $install_path/lib/libxerces-c.so
if [ -f "$install_path/lib/libxerces-c-$version.dylib" ]; then
  ln -s $install_path/lib/libxerces-c-$version.dylib $install_path/lib/libxerces-c.dylib
fi
if [ -f "$install_path/lib/libxerces-c-$version.a" ]; then
  ln -s $install_path/lib/libxerces-c-$version.a $install_path/lib/libxerces-c.a
fi
