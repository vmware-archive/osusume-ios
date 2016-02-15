#!/usr/bin/env bash

xcodebuild -list
xcodebuild -project Osusume.xcodeproj -scheme "Osusume-Staging" -sdk iphonesimulator -destination "platform=iOS Simulator,OS=9.2,name=iPhone 6" test

