[![Build Status](https://travis-ci.org/SiddarthaPolisetty/SPTestRailReporter.svg?branch=master)](https://travis-ci.org/SiddarthaPolisetty/SPTestRailReporter)
[![Version](http://img.shields.io/cocoapods/v/SPTestRailReporter.svg?style=flat)](https://cocoapods.org/?q=SPTestRail) 
[![Platform](http://img.shields.io/cocoapods/p/SPTestRailReporter.svg?style=flat)](https://cocoapods.org/?q=SPTestRail)
[![License](http://img.shields.io/cocoapods/l/SPTestRailReporter.svg?style=flat)](https://github.com/SiddarthaPolisetty/SPTestRailReporter/blob/master/LICENSE)
# **SPTestRailReporter**
**[SPTestRailReporter](http://siddarthapolisetty.github.io/SPTestRailReporter/)** is the missing iOS Framework that automagically performs [TestRail](http://www.gurock.com/testrail/) Reporting.

## What is TestRail
Modern Test Case Management Software for QA and Development Teams
- Efficiently manage test cases, plans and runs.
- Boost testing productivity significantly.
- Get real-time insights into your testing progress.
- Integrates with your issue tracker & test automation.

## Add SPTestRailReporter to your project
- Simply add [`pod 'SPTestRailReporter', '1.0.0'`](https://cocoapods.org/?q=SPTestRail) as a dependency in your project.
- You can also fork/download and start building cool stuff with [SPTestRailReporter Repository](https://github.com/SiddarthaPolisetty/SPTestRailReporter). 

## Using SPTestRailReporter
**SPTestRailReporter** performs CRUD operations on most entities supported by TestRail api v2. The following documentation helps you onboard SPTestRailReporter.

- Headers Required
    ```objective-c
    #import <SPTestRailReporter/SPTestRailReporter.h>
    ```

- Configure to Point to your TestRail instance, provide credentials for accessing the api's.
    ```objective-c
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"<yourtestrailurl>"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"<yourtestrailemail>";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"<yourtestrailpassword>";
    ```

- Initialize SPTestRailReporter
    ```objective-c
    [SPTestRailReporter sharedReporter]
    ```

- Now, that you have SPTestRailProvider's singleton instance, you are all set to play with the following API interfaces.

- Utils for TestRail Results
    ```objective-c
    - (NSArray *)getAllResultsforTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)getAllResultsforCaseId:(NSNumber *)caseId ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)getAllResultsforRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailResult *)addResult:(SPTestRailResult *)result ForTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailResult *)addResult:(SPTestRailResult *)result ForRunId:(NSNumber *)runId ForCaseId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)addResults:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)addResultsForCases:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Tests
    ```objective-c
    - (SPTestRailTest *)getTestWithId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)getAllTestsWithRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Cases
    ```objective-c
    - (SPTestRailCase *)getCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)getAllCasesForProjectId:(NSNumber *)projectId WithSectionId:(NSNumber *)sectionId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailCase *)addCase:(SPTestRailCase *)testCase WithSectionId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailCase *)updateCase:(SPTestRailCase *)testCase Error:(NSError *__autoreleasing *)error;
    - (BOOL)deleteCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Config and Cofig Groups
    ```objective-c
    - (NSArray *)getAllConfigGroupsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (BOOL)deleteConfigWithId:(NSNumber *)configId Error:(NSError *__autoreleasing *)error;
    - (BOOL)deleteConfigGroupWithId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailConfig *)addConfig:(SPTestRailConfig *)config InConfigGroupId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailConfigGroup *)addConfigGroup:(SPTestRailConfigGroup *)configGroup InProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailConfig *)updateConfig:(SPTestRailConfig *)config Error:(NSError *__autoreleasing *)error;
    - (SPTestRailConfigGroup *)updateConfigurationGroup:(SPTestRailConfigGroup *)configGroup Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Plans
    ```objective-c
    - (NSArray *)getAllPlansForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailPlan *)getPlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
    - (BOOL)closePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
    - (BOOL)deletePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailPlan *)addPlan:(SPTestRailPlan *)plan ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailPlan *)updatePlan:(SPTestRailPlan *)plan Error:(NSError *__autoreleasing *)error;
    - (SPTestRailPlanEntry *)addPlanEntry:(SPTestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailPlanEntry *)updatePlanEntry:(SPTestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
    - (BOOL)deletePLanEntryWithEntryId:(NSString *)entryId InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Runs
    ```objective-c
    - (NSArray *)getAllRunsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailRun *)getRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
    - (BOOL)closeRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
    - (BOOL)deleteRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailRun *)addRun:(SPTestRailRun *)run ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailRun *)updateRun:(SPTestRailRun *)run Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Suites
    ```objective-c
    - (SPTestRailSuite *)addSuite:(SPTestRailSuite *)suite ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailSuite *)updateSuite:(SPTestRailSuite *)suite Error:(NSError *__autoreleasing *)error;
    - (BOOL)deleteSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)getAllSuitesForProject:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailSuite *)getSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Sections
    ```objective-c
    - (SPTestRailSection *)addSection:(SPTestRailSection *)section ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailSection *)updateSection:(SPTestRailSection *)section Error:(NSError *__autoreleasing *)error;
    - (BOOL)deleteSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)getAllSectionsForProjectWithId:(NSNumber *)projectId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailSection *)getSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Milestones
    ```objective-c
    - (SPTestRailMileStone *)addMileStone:(SPTestRailMileStone *)mileStone ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailMileStone *)updateMileStone:(SPTestRailMileStone *)mileStone Error:(NSError *__autoreleasing *)error;
    - (BOOL)deleteMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)getAllMileStonesForProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailMileStone *)getMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Users
    ```objective-c
    - (NSArray *)getAllUsersError:(NSError *__autoreleasing *)error;
    - (SPTestRailUser *)getUserWithId:(NSNumber *)userId Error:(NSError *__autoreleasing *)error;
    - (SPTestRailUser *)getUserWithEmail:(NSString *)email Error:(NSError *__autoreleasing *)error;
    ```

- Utils for TestRail Projects
    ```objective-c
    - (SPTestRailProject *)addProject:(SPTestRailProject *)project Error:(NSError *__autoreleasing *)error;
    - (SPTestRailProject *)updateProject:(SPTestRailProject *)project Error:(NSError *__autoreleasing *)error;
    - (BOOL)deleteProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    - (NSArray *)getAllProjectsError:(NSError *__autoreleasing *)error;
    - (SPTestRailProject *)getProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error;
    ```
    
- More Usage Examples can be found in [Example](https://github.com/SiddarthaPolisetty/SPTestRailReporter/tree/master/SPTestRailReporterExample). This Example adds SPTestRailReporter as a pod to the test target.

## TestRail API Reference
More Information on model schema, usage information and common error codes can be found here [API V2](http://docs.gurock.com/testrail-api2/start) 

## Author and Contributor
Created with love by [Siddartha Polisetty](https://www.linkedin.com/in/siddarthapolisetty). 

## Contact
Please Create an issue and assign it to @SiddarthaPolisetty.

## Shameless Plugs
![Mentions](https://s3.amazonaws.com/mentions/mentions.png)

## Together we can end World Hunger. Please [Donate](http://www.shfb.org/donate)
