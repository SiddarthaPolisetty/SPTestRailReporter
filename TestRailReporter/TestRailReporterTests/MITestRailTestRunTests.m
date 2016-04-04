//
//  MITestRailTestRunTests.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 4/3/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailTestRunTests : XCTestCase
@property (nonatomic) int createdProjectId;
@property (nonatomic) int createdSuiteId;
@property (nonatomic) int createdMileStoneId;
@end

@implementation MITestRailTestRunTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    MITestRailProject *projectForTesting = [[MITestRailProject alloc] initWithName:@"Project Milestone Test" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectForTesting = [[MITestRailReporter sharedReporter] createProject:projectForTesting];
    self.createdProjectId = projectForTesting.projectId;
    MITestRailSuite *suite1 = [[MITestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[MITestRailReporter sharedReporter] createSuite:suite1 ForProjectId:self.createdProjectId];
    self.createdSuiteId = suite1.suiteId;
    MITestRailMileStone *mileStone = [[MITestRailMileStone alloc] init];
    mileStone.name = [NSString stringWithFormat:@"Milestone %@", [[NSUUID UUID] UUIDString]];
    mileStone.projectId = self.createdProjectId;
    mileStone = [[MITestRailReporter sharedReporter] createMileStone:mileStone ForProjectId:mileStone.projectId];
    self.createdMileStoneId = mileStone.mileStoneId;
}

- (void)testTestRunsAPI {
    //step 1 : add a couple of test runs
    for (int i = 0; i < 3; i++ ) {
        MITestRailRun *run = [[MITestRailRun alloc] init];
        run.name = [NSString stringWithFormat:@"Run - %@", [NSUUID UUID].UUIDString];
        run.suiteId = self.createdSuiteId;
        run.mileStoneId = self.createdMileStoneId;
        run.projectId = self.createdProjectId;
        [[MITestRailReporter sharedReporter] createRun:run ForProjectId:self.createdProjectId];
    }
    //step 2 : list all test runs for a given project
    NSArray *runs = [[MITestRailReporter sharedReporter] getAllRunsForProjectId:self.createdProjectId];
    //step 3 : update all test runs
    for (MITestRailRun *run in runs) {
        run.name = [NSString stringWithFormat:@"%@ - Updated", run.name];
        [[MITestRailReporter sharedReporter] updateRun:run];
    }
    //step 4 : fetch a test run by id
    int runId = [(MITestRailRun *)[runs firstObject] runId];
    MITestRailRun *fetchedRun = [[MITestRailReporter sharedReporter] getRunWithId:runId];
    //step 5 : delete a particular test run
    [[MITestRailReporter sharedReporter] deleteRunWithId:fetchedRun.runId];
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
