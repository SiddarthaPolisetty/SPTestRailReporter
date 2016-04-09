//
//  SPTestRailTestAndResultTests.m
//  SPTestRailReporterExampleTests
//
//  Created by Siddartha Polisetty on 4/4/16.
//  Copyright (c) 2016 Siddartha Polisetty
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <XCTest/XCTest.h>
#import <SPTestRailReporter/SPTestRailReporter.h>

@interface SPTestRailTestAndResultTests : XCTestCase

@end

@implementation SPTestRailTestAndResultTests

- (void)setUp {
    [super setUp];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"<yourtestrailurl>"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"<yourtestrailemail>";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"<yourtestrailpassword>";
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
