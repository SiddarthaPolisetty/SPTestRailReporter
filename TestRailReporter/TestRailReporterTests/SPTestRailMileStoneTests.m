//
//  SPTestRailMileStoneTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/1/16.
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

@interface SPTestRailMileStoneTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@end

@implementation SPTestRailMileStoneTests

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

- (void)testMileStonesAPI {
    NSError *error = nil;
    //step 1 : create a bunch of milestones
    for (int i = 0; i < 3; i++ ) {
        SPTestRailMileStone *mileStone = [[SPTestRailMileStone alloc] init];
        mileStone.name = [NSString stringWithFormat:@"Milestone %@", [[NSUUID UUID] UUIDString]];
        mileStone.projectId = self.createdProjectId;
        [[SPTestRailReporter sharedReporter] addMileStone:mileStone ForProjectId:mileStone.projectId Error:&error];
    }
    //step 2 : fetch all milestones
    NSArray *mileStones = [[SPTestRailReporter sharedReporter] getAllMileStonesForProjectWithId:self.createdProjectId Error:&error];
    //step 3 : update all milestones
    for (SPTestRailMileStone *mileStone in mileStones) {
        mileStone.name = [NSString stringWithFormat:@"%@ - Updated", mileStone.name];
        [[SPTestRailReporter sharedReporter] updateMileStone:mileStone Error:&error];
    }
    //step 4 : fetch milestone by Id
    NSNumber *mileStoneId = [(SPTestRailMileStone *)[mileStones firstObject] mileStoneId];
    SPTestRailMileStone *fetchedMileStone = [[SPTestRailReporter sharedReporter] getMileStoneWithId:mileStoneId Error:&error];
    //step 5 : delete milestone
    [[SPTestRailReporter sharedReporter] deleteMileStoneWithId:fetchedMileStone.mileStoneId Error:&error];
    
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
