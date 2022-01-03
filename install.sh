#!/bin/sh

swift build -c release
cd .build/release
cp -f snpm /usr/local/bin/snpm
cd ..
