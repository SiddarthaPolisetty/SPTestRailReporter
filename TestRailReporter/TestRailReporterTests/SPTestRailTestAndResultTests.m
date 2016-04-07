//
//  SPTestRailTestAndResultTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/4/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPTestRailReporter.h"
#import "SPTestRailConfigurationBuilder.h"

@interface SPTestRailTestAndResultTests : XCTestCase

@end

@implementation SPTestRailTestAndResultTests

- (void)setUp {
    [super setUp];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
}

- (void)testTestsAndResultsAPI {
    NSError *error = nil;
    NSArray *projects = [[SPTestRailReporter sharedReporter] getAllProjectsError:&error];
    SPTestRailProject *myProject = [projects firstObject];
    NSArray *runs = [[SPTestRailReporter sharedReporter] getAllRunsForProjectId:myProject.projectId Error:&error];
    SPTestRailRun *myRun = [runs firstObject];
    NSArray *tests = [[SPTestRailReporter sharedReporter] getAllTestsWithRunId:myRun.runId Error:&error];
    SPTestRailTest *myTest = [tests firstObject];
    SPTestRailResult *result1 = [[SPTestRailResult alloc] init];
    result1.statusId = @(1);
    result1.comment = @"Passed :)";
    SPTestRailResult *result2 = [[SPTestRailResult alloc] init];
    result2.statusId = @(2);
    result2.comment = @"Failed :(";
    result1 = [[SPTestRailReporter sharedReporter] addResult:result1 ForTestId:myTest.testId Error:&error];
    result2 = [[SPTestRailReporter sharedReporter] addResult:result2 ForRunId:myTest.runId ForCaseId:myTest.caseId Error:&error];
    [[SPTestRailReporter sharedReporter] addResults:@[result1, result2] ForRunId:myRun.runId Error:&error];
    __unused NSArray *results = [[SPTestRailReporter sharedReporter] getAllResultsforRunId:myRun.runId Error:&error];
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
