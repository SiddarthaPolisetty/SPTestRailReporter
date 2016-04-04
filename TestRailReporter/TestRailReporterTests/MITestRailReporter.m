//
//  MITestRailReporter.m
//  DocsAtWork
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 MobileIron. All rights reserved.
//
#import "MITestRailReporter.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "NSData+Base64.h"
#import "JSONHTTPClient.h"

@implementation MITestRailReporter
+ (instancetype)sharedReporter {
    static dispatch_once_t onceToken = 0;
    static MITestRailReporter *sharedReporter = nil;
    dispatch_once(&onceToken, ^{
        sharedReporter = [[self alloc] initPrivate];
    });
    
    return sharedReporter;
}


- (instancetype)initPrivate {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)init {
    [NSException raise:@"Invalid Initializer" format:@"Please use [MITestRailReporter sharedReporter]"];
    return nil;
}


- (id) syncronousRequestWithMethod:(NSString*)method URL:(NSURL*)requestURL Parameters: (NSDictionary*) parameters {
    __block id reponseJSON = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //@"https://mobileiron.testrail.net?/api/v2/get_projects"
    NSMutableURLRequest *mitrRequest = [NSMutableURLRequest requestWithURL:requestURL];
    [mitrRequest setHTTPMethod:method];
    [mitrRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mitrRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [mitrRequest setValue:@"MITestRailReporter Client" forHTTPHeaderField:@"User-Agent"];
    [mitrRequest setValue:[MITestRailConfigurationBuilder sharedConfigurationBuilder].valueForAuthHeader forHTTPHeaderField:@"Authorization"];
    if (parameters) {
        NSError *error = nil;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        if (!error) {
            [mitrRequest setHTTPBody:requestData];
        }
    }
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:mitrRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        reponseJSON = [responseObject mutableCopy];
        dispatch_semaphore_signal(semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NSException raise:@"Error" format:[NSString stringWithFormat:@"%@", error.description]];
    }];
    [operation start];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return reponseJSON;
}


#pragma mark - Case CRUD
- (MITestRailCase *)getCaseWithId:(NSNumber *)caseId {
    NSString *getCaseURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_case/%@", caseId]];
    NSURL *getCaseURL = [NSURL URLWithString:getCaseURLString];
    NSDictionary *getCaseURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getCaseURL Parameters:nil];
    NSError *error = nil;
    MITestRailCase *fetchedCase = [[MITestRailCase alloc] initWithDictionary:getCaseURLResponse error:&error];
    return error ? nil : fetchedCase;
}

- (NSArray *)getAllCasesForProjectId:(NSNumber *)projectId WithSectionId:(NSNumber *)sectionId WithSuiteId:(NSNumber *)suiteId {
    NSString *getAllCasesURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_cases/%@&suite_id=%@&section_id=%@",projectId, suiteId, sectionId]];
    NSURL *getAllCasesURL = [NSURL URLWithString:getAllCasesURLString];
    NSArray *getAllCasesURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllCasesURL Parameters:nil];
    NSError *error = nil;
    NSArray *casesArray = [MITestRailCase arrayOfModelsFromDictionaries:getAllCasesURLResponse error:&error];
    return error ? nil : casesArray;
}

- (MITestRailCase *)createCase:(MITestRailCase *)testCase WithSectionId:(NSNumber *)sectionId {
    NSString *createCaseURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_case/%@", sectionId]];
    NSURL *createCaseURL = [NSURL URLWithString:createCaseURLString];
    NSDictionary *createCaseURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createCaseURL Parameters:[testCase toDictionary]];
    NSError *error = nil;
    MITestRailCase *createdCase = [[MITestRailCase alloc] initWithDictionary:createCaseURLResponse error:&error];
    return error ? nil : createdCase;
}

