//
//  MITestRailConfigTests.m
//  MITestRailConfigurationTests
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailConfigTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@property (nonatomic, strong) NSNumber *createdMileStoneId;
@property (nonatomic, strong) MITestRailRun *createdRun;
@end

@implementation MITestRailConfigTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    MITestRailProject *projectForTesting = [[MITestRailProject alloc] initWithName:@"Project For Testing" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectForTesting = [[MITestRailReporter sharedReporter] createProject:projectForTesting];
    self.createdProjectId = projectForTesting.projectId;
    MITestRailSuite *suite1 = [[MITestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[MITestRailReporter sharedReporter] createSuite:suite1 ForProjectId:self.createdProjectId];
    self.createdSuiteId = suite1.suiteId;
    MITestRailMileStone *mileStone = [[MITestRailMileStone alloc] init];
    mileStone.name = [NSString stringWithFormat:@"Milestone - %@", [[NSUUID UUID] UUIDString]];
    mileStone.projectId = self.createdProjectId;
    mileStone = [[MITestRailReporter sharedReporter] createMileStone:mileStone ForProjectId:mileStone.projectId];
    self.createdMileStoneId = mileStone.mileStoneId;
    MITestRailRun *run = [[MITestRailRun alloc] init];
    run.name = [NSString stringWithFormat:@"Run - %@", [NSUUID UUID].UUIDString];
    run.suiteId = self.createdSuiteId;
    run.mileStoneId = self.createdMileStoneId;
    run.projectId = self.createdProjectId;
    self.createdRun = [[MITestRailReporter sharedReporter] createRun:run ForProjectId:self.createdProjectId];
}


- (void)testConfigurationsAPI {
    //step 1 : add a config group
    MITestRailConfigGroup *configGroup = [[MITestRailConfigGroup alloc] init];
    configGroup.projectId = self.createdProjectId;
    configGroup.name = [NSString stringWithFormat:@"Configuration Group - %@", [[NSUUID UUID] UUIDString]];
    configGroup = [[MITestRailReporter sharedReporter] createConfigGroup:configGroup InProjectId:self.createdProjectId];
    //step 2 : update config group
    MITestRailConfig *config = [[MITestRailConfig alloc] init];
    config.name = [NSString stringWithFormat:@"Configuration - %@", [[NSUUID UUID] UUIDString]];
    configGroup.configurationsSeperated = (NSArray<MITestRailConfig> *)@[config];
    configGroup = [[MITestRailReporter sharedReporter] updateConfigurationGroup:configGroup];
    //step 3 : add a couple of configs to a config group
    for (int i = 0; i < 3; i++) {
        MITestRailConfig *config = [[MITestRailConfig alloc] init];
        config.name = [NSString stringWithFormat:@"Configuration - %@", [[NSUUID UUID] UUIDString]];
        [[MITestRailReporter sharedReporter] createConfig:config InConfigGroupId:configGroup.configGroupId];
    }
    //step 4 : update all linked configs
    NSArray *configurations = [[MITestRailReporter sharedReporter] getAllConfigGroupsForProjectId:self.createdProjectId];
    for (MITestRailConfigGroup *configGroup in configurations) {
        for (MITestRailConfig *config in configGroup.configurationsSeperated) {
            config.name = [NSString stringWithFormat:@"%@ - Updated", config.name];
            [[MITestRailReporter sharedReporter] updateConfig:config];
        }
    }
    //step 5 : delete all linked configs
    for (MITestRailConfigGroup *configGroup in configurations) {
        for (MITestRailConfig *config in configGroup.configurationsSeperated) {
            [[MITestRailReporter sharedReporter] deleteConfigWithId:config.configId];
        }
    }
    //step 6 : delete a particular config group
    [[MITestRailReporter sharedReporter] deleteConfigGroupWithId:configGroup.configGroupId];
}


- (void)tearDown {
    //step 1 : get all projects
    NSArray *projects = [[MITestRailReporter sharedReporter] getAllProjects];
    //step 2 : delete all projects
    for (MITestRailProject *project in projects) {
        [[MITestRailReporter sharedReporter] deleteProjectWithId:project.projectId];
    }
}
@end
