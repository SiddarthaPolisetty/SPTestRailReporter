//
//  TestRailReporterTests.m
//  TestRailReporterTests
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"

@interface TestRailReporterTests : XCTestCase

@end

@implementation TestRailReporterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    NSArray *mileStones = [[MITestRailReporter sharedReporter] getAllMileStones];
    __unused NSArray *testRuns = [[MITestRailReporter sharedReporter] getAllTestRuns];
    __unused NSArray *testCases = [[MITestRailReporter sharedReporter] getAllTestCases];
    NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjects];
    NSArray *suites = [[MITestRailReporter sharedReporter] getAllSuitesForProject:23];
    for (MITestRailSuite *suite in suites) {
        NSLog(@"%@", suite.description);
    }
    for (MITestRailProject *project in projects) {
        NSLog(@"%@", project.description);
    }
    for (MITestRailMileStone *mileStone in mileStones) {
        NSLog(@"%@", mileStone.description);
    }
    MITestRailProject *contentProject = [[MITestRailReporter sharedReporter] getProjectWithId:23];
    NSLog(@"%@", contentProject.description);
    
    
}


@end
