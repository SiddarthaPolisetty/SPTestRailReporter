# **SPTestRailReporter**
**SPTestRailReporter** is the missing iOS Framework that automagically performs [TestRail](http://www.gurock.com/testrail/) Reporting.

## What is TestRail
Modern Test Case Management Software for QA and Development Teams
- Efficiently manage test cases, plans and runs.
- Boost testing productivity significantly.
- Get real-time insights into your testing progress.
- Integrates with your issue tracker & test automation.

## How to integrate SPTestRailReporter into your project
- At present we have this [SPTestRailReporter](https://github.com/SiddarthaPolisetty/SPTestRailReporter) Repository. You can download and start building cool stuff.
- We are busy building more features and eventually create a pod to easily plug and play :)

## Using SPTestRailReporter
**SPTestRailReporter** performs almost all CRUD operations on all entities supported by TestRail api v2. The following methods provide an overview of SPTestRailReporter's interface.

```objective-c
//Result CRUD
- (NSArray *)getAllResultsforTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllResultsforCaseId:(NSNumber *)caseId ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllResultsforRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (SPTestRailResult *)addResult:(SPTestRailResult *)result ForTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (SPTestRailResult *)addResult:(SPTestRailResult *)result ForRunId:(NSNumber *)runId ForCaseId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
- (NSArray *)addResults:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (NSArray *)addResultsForCases:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;


//Test CRUD
- (SPTestRailTest *)getTestWithId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllTestsWithRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;

//Case CRUD
- (SPTestRailCase *)getCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllCasesForProjectId:(NSNumber *)projectId WithSectionId:(NSNumber *)sectionId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (SPTestRailCase *)addCase:(SPTestRailCase *)testCase WithSectionId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
- (SPTestRailCase *)updateCase:(SPTestRailCase *)testCase Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;

//Configs and ConfigGroup CRUD
- (NSArray *)getAllConfigGroupsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteConfigWithId:(NSNumber *)configId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteConfigGroupWithId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error;
- (SPTestRailConfig *)addConfig:(SPTestRailConfig *)config InConfigGroupId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error;
- (SPTestRailConfigGroup *)addConfigGroup:(SPTestRailConfigGroup *)configGroup InProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailConfig *)updateConfig:(SPTestRailConfig *)config Error:(NSError *__autoreleasing *)error;
- (SPTestRailConfigGroup *)updateConfigurationGroup:(SPTestRailConfigGroup *)configGroup Error:(NSError *__autoreleasing *)error;

//Plan CRUD
- (NSArray *)getAllPlansForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlan *)getPlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)closePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)deletePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlan *)addPlan:(SPTestRailPlan *)plan ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlan *)updatePlan:(SPTestRailPlan *)plan Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlanEntry *)addPlanEntry:(SPTestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (SPTestRailPlanEntry *)updatePlanEntry:(SPTestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
- (BOOL)deletePLanEntryWithEntryId:(NSString *)entryId InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;

//Run CRUD
- (NSArray *)getAllRunsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailRun *)getRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (BOOL)closeRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
- (SPTestRailRun *)addRun:(SPTestRailRun *)run ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailRun *)updateRun:(SPTestRailRun *)run Error:(NSError *__autoreleasing *)error;

//Suite CRUD
- (SPTestRailSuite *)addSuite:(SPTestRailSuite *)suite ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailSuite *)updateSuite:(SPTestRailSuite *)suite Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllSuitesForProject:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailSuite *)getSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;

//Section CRUD
- (SPTestRailSection *)addSection:(SPTestRailSection *)section ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailSection *)updateSection:(SPTestRailSection *)section Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllSectionsForProjectWithId:(NSNumber *)projectId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
- (SPTestRailSection *)getSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;

//Milestone CRUD
- (SPTestRailMileStone *)addMileStone:(SPTestRailMileStone *)mileStone ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailMileStone *)updateMileStone:(SPTestRailMileStone *)mileStone Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllMileStonesForProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (SPTestRailMileStone *)getMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error;

//User CRUD
- (NSArray *)getAllUsersError:(NSError *__autoreleasing *)error;
- (SPTestRailUser *)getUserWithId:(NSNumber *)userId Error:(NSError *__autoreleasing *)error;
- (SPTestRailUser *)getUserWithEmail:(NSString *)email Error:(NSError *__autoreleasing *)error;

//Project CRUD
- (SPTestRailProject *)addProject:(SPTestRailProject *)project Error:(NSError *__autoreleasing *)error;
- (SPTestRailProject *)updateProject:(SPTestRailProject *)project Error:(NSError *__autoreleasing *)error;
- (BOOL)deleteProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
- (NSArray *)getAllProjectsError:(NSError *__autoreleasing *)error;
- (SPTestRailProject *)getProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
```

## Authors and Contributors
Created with love by @SiddarthaPolisetty. 

## Support or Contact
Please Create an issue and assign it to @SiddarthaPolisetty.