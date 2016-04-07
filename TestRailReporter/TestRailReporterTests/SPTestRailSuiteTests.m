//
//  SPTestRailSuiteTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/3/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
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
