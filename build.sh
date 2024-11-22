#!/bin/sh
rm -rf _build
cp -r static _build

# osu! daily
./build-osu-daily.sh
