//
//  SPTestRailSectionTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/3/16.
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
