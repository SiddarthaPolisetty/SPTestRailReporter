//
//  SPTestRailReporter.h
//  DocsAtWork
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





#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "SPTestRailConfigurationBuilder.h"
#import "SPTestRailProject.h"
#import "SPTestRailSuite.h"
#import "SPTestRailProject.h"
#import "SPTestRailCase.h"
#import "SPTestRailMileStone.h"
#import "SPTestRailRun.h"
#import "SPTestRailUser.h"
#import "SPTestRailSection.h"
#import "SPTestRailPlan.h"
#import "SPTestRailConfigGroup.h"
#import "SPTestRailTest.h"
#import "SPTestRailResult.h"

@interface SPTestRailReporter : NSObject
+ (instancetype)sharedReporter;

#pragma mark - Result CRUD
- (NSArray *)getAllResultsforTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllResultsforCaseId:(NSNumber *)caseId ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllResultsforRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (SPTestRailResult *)addResult:(SPTestRailResult *)result ForTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (SPTestRailResult *)addResult:(SPTestRailResult *)result ForRunId:(NSNumber *)runId ForCaseId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
- (NSArray *)addResults:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (NSArray *)addResultsForCases:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;


#pragma mark - Test CRUD
- (SPTestRailTest *)getTestWithId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllTestsWithRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;

#pragma mark - Case CRUD
- (SPTestRailCase *)getCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllCasesForProjectId:(NSNumber *)projectId WithSectionId:(NSNumber *)sectionId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (SPTestRailCase *)addCase:(SPTestRailCase *)testCase WithSectionId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
- (SPTestRailCase *)updateCase:(SPTestRailCase *)testCase Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;

#pragma mark - Configuration CRUD
- (NSArray *)getAllConfigGroupsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteConfigWithId:(NSNumber *)configId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteConfigGroupWithId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error;
- (SPTestRailConfig *)addConfig:(SPTestRailConfig *)config InConfigGroupId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error;
- (SPTestRailConfigGroup *)addConfigGroup:(SPTestRailConfigGroup *)configGroup InProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailConfig *)updateConfig:(SPTestRailConfig *)config Error:(NSError *__autoreleasing *)error;
- (SPTestRailConfigGroup *)updateConfigurationGroup:(SPTestRailConfigGroup *)configGroup Error:(NSError *__autoreleasing *)error;

#pragma mark - Plan CRUD
- (NSArray *)getAllPlansForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlan *)getPlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)closePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)deletePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlan *)addPlan:(SPTestRailPlan *)plan ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlan *)updatePlan:(SPTestRailPlan *)plan Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlanEntry *)addPlanEntry:(SPTestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlanEntry *)updatePlanEntry:(SPTestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)deletePLanEntryWithEntryId:(NSString *)entryId InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;

#pragma mark - Run CRUD
- (NSArray *)getAllRunsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailRun *)getRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (BOOL)closeRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (SPTestRailRun *)addRun:(SPTestRailRun *)run ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailRun *)updateRun:(SPTestRailRun *)run Error:(NSError *__autoreleasing *)error;

#pragma mark - Suite CRUD
- (SPTestRailSuite *)addSuite:(SPTestRailSuite *)suite ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailSuite *)updateSuite:(SPTestRailSuite *)suite Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllSuitesForProject:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailSuite *)getSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;

#pragma mark - Section CRUD
- (SPTestRailSection *)addSection:(SPTestRailSection *)section ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailSection *)updateSection:(SPTestRailSection *)section Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllSectionsForProjectWithId:(NSNumber *)projectId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (SPTestRailSection *)getSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;

#pragma mark - Milestone CRUD
- (SPTestRailMileStone *)addMileStone:(SPTestRailMileStone *)mileStone ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailMileStone *)updateMileStone:(SPTestRailMileStone *)mileStone Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllMileStonesForProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailMileStone *)getMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error;

#pragma mark - User CRUD
- (NSArray *)getAllUsersError:(NSError *__autoreleasing *)error;
- (SPTestRailUser *)getUserWithId:(NSNumber *)userId Error:(NSError *__autoreleasing *)error;
- (SPTestRailUser *)getUserWithEmail:(NSString *)email Error:(NSError *__autoreleasing *)error;

#pragma mark - Project CRUD
- (SPTestRailProject *)addProject:(SPTestRailProject *)project Error:(NSError *__autoreleasing *)error;
- (SPTestRailProject *)updateProject:(SPTestRailProject *)project Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllProjectsError:(NSError *__autoreleasing *)error;
- (SPTestRailProject *)getProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
@end
