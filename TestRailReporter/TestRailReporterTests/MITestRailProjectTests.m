//
//  MITestRailProjectTests.m
//  MITestRailProjectTests
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailProjectTests : XCTestCase

@end

@implementation MITestRailProjectTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
}


- (void)testProjectsAPI {
    NSError *error = nil;
    //step 1 : create ProjectA
    MITestRailProject *projectA = [[MITestRailProject alloc] initWithName:@"Project For Testing" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectA = [[MITestRailReporter sharedReporter] addProject:projectA Error:&error];
    XCTAssertNil(error);
    //step 2 : create ProjectB
    MITestRailProject *projectB = [[MITestRailProject alloc] initWithName:@"ProjectB" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectB = [[MITestRailReporter sharedReporter] addProject:projectB Error:&error];
    XCTAssertNil(error);
    //step 3 : update ProjectA
    projectA.name = @"ProjectA Updated Name";
    [[MITestRailReporter sharedReporter] updateProject:projectA Error:&error];
    XCTAssertNil(error);
    //step 4 : get all projects
    __unused NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjectsError:&error];
    XCTAssertNil(error);
    //step 5 : get project by id
    __unused MITestRailProject *project = [[MITestRailReporter sharedReporter] getProjectWithId:projectA.projectId Error:&error];
    XCTAssertNil(error);
    //step 6 : delete all projects
    [[MITestRailReporter sharedReporter] deleteProjectWithId:projectA.projectId Error:&error];
    XCTAssertNil(error);
    [[MITestRailReporter sharedReporter] deleteProjectWithId:projectB.projectId Error:&error];
    XCTAssertNil(error);
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
