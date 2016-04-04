//
//  MITestRailReporter.h
//  DocsAtWork
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 MobileIron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "MITestRailConfigurationBuilder.h"
#import "MITestRailProject.h"
#import "MITestRailSuite.h"
#import "MITestRailProject.h"
#import "MITestRailCase.h"
#import "MITestRailMileStone.h"
#import "MITestRailRun.h"
#import "MITestRailUser.h"
#import "MITestRailSection.h"
#import "MITestRailPlan.h"
#import "MITestRailConfigGroup.h"
#import "MITestRailTest.h"
#import "MITestRailResult.h"

@interface MITestRailReporter : NSObject
+ (instancetype)sharedReporter;

#pragma mark - Result CRUD
- (NSArray *)getAllResultsforTestId:(NSNumber *)testId;
- (NSArray *)getAllResultsforCaseId:(NSNumber *)caseId;
- (NSArray *)getAllResultsforRunId:(NSNumber *)runId;
- (MITestRailResult *)addResult:(MITestRailResult *)result ForTestId:(NSNumber *)testId;
- (MITestRailResult *)addResult:(MITestRailResult *)result ForRunId:(NSNumber *)runId ForCaseId:(NSNumber *)caseId;
- (NSArray *)addResults:(NSArray *)testResults ForRunId:(NSNumber *)runId;
- (NSArray *)addResultsForCases:(NSArray *)testResults ForRunId:(NSNumber *)runId;


#pragma mark - Test CRUD
- (MITestRailTest *)getTestWithId:(NSNumber *)testId;
- (NSArray *)getAllTestsWithRunId:(NSNumber *)runId;

#pragma mark - Case CRUD
- (MITestRailCase *)getCaseWithId:(NSNumber *)caseId;
- (NSArray *)getAllCasesForProjectId:(NSNumber *)projectId WithSectionId:(NSNumber *)sectionId WithSuiteId:(NSNumber *)suiteId;
- (MITestRailCase *)createCase:(MITestRailCase *)testCase WithSectionId:(NSNumber *)sectionId;
- (MITestRailCase *)updateCase:(MITestRailCase *)testCase;
- (BOOL)deleteCaseWithId:(NSNumber *)caseId;

#pragma mark - Configuration CRUD
- (NSArray *)getAllConfigGroupsForProjectId:(NSNumber *)projectId;
- (BOOL)deleteConfigWithId:(NSNumber *)configId;
- (BOOL)deleteConfigGroupWithId:(NSNumber *)configGroupId;
- (MITestRailConfig *)createConfig:(MITestRailConfig *)config InConfigGroupId:(NSNumber *)configGroupId;
- (MITestRailConfigGroup *)createConfigGroup:(MITestRailConfigGroup *)configGroup InProjectId:(NSNumber *)projectId;
- (MITestRailConfig *)updateConfig:(MITestRailConfig *)config;
- (MITestRailConfigGroup *)updateConfigurationGroup:(MITestRailConfigGroup *)configGroup;

#pragma mark - Plan CRUD
- (NSArray *)getAllPlansForProjectId:(NSNumber *)projectId;
- (MITestRailPlan *)getPlanWithId:(NSNumber *)planId;
- (BOOL)closePlanWithId:(NSNumber *)planId;
- (BOOL)deletePlanWithId:(NSNumber *)planId;
- (MITestRailPlan *)createPlan:(MITestRailPlan *)plan ForProjectId:(NSNumber *)projectId;
- (MITestRailPlan *)updatePlan:(MITestRailPlan *)plan;
- (MITestRailPlanEntry *)createPlanEntry:(MITestRailPlanEntry *)entry InPlanId:(NSNumber *)planId;
- (MITestRailPlanEntry *)updatePlanEntry:(MITestRailPlanEntry *)entry InPlanId:(NSNumber *)planId;
- (BOOL)deletePLanEntryWithEntryId:(NSString *)entryId InPlanId:(NSNumber *)planId;

#pragma mark - Run CRUD
- (NSArray *)getAllRunsForProjectId:(NSNumber *)projectId;
- (MITestRailRun *)getRunWithId:(NSNumber *)runId;
- (BOOL)closeRunWithId:(NSNumber *)runId;
- (BOOL)deleteRunWithId:(NSNumber *)runId;
- (MITestRailRun *)createRun:(MITestRailRun *)run ForProjectId:(NSNumber *)projectId;
- (MITestRailRun *)updateRun:(MITestRailRun *)run;

#pragma mark - Suite CRUD
- (MITestRailSuite *)createSuite:(MITestRailSuite *)suite ForProjectId:(NSNumber *)projectId;
- (MITestRailSuite *)updateSuite:(MITestRailSuite *)suite;
- (BOOL)deleteSuiteWithId:(NSNumber *)suiteId;
- (NSArray *)getAllSuitesForProject:(NSNumber *)projectId;
- (MITestRailSuite *)getSuiteWithId:(NSNumber *)suiteId;

#pragma mark - Section CRUD
- (MITestRailSection *)createSection:(MITestRailSection *)section ForProjectId:(NSNumber *)projectId;
- (MITestRailSection *)updateSection:(MITestRailSection *)section;
- (BOOL)deleteSectionWithId:(NSNumber *)sectionId;
- (NSArray *)getAllSectionsForProjectWithId:(NSNumber *)projectId WithSuiteId:(NSNumber *)suiteId;
- (MITestRailSection *)getSectionWithId:(NSNumber *)sectionId;

#pragma mark - Milestone CRUD
- (MITestRailMileStone *)createMileStone:(MITestRailMileStone *)mileStone ForProjectId:(NSNumber *)projectId;
- (MITestRailMileStone *)updateMileStone:(MITestRailMileStone *)mileStone;
- (BOOL)deleteMileStoneWithId:(NSNumber *)mileStoneId;
- (NSArray *)getAllMileStonesForProjectWithId:(NSNumber *)projectId;
- (MITestRailMileStone *)getMileStoneWithId:(NSNumber *)mileStoneId;

#pragma mark - User CRUD
- (NSArray *)getAllUsers;
- (MITestRailUser *)getUserWithId:(NSNumber *)userId;
- (MITestRailUser *)getUserWithEmail:(NSString *)email;

#pragma mark - Project CRUD
- (MITestRailProject *)createProject:(MITestRailProject *)project;
- (MITestRailProject *)updateProject:(MITestRailProject *)project;
- (BOOL)deleteProjectWithId:(NSNumber *)projectId;
- (NSArray *)getAllProjects;
- (MITestRailProject *)getProjectWithId:(NSNumber *)projectId;
@end
