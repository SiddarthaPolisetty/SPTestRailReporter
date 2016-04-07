//
//  SPTestRailSectionTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/3/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPTestRailReporter.h"
#import "SPTestRailConfigurationBuilder.h"

@interface SPTestRailSectionTests : XCTestCase
@property (nonatomic, strong) NSNumber *createdProjectId;
@property (nonatomic, strong) NSNumber *createdSuiteId;
@end

@implementation SPTestRailSectionTests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
    SPTestRailProject *projectForTesting = [[SPTestRailProject alloc] initWithName:@"Project Milestone Test" Announcement:@"testing the API" Mode:SPTestRailSuiteModeMultipleSuites];
    projectForTesting = [[SPTestRailReporter sharedReporter] addProject:projectForTesting Error:&error];
    self.createdProjectId = projectForTesting.projectId;
    SPTestRailSuite *suite1 = [[SPTestRailSuite alloc] initWithName:@"My New Suite 1" Description:@"Testing" ProjectId:self.createdProjectId];
    suite1 = [[SPTestRailReporter sharedReporter] addSuite:suite1 ForProjectId:self.createdProjectId Error:&error];
    self.createdSuiteId = suite1.suiteId;
}

- (void)testSectionsAPI {
    NSError *error = nil;
    //step 1 : add a couple of sections
    for (int i = 0; i < 3; i++ ) {
        SPTestRailSection *section = [[SPTestRailSection alloc] init];
        section.name = [NSString stringWithFormat:@"Section - %@", [[NSUUID UUID] UUIDString]];
        section.suiteId = self.createdSuiteId;
        section.sectionDescription = @"";
        [[SPTestRailReporter sharedReporter] addSection:section ForProjectId:self.createdProjectId Error:&error];
    }
    //step 2 : list all sections for a given project
    NSArray *sections = [[SPTestRailReporter sharedReporter] getAllSectionsForProjectWithId:self.createdProjectId WithSuiteId:self.createdSuiteId Error:&error];
    //step 3 : update all sections
    for (SPTestRailSection *section in sections) {
        section.name = [NSString stringWithFormat:@"%@ - Updated", section.name];
        [[SPTestRailReporter sharedReporter] updateSection:section Error:&error];
    }
    //step 4 : fetch a section by id
    NSNumber *sectionId = [(SPTestRailSection *)[sections firstObject] sectionId];
    SPTestRailSection *fetchedSection = [[SPTestRailReporter sharedReporter] getSectionWithId:sectionId Error:&error];
    //step 5 : delete a particular section
    [[SPTestRailReporter sharedReporter] deleteSectionWithId:fetchedSection.sectionId Error:&error];
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