- (MITestRailCase *)updateCase:(MITestRailCase *)testCase {
    NSString *updateCaseURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_case/%@", testCase.caseId]];
    NSURL *updateCaseURL = [NSURL URLWithString:updateCaseURLString];
    NSDictionary *updateCaseURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateCaseURL Parameters:[testCase toDictionary]];
    NSError *error = nil;
    MITestRailCase *updatedCase = [[MITestRailCase alloc] initWithDictionary:updateCaseURLResponse error:&error];
    return error ? nil : updatedCase;
}

- (BOOL)deleteCaseWithId:(NSNumber *)caseId {
    NSString *deleteCaseURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_case/%@", caseId]];
    NSURL *deleteCaseURL = [NSURL URLWithString:deleteCaseURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteCaseURL Parameters:nil];
    return YES;
}

#pragma mark - Configuration CRUD
- (NSArray *)getAllConfigGroupsForProjectId:(NSNumber *)projectId {
    NSString *getAllConfigGroupsURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_configs/%@",projectId]];
    NSURL *getAllConfigGroupsURL = [NSURL URLWithString:getAllConfigGroupsURLString];
    NSArray *getAllConfigGroupsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllConfigGroupsURL Parameters:nil];
    NSError *error = nil;
    NSArray *configsArray = [MITestRailConfigGroup arrayOfModelsFromDictionaries:getAllConfigGroupsURLResponse error:&error];
    return error ? nil : configsArray;
}

- (BOOL)deleteConfigWithId:(NSNumber *)configId {
    NSString *deleteConfigURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_config/%@", configId]];
    NSURL *deleteConfigURL = [NSURL URLWithString:deleteConfigURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteConfigURL Parameters:nil];
    return YES;
}

- (BOOL)deleteConfigGroupWithId:(NSNumber *)configGroupId {
    NSString *deleteConfigGroupURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_config_group/%@", configGroupId]];
    NSURL *deleteConfigGroupURL = [NSURL URLWithString:deleteConfigGroupURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteConfigGroupURL Parameters:nil];
    return YES;
}

- (MITestRailConfig *)createConfig:(MITestRailConfig *)config InConfigGroupId:(NSNumber *)configGroupId {
    NSString *createConfigURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_config/%@", configGroupId]];
    NSURL *createConfigURL = [NSURL URLWithString:createConfigURLString];
    NSDictionary *createConfigURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createConfigURL Parameters:[config toDictionary]];
    NSError *error = nil;
    MITestRailConfig *createdConfig = [[MITestRailConfig alloc] initWithDictionary:createConfigURLResponse error:&error];
    return error ? nil : createdConfig;
}

- (MITestRailConfigGroup *)createConfigGroup:(MITestRailConfigGroup *)configGroup InProjectId:(NSNumber *)projectId {
    NSString *createConfigGroupURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_config_group/%@", projectId]];
    NSURL *createConfigGroupURL = [NSURL URLWithString:createConfigGroupURLString];
    NSDictionary *createConfigGroupURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createConfigGroupURL Parameters:[configGroup toDictionary]];
    NSError *error = nil;
    MITestRailConfigGroup *createdConfigGroup = [[MITestRailConfigGroup alloc] initWithDictionary:createConfigGroupURLResponse error:&error];
    return error ? nil : createdConfigGroup;
}

- (MITestRailConfig *)updateConfig:(MITestRailConfig *)config {
    NSString *updateConfigURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_config/%@", config.configId]];
    NSURL *updateConfigURL = [NSURL URLWithString:updateConfigURLString];
    NSDictionary *updateConfigURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateConfigURL Parameters:[config toDictionary]];
    NSError *error = nil;
    MITestRailConfig *updatedConfig = [[MITestRailConfig alloc] initWithDictionary:updateConfigURLResponse error:&error];
    return error ? nil : updatedConfig;
}

