#!/bin/bash
cd "$(dirname "$0")"
cmake . --preset=ios-dev
#open build/ios-dev/*.xcodeproj