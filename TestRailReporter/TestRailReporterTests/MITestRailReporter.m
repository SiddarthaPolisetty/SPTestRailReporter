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

#pragma mark - milestone CRUD
- (NSArray *)getAllMileStones {
    NSMutableArray *mileStonesArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/get_milestones/%d", 23];
    NSURL *getAllMileStonesURL = [NSURL URLWithString:urlString];
    NSArray *mileStonesResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllMileStonesURL Parameters:nil];
    for (NSDictionary *dict in mileStonesResponse) {
        NSError *error = nil;
        MITestRailMileStone *mileStone = [[MITestRailMileStone alloc] initWithDictionary:dict error:&error];
        if (!error) {
            [mileStonesArray addObject:mileStone];
        }
    }
    return mileStonesArray;

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


#pragma mark - project CRUD
- (MITestRailProject *)updateProject:(MITestRailProject *)project {
    NSURL *updateProjectURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/update_project/%d", project.projectId]];
    NSDictionary *requestDictionary = [project toDictionary];
    NSDictionary *projectsResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateProjectURL Parameters:requestDictionary];
    NSError *error = nil;
    MITestRailProject *responseProject = [[MITestRailProject alloc] initWithDictionary:projectsResponse error:&error];
    return error ? nil :responseProject;
}

- (MITestRailProject *)createProject:(MITestRailProject *)project {
    NSDictionary *requestDictionary = [project toDictionary];
    NSURL *addProjectURL = [NSURL URLWithString:@"https://mobileiron.testrail.net?/api/v2/add_project"];
    NSDictionary *projectsResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:addProjectURL Parameters:requestDictionary];
    NSError *error = nil;
    MITestRailProject *responseProject = [[MITestRailProject alloc] initWithDictionary:projectsResponse error:&error];
    return error ? nil :responseProject;
}

- (MITestRailProject *)getProjectWithId:(int)projectId {
    NSURL *getProjectURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/get_project/%d", projectId]];
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

- (BOOL)deleteProject:(int)projectId {
    NSURL *deleteProjectURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://mobileiron.testrail.net?/api/v2/delete_project/%d", projectId]];
    NSDictionary *projectsResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:deleteProjectURL Parameters:nil];
    return YES;
}

@end