- (MITestRailConfigGroup *)updateConfigurationGroup:(MITestRailConfigGroup *)configGroup {
    NSString *updateConfigGroupURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_config_group/%@", configGroup.configGroupId]];
    NSURL *updateConfigGroupURL = [NSURL URLWithString:updateConfigGroupURLString];
    NSDictionary *updateConfigGroupURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateConfigGroupURL Parameters:[configGroup toDictionary]];
    NSError *error = nil;
    MITestRailConfigGroup *updatedConfigGroup = [[MITestRailConfigGroup alloc] initWithDictionary:updateConfigGroupURLResponse error:&error];
    return error ? nil : updatedConfigGroup;
}

#pragma mark - Plan CRUD
- (NSArray *)getAllPlansForProjectId:(NSNumber *)projectId {
    NSString *getAllPlansRunsURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_plans/%@",projectId]];
    NSURL *getAllPlansRunsURL = [NSURL URLWithString:getAllPlansRunsURLString];
    NSArray *getAllPlansRunsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllPlansRunsURL Parameters:nil];
    NSError *error = nil;
    NSArray *testPlansArray = [MITestRailPlan arrayOfModelsFromDictionaries:getAllPlansRunsURLResponse error:&error];
    return error ? nil : testPlansArray;
}

- (MITestRailPlan *)getPlanWithId:(NSNumber *)planId {
    NSString *getPlanURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_plan/%@", planId]];
    NSURL *getPlanURL = [NSURL URLWithString:getPlanURLString];
    NSDictionary *getPlanURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getPlanURL Parameters:nil];
    NSError *error = nil;
    MITestRailPlan *fetchedPlan = [[MITestRailPlan alloc] initWithDictionary:getPlanURLResponse error:&error];
    return error ? nil : fetchedPlan;
}

- (BOOL)closePlanWithId:(NSNumber *)planId {
    NSString *closePlanURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/close_plan/%@", planId]];
    NSURL *closePlanURL = [NSURL URLWithString:closePlanURLString];
    [self syncronousRequestWithMethod:@"POST" URL:closePlanURL Parameters:nil];
    return YES;
}
- (BOOL)deletePlanWithId:(NSNumber *)planId {
    NSString *deletePlanURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_plan/%@", planId]];
    NSURL *deletePlanURL = [NSURL URLWithString:deletePlanURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deletePlanURL Parameters:nil];
    return YES;
}

- (MITestRailPlan *)createPlan:(MITestRailPlan *)plan ForProjectId:(NSNumber *)projectId {
    NSString *createPlanURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_plan/%@", projectId]];
    NSURL *createPlanURL = [NSURL URLWithString:createPlanURLString];
    NSDictionary *createPlanURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createPlanURL Parameters:[plan toDictionary]];
    NSError *error = nil;
    MITestRailPlan *createdPlan = [[MITestRailPlan alloc] initWithDictionary:createPlanURLResponse error:&error];
    return error ? nil : createdPlan;
}

- (MITestRailPlan *)updatePlan:(MITestRailPlan *)plan {
    NSString *updatePlanURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_plan/%@", plan.planId]];
    NSURL *updatePlanURL = [NSURL URLWithString:updatePlanURLString];
    NSDictionary *updatePlanURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updatePlanURL Parameters:[plan toDictionary]];
    NSError *error = nil;
    MITestRailPlan *updatedPlan = [[MITestRailPlan alloc] initWithDictionary:updatePlanURLResponse error:&error];
    return error ? nil : updatedPlan;
}

- (MITestRailPlanEntry *)createPlanEntry:(MITestRailPlanEntry *)entry InPlanId:(NSNumber *)planId {
    NSString *createPlanEntryURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_plan_entry/%@", planId]];
    NSURL *createPlanEntryURL = [NSURL URLWithString:createPlanEntryURLString];
    NSDictionary *createPlanEntryURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createPlanEntryURL Parameters:[entry toDictionary]];
    NSError *error = nil;
    MITestRailPlanEntry *createdPlanEntry = [[MITestRailPlanEntry alloc] initWithDictionary:createPlanEntryURLResponse error:&error];
    return error ? nil : createdPlanEntry;
}

