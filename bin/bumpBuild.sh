#!/bin/sh

buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "Osusume/Application/Info.plist")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "Osusume/Application/Info.plist"
