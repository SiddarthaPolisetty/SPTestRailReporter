//
//  SPTestRailProjectTests.m
//  SPTestRailReporterExampleTests
//
//  Created by Siddartha Polisetty on 3/22/16.
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

@interface SPTestRailProjectTests : XCTestCase

@end

@implementation SPTestRailProjectTests

- (void)setUp {
    [super setUp];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"<yourtestrailurl>"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"<yourtestrailemail>";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"<yourtestrailpassword>";
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
