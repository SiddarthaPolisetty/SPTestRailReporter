//
//  MITestRailMileStoneTests.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 4/1/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailMileStoneTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@end

@implementation MITestRailMileStoneTests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    MITestRailProject *projectForTesting = [[MITestRailProject alloc] initWithName:@"Project Milestone Test" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectForTesting = [[MITestRailReporter sharedReporter] addProject:projectForTesting Error:&error];
    self.createdProjectId = projectForTesting.projectId;
    
}

- (void)testMileStonesAPI {
    NSError *error = nil;
    //step 1 : create a bunch of milestones
    for (int i = 0; i < 3; i++ ) {
        MITestRailMileStone *mileStone = [[MITestRailMileStone alloc] init];
        mileStone.name = [NSString stringWithFormat:@"Milestone %@", [[NSUUID UUID] UUIDString]];
        mileStone.projectId = self.createdProjectId;
        [[MITestRailReporter sharedReporter] addMileStone:mileStone ForProjectId:mileStone.projectId Error:&error];
    }
    //step 2 : fetch all milestones
    NSArray *mileStones = [[MITestRailReporter sharedReporter] getAllMileStonesForProjectWithId:self.createdProjectId Error:&error];
    //step 3 : update all milestones
    for (MITestRailMileStone *mileStone in mileStones) {
        mileStone.name = [NSString stringWithFormat:@"%@ - Updated", mileStone.name];
        [[MITestRailReporter sharedReporter] updateMileStone:mileStone Error:&error];
    }
    //step 4 : fetch milestone by Id
    NSNumber *mileStoneId = [(MITestRailMileStone *)[mileStones firstObject] mileStoneId];
    MITestRailMileStone *fetchedMileStone = [[MITestRailReporter sharedReporter] getMileStoneWithId:mileStoneId Error:&error];
    //step 5 : delete milestone
    [[MITestRailReporter sharedReporter] deleteMileStoneWithId:fetchedMileStone.mileStoneId Error:&error];
    
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
