#!/bin/sh
cd Example
pod install
xcodebuild -workspace Example.xcworkspace -scheme Example -sdk iphonesimulator9.3 clean
xcodebuild -workspace Example.xcworkspace -scheme Example -sdk iphonesimulator9.3
xcodebuild -workspace Example.xcworkspace -scheme Example -sdk iphonesimulator9.3 test
