//
//  MITestRailReporter.m
//  DocsAtWork
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 MobileIron. All rights reserved.
//
#import "MITestRailReporter.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MITestRailConfigurationBuilder.h"
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

#pragma mark - run CRUD
- (NSArray *)getAllTestRuns {
    NSMutableArray *testRunsArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/get_runs/%d", 23];
    NSURL *getAllTestRunsURL = [NSURL URLWithString:urlString];
    NSArray *testRunsResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllTestRunsURL Parameters:nil];
    for (NSDictionary *testRunDict in testRunsResponse) {
        NSMutableDictionary *mutableTestRun = [NSMutableDictionary dictionaryWithDictionary:testRunDict];
        mutableTestRun[@"config_ids"] = @[@1 , @3];
        NSError *error = nil;
        MITestRailRun *testRun = [[MITestRailRun alloc] initWithDictionary:mutableTestRun error:&error];
        if (!error) {
            [testRunsArray addObject:testRun];
        }else {
            [NSException raise:@"Error" format:[NSString stringWithFormat:@"%@", error]];
        }
    }
    return testRunsArray;
}

#pragma mark - case CRUD
- (NSArray *)getAllTestCases {
    NSMutableArray *casesArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/get_cases/%d&suite_id=%d", 23, 261];
    NSURL *getAllCasesURL = [NSURL URLWithString:urlString];
    NSArray *casesResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllCasesURL Parameters:nil];
    for (NSDictionary *dict in casesResponse) {
        NSError *error = nil;
        MITestRailCase *testCase = [[MITestRailCase alloc] initWithDictionary:dict error:&error];
        if (!error) {
            [casesArray addObject:testCase];
        }
    }
    return casesArray;
}

#pragma mark - suite CRUD
- (MITestRailSuite *)createSuite:(MITestRailSuite *)suite {
    NSString *urlString = [NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/add_suite/%d", suite.projectId];
    NSURL *addSuitesURL = [NSURL URLWithString:urlString];
    NSDictionary *dict = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addSuitesURL Parameters:[suite toDictionary]];
    NSError *error = nil;
    MITestRailSuite *createdSuite = [[MITestRailSuite alloc] initWithDictionary:dict error:&error];
    if (!error) {
        return createdSuite;
    }
    return nil;
}

- (MITestRailSuite *)updateSuite:(MITestRailSuite *)suite {
    NSString *urlString = [NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/update_suite/%d", suite.projectId];
    NSURL *addSuitesURL = [NSURL URLWithString:urlString];
    NSDictionary *dict = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addSuitesURL Parameters:[suite toDictionary]];
    NSError *error = nil;
    MITestRailSuite *updatedSuite = [[MITestRailSuite alloc] initWithDictionary:dict error:&error];
    if (!error) {
        return updatedSuite;
    }
    return nil;
}

- (BOOL)deleteSuite:(int)suiteId; {
    NSString *urlString = [NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/delete_suite/%d", suiteId];
    NSURL *addSuitesURL = [NSURL URLWithString:urlString];
    [self syncronousRequestWithMethod:@"POST" URL:addSuitesURL Parameters:nil];
    return YES;
}

- (NSArray *)getAllSuitesForProject:(int)projectId {
    NSMutableArray *suitesArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/get_suites/%d", projectId];
    NSURL *getAllSuitesURL = [NSURL URLWithString:urlString];
    NSArray *suitesResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllSuitesURL Parameters:nil];
    NSError *error = nil;
    suitesArray = [MITestRailSuite arrayOfModelsFromDictionaries:suitesResponse error:&error];
    return suitesArray;
}

- (MITestRailSuite *)getSuiteWithId:(int)suiteId {
    return nil;
}

#pragma mark - Milestone CRUD
- (MITestRailMileStone *)createMileStone:(MITestRailMileStone *)mileStone ForProjectId:(int)projectId {
    NSString *createMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_milestone/%d", projectId]];
    NSURL *createMileStoneURL = [NSURL URLWithString:createMileStoneURLString];
    NSDictionary *createMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createMileStoneURL Parameters:[mileStone toDictionary]];
    NSError *error = nil;
    MITestRailMileStone *createdMileStone = [[MITestRailMileStone alloc] initWithDictionary:createMileStoneURLResponse error:&error];
    return error ? nil :createdMileStone;
}

- (MITestRailMileStone *)updateMileStone:(MITestRailMileStone *)mileStone {
    NSString *updateMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_milestone/%d", mileStone.mileStoneId]];
    NSURL *updateMileStoneURL = [NSURL URLWithString:updateMileStoneURLString];
    NSDictionary *updateMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateMileStoneURL Parameters:[mileStone toDictionary]];
    NSError *error = nil;
    MITestRailMileStone *updatedMileStone = [[MITestRailMileStone alloc] initWithDictionary:updateMileStoneURLResponse error:&error];
    return error ? nil :updatedMileStone;
}

