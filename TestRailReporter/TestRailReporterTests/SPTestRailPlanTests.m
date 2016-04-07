//
//  SPTestRailPlanTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/4/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPTestRailReporter.h"
#import "SPTestRailConfigurationBuilder.h"

@interface SPTestRailPlanTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@property (nonatomic, strong) NSNumber *createdMileStoneId;
@property (nonatomic, strong) SPTestRailRun *createdRun;
@end

@implementation SPTestRailPlanTests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    SPTestRailProject *projectForTesting = [[SPTestRailProject alloc] initWithName:@"Project For Testing" Announcement:@"testing the API" Mode:SPTestRailSuiteModeMultipleSuites];
    projectForTesting = [[SPTestRailReporter sharedReporter] addProject:projectForTesting Error:&error];
    self.createdProjectId = projectForTesting.projectId;
    SPTestRailSuite *suite1 = [[SPTestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[SPTestRailReporter sharedReporter] addSuite:suite1 ForProjectId:self.createdProjectId Error:&error];
    self.createdSuiteId = suite1.suiteId;
    SPTestRailMileStone *mileStone = [[SPTestRailMileStone alloc] init];
    mileStone.name = [NSString stringWithFormat:@"Milestone - %@", [[NSUUID UUID] UUIDString]];
    mileStone.projectId = self.createdProjectId;
    mileStone = [[SPTestRailReporter sharedReporter] addMileStone:mileStone ForProjectId:mileStone.projectId Error:&error];
    self.createdMileStoneId = mileStone.mileStoneId;
    SPTestRailRun *run = [[SPTestRailRun alloc] init];
    run.name = [NSString stringWithFormat:@"Run - %@", [NSUUID UUID].UUIDString];
    run.suiteId = self.createdSuiteId;
    run.mileStoneId = self.createdMileStoneId;
    run.projectId = self.createdProjectId;
    self.createdRun = [[SPTestRailReporter sharedReporter] addRun:run ForProjectId:self.createdProjectId Error:&error];
}

- (void)testPlansAPI {
    NSError *error = nil;
    //step 1 : add a couple of test plans
    for (int i = 0; i < 3; i++ ) {
        SPTestRailPlanEntry *planEntry1 = [[SPTestRailPlanEntry alloc] init];
        planEntry1.name = [NSString stringWithFormat:@"Plan Entry - %@", [NSUUID UUID].UUIDString];
        planEntry1.suiteId = self.createdSuiteId;
        planEntry1.runs = (NSArray <SPTestRailRun> *)@[self.createdRun];
        SPTestRailPlan *plan = [[SPTestRailPlan alloc] init];
        plan.name = [NSString stringWithFormat:@"Plan - %@", [NSUUID UUID].UUIDString];
        plan.planDescription = @"";
        plan.milestoneId = self.createdMileStoneId;
        plan.entries = (NSArray <SPTestRailPlanEntry> *)@[planEntry1];
        [[SPTestRailReporter sharedReporter] addPlan:plan ForProjectId:self.createdProjectId Error:&error];
    }
    //step 2 : list all test plans for a given project
    NSArray *testPlans = [[SPTestRailReporter sharedReporter] getAllPlansForProjectId:self.createdProjectId Error:&error];
    //step 3 : update all test plans
    for (SPTestRailPlan *plan in testPlans) {
        plan.name = [NSString stringWithFormat:@"%@ - Updated", plan.name];
        [[SPTestRailReporter sharedReporter] updatePlan:plan Error:&error];
    }
    //step 4 : fetch a plan by id
    NSNumber *planId = [(SPTestRailPlan *)[testPlans firstObject] planId];
    SPTestRailPlan *fetchedPlan = [[SPTestRailReporter sharedReporter] getPlanWithId:planId Error:&error];
    //step 5 : add a couple of plan entries to a plan
    for (int i = 0; i < 3; i++ ) {
        SPTestRailPlanEntry *planEntry = [[SPTestRailPlanEntry alloc] init];
        planEntry.name = [NSString stringWithFormat:@"Plan Entry - %@", [NSUUID UUID].UUIDString];
        planEntry.suiteId = self.createdSuiteId;
        planEntry.runs = (NSArray <SPTestRailRun> *)@[self.createdRun];
        [[SPTestRailReporter sharedReporter] addPlanEntry:planEntry InPlanId:planId Error:&error];
    }
    //step 6 : update all linked plan entries
    fetchedPlan = [[SPTestRailReporter sharedReporter] getPlanWithId:planId Error:&error];
    for (SPTestRailPlanEntry *planEntry in fetchedPlan.entries) {
        planEntry.name = [NSString stringWithFormat:@"%@ - Updated", planEntry.name];
        [[SPTestRailReporter sharedReporter] updatePlanEntry:planEntry InPlanId:planId Error:&error];
    }
    //step 7 : delete all linked plan entries
    fetchedPlan = [[SPTestRailReporter sharedReporter] getPlanWithId:planId Error:&error];
    for (SPTestRailPlanEntry *planEntry in fetchedPlan.entries) {
        [[SPTestRailReporter sharedReporter] deletePLanEntryWithEntryId:planEntry.planEntryId InPlanId:planId Error:&error];
    }
    //step 8 : close a particular test plan
    NSNumber *closePlanId = [(SPTestRailPlan *)[testPlans lastObject] planId];
    [[SPTestRailReporter sharedReporter] closePlanWithId:closePlanId Error:&error];
    //step 9 : delete a particular test plan
    [[SPTestRailReporter sharedReporter] deletePlanWithId:planId Error:&error];

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