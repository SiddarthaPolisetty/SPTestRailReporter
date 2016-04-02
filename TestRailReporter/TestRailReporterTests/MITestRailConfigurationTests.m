//
//  MITestRailConfigurationTests.m
//  MITestRailConfigurationTests
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailConfigurationTests : XCTestCase

@end

@implementation MITestRailConfigurationTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://mobileiron.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"spolisetty@mobileiron.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Siddarth1!";
}


- (void)testProjectsAPI {
    //step 1 : create ProjectA
    MITestRailProject *projectA = [[MITestRailProject alloc] initWithName:@"ProjectA" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectA = [[MITestRailReporter sharedReporter] createProject:projectA];
    //step 2 : create ProjectB
    MITestRailProject *projectB = [[MITestRailProject alloc] initWithName:@"ProjectM" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectB = [[MITestRailReporter sharedReporter] createProject:projectB];
    //step 3 : update ProjectA
    projectA.name = @"ProjectA Updated Name";
    [[MITestRailReporter sharedReporter] updateProject:projectA];
    //step 4 : get all projects
    NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjects];
    for (MITestRailProject *project in projects) {
        NSLog(@"%@", project);
    }
    //step 5 : get project by id
    MITestRailProject *project = [[MITestRailReporter sharedReporter] getProjectWithId:projectA.projectId];
    NSLog(@"%@", project);
    //step 6 : delete all projects
    [[MITestRailReporter sharedReporter] deleteProjectWithId:projectA.projectId];
    [[MITestRailReporter sharedReporter] deleteProjectWithId:projectB.projectId];
}

//- (void)testExample {
//    NSArray *mileStones = [[MITestRailReporter sharedReporter] getAllMileStones];
//    __unused NSArray *testRuns = [[MITestRailReporter sharedReporter] getAllTestRuns];
//    __unused NSArray *testCases = [[MITestRailReporter sharedReporter] getAllTestCases];
//   NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjects];
//    NSArray *suites = [[MITestRailReporter sharedReporter] getAllSuitesForProject:23];
//    for (MITestRailSuite *suite in suites) {
//        NSLog(@"%@", suite.description);
//    }
//    for (MITestRailProject *project in projects) {
//        NSLog(@"%@", project.description);
//    }
//    for (MITestRailMileStone *mileStone in mileStones) {
//        NSLog(@"%@", mileStone.description);
//    }
//    MITestRailProject *contentProject = [[MITestRailReporter sharedReporter] getProjectWithId:23];
//    NSLog(@"%@", contentProject.description);
//    
//    
//}

- (void)tearDown {
    //step 1 : get all projects
    NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjects];
    //step 2 : delete all projects
    for (MITestRailProject *project in projects) {
        [[MITestRailReporter sharedReporter] deleteProjectWithId:project.projectId];
    }
}
@end
