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
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@property (nonatomic, strong) NSNumber *createdMileStoneId;
@end

@implementation MITestRailTestRunTests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    MITestRailProject *projectForTesting = [[MITestRailProject alloc] initWithName:@"Project Milestone Test" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectForTesting = [[MITestRailReporter sharedReporter] addProject:projectForTesting Error:&error];
    self.createdProjectId = projectForTesting.projectId;
    MITestRailSuite *suite1 = [[MITestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[MITestRailReporter sharedReporter] addSuite:suite1 ForProjectId:self.createdProjectId Error:&error];
    self.createdSuiteId = suite1.suiteId;
    MITestRailMileStone *mileStone = [[MITestRailMileStone alloc] init];
    mileStone.name = [NSString stringWithFormat:@"Milestone %@", [[NSUUID UUID] UUIDString]];
    mileStone.projectId = self.createdProjectId;
    mileStone = [[MITestRailReporter sharedReporter] addMileStone:mileStone ForProjectId:mileStone.projectId Error:&error];
    self.createdMileStoneId = mileStone.mileStoneId;
}

- (void)testTestRunsAPI {
    NSError *error = nil;
    //step 1 : add a couple of test runs
    for (int i = 0; i < 3; i++ ) {
        MITestRailRun *run = [[MITestRailRun alloc] init];
        run.name = [NSString stringWithFormat:@"Run - %@", [NSUUID UUID].UUIDString];
        run.suiteId = self.createdSuiteId;
        run.mileStoneId = self.createdMileStoneId;
        run.projectId = self.createdProjectId;
        [[MITestRailReporter sharedReporter] addRun:run ForProjectId:self.createdProjectId Error:&error];
    }
    //step 2 : list all test runs for a given project
    NSArray *runs = [[MITestRailReporter sharedReporter] getAllRunsForProjectId:self.createdProjectId Error:&error];
    //step 3 : update all test runs
    for (MITestRailRun *run in runs) {
        run.name = [NSString stringWithFormat:@"%@ - Updated", run.name];
        [[MITestRailReporter sharedReporter] updateRun:run Error:&error];
    }
    //step 4 : fetch a test run by id
    NSNumber *runId = [(MITestRailRun *)[runs firstObject] runId];
    MITestRailRun *fetchedRun = [[MITestRailReporter sharedReporter] getRunWithId:runId Error:&error];
    //step 5 : delete a particular test run
    [[MITestRailReporter sharedReporter] deleteRunWithId:fetchedRun.runId Error:&error];
}

- (void)tearDown {
    NSError *error = nil;
    //step 1 : get all projects
    NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjectsError:&error];
    //step 2 : delete all projects
    for (MITestRailProject *project in projects) {
        [[MITestRailReporter sharedReporter] deleteProjectWithId:project.projectId Error:&error];
    }
}
@end