- (MITestRailPlanEntry *)updatePlanEntry:(MITestRailPlanEntry *)entry InPlanId:(NSNumber *)planId {
    NSString *updatePlanEntryURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_plan_entry/%@/%@", planId, entry.planEntryId]];
    NSURL *updatePlanEntryURL = [NSURL URLWithString:updatePlanEntryURLString];
    NSDictionary *updatePlanEntryURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updatePlanEntryURL Parameters:[entry toDictionary]];
    NSError *error = nil;
    MITestRailPlanEntry *updatedPlanEntry = [[MITestRailPlanEntry alloc] initWithDictionary:updatePlanEntryURLResponse error:&error];
    return error ? nil : updatedPlanEntry;
}

- (BOOL)deletePLanEntryWithEntryId:(NSString *)entryId InPlanId:(NSNumber *)planId {
    NSString *deletePlanEntryURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_plan_entry/%@/%@", planId, entryId]];
    NSURL *deletePlanEntryURL = [NSURL URLWithString:deletePlanEntryURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deletePlanEntryURL Parameters:nil];
    return YES;
}

#pragma mark - Run CRUD
- (NSArray *)getAllRunsForProjectId:(NSNumber *)projectId {
    NSString *getAllTestRunsURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_runs/%@",projectId]];
    NSURL *getAllTestRunsURL = [NSURL URLWithString:getAllTestRunsURLString];
    NSArray *getAllTestRunsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllTestRunsURL Parameters:nil];
    NSError *error = nil;
    NSArray *testRunsArray = [MITestRailRun arrayOfModelsFromDictionaries:getAllTestRunsURLResponse error:&error];
    return error ? nil : testRunsArray;
}

- (MITestRailRun *)getRunWithId:(NSNumber *)runId {
    NSString *getTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_run/%@", runId]];
    NSURL *getTestRunURL = [NSURL URLWithString:getTestRunURLString];
    NSDictionary *getTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getTestRunURL Parameters:nil];
    NSError *error = nil;
    MITestRailRun *fetchedTestRun = [[MITestRailRun alloc] initWithDictionary:getTestRunURLResponse error:&error];
    return error ? nil : fetchedTestRun;
}

- (BOOL)closeRunWithId:(NSNumber *)runId {
    NSString *closeTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/close_run/%@", runId]];
    NSURL *closeTestRunURL = [NSURL URLWithString:closeTestRunURLString];
    [self syncronousRequestWithMethod:@"POST" URL:closeTestRunURL Parameters:nil];
    return YES;
}

- (BOOL)deleteRunWithId:(NSNumber *)runId {
    NSString *deleteTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_run/%@", runId]];
    NSURL *deleteTestRunURL = [NSURL URLWithString:deleteTestRunURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteTestRunURL Parameters:nil];
    return YES;
}

- (MITestRailRun *)createRun:(MITestRailRun *)run ForProjectId:(NSNumber *)projectId {
    NSString *createTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_run/%@", projectId]];
    NSURL *createTestRunURL = [NSURL URLWithString:createTestRunURLString];
    NSDictionary *createTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createTestRunURL Parameters:[run toDictionary]];
    NSError *error = nil;
    MITestRailRun *createdTestRun = [[MITestRailRun alloc] initWithDictionary:createTestRunURLResponse error:&error];
    return error ? nil : createdTestRun;
}

- (MITestRailRun *)updateRun:(MITestRailRun *)run {
    NSString *updateTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_run/%@", run.runId]];
    NSURL *updateTestRunURL = [NSURL URLWithString:updateTestRunURLString];
    NSDictionary *updateTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateTestRunURL Parameters:[run toDictionary]];
    NSError *error = nil;
    MITestRailRun *updateTestRun = [[MITestRailRun alloc] initWithDictionary:updateTestRunURLResponse error:&error];
    return error ? nil : updateTestRun;
}

