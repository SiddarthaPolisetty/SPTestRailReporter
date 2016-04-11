//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Siddartha Polisetty on 4/11/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SPTestRailReporter/SPTestRailReporter.h>

@interface ExampleTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@end

@implementation ExampleTests

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
    for (SPTestRailMileStone *mileStone in mileStones ) {
        NSLog(@"%@", mileStone);
    }
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
