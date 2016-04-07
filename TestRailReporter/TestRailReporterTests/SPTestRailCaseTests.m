//
//  SPTestRailCaseTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/4/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPTestRailReporter.h"
#import "SPTestRailConfigurationBuilder.h"

@interface SPTestRailCaseTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@property (nonatomic, strong) NSNumber *createdMileStoneId;
@property (nonatomic, strong) NSNumber *createdSectionId;
@property (nonatomic, strong) SPTestRailRun *createdRun;
@end

@implementation SPTestRailCaseTests

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
    SPTestRailSection *section = [[SPTestRailSection alloc] init];
    section.name = [NSString stringWithFormat:@"Section - %@", [[NSUUID UUID] UUIDString]];
    section.suiteId = self.createdSuiteId;
    section.sectionDescription = @"";
    section = [[SPTestRailReporter sharedReporter] addSection:section ForProjectId:self.createdProjectId Error:&error];
    self.createdSectionId = section.sectionId;
}

- (void)testCasesAPI {
    NSError *error = nil;
    //step 1 : add a couple of cases
    for (int i = 0; i < 3; i++ ) {
        SPTestRailCase *testCase = [[SPTestRailCase alloc] init];
        SPTestRailCustomStep *step1 = [[SPTestRailCustomStep alloc] init];
        step1.content = @"content 1";
        step1.expected = @"expectation 1";
        testCase.customStepsSeperated = (NSArray<SPTestRailCustomStep> *)@[step1];
        testCase.title = @"Test Case";
        testCase.suiteId = self.createdSuiteId;
        [[SPTestRailReporter sharedReporter] addCase:testCase WithSectionId:self.createdSectionId Error:&error];
    }
    //step 2 : list all test cases for a given project, section, suite
    NSArray *testCases = [[SPTestRailReporter sharedReporter] getAllCasesForProjectId:self.createdProjectId WithSectionId:self.createdSectionId WithSuiteId:self.createdSuiteId Error:&error];
    //step 3 : update all cases
    for (SPTestRailCase *testCase in testCases) {
        testCase.title = [NSString stringWithFormat:@"%@ - Updated", testCase.title];
        [[SPTestRailReporter sharedReporter] updateCase:testCase Error:&error];
    }

    //step 4 : fetch a case by id
    NSNumber *caseId = [(SPTestRailCase *)[testCases firstObject] caseId];
    __unused SPTestRailCase *fetchedCase = [[SPTestRailReporter sharedReporter] getCaseWithId:caseId Error:&error];
    //step 7 : delete a case
    [[SPTestRailReporter sharedReporter] deleteCaseWithId:caseId Error:&error];
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