#pragma mark - Suite CRUD
- (MITestRailSuite *)createSuite:(MITestRailSuite *)suite ForProjectId:(NSNumber *)projectId {
    NSString *createSuiteURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_suite/%@", projectId]];
    NSURL *createSuiteURL = [NSURL URLWithString:createSuiteURLString];
    NSDictionary *createSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createSuiteURL Parameters:[suite toDictionary]];
    NSError *error = nil;
    MITestRailSuite *createdSuite = [[MITestRailSuite alloc] initWithDictionary:createSuiteURLResponse error:&error];
    return error ? nil :createdSuite;
}

- (MITestRailSuite *)updateSuite:(MITestRailSuite *)suite {
    NSString *updateSuiteURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_suite/%@", suite.suiteId]];
    NSURL *updateSuiteURL = [NSURL URLWithString:updateSuiteURLString];
    NSDictionary *updateSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateSuiteURL Parameters:[suite toDictionary]];
    NSError *error = nil;
    MITestRailSuite *updatedSuite = [[MITestRailSuite alloc] initWithDictionary:updateSuiteURLResponse error:&error];
    return error ? nil :updatedSuite;
}

- (BOOL)deleteSuiteWithId:(NSNumber *)suiteId {
    NSString *deleteSuiteURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_suite/%@", suiteId]];
    NSURL *deleteSuiteURL = [NSURL URLWithString:deleteSuiteURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteSuiteURL Parameters:nil];
    return YES;
}

- (NSArray *)getAllSuitesForProject:(NSNumber *)projectId {
    NSString *getAllSuitesURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_suites/%@",projectId]];
    NSURL *getAllSuitesURL = [NSURL URLWithString:getAllSuitesURLString];
    NSArray *getAllSuitesURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllSuitesURL Parameters:nil];
    NSError *error = nil;
    NSArray *suitesArray = [MITestRailSuite arrayOfModelsFromDictionaries:getAllSuitesURLResponse error:&error];
    return error ? nil :suitesArray;
}

- (MITestRailSuite *)getSuiteWithId:(NSNumber *)suiteId {
    NSString *getSuiteURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_suite/%@",suiteId]];
    NSURL *getSuiteURL = [NSURL URLWithString:getSuiteURLString];
    NSDictionary *getSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getSuiteURL Parameters:nil];
    NSError *error = nil;
    MITestRailSuite *fetchedSuite = [[MITestRailSuite alloc] initWithDictionary:getSuiteURLResponse error:&error];
    return error ? nil :fetchedSuite;
}

#pragma mark - Section CRUD
- (MITestRailSection *)createSection:(MITestRailSection *)section ForProjectId:(NSNumber *)projectId {
    NSString *createSectionURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_section/%@", projectId]];
    NSURL *createSectionURL = [NSURL URLWithString:createSectionURLString];
    NSDictionary *createSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createSectionURL Parameters:[section toDictionary]];
    NSError *error = nil;
    MITestRailSection *createdSection = [[MITestRailSection alloc] initWithDictionary:createSectionURLResponse error:&error];
    return error ? nil : createdSection;
}

- (MITestRailSection *)updateSection:(MITestRailSection *)section {
    NSString *updateSectionURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_section/%@", section.sectionId]];
    NSURL *updateSectionURL = [NSURL URLWithString:updateSectionURLString];
    NSDictionary *updateSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateSectionURL Parameters:[section toDictionary]];
    NSError *error = nil;
    MITestRailSection *updatedSection = [[MITestRailSection alloc] initWithDictionary:updateSectionURLResponse error:&error];
    return error ? nil : updatedSection;
}

