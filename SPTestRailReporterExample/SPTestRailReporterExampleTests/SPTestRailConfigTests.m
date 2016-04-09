//
//  SPTestRailConfigTests.m
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

@interface SPTestRailConfigTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@property (nonatomic, strong) NSNumber *createdMileStoneId;
@property (nonatomic, strong) SPTestRailRun *createdRun;
@end

@implementation SPTestRailConfigTests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"<yourtestrailurl>"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"<yourtestrailemail>";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"<yourtestrailpassword>";
    SPTestRailProject *projectForTesting = [[SPTestRailProject alloc] initWithName:@"Project For Testing" Announcement:@"testing the API" Mode:SPTestRailSuiteModeMultipleSuites];
    projectForTesting = [[SPTestRailReporter sharedReporter] addProject:projectForTesting Error:&error];
    self.createdProjectId = projectForTesting.projectId;
    SPTestRailSuite *suite1 = [[SPTestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[SPTestRailReporter sharedReporter] addSuite:suite1 ForProjectId:self.createdProjectId Error:&error];
    self.createdSuiteId = suite1.suiteId;
    SPTestRailMileStone *mileStone = [[SPTestRailMileStone alloc] init];
    mileStone.name = [NSString stringWithFormat:@"Milestone - %@", [[NSUUID UUID] UUIDString]];
    mileStone.projectId = self.createdProjectId;
    mileStone = [[SPTestRailReporter sharedReporter] addMileStone:mileStone ForProjectId:mileStone.projectId Error:&error];
    self.createdMileStoneId = mileStone.mileStoneId;
    SPTestRailRun *run = [[SPTestRailRun alloc] init];
    run.name = [NSString stringWithFormat:@"Run - %@", [NSUUID UUID].UUIDString];
    run.suiteId = self.createdSuiteId;
    run.mileStoneId = self.createdMileStoneId;
    run.projectId = self.createdProjectId;
    self.createdRun = [[SPTestRailReporter sharedReporter] addRun:run ForProjectId:self.createdProjectId Error:&error];
}


- (void)testConfigurationsAPI {
    NSError *error = nil;
    //step 1 : add a config group
    SPTestRailConfigGroup *configGroup = [[SPTestRailConfigGroup alloc] init];
    configGroup.projectId = self.createdProjectId;
    configGroup.name = [NSString stringWithFormat:@"Configuration Group - %@", [[NSUUID UUID] UUIDString]];
    configGroup = [[SPTestRailReporter sharedReporter] addConfigGroup:configGroup InProjectId:self.createdProjectId Error:&error];
    //step 2 : update config group
    SPTestRailConfig *config = [[SPTestRailConfig alloc] init];
    config.name = [NSString stringWithFormat:@"Configuration - %@", [[NSUUID UUID] UUIDString]];
    configGroup.configurationsSeperated = (NSArray<SPTestRailConfig> *)@[config];
    configGroup = [[SPTestRailReporter sharedReporter] updateConfigurationGroup:configGroup Error:&error];
    //step 3 : add a couple of configs to a config group
    for (int i = 0; i < 3; i++) {
        SPTestRailConfig *config = [[SPTestRailConfig alloc] init];
        config.name = [NSString stringWithFormat:@"Configuration - %@", [[NSUUID UUID] UUIDString]];
        [[SPTestRailReporter sharedReporter] addConfig:config InConfigGroupId:configGroup.configGroupId Error:&error];
    }
    //step 4 : update all linked configs
    NSArray *configurations = [[SPTestRailReporter sharedReporter] getAllConfigGroupsForProjectId:self.createdProjectId Error:&error];
    for (SPTestRailConfigGroup *configGroup in configurations) {
        for (SPTestRailConfig *config in configGroup.configurationsSeperated) {
            config.name = [NSString stringWithFormat:@"%@ - Updated", config.name];
            [[SPTestRailReporter sharedReporter] updateConfig:config Error:&error];
        }
    }
    //step 5 : delete all linked configs
    for (SPTestRailConfigGroup *configGroup in configurations) {
        for (SPTestRailConfig *config in configGroup.configurationsSeperated) {
            [[SPTestRailReporter sharedReporter] deleteConfigWithId:config.configId Error:&error];
        }
    }
    //step 6 : delete a particular config group
    [[SPTestRailReporter sharedReporter] deleteConfigGroupWithId:configGroup.configGroupId Error:&error];
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
