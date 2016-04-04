//
//  MITestRailTestAndResultTests.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 4/4/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailTestAndResultTests : XCTestCase

@end

@implementation MITestRailTestAndResultTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
}

- (void)testTestsAndResultsAPI {
    NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjects];
    MITestRailProject *myProject = [projects firstObject];
    NSArray *runs = [[MITestRailReporter sharedReporter] getAllRunsForProjectId:myProject.projectId];
    MITestRailRun *myRun = [runs firstObject];
    NSArray *tests = [[MITestRailReporter sharedReporter] getAllTestsWithRunId:myRun.runId];
    MITestRailTest *myTest = [tests firstObject];
    MITestRailResult *result1 = [[MITestRailResult alloc] init];
    result1.statusId = @(1);
    result1.comment = @"Passed :)";
    MITestRailResult *result2 = [[MITestRailResult alloc] init];
    result2.statusId = @(2);
    result2.comment = @"Failed :(";
    result1 = [[MITestRailReporter sharedReporter] addResult:result1 ForTestId:myTest.testId];
    result2 = [[MITestRailReporter sharedReporter] addResult:result2 ForRunId:myTest.runId ForCaseId:myTest.caseId];
    [[MITestRailReporter sharedReporter] addResults:@[result1, result2] ForRunId:myRun.runId];
    __unused NSArray *results = [[MITestRailReporter sharedReporter] getAllResultsforRunId:myRun.runId];
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
