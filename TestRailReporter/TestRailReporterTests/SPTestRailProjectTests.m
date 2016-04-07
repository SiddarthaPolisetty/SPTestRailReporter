//
//  SPTestRailProjectTests.m
//  SPTestRailProjectTests
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPTestRailReporter.h"
#import "SPTestRailConfigurationBuilder.h"

@interface SPTestRailProjectTests : XCTestCase

@end

@implementation SPTestRailProjectTests

- (void)setUp {
    [super setUp];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
}


- (void)testProjectsAPI {
    NSError *error = nil;
    //step 1 : create ProjectA
    SPTestRailProject *projectA = [[SPTestRailProject alloc] initWithName:@"Project For Testing" Announcement:@"testing the API" Mode:SPTestRailSuiteModeMultipleSuites];
    projectA = [[SPTestRailReporter sharedReporter] addProject:projectA Error:&error];
    XCTAssertNil(error);
    //step 2 : create ProjectB
    SPTestRailProject *projectB = [[SPTestRailProject alloc] initWithName:@"ProjectB" Announcement:@"testing the API" Mode:SPTestRailSuiteModeMultipleSuites];
    projectB = [[SPTestRailReporter sharedReporter] addProject:projectB Error:&error];
    XCTAssertNil(error);
    //step 3 : update ProjectA
    projectA.name = @"ProjectA Updated Name";
    [[SPTestRailReporter sharedReporter] updateProject:projectA Error:&error];
    XCTAssertNil(error);
    //step 4 : get all projects
    __unused NSArray *projects = [[SPTestRailReporter sharedReporter] getAllProjectsError:&error];
    XCTAssertNil(error);
    //step 5 : get project by id
    __unused SPTestRailProject *project = [[SPTestRailReporter sharedReporter] getProjectWithId:projectA.projectId Error:&error];
    XCTAssertNil(error);
    //step 6 : delete all projects
    [[SPTestRailReporter sharedReporter] deleteProjectWithId:projectA.projectId Error:&error];
    XCTAssertNil(error);
    [[SPTestRailReporter sharedReporter] deleteProjectWithId:projectB.projectId Error:&error];
    XCTAssertNil(error);
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