- (BOOL)deleteSectionWithId:(NSNumber *)sectionId {
    NSString *deleteSectionURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_section/%@",sectionId]];
    NSURL *deleteSectionURL = [NSURL URLWithString:deleteSectionURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteSectionURL Parameters:nil];
    return YES;
}

- (MITestRailSection *)getSectionWithId:(NSNumber *)sectionId {
    NSString *getSectionURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_section/%@",sectionId]];
    NSURL *getSectionURL = [NSURL URLWithString:getSectionURLString];
    NSDictionary *getSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getSectionURL Parameters:nil];
    NSError *error = nil;
    MITestRailSection *fetchedSection = [[MITestRailSection alloc] initWithDictionary:getSectionURLResponse error:&error];
    return error ? nil : fetchedSection;
}

- (NSArray *)getAllSectionsForProjectWithId:(NSNumber *)projectId WithSuiteId:(NSNumber *)suiteId {
    NSString *getAllSectionsURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_sections/%@&suite_id=%@",projectId, suiteId]];
    NSURL *getAllSectionsURL = [NSURL URLWithString:getAllSectionsURLString];
    NSArray *getAllSectionsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllSectionsURL Parameters:nil];
    NSError *error = nil;
    NSArray *sectionsArray = [MITestRailSection arrayOfModelsFromDictionaries:getAllSectionsURLResponse error:&error];
    return error ? nil : sectionsArray;
}

#pragma mark - Milestone CRUD
- (MITestRailMileStone *)createMileStone:(MITestRailMileStone *)mileStone ForProjectId:(NSNumber *)projectId {
    NSString *createMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_milestone/%@", projectId]];
    NSURL *createMileStoneURL = [NSURL URLWithString:createMileStoneURLString];
    NSDictionary *createMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createMileStoneURL Parameters:[mileStone toDictionary]];
    NSError *error = nil;
    MITestRailMileStone *createdMileStone = [[MITestRailMileStone alloc] initWithDictionary:createMileStoneURLResponse error:&error];
    return error ? nil : createdMileStone;
}

- (MITestRailMileStone *)updateMileStone:(MITestRailMileStone *)mileStone {
    NSString *updateMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_milestone/%@", mileStone.mileStoneId]];
    NSURL *updateMileStoneURL = [NSURL URLWithString:updateMileStoneURLString];
    NSDictionary *updateMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateMileStoneURL Parameters:[mileStone toDictionary]];
    NSError *error = nil;
    MITestRailMileStone *updatedMileStone = [[MITestRailMileStone alloc] initWithDictionary:updateMileStoneURLResponse error:&error];
    return error ? nil : updatedMileStone;
}

- (BOOL)deleteMileStoneWithId:(NSNumber *)mileStoneId {
    NSString *deleteMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_milestone/%@",mileStoneId]];
    NSURL *deleteMileStoneURL = [NSURL URLWithString:deleteMileStoneURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteMileStoneURL Parameters:nil];
    return YES;
}


- (NSArray *)getAllMileStonesForProjectWithId:(NSNumber *)projectId {
    NSString *getAllMileStonesURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_milestones/%@",projectId]];
    NSURL *getAllMileStonesURL = [NSURL URLWithString:getAllMileStonesURLString];
    NSArray *getAllMileStonesURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllMileStonesURL Parameters:nil];
    NSError *error = nil;
    NSArray *mileStonesArray = [MITestRailMileStone arrayOfModelsFromDictionaries:getAllMileStonesURLResponse error:&error];
    return error ? nil : mileStonesArray;
}

- (MITestRailMileStone *)getMileStoneWithId:(NSNumber *)mileStoneId {
    NSString *getMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_milestone/%@",mileStoneId]];
    NSURL *getMileStoneURL = [NSURL URLWithString:getMileStoneURLString];
    NSDictionary *getMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getMileStoneURL Parameters:nil];
    NSError *error = nil;
    MITestRailMileStone *fetchedMileStone = [[MITestRailMileStone alloc] initWithDictionary:getMileStoneURLResponse error:&error];
    return error ? nil : fetchedMileStone;
}


