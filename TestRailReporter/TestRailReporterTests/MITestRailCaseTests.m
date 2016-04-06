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
    NSError *error = nil;
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    MITestRailProject *projectForTesting = [[MITestRailProject alloc] initWithName:@"Project For Testing" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectForTesting = [[MITestRailReporter sharedReporter] addProject:projectForTesting Error:&error];
    self.createdProjectId = projectForTesting.projectId;
    MITestRailSuite *suite1 = [[MITestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[MITestRailReporter sharedReporter] addSuite:suite1 ForProjectId:self.createdProjectId Error:&error];
    self.createdSuiteId = suite1.suiteId;
    MITestRailMileStone *mileStone = [[MITestRailMileStone alloc] init];
    mileStone.name = [NSString stringWithFormat:@"Milestone - %@", [[NSUUID UUID] UUIDString]];
    mileStone.projectId = self.createdProjectId;
    mileStone = [[MITestRailReporter sharedReporter] addMileStone:mileStone ForProjectId:mileStone.projectId Error:&error];
    self.createdMileStoneId = mileStone.mileStoneId;
    MITestRailRun *run = [[MITestRailRun alloc] init];
    run.name = [NSString stringWithFormat:@"Run - %@", [NSUUID UUID].UUIDString];
    run.suiteId = self.createdSuiteId;
    run.mileStoneId = self.createdMileStoneId;
    run.projectId = self.createdProjectId;
    self.createdRun = [[MITestRailReporter sharedReporter] addRun:run ForProjectId:self.createdProjectId Error:&error];
    MITestRailSection *section = [[MITestRailSection alloc] init];
    section.name = [NSString stringWithFormat:@"Section - %@", [[NSUUID UUID] UUIDString]];
    section.suiteId = self.createdSuiteId;
    section.sectionDescription = @"";
    section = [[MITestRailReporter sharedReporter] addSection:section ForProjectId:self.createdProjectId Error:&error];
    self.createdSectionId = section.sectionId;
}

- (void)testCasesAPI {
    NSError *error = nil;
    //step 1 : add a couple of cases
    for (int i = 0; i < 3; i++ ) {
        MITestRailCase *testCase = [[MITestRailCase alloc] init];
        MITestRailCustomStep *step1 = [[MITestRailCustomStep alloc] init];
        step1.content = @"content 1";
        step1.expected = @"expectation 1";
        testCase.customStepsSeperated = (NSArray<MITestRailCustomStep> *)@[step1];
        testCase.title = @"Test Case";
        testCase.suiteId = self.createdSuiteId;
        [[MITestRailReporter sharedReporter] addCase:testCase WithSectionId:self.createdSectionId Error:&error];
    }
    //step 2 : list all test cases for a given project, section, suite
    NSArray *testCases = [[MITestRailReporter sharedReporter] getAllCasesForProjectId:self.createdProjectId WithSectionId:self.createdSectionId WithSuiteId:self.createdSuiteId Error:&error];
    //step 3 : update all cases
    for (MITestRailCase *testCase in testCases) {
        testCase.title = [NSString stringWithFormat:@"%@ - Updated", testCase.title];
        [[MITestRailReporter sharedReporter] updateCase:testCase Error:&error];
    }

    //step 4 : fetch a case by id
    NSNumber *caseId = [(MITestRailCase *)[testCases firstObject] caseId];
    __unused MITestRailCase *fetchedCase = [[MITestRailReporter sharedReporter] getCaseWithId:caseId Error:&error];
    //step 7 : delete a case
    [[MITestRailReporter sharedReporter] deleteCaseWithId:caseId Error:&error];
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