- (BOOL)deleteMileStoneWithId:(int)mileStoneId {
    NSString *deleteMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_milestone/%d",mileStoneId]];
    NSURL *deleteMileStoneURL = [NSURL URLWithString:deleteMileStoneURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteMileStoneURL Parameters:nil];
    return YES;
}


- (NSArray *)getAllMileStonesForProjectWithId:(int)projectId {
    NSString *getAllMileStonesURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_milestones/%d",projectId]];
    NSURL *getAllMileStonesURL = [NSURL URLWithString:getAllMileStonesURLString];
    NSArray *getAllMileStonesURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllMileStonesURL Parameters:nil];
    NSError *error = nil;
    NSArray *mileStonesArray = [MITestRailMileStone arrayOfModelsFromDictionaries:getAllMileStonesURLResponse error:&error];
    return error ? nil :mileStonesArray;
}

- (MITestRailMileStone *)getMileStoneWithId:(int)mileStoneId {
    NSString *getMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_milestone/%d",mileStoneId]];
    NSURL *getMileStoneURL = [NSURL URLWithString:getMileStoneURLString];
    NSDictionary *getMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getMileStoneURL Parameters:nil];
    NSError *error = nil;
    MITestRailMileStone *mileStone = [[MITestRailMileStone alloc] initWithDictionary:getMileStoneURLResponse error:&error];
    return error ? nil :mileStone;
}


#pragma mark - User CRUD
- (NSArray *)getAllUsers {
    NSString *getAllUsersURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:@"index.php?/api/v2/get_users"];
    NSURL *getAllProjectsURL = [NSURL URLWithString:getAllUsersURLString];
    NSArray *getAllUsersURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllProjectsURL Parameters:nil];
    NSError *error = nil;
    NSArray *usersArray = [MITestRailUser arrayOfModelsFromDictionaries:getAllUsersURLResponse error:&error];
    return error ? nil :usersArray;
}

- (MITestRailUser *)getUserWithId:(int)userId {
    NSString *getUserURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_user/%d", userId]];
    NSURL *getUserURL = [NSURL URLWithString:getUserURLString];
    NSDictionary *getUserURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getUserURL Parameters:nil];
    NSError *error = nil;
    MITestRailUser *user = [[MITestRailUser alloc] initWithDictionary:getUserURLResponse error:&error];
    return error ? nil : user;
}

- (MITestRailUser *)getUserWithEmail:(NSString *)email {
    NSString *getUserURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_user_by_email&email=%@", email]];
    NSURL *getUserURL = [NSURL URLWithString:getUserURLString];
    NSDictionary *getUserURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getUserURL Parameters:nil];
    NSError *error = nil;
    MITestRailUser *user = [[MITestRailUser alloc] initWithDictionary:getUserURLResponse error:&error];
    return error ? nil : user;
}



#pragma mark - project CRUD
- (MITestRailProject *)updateProject:(MITestRailProject *)project {
    NSString *updateProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_project/%d", project.projectId]];
    NSURL *updateProjectURL = [NSURL URLWithString:updateProjectURLString];
    NSDictionary *requestDictionary = [project toDictionary];
    NSDictionary *projectsResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateProjectURL Parameters:requestDictionary];
    NSError *error = nil;
    MITestRailProject *responseProject = [[MITestRailProject alloc] initWithDictionary:projectsResponse error:&error];
    return error ? nil :responseProject;
}

- (MITestRailProject *)createProject:(MITestRailProject *)project {
    NSDictionary *requestDictionary = [project toDictionary];
    NSString *createProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_project"]];
    NSURL *createProjectURL = [NSURL URLWithString:createProjectURLString];
    NSDictionary *projectsResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createProjectURL Parameters:requestDictionary];
    NSError *error = nil;
    MITestRailProject *responseProject = [[MITestRailProject alloc] initWithDictionary:projectsResponse error:&error];
    return error ? nil :responseProject;
}

- (MITestRailProject *)getProjectWithId:(int)projectId {
    NSString *getProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_project/%d", projectId]];
    NSURL *getProjectURL = [NSURL URLWithString:getProjectURLString];
    NSDictionary *projectsResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getProjectURL Parameters:nil];
    NSError *error = nil;
    MITestRailProject *responseProject = [[MITestRailProject alloc] initWithDictionary:projectsResponse error:&error];
    return error ? nil :responseProject;

}

- (NSArray *)getAllProjects {
    NSMutableArray *projectsArray = [NSMutableArray array];
    NSString *getAllProjectsURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:@"index.php?/api/v2/get_projects"];
    NSURL *getAllProjectsURL = [NSURL URLWithString:getAllProjectsURLString];
    NSArray *projectsResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllProjectsURL Parameters:nil];
    NSError *error = nil;
    projectsArray = [MITestRailProject arrayOfModelsFromDictionaries:projectsResponse error:&error];
    return projectsArray;
}

- (BOOL)deleteProjectWithId:(int)projectId {
    NSString *deleteProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_project/%d", projectId]];
    NSURL *deleteProjectURL = [NSURL URLWithString:deleteProjectURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteProjectURL Parameters:nil];
    return YES;
}

@end
