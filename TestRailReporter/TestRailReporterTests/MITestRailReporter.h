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
- (NSArray *)getAllResultsforTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllResultsforCaseId:(NSNumber *)caseId ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllResultsforRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (MITestRailResult *)addResult:(MITestRailResult *)result ForTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (MITestRailResult *)addResult:(MITestRailResult *)result ForRunId:(NSNumber *)runId ForCaseId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
- (NSArray *)addResults:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (NSArray *)addResultsForCases:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;


#pragma mark - Test CRUD
- (MITestRailTest *)getTestWithId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllTestsWithRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;

#pragma mark - Case CRUD
- (MITestRailCase *)getCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllCasesForProjectId:(NSNumber *)projectId WithSectionId:(NSNumber *)sectionId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (MITestRailCase *)addCase:(MITestRailCase *)testCase WithSectionId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
- (MITestRailCase *)updateCase:(MITestRailCase *)testCase Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;

#pragma mark - Configuration CRUD
- (NSArray *)getAllConfigGroupsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteConfigWithId:(NSNumber *)configId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteConfigGroupWithId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error;
- (MITestRailConfig *)addConfig:(MITestRailConfig *)config InConfigGroupId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error;
- (MITestRailConfigGroup *)addConfigGroup:(MITestRailConfigGroup *)configGroup InProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailConfig *)updateConfig:(MITestRailConfig *)config Error:(NSError *__autoreleasing *)error;
- (MITestRailConfigGroup *)updateConfigurationGroup:(MITestRailConfigGroup *)configGroup Error:(NSError *__autoreleasing *)error;

#pragma mark - Plan CRUD
- (NSArray *)getAllPlansForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailPlan *)getPlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)closePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)deletePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (MITestRailPlan *)addPlan:(MITestRailPlan *)plan ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailPlan *)updatePlan:(MITestRailPlan *)plan Error:(NSError *__autoreleasing *)error;
- (MITestRailPlanEntry *)addPlanEntry:(MITestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (MITestRailPlanEntry *)updatePlanEntry:(MITestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)deletePLanEntryWithEntryId:(NSString *)entryId InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;

#pragma mark - Run CRUD
- (NSArray *)getAllRunsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailRun *)getRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (BOOL)closeRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (MITestRailRun *)addRun:(MITestRailRun *)run ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailRun *)updateRun:(MITestRailRun *)run Error:(NSError *__autoreleasing *)error;

#pragma mark - Suite CRUD
- (MITestRailSuite *)addSuite:(MITestRailSuite *)suite ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailSuite *)updateSuite:(MITestRailSuite *)suite Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllSuitesForProject:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailSuite *)getSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;

#pragma mark - Section CRUD
- (MITestRailSection *)addSection:(MITestRailSection *)section ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailSection *)updateSection:(MITestRailSection *)section Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllSectionsForProjectWithId:(NSNumber *)projectId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (MITestRailSection *)getSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;

#pragma mark - Milestone CRUD
- (MITestRailMileStone *)addMileStone:(MITestRailMileStone *)mileStone ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailMileStone *)updateMileStone:(MITestRailMileStone *)mileStone Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllMileStonesForProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (MITestRailMileStone *)getMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error;

#pragma mark - User CRUD
- (NSArray *)getAllUsersError:(NSError *__autoreleasing *)error;
- (MITestRailUser *)getUserWithId:(NSNumber *)userId Error:(NSError *__autoreleasing *)error;
- (MITestRailUser *)getUserWithEmail:(NSString *)email Error:(NSError *__autoreleasing *)error;

#pragma mark - Project CRUD
- (MITestRailProject *)addProject:(MITestRailProject *)project Error:(NSError *__autoreleasing *)error;
- (MITestRailProject *)updateProject:(MITestRailProject *)project Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllProjectsError:(NSError *__autoreleasing *)error;
- (MITestRailProject *)getProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
@end