#pragma mark - User CRUD
- (NSArray *)getAllUsers {
    NSString *getAllUsersURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:@"index.php?/api/v2/get_users"];
    NSURL *getAllProjectsURL = [NSURL URLWithString:getAllUsersURLString];
    NSArray *getAllUsersURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllProjectsURL Parameters:nil];
    NSError *error = nil;
    NSArray *usersArray = [MITestRailUser arrayOfModelsFromDictionaries:getAllUsersURLResponse error:&error];
    return error ? nil : usersArray;
}

- (MITestRailUser *)getUserWithId:(NSNumber *)userId {
    NSString *getUserURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_user/%@", userId]];
    NSURL *getUserURL = [NSURL URLWithString:getUserURLString];
    NSDictionary *getUserURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getUserURL Parameters:nil];
    NSError *error = nil;
    MITestRailUser *fetchedUser = [[MITestRailUser alloc] initWithDictionary:getUserURLResponse error:&error];
    return error ? nil : fetchedUser;
}

- (MITestRailUser *)getUserWithEmail:(NSString *)email {
    NSString *getUserURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_user_by_email&email=%@", email]];
    NSURL *getUserURL = [NSURL URLWithString:getUserURLString];
    NSDictionary *getUserURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getUserURL Parameters:nil];
    NSError *error = nil;
    MITestRailUser *fetchedUser = [[MITestRailUser alloc] initWithDictionary:getUserURLResponse error:&error];
    return error ? nil : fetchedUser;
}



#pragma mark - project CRUD
- (MITestRailProject *)updateProject:(MITestRailProject *)project {
    NSString *updateProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_project/%@", project.projectId]];
    NSURL *updateProjectURL = [NSURL URLWithString:updateProjectURLString];
    NSDictionary *updateProjectURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateProjectURL Parameters:[project toDictionary]];
    NSError *error = nil;
    MITestRailProject *updatedProject = [[MITestRailProject alloc] initWithDictionary:updateProjectURLResponse error:&error];
    return error ? nil : updatedProject;
}

- (MITestRailProject *)createProject:(MITestRailProject *)project {
    NSString *createProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_project"]];
    NSURL *createProjectURL = [NSURL URLWithString:createProjectURLString];
    NSDictionary *createProjectURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createProjectURL Parameters:[project toDictionary]];
    NSError *error = nil;
    MITestRailProject *createdProject = [[MITestRailProject alloc] initWithDictionary:createProjectURLResponse error:&error];
    return error ? nil : createdProject;
}

- (MITestRailProject *)getProjectWithId:(NSNumber *)projectId {
    NSString *getProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_project/%@", projectId]];
    NSURL *getProjectURL = [NSURL URLWithString:getProjectURLString];
    NSDictionary *getProjectURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getProjectURL Parameters:nil];
    NSError *error = nil;
    MITestRailProject *fetchedProject = [[MITestRailProject alloc] initWithDictionary:getProjectURLResponse error:&error];
    return error ? nil : fetchedProject;

}

- (NSArray *)getAllProjects {
    NSString *getAllProjectsURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:@"index.php?/api/v2/get_projects"];
    NSURL *getAllProjectsURL = [NSURL URLWithString:getAllProjectsURLString];
    NSArray *getAllProjectsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllProjectsURL Parameters:nil];
    NSError *error = nil;
    NSMutableArray *projectsArray = [MITestRailProject arrayOfModelsFromDictionaries:getAllProjectsURLResponse error:&error];
    return error ? nil : projectsArray;
}

- (BOOL)deleteProjectWithId:(NSNumber *)projectId {
    NSString *deleteProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_project/%@", projectId]];
    NSURL *deleteProjectURL = [NSURL URLWithString:deleteProjectURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteProjectURL Parameters:nil];
    return YES;
}

@end
