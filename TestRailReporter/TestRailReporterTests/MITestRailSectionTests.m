//
//  MITestRailSectionTests.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 4/3/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailSectionTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@end

@implementation MITestRailSectionTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    MITestRailProject *projectForTesting = [[MITestRailProject alloc] initWithName:@"Project Milestone Test" Announcement:@"testing the API" Mode:MITestRailSuiteModeMultipleSuites];
    projectForTesting = [[MITestRailReporter sharedReporter] createProject:projectForTesting];
    self.createdProjectId = projectForTesting.projectId;
    MITestRailSuite *suite1 = [[MITestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[MITestRailReporter sharedReporter] createSuite:suite1 ForProjectId:self.createdProjectId];
    self.createdSuiteId = suite1.suiteId;
}

- (void)testSectionsAPI {
    //step 1 : add a couple of sections
    for (int i = 0; i < 3; i++ ) {
        MITestRailSection *section = [[MITestRailSection alloc] init];
        section.name = [NSString stringWithFormat:@"Section - %@", [[NSUUID UUID] UUIDString]];
        section.suiteId = self.createdSuiteId;
        section.sectionDescription = @"";
        [[MITestRailReporter sharedReporter] createSection:section ForProjectId:self.createdProjectId];
    }
    //step 2 : list all sections for a given project
    NSArray *sections = [[MITestRailReporter sharedReporter] getAllSectionsForProjectWithId:self.createdProjectId WithSuiteId:self.createdSuiteId];
    //step 3 : update all sections
    for (MITestRailSection *section in sections) {
        section.name = [NSString stringWithFormat:@"%@ - Updated", section.name];
        [[MITestRailReporter sharedReporter] updateSection:section];
    }
    //step 4 : fetch a section by id
    NSNumber *sectionId = [(MITestRailSection *)[sections firstObject] sectionId];
    MITestRailSection *fetchedSection = [[MITestRailReporter sharedReporter] getSectionWithId:sectionId];
    //step 5 : delete a particular section
    [[MITestRailReporter sharedReporter] deleteSectionWithId:fetchedSection.sectionId];
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
