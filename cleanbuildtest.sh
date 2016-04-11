#!/bin/sh
cd SPTestRailReporterExample
pod install
cd ..
xcodebuild -workspace SPTestRailReporterExample/SPTestRailReporterExample.xcworkspace -scheme SPTestRailReporterExample -sdk iphonesimulator9.3 clean
xcodebuild -workspace SPTestRailReporterExample/SPTestRailReporterExample.xcworkspace -scheme SPTestRailReporterExample -sdk iphonesimulator9.3
xcodebuild -workspace SPTestRailReporterExample/SPTestRailReporterExample.xcworkspace -scheme SPTestRailReporterExample -sdk iphonesimulator9.3 test
