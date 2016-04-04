//
//  MITestRailCaseTests.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 4/4/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailCaseTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@property (nonatomic, strong) NSNumber *createdMileStoneId;
@property (nonatomic, strong) NSNumber *createdSectionId;
@property (nonatomic, strong) MITestRailRun *createdRun;
@end

@implementation MITestRailCaseTests

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
    MITestRailSection *section = [[MITestRailSection alloc] init];
    section.name = [NSString stringWithFormat:@"Section - %@", [[NSUUID UUID] UUIDString]];
    section.suiteId = self.createdSuiteId;
    section.sectionDescription = @"";
    section = [[MITestRailReporter sharedReporter] createSection:section ForProjectId:self.createdProjectId];
    self.createdSectionId = section.sectionId;
}

- (void)testCasesAPI {
    //step 1 : add a couple of cases
    for (int i = 0; i < 3; i++ ) {
        MITestRailCase *testCase = [[MITestRailCase alloc] init];
        MITestRailCustomStep *step1 = [[MITestRailCustomStep alloc] init];
        step1.content = @"content 1";
        step1.expected = @"expectation 1";
        testCase.customStepsSeperated = (NSArray<MITestRailCustomStep> *)@[step1];
        testCase.title = @"Test Case";
        testCase.suiteId = self.createdSuiteId;
        [[MITestRailReporter sharedReporter] createCase:testCase WithSectionId:self.createdSectionId];
    }
    //step 2 : list all test cases for a given project, section, suite
    NSArray *testCases = [[MITestRailReporter sharedReporter] getAllCasesForProjectId:self.createdProjectId WithSectionId:self.createdSectionId WithSuiteId:self.createdSuiteId];
    //step 3 : update all cases
    for (MITestRailCase *testCase in testCases) {
        testCase.title = [NSString stringWithFormat:@"%@ - Updated", testCase.title];
        [[MITestRailReporter sharedReporter] updateCase:testCase];
    }

    //step 4 : fetch a case by id
    NSNumber *caseId = [(MITestRailCase *)[testCases firstObject] caseId];
    MITestRailCase *fetchedCase = [[MITestRailReporter sharedReporter] getCaseWithId:caseId];
    //step 7 : delete a case
    [[MITestRailReporter sharedReporter] deleteCaseWithId:caseId];
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
