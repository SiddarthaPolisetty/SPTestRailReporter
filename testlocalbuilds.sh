#!/bin/sh
xctool -workspace SPTestRailReporterExample/SPTestRailReporterExample.xcworkspace -scheme SPTestRailReporterExample -sdk iphonesimulator clean
xctool -workspace SPTestRailReporterExample/SPTestRailReporterExample.xcworkspace -scheme SPTestRailReporterExample -sdk iphonesimulator build
xctool -workspace SPTestRailReporterExample/SPTestRailReporterExample.xcworkspace -scheme SPTestRailReporterExample -sdk iphonesimulator test
