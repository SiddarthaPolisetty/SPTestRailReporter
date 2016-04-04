//
//  MITestRailSuiteTests.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 4/3/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailSuiteTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@end

@implementation MITestRailSuiteTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    MITestRailProject *projectForTesting = [[MITestRailProject alloc] initWithName:@"Project Milestone Test" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectForTesting = [[MITestRailReporter sharedReporter] createProject:projectForTesting];
    self.createdProjectId = projectForTesting.projectId;
}

- (void)testSuitesAPI {
    //step 1 : add a couple of suites
    for (int i = 0; i < 3; i++ ) {
        MITestRailSuite *suite = [[MITestRailSuite alloc] initWithName:[NSString stringWithFormat:@"Suite - %@", [[NSUUID UUID] UUIDString]] Description:nil ProjectId:self.createdProjectId];
        [[MITestRailReporter sharedReporter] createSuite:suite ForProjectId:self.createdProjectId];
    }
    //step 2 : list all suites for a given project
    NSArray *suites = [[MITestRailReporter sharedReporter] getAllSuitesForProject:self.createdProjectId];
    //step 3 : update all suites
    for (MITestRailSuite *suite in suites) {
        suite.name = [NSString stringWithFormat:@"%@ - Updated", suite.name];
        [[MITestRailReporter sharedReporter] updateSuite:suite];
    }
    //step 4 : fetch a suite by id
    NSNumber *suiteId = [(MITestRailSuite *)[suites firstObject] suiteId];
    MITestRailSuite *fetchedSuite = [[MITestRailReporter sharedReporter] getSuiteWithId:suiteId];
    //step 5 : delete a particular suite
    [[MITestRailReporter sharedReporter] deleteSuiteWithId:fetchedSuite.suiteId];
}

- (void)tearDown {
    //step 1 : get all projects
    NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjects];
    //step 2 : delete all projects
    for (MITestRailProject *project in projects) {
        [[MITestRailReporter sharedReporter] deleteProjectWithId:project.projectId];
    }
}
@end
