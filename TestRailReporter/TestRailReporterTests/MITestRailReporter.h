//
//  MITestRailReporter.h
//  DocsAtWork
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 MobileIron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "MITestRailProject.h"
#import "MITestRailSuite.h"
#import "MITestRailProject.h"
#import "MITestRailCase.h"
#import "MITestRailMileStone.h"
#import "MITestRailRun.h"
#import "MITestRailUser.h"
#import "MITestRailSection.h"

@interface MITestRailReporter : NSObject
+ (instancetype)sharedReporter;

#pragma mark - case CRUD
- (NSArray *)getAllTestCases;

#pragma mark - Run CRUD
- (NSArray *)getAllRunsForProjectId:(int)projectId;
- (MITestRailRun *)getRunWithId:(int)runId;
- (BOOL)closeRunWithId:(int)runId;
- (BOOL)deleteRunWithId:(int)runId;
- (MITestRailRun *)createRun:(MITestRailRun *)run ForProjectId:(int)projectId;
- (MITestRailRun *)updateRun:(MITestRailRun *)run;

#pragma mark - Suite CRUD
- (MITestRailSuite *)createSuite:(MITestRailSuite *)suite ForProjectId:(int)projectId;
- (MITestRailSuite *)updateSuite:(MITestRailSuite *)suite;
- (BOOL)deleteSuiteWithId:(int)suiteId;
- (NSArray *)getAllSuitesForProject:(int)projectId;
- (MITestRailSuite *)getSuiteWithId:(int)suiteId;

#pragma mark - Section CRUD
- (MITestRailSection *)createSection:(MITestRailSection *)section ForProjectId:(int)projectId;
- (MITestRailSection *)updateSection:(MITestRailSection *)section;
- (BOOL)deleteSectionWithId:(int)sectionId;
- (NSArray *)getAllSectionsForProjectWithId:(int)projectId WithSuiteId:(int)suiteId;
- (MITestRailSection *)getSectionWithId:(int)sectionId;

#pragma mark - Milestone CRUD
- (MITestRailMileStone *)createMileStone:(MITestRailMileStone *)mileStone ForProjectId:(int)projectId;
- (MITestRailMileStone *)updateMileStone:(MITestRailMileStone *)mileStone;
- (BOOL)deleteMileStoneWithId:(int)mileStoneId;
- (NSArray *)getAllMileStonesForProjectWithId:(int)projectId;
- (MITestRailMileStone *)getMileStoneWithId:(int)mileStoneId;

#pragma mark - User CRUD
- (NSArray *)getAllUsers;
- (MITestRailUser *)getUserWithId:(int)userId;
- (MITestRailUser *)getUserWithEmail:(NSString *)email;

#pragma mark - Project CRUD
- (MITestRailProject *)createProject:(MITestRailProject *)project;
- (MITestRailProject *)updateProject:(MITestRailProject *)project;
- (BOOL)deleteProjectWithId:(int)projectId;
- (NSArray *)getAllProjects;
- (MITestRailProject *)getProjectWithId:(int)projectId;
@end
