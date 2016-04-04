//
//  MITestRailPlanTests.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 4/4/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailPlanTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@property (nonatomic, strong) NSNumber *createdMileStoneId;
@property (nonatomic, strong) MITestRailRun *createdRun;
@end

@implementation MITestRailPlanTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    MITestRailProject *projectForTesting = [[MITestRailProject alloc] initWithName:@"Project For Testing" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectForTesting = [[MITestRailReporter sharedReporter] createProject:projectForTesting];
    self.createdProjectId = projectForTesting.projectId;
    MITestRailSuite *suite1 = [[MITestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[MITestRailReporter sharedReporter] createSuite:suite1 ForProjectId:self.createdProjectId];
    self.createdSuiteId = suite1.suiteId;
    MITestRailMileStone *mileStone = [[MITestRailMileStone alloc] init];
    mileStone.name = [NSString stringWithFormat:@"Milestone - %@", [[NSUUID UUID] UUIDString]];
    mileStone.projectId = self.createdProjectId;
    mileStone = [[MITestRailReporter sharedReporter] createMileStone:mileStone ForProjectId:mileStone.projectId];
    self.createdMileStoneId = mileStone.mileStoneId;
    MITestRailRun *run = [[MITestRailRun alloc] init];
    run.name = [NSString stringWithFormat:@"Run - %@", [NSUUID UUID].UUIDString];
    run.suiteId = self.createdSuiteId;
    run.mileStoneId = self.createdMileStoneId;
    run.projectId = self.createdProjectId;
    self.createdRun = [[MITestRailReporter sharedReporter] createRun:run ForProjectId:self.createdProjectId];
}

- (void)testPlansAPI {
    //step 1 : add a couple of test plans
    for (int i = 0; i < 3; i++ ) {
        MITestRailPlanEntry *planEntry1 = [[MITestRailPlanEntry alloc] init];
        planEntry1.name = [NSString stringWithFormat:@"Plan Entry - %@", [NSUUID UUID].UUIDString];
        planEntry1.suiteId = self.createdSuiteId;
        planEntry1.runs = (NSArray <MITestRailRun> *)@[self.createdRun];
        MITestRailPlan *plan = [[MITestRailPlan alloc] init];
        plan.name = [NSString stringWithFormat:@"Plan - %@", [NSUUID UUID].UUIDString];
        plan.planDescription = @"";
        plan.milestoneId = self.createdMileStoneId;
        plan.entries = (NSArray <MITestRailPlanEntry> *)@[planEntry1];
        [[MITestRailReporter sharedReporter] createPlan:plan ForProjectId:self.createdProjectId];
    }
    //step 2 : list all test plans for a given project
    NSArray *testPlans = [[MITestRailReporter sharedReporter] getAllPlansForProjectId:self.createdProjectId];
    //step 3 : update all test plans
    for (MITestRailPlan *plan in testPlans) {
        plan.name = [NSString stringWithFormat:@"%@ - Updated", plan.name];
        [[MITestRailReporter sharedReporter] updatePlan:plan];
    }
    //step 4 : fetch a plan by id
    NSNumber *planId = [(MITestRailPlan *)[testPlans firstObject] planId];
    MITestRailPlan *fetchedPlan = [[MITestRailReporter sharedReporter] getPlanWithId:planId];
    //step 5 : add a couple of plan entries to a plan
    for (int i = 0; i < 3; i++ ) {
        MITestRailPlanEntry *planEntry = [[MITestRailPlanEntry alloc] init];
        planEntry.name = [NSString stringWithFormat:@"Plan Entry - %@", [NSUUID UUID].UUIDString];
        planEntry.suiteId = self.createdSuiteId;
        planEntry.runs = (NSArray <MITestRailRun> *)@[self.createdRun];
        [[MITestRailReporter sharedReporter] createPlanEntry:planEntry InPlanId:planId];
    }
    //step 6 : update all linked plan entries
    fetchedPlan = [[MITestRailReporter sharedReporter] getPlanWithId:planId];
    for (MITestRailPlanEntry *planEntry in fetchedPlan.entries) {
        planEntry.name = [NSString stringWithFormat:@"%@ - Updated", planEntry.name];
        [[MITestRailReporter sharedReporter] updatePlanEntry:planEntry InPlanId:planId];
    }
    //step 7 : delete all linked plan entries
    fetchedPlan = [[MITestRailReporter sharedReporter] getPlanWithId:planId];
    for (MITestRailPlanEntry *planEntry in fetchedPlan.entries) {
        [[MITestRailReporter sharedReporter] deletePLanEntryWithEntryId:planEntry.planEntryId InPlanId:planId];
    }
    //step 8 : close a particular test plan
    NSNumber *closePlanId = [(MITestRailPlan *)[testPlans lastObject] planId];
    [[MITestRailReporter sharedReporter] closePlanWithId:closePlanId];
    //step 9 : delete a particular test plan
    [[MITestRailReporter sharedReporter] deletePlanWithId:planId];

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
