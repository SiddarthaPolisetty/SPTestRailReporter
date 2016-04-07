//
//  SPTestRailTestRunTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/3/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPTestRailReporter.h"
#import "SPTestRailConfigurationBuilder.h"

@interface SPTestRailTestRunTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@property (nonatomic, strong) NSNumber *createdMileStoneId;
@end

@implementation SPTestRailTestRunTests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    SPTestRailProject *projectForTesting = [[SPTestRailProject alloc] initWithName:@"Project Milestone Test" Announcement:@"testing the API" Mode:SPTestRailSuiteModeMultipleSuites];
    projectForTesting = [[SPTestRailReporter sharedReporter] addProject:projectForTesting Error:&error];
    self.createdProjectId = projectForTesting.projectId;
    SPTestRailSuite *suite1 = [[SPTestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[SPTestRailReporter sharedReporter] addSuite:suite1 ForProjectId:self.createdProjectId Error:&error];
    self.createdSuiteId = suite1.suiteId;
    SPTestRailMileStone *mileStone = [[SPTestRailMileStone alloc] init];
    mileStone.name = [NSString stringWithFormat:@"Milestone %@", [[NSUUID UUID] UUIDString]];
    mileStone.projectId = self.createdProjectId;
    mileStone = [[SPTestRailReporter sharedReporter] addMileStone:mileStone ForProjectId:mileStone.projectId Error:&error];
    self.createdMileStoneId = mileStone.mileStoneId;
}

- (void)testTestRunsAPI {
    NSError *error = nil;
    //step 1 : add a couple of test runs
    for (int i = 0; i < 3; i++ ) {
        SPTestRailRun *run = [[SPTestRailRun alloc] init];
        run.name = [NSString stringWithFormat:@"Run - %@", [NSUUID UUID].UUIDString];
        run.suiteId = self.createdSuiteId;
        run.mileStoneId = self.createdMileStoneId;
        run.projectId = self.createdProjectId;
        [[SPTestRailReporter sharedReporter] addRun:run ForProjectId:self.createdProjectId Error:&error];
    }
    //step 2 : list all test runs for a given project
    NSArray *runs = [[SPTestRailReporter sharedReporter] getAllRunsForProjectId:self.createdProjectId Error:&error];
    //step 3 : update all test runs
    for (SPTestRailRun *run in runs) {
        run.name = [NSString stringWithFormat:@"%@ - Updated", run.name];
        [[SPTestRailReporter sharedReporter] updateRun:run Error:&error];
    }
    //step 4 : fetch a test run by id
    NSNumber *runId = [(SPTestRailRun *)[runs firstObject] runId];
    SPTestRailRun *fetchedRun = [[SPTestRailReporter sharedReporter] getRunWithId:runId Error:&error];
    //step 5 : delete a particular test run
    [[SPTestRailReporter sharedReporter] deleteRunWithId:fetchedRun.runId Error:&error];
}

- (void)tearDown {
    NSError *error = nil;
    //step 1 : get all projects
    NSArray *projects = [[SPTestRailReporter sharedReporter] getAllProjectsError:&error];
    //step 2 : delete all projects
    for (SPTestRailProject *project in projects) {
        [[SPTestRailReporter sharedReporter] deleteProjectWithId:project.projectId Error:&error];
    }
}
@end
