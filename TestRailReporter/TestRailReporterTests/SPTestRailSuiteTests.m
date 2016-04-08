//
//  SPTestRailSuiteTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/3/16.
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
#import "SPTestRailReporter.h"
#import "SPTestRailConfigurationBuilder.h"

@interface SPTestRailSuiteTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@end

@implementation SPTestRailSuiteTests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    SPTestRailProject *projectForTesting = [[SPTestRailProject alloc] initWithName:@"Project Milestone Test" Announcement:@"testing the API" Mode:SPTestRailSuiteModeMultipleSuites];
    projectForTesting = [[SPTestRailReporter sharedReporter] addProject:projectForTesting Error:&error];
    self.createdProjectId = projectForTesting.projectId;
}

- (void)testSuitesAPI {
    NSError *error = nil;
    //step 1 : add a couple of suites
    for (int i = 0; i < 3; i++ ) {
        SPTestRailSuite *suite = [[SPTestRailSuite alloc] initWithName:[NSString stringWithFormat:@"Suite - %@", [[NSUUID UUID] UUIDString]] Description:nil ProjectId:self.createdProjectId];
        [[SPTestRailReporter sharedReporter] addSuite:suite ForProjectId:self.createdProjectId Error:&error];
    }
    //step 2 : list all suites for a given project
    NSArray *suites = [[SPTestRailReporter sharedReporter] getAllSuitesForProject:self.createdProjectId Error:&error];
    //step 3 : update all suites
    for (SPTestRailSuite *suite in suites) {
        suite.name = [NSString stringWithFormat:@"%@ - Updated", suite.name];
        [[SPTestRailReporter sharedReporter] updateSuite:suite Error:&error];
    }
    //step 4 : fetch a suite by id
    NSNumber *suiteId = [(SPTestRailSuite *)[suites firstObject] suiteId];
    SPTestRailSuite *fetchedSuite = [[SPTestRailReporter sharedReporter] getSuiteWithId:suiteId Error:&error];
    //step 5 : delete a particular suite
    [[SPTestRailReporter sharedReporter] deleteSuiteWithId:fetchedSuite.suiteId Error:&error];
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
