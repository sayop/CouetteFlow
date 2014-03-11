#!/bin/sh
echo $1
mkdir "$1"
cp "$1"*.png ./"$1"
convert  "$1"*.png +dither -layers Optimize -colors 256 -depth 8 "$1".gif
rm -f $1*.png


