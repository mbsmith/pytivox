#!/bin/sh

volume_name="pyTivoX"
source_dir="/Users/yoav/src/pytivox/build/Release"
dmg_dir="$source_dir/../dmg"
output_dir="/Users/yoav/Desktop/"

stuff_to_copy="pyTivoX.app INSTALL.txt gpl-3.0.txt .DS_Store"
# *** SET VERSION
if [ $1 ]; then
    version=$1
else
    version="test"
fi

# *** SET DMG NAME
dmg_name="pyTivoX-${version}.dmg"

# *** CREATE
mkdir -p $dmg_dir
tar -C $source_dir -c $stuff_to_copy | tar -C $dmg_dir -x
hdiutil create "$output_dir/$dmg_name" -srcfolder $dmg_dir -ov -volname "$volume_name"
rm -rf $dmg_dir
