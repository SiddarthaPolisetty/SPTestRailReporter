#!/bin/sh
xctool -workspace SPTestRailReporter/SPTestRailReporter.xcworkspace -scheme SPTestRailReporter -sdk iphonesimulator clean
xctool -workspace SPTestRailReporter/SPTestRailReporter.xcworkspace -scheme SPTestRailReporter -sdk iphonesimulator build
xctool -workspace SPTestRailReporter/SPTestRailReporter.xcworkspace -scheme SPTestRailReporter -sdk iphonesimulator test
