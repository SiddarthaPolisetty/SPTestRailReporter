//
//  SPTestRailReporter.m
//  DocsAtWork
//
//  added by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//
#import "SPTestRailReporter.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "NSData+Base64.h"
#import "JSONHTTPClient.h"

@implementation SPTestRailReporter
+ (instancetype)sharedReporter {
    static dispatch_once_t onceToken = 0;
    static SPTestRailReporter *sharedReporter = nil;
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
    [NSException raise:@"Invalid Initializer" format:@"Please use [SPTestRailReporter sharedReporter]"];
    return nil;
}


- (id) syncronousRequestWithMethod:(NSString*)method URL:(NSURL*)requestURL Parameters: (NSDictionary*) parameters Error:(NSError **)error {
    __block id reponseJSON = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableURLRequest *mitrRequest = [NSMutableURLRequest requestWithURL:requestURL];
    [mitrRequest setHTTPMethod:method];
    [mitrRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mitrRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [mitrRequest setValue:@"SPTestRailReporter Client" forHTTPHeaderField:@"User-Agent"];
    [mitrRequest setValue:[SPTestRailConfigurationBuilder sharedConfigurationBuilder].valueForAuthHeader forHTTPHeaderField:@"Authorization"];
    NSError *spError = nil;
    if (parameters) {
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&spError];
        if (spError) {
            if(error) *error = spError;
            return nil;
        }
        [mitrRequest setHTTPBody:requestData];
    }
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:mitrRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        reponseJSON = [responseObject mutableCopy];
        dispatch_semaphore_signal(semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError *networkError) {
        if (networkError) {
            if(error) *error = networkError;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [operation start];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return reponseJSON;
}

#pragma mark - Result CRUD
- (NSArray *)getAllResultsforTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllResultsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_results/%@", testId]];
    NSURL *getAllResultsURL = [NSURL URLWithString:getAllResultsURLString];
    NSArray *getAllResultsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllResultsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *resultsArray = [SPTestRailTest arrayOfModelsFromDictionaries:getAllResultsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return resultsArray;
}

- (NSArray *)getAllResultsforCaseId:(NSNumber *)caseId ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllResultsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_results_for_case/%@/%@", runId, caseId]];
    NSURL *getAllResultsURL = [NSURL URLWithString:getAllResultsURLString];
    NSArray *getAllResultsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllResultsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *resultsArray = [SPTestRailTest arrayOfModelsFromDictionaries:getAllResultsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return resultsArray;
}

- (NSArray *)getAllResultsforRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllResultsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_results_for_run/%@", runId]];
    NSURL *getAllResultsURL = [NSURL URLWithString:getAllResultsURLString];
    NSArray *getAllResultsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllResultsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *resultsArray = [SPTestRailTest arrayOfModelsFromDictionaries:getAllResultsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return resultsArray;
}

- (SPTestRailResult *)addResult:(SPTestRailResult *)result ForTestId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addResultURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_result/%@", testId]];
    NSURL *addResultURL = [NSURL URLWithString:addResultURLString];
    NSDictionary *addResultURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addResultURL Parameters:[result toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailResult *addedResult = [[SPTestRailResult alloc] initWithDictionary:addResultURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedResult;
}
- (SPTestRailResult *)addResult:(SPTestRailResult *)result ForRunId:(NSNumber *)runId ForCaseId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addResultURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_result_for_case/%@/%@", runId, caseId]];
    NSURL *addResultURL = [NSURL URLWithString:addResultURLString];
    NSDictionary *addResultURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addResultURL Parameters:[result toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailResult *addedResult = [[SPTestRailResult alloc] initWithDictionary:addResultURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedResult;
}

- (NSDictionary *)resultDictionaryFromResults:(NSArray *)results {
    NSMutableDictionary *resultsDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *arrayOfResults = [NSMutableArray array];
    for (SPTestRailResult *result in results) {
        [arrayOfResults addObject:result.toDictionary];
    }
    resultsDictionary[@"results"] = arrayOfResults;
    return [resultsDictionary copy];
}

- (NSArray *)addResults:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addResultsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_results/%@", runId]];
    NSURL *addResultsURL = [NSURL URLWithString:addResultsURLString];
    NSArray *addResultsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"POST" URL:addResultsURL Parameters:[self resultDictionaryFromResults:testResults] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *resultsArray = [SPTestRailResult arrayOfModelsFromDictionaries:addResultsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return resultsArray;
}

- (NSArray *)addResultsForCases:(NSArray *)testResults ForRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addResultsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_results_for_cases/%@", runId]];
    NSURL *addResultsURL = [NSURL URLWithString:addResultsURLString];
    NSArray *addResultsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"POST" URL:addResultsURL Parameters:[self resultDictionaryFromResults:testResults] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *resultsArray = [SPTestRailResult arrayOfModelsFromDictionaries:addResultsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return resultsArray;
}

#pragma mark - Test CRUD
- (SPTestRailTest *)getTestWithId:(NSNumber *)testId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getTestURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_test/%@", testId]];
    NSURL *getTestURL = [NSURL URLWithString:getTestURLString];
    NSDictionary *getTestURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getTestURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailTest *fetchedTest= [[SPTestRailTest alloc] initWithDictionary:getTestURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedTest;
}

- (NSArray *)getAllTestsWithRunId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllTestsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_tests/%@", runId]];
    NSURL *getAllTestsURL = [NSURL URLWithString:getAllTestsURLString];
    NSArray *getAllTestsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllTestsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *testsArray = [SPTestRailTest arrayOfModelsFromDictionaries:getAllTestsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return testsArray;
}

#pragma mark - Case CRUD
- (SPTestRailCase *)getCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getCaseURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_case/%@", caseId]];
    NSURL *getCaseURL = [NSURL URLWithString:getCaseURLString];
    NSDictionary *getCaseURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getCaseURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailCase *fetchedCase = [[SPTestRailCase alloc] initWithDictionary:getCaseURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedCase;
}

- (NSArray *)getAllCasesForProjectId:(NSNumber *)projectId WithSectionId:(NSNumber *)sectionId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllCasesURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_cases/%@&suite_id=%@&section_id=%@",projectId, suiteId, sectionId]];
    NSURL *getAllCasesURL = [NSURL URLWithString:getAllCasesURLString];
    NSArray *getAllCasesURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllCasesURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *casesArray = [SPTestRailCase arrayOfModelsFromDictionaries:getAllCasesURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return casesArray;
}

- (SPTestRailCase *)addCase:(SPTestRailCase *)testCase WithSectionId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addCaseURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_case/%@", sectionId]];
    NSURL *addCaseURL = [NSURL URLWithString:addCaseURLString];
    
    NSDictionary *addCaseURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addCaseURL Parameters:[testCase toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailCase *addedCase = [[SPTestRailCase alloc] initWithDictionary:addCaseURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedCase;
}

- (SPTestRailCase *)updateCase:(SPTestRailCase *)testCase Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updateCaseURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_case/%@", testCase.caseId]];
    NSURL *updateCaseURL = [NSURL URLWithString:updateCaseURLString];
    NSDictionary *updateCaseURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateCaseURL Parameters:[testCase toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailCase *updatedCase = [[SPTestRailCase alloc] initWithDictionary:updateCaseURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedCase;
}

- (BOOL)deleteCaseWithId:(NSNumber *)caseId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deleteCaseURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_case/%@", caseId]];
    NSURL *deleteCaseURL = [NSURL URLWithString:deleteCaseURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:deleteCaseURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

#pragma mark - Configuration CRUD
- (NSArray *)getAllConfigGroupsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllConfigGroupsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_configs/%@",projectId]];
    NSURL *getAllConfigGroupsURL = [NSURL URLWithString:getAllConfigGroupsURLString];
    
    NSArray *getAllConfigGroupsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllConfigGroupsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *configsArray = [SPTestRailConfigGroup arrayOfModelsFromDictionaries:getAllConfigGroupsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return configsArray;
}

- (BOOL)deleteConfigWithId:(NSNumber *)configId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deleteConfigURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_config/%@", configId]];
    NSURL *deleteConfigURL = [NSURL URLWithString:deleteConfigURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteConfigURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

- (BOOL)deleteConfigGroupWithId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deleteConfigGroupURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_config_group/%@", configGroupId]];
    NSURL *deleteConfigGroupURL = [NSURL URLWithString:deleteConfigGroupURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:deleteConfigGroupURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

- (SPTestRailConfig *)addConfig:(SPTestRailConfig *)config InConfigGroupId:(NSNumber *)configGroupId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *createConfigURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_config/%@", configGroupId]];
    NSURL *createConfigURL = [NSURL URLWithString:createConfigURLString];
    
    NSDictionary *createConfigURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createConfigURL Parameters:[config toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailConfig *addedConfig = [[SPTestRailConfig alloc] initWithDictionary:createConfigURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedConfig;
}

- (SPTestRailConfigGroup *)addConfigGroup:(SPTestRailConfigGroup *)configGroup InProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addConfigGroupURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_config_group/%@", projectId]];
    NSURL *addConfigGroupURL = [NSURL URLWithString:addConfigGroupURLString];
    
    NSDictionary *addConfigGroupURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addConfigGroupURL Parameters:[configGroup toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailConfigGroup *addedConfigGroup = [[SPTestRailConfigGroup alloc] initWithDictionary:addConfigGroupURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedConfigGroup;
}

- (SPTestRailConfig *)updateConfig:(SPTestRailConfig *)config Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updateConfigURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_config/%@", config.configId]];
    NSURL *updateConfigURL = [NSURL URLWithString:updateConfigURLString];
    
    NSDictionary *updateConfigURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateConfigURL Parameters:[config toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailConfig *updatedConfig = [[SPTestRailConfig alloc] initWithDictionary:updateConfigURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedConfig;
}

- (SPTestRailConfigGroup *)updateConfigurationGroup:(SPTestRailConfigGroup *)configGroup Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updateConfigGroupURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_config_group/%@", configGroup.configGroupId]];
    NSURL *updateConfigGroupURL = [NSURL URLWithString:updateConfigGroupURLString];
    
    NSDictionary *updateConfigGroupURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateConfigGroupURL Parameters:[configGroup toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailConfigGroup *updatedConfigGroup = [[SPTestRailConfigGroup alloc] initWithDictionary:updateConfigGroupURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedConfigGroup;
}

#pragma mark - Plan CRUD
- (NSArray *)getAllPlansForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllPlansRunsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_plans/%@",projectId]];
    NSURL *getAllPlansRunsURL = [NSURL URLWithString:getAllPlansRunsURLString];
    
    NSArray *getAllPlansRunsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllPlansRunsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *testPlansArray = [SPTestRailPlan arrayOfModelsFromDictionaries:getAllPlansRunsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return testPlansArray;
}

- (SPTestRailPlan *)getPlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getPlanURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_plan/%@", planId]];
    NSURL *getPlanURL = [NSURL URLWithString:getPlanURLString];
    
    NSDictionary *getPlanURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getPlanURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailPlan *fetchedPlan = [[SPTestRailPlan alloc] initWithDictionary:getPlanURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedPlan;
}

- (BOOL)closePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *closePlanURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/close_plan/%@", planId]];
    NSURL *closePlanURL = [NSURL URLWithString:closePlanURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:closePlanURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

- (BOOL)deletePlanWithId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deletePlanURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_plan/%@", planId]];
    NSURL *deletePlanURL = [NSURL URLWithString:deletePlanURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deletePlanURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

- (SPTestRailPlan *)addPlan:(SPTestRailPlan *)plan ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addPlanURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_plan/%@", projectId]];
    NSURL *addPlanURL = [NSURL URLWithString:addPlanURLString];
    
    NSDictionary *addPlanURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addPlanURL Parameters:[plan toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailPlan *addedPlan = [[SPTestRailPlan alloc] initWithDictionary:addPlanURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedPlan;
}

- (SPTestRailPlan *)updatePlan:(SPTestRailPlan *)plan Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updatePlanURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_plan/%@", plan.planId]];
    NSURL *updatePlanURL = [NSURL URLWithString:updatePlanURLString];
    
    NSDictionary *updatePlanURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updatePlanURL Parameters:[plan toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailPlan *updatedPlan = [[SPTestRailPlan alloc] initWithDictionary:updatePlanURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedPlan;
}

- (SPTestRailPlanEntry *)addPlanEntry:(SPTestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addPlanEntryURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_plan_entry/%@", planId]];
    NSURL *addPlanEntryURL = [NSURL URLWithString:addPlanEntryURLString];
    
    NSDictionary *addPlanEntryURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addPlanEntryURL Parameters:[entry toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailPlanEntry *addedPlanEntry = [[SPTestRailPlanEntry alloc] initWithDictionary:addPlanEntryURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedPlanEntry;
}

- (SPTestRailPlanEntry *)updatePlanEntry:(SPTestRailPlanEntry *)entry InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updatePlanEntryURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_plan_entry/%@/%@", planId, entry.planEntryId]];
    NSURL *updatePlanEntryURL = [NSURL URLWithString:updatePlanEntryURLString];
    
    NSDictionary *updatePlanEntryURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updatePlanEntryURL Parameters:[entry toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailPlanEntry *updatedPlanEntry = [[SPTestRailPlanEntry alloc] initWithDictionary:updatePlanEntryURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedPlanEntry;
}

- (BOOL)deletePLanEntryWithEntryId:(NSString *)entryId InPlanId:(NSNumber *)planId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deletePlanEntryURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_plan_entry/%@/%@", planId, entryId]];
    NSURL *deletePlanEntryURL = [NSURL URLWithString:deletePlanEntryURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:deletePlanEntryURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

#pragma mark - Run CRUD
- (NSArray *)getAllRunsForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllTestRunsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_runs/%@",projectId]];
    NSURL *getAllTestRunsURL = [NSURL URLWithString:getAllTestRunsURLString];
    
    NSArray *getAllTestRunsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllTestRunsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *testRunsArray = [SPTestRailRun arrayOfModelsFromDictionaries:getAllTestRunsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return testRunsArray;
}

- (SPTestRailRun *)getRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getTestRunURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_run/%@", runId]];
    NSURL *getTestRunURL = [NSURL URLWithString:getTestRunURLString];
    
    NSDictionary *getTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getTestRunURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailRun *fetchedTestRun = [[SPTestRailRun alloc] initWithDictionary:getTestRunURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedTestRun;
}

- (BOOL)closeRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *closeTestRunURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/close_run/%@", runId]];
    NSURL *closeTestRunURL = [NSURL URLWithString:closeTestRunURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:closeTestRunURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

- (BOOL)deleteRunWithId:(NSNumber *)runId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deleteTestRunURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_run/%@", runId]];
    NSURL *deleteTestRunURL = [NSURL URLWithString:deleteTestRunURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:deleteTestRunURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

- (SPTestRailRun *)addRun:(SPTestRailRun *)run ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addTestRunURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_run/%@", projectId]];
    NSURL *addTestRunURL = [NSURL URLWithString:addTestRunURLString];
    
    NSDictionary *addTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addTestRunURL Parameters:[run toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailRun *addedTestRun = [[SPTestRailRun alloc] initWithDictionary:addTestRunURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedTestRun;
}

- (SPTestRailRun *)updateRun:(SPTestRailRun *)run Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updateTestRunURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_run/%@", run.runId]];
    NSURL *updateTestRunURL = [NSURL URLWithString:updateTestRunURLString];
    
    NSDictionary *updateTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateTestRunURL Parameters:[run toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailRun *updatedTestRun = [[SPTestRailRun alloc] initWithDictionary:updateTestRunURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedTestRun;
}

#pragma mark - Suite CRUD
- (SPTestRailSuite *)addSuite:(SPTestRailSuite *)suite ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addSuiteURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_suite/%@", projectId]];
    NSURL *addSuiteURL = [NSURL URLWithString:addSuiteURLString];
    
    NSDictionary *addSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addSuiteURL Parameters:[suite toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailSuite *addedSuite = [[SPTestRailSuite alloc] initWithDictionary:addSuiteURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedSuite;
}

- (SPTestRailSuite *)updateSuite:(SPTestRailSuite *)suite Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updateSuiteURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_suite/%@", suite.suiteId]];
    NSURL *updateSuiteURL = [NSURL URLWithString:updateSuiteURLString];
    
    NSDictionary *updateSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateSuiteURL Parameters:[suite toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailSuite *updatedSuite = [[SPTestRailSuite alloc] initWithDictionary:updateSuiteURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedSuite;
}

- (BOOL)deleteSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deleteSuiteURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_suite/%@", suiteId]];
    NSURL *deleteSuiteURL = [NSURL URLWithString:deleteSuiteURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:deleteSuiteURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

- (NSArray *)getAllSuitesForProject:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllSuitesURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_suites/%@",projectId]];
    NSURL *getAllSuitesURL = [NSURL URLWithString:getAllSuitesURLString];
    
    NSArray *getAllSuitesURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllSuitesURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *suitesArray = [SPTestRailSuite arrayOfModelsFromDictionaries:getAllSuitesURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return suitesArray;
}

- (SPTestRailSuite *)getSuiteWithId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getSuiteURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_suite/%@",suiteId]];
    NSURL *getSuiteURL = [NSURL URLWithString:getSuiteURLString];
    
    NSDictionary *getSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getSuiteURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailSuite *fetchedSuite = [[SPTestRailSuite alloc] initWithDictionary:getSuiteURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedSuite;
}

#pragma mark - Section CRUD
- (SPTestRailSection *)addSection:(SPTestRailSection *)section ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addSectionURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_section/%@", projectId]];
    NSURL *addSectionURL = [NSURL URLWithString:addSectionURLString];
    
    NSDictionary *addSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addSectionURL Parameters:[section toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailSection *addedSection = [[SPTestRailSection alloc] initWithDictionary:addSectionURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedSection;
}

- (SPTestRailSection *)updateSection:(SPTestRailSection *)section Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updateSectionURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_section/%@", section.sectionId]];
    NSURL *updateSectionURL = [NSURL URLWithString:updateSectionURLString];
    
    NSDictionary *updateSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateSectionURL Parameters:[section toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailSection *updatedSection = [[SPTestRailSection alloc] initWithDictionary:updateSectionURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedSection;
}

- (BOOL)deleteSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deleteSectionURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_section/%@",sectionId]];
    NSURL *deleteSectionURL = [NSURL URLWithString:deleteSectionURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:deleteSectionURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

- (SPTestRailSection *)getSectionWithId:(NSNumber *)sectionId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getSectionURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_section/%@",sectionId]];
    NSURL *getSectionURL = [NSURL URLWithString:getSectionURLString];
    
    NSDictionary *getSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getSectionURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailSection *fetchedSection = [[SPTestRailSection alloc] initWithDictionary:getSectionURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedSection;
}

- (NSArray *)getAllSectionsForProjectWithId:(NSNumber *)projectId WithSuiteId:(NSNumber *)suiteId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllSectionsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_sections/%@&suite_id=%@",projectId, suiteId]];
    NSURL *getAllSectionsURL = [NSURL URLWithString:getAllSectionsURLString];
    
    NSArray *getAllSectionsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllSectionsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *sectionsArray = [SPTestRailSection arrayOfModelsFromDictionaries:getAllSectionsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return sectionsArray;
}

#pragma mark - Milestone CRUD
- (SPTestRailMileStone *)addMileStone:(SPTestRailMileStone *)mileStone ForProjectId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *createMileStoneURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_milestone/%@", projectId]];
    NSURL *createMileStoneURL = [NSURL URLWithString:createMileStoneURLString];
    
    NSDictionary *createMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createMileStoneURL Parameters:[mileStone toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailMileStone *addedMileStone = [[SPTestRailMileStone alloc] initWithDictionary:createMileStoneURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedMileStone;
}

- (SPTestRailMileStone *)updateMileStone:(SPTestRailMileStone *)mileStone Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updateMileStoneURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_milestone/%@", mileStone.mileStoneId]];
    NSURL *updateMileStoneURL = [NSURL URLWithString:updateMileStoneURLString];
    
    NSDictionary *updateMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateMileStoneURL Parameters:[mileStone toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailMileStone *updatedMileStone = [[SPTestRailMileStone alloc] initWithDictionary:updateMileStoneURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedMileStone;
}

- (BOOL)deleteMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deleteMileStoneURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_milestone/%@",mileStoneId]];
    NSURL *deleteMileStoneURL = [NSURL URLWithString:deleteMileStoneURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:deleteMileStoneURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}


- (NSArray *)getAllMileStonesForProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllMileStonesURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_milestones/%@",projectId]];
    NSURL *getAllMileStonesURL = [NSURL URLWithString:getAllMileStonesURLString];
    
    NSArray *getAllMileStonesURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllMileStonesURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *mileStonesArray = [SPTestRailMileStone arrayOfModelsFromDictionaries:getAllMileStonesURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return mileStonesArray;
}

- (SPTestRailMileStone *)getMileStoneWithId:(NSNumber *)mileStoneId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getMileStoneURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_milestone/%@",mileStoneId]];
    NSURL *getMileStoneURL = [NSURL URLWithString:getMileStoneURLString];
    
    NSDictionary *getMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getMileStoneURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailMileStone *fetchedMileStone = [[SPTestRailMileStone alloc] initWithDictionary:getMileStoneURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedMileStone;
}


#pragma mark - User CRUD
- (NSArray *)getAllUsersError:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllUsersURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:@"index.php?/api/v2/get_users"];
    NSURL *getAllProjectsURL = [NSURL URLWithString:getAllUsersURLString];
    
    NSArray *getAllUsersURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllProjectsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSArray *usersArray = [SPTestRailUser arrayOfModelsFromDictionaries:getAllUsersURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return usersArray;
}

- (SPTestRailUser *)getUserWithId:(NSNumber *)userId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getUserURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_user/%@", userId]];
    NSURL *getUserURL = [NSURL URLWithString:getUserURLString];
    
    NSDictionary *getUserURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getUserURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailUser *fetchedUser = [[SPTestRailUser alloc] initWithDictionary:getUserURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedUser;
}

- (SPTestRailUser *)getUserWithEmail:(NSString *)email Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getUserURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_user_by_email&email=%@", email]];
    NSURL *getUserURL = [NSURL URLWithString:getUserURLString];
    
    NSDictionary *getUserURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getUserURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailUser *fetchedUser = [[SPTestRailUser alloc] initWithDictionary:getUserURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedUser;
}



#pragma mark - project CRUD
- (SPTestRailProject *)updateProject:(SPTestRailProject *)project Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *updateProjectURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_project/%@", project.projectId]];
    NSURL *updateProjectURL = [NSURL URLWithString:updateProjectURLString];
    
    NSDictionary *updateProjectURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateProjectURL Parameters:[project toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailProject *updatedProject = [[SPTestRailProject alloc] initWithDictionary:updateProjectURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return updatedProject;
}

- (SPTestRailProject *)addProject:(SPTestRailProject *)project Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *addProjectURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_project"]];
    NSURL *addProjectURL = [NSURL URLWithString:addProjectURLString];
    
    NSDictionary *addProjectURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addProjectURL Parameters:[project toDictionary] Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailProject *addedProject = [[SPTestRailProject alloc] initWithDictionary:addProjectURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return addedProject;
}

- (SPTestRailProject *)getProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getProjectURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_project/%@", projectId]];
    NSURL *getProjectURL = [NSURL URLWithString:getProjectURLString];
    
    NSDictionary *getProjectURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getProjectURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    SPTestRailProject *fetchedProject = [[SPTestRailProject alloc] initWithDictionary:getProjectURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return fetchedProject;

}

- (NSArray *)getAllProjectsError:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *getAllProjectsURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:@"index.php?/api/v2/get_projects"];
    NSURL *getAllProjectsURL = [NSURL URLWithString:getAllProjectsURLString];
    
    NSArray *getAllProjectsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllProjectsURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    NSMutableArray *projectsArray = [SPTestRailProject arrayOfModelsFromDictionaries:getAllProjectsURLResponse error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
        return nil;
    }
    return projectsArray;
}

- (BOOL)deleteProjectWithId:(NSNumber *)projectId Error:(NSError *__autoreleasing *)error {
    NSError *crudError = nil;
    NSString *deleteProjectURLString = [[SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_project/%@", projectId]];
    NSURL *deleteProjectURL = [NSURL URLWithString:deleteProjectURLString];
    
    [self syncronousRequestWithMethod:@"POST" URL:deleteProjectURL Parameters:nil Error:&crudError];
    if (crudError) {
        if (error) *error = crudError;
    }
    return !crudError;
}

@end
