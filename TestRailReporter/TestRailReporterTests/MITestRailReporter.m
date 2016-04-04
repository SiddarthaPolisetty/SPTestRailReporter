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

#pragma mark - Run CRUD
- (NSArray *)getAllRunsForProjectId:(int)projectId {
    NSString *getAllTestRunsURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_runs/%d",projectId]];
    NSURL *getAllTestRunsURL = [NSURL URLWithString:getAllTestRunsURLString];
    NSArray *getAllTestRunsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllTestRunsURL Parameters:nil];
    NSError *error = nil;
    NSArray *testRunsArray = [MITestRailRun arrayOfModelsFromDictionaries:getAllTestRunsURLResponse error:&error];
    return error ? nil : testRunsArray;
}

- (MITestRailRun *)getRunWithId:(int)runId {
    NSString *getTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_run/%d", runId]];
    NSURL *getTestRunURL = [NSURL URLWithString:getTestRunURLString];
    NSDictionary *getTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getTestRunURL Parameters:nil];
    NSError *error = nil;
    MITestRailRun *fetchedTestRun = [[MITestRailRun alloc] initWithDictionary:getTestRunURLResponse error:&error];
    return error ? nil : fetchedTestRun;
}

- (BOOL)closeRunWithId:(int)runId {
    NSString *closeTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/close_run/%d", runId]];
    NSURL *closeTestRunURL = [NSURL URLWithString:closeTestRunURLString];
    [self syncronousRequestWithMethod:@"POST" URL:closeTestRunURL Parameters:nil];
    return YES;
}

- (BOOL)deleteRunWithId:(int)runId {
    NSString *deleteTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_run/%d", runId]];
    NSURL *deleteTestRunURL = [NSURL URLWithString:deleteTestRunURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteTestRunURL Parameters:nil];
    return YES;
}

- (MITestRailRun *)createRun:(MITestRailRun *)run ForProjectId:(int)projectId {
    NSString *createTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_run/%d", projectId]];
    NSURL *createTestRunURL = [NSURL URLWithString:createTestRunURLString];
    NSDictionary *createTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createTestRunURL Parameters:[run toDictionary]];
    NSError *error = nil;
    MITestRailRun *createdTestRun = [[MITestRailRun alloc] initWithDictionary:createTestRunURLResponse error:&error];
    return error ? nil : createdTestRun;
}

- (MITestRailRun *)updateRun:(MITestRailRun *)run {
    NSString *updateTestRunURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_run/%d", run.runId]];
    NSURL *updateTestRunURL = [NSURL URLWithString:updateTestRunURLString];
    NSDictionary *updateTestRunURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateTestRunURL Parameters:[run toDictionary]];
    NSError *error = nil;
    MITestRailRun *updateTestRun = [[MITestRailRun alloc] initWithDictionary:updateTestRunURLResponse error:&error];
    return error ? nil : updateTestRun;
}

#pragma mark - Suite CRUD
- (MITestRailSuite *)createSuite:(MITestRailSuite *)suite ForProjectId:(int)projectId {
    NSString *createSuiteURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_suite/%d", projectId]];
    NSURL *createSuiteURL = [NSURL URLWithString:createSuiteURLString];
    NSDictionary *createSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createSuiteURL Parameters:[suite toDictionary]];
    NSError *error = nil;
    MITestRailSuite *createdSuite = [[MITestRailSuite alloc] initWithDictionary:createSuiteURLResponse error:&error];
    return error ? nil :createdSuite;
}

- (MITestRailSuite *)updateSuite:(MITestRailSuite *)suite {
    NSString *updateSuiteURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_suite/%d", suite.suiteId]];
    NSURL *updateSuiteURL = [NSURL URLWithString:updateSuiteURLString];
    NSDictionary *updateSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateSuiteURL Parameters:[suite toDictionary]];
    NSError *error = nil;
    MITestRailSuite *updatedSuite = [[MITestRailSuite alloc] initWithDictionary:updateSuiteURLResponse error:&error];
    return error ? nil :updatedSuite;
}

- (BOOL)deleteSuiteWithId:(int)suiteId {
    NSString *deleteSuiteURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_suite/%d", suiteId]];
    NSURL *deleteSuiteURL = [NSURL URLWithString:deleteSuiteURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteSuiteURL Parameters:nil];
    return YES;
}

- (NSArray *)getAllSuitesForProject:(int)projectId {
    NSString *getAllSuitesURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_suites/%d",projectId]];
    NSURL *getAllSuitesURL = [NSURL URLWithString:getAllSuitesURLString];
    NSArray *getAllSuitesURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllSuitesURL Parameters:nil];
    NSError *error = nil;
    NSArray *suitesArray = [MITestRailSuite arrayOfModelsFromDictionaries:getAllSuitesURLResponse error:&error];
    return error ? nil :suitesArray;
}

- (MITestRailSuite *)getSuiteWithId:(int)suiteId {
    NSString *getSuiteURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_suite/%d",suiteId]];
    NSURL *getSuiteURL = [NSURL URLWithString:getSuiteURLString];
    NSDictionary *getSuiteURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getSuiteURL Parameters:nil];
    NSError *error = nil;
    MITestRailSuite *fetchedSuite = [[MITestRailSuite alloc] initWithDictionary:getSuiteURLResponse error:&error];
    return error ? nil :fetchedSuite;
}

#pragma mark - Section CRUD
- (MITestRailSection *)createSection:(MITestRailSection *)section ForProjectId:(int)projectId {
    NSMutableDictionary *filteredDictionary = [NSMutableDictionary dictionary];
    if (section.suiteId > 0) {
        filteredDictionary[@"suite_id"] = @(section.suiteId);
    }
    if (section.parentId) {
        filteredDictionary[@"parent_id"] = @(section.parentId);
    }
    filteredDictionary[@"name"] = section.name;
    filteredDictionary[@"descriotion"] = section.sectionDescription;
    NSString *createSectionURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_section/%d", projectId]];
    NSURL *createSectionURL = [NSURL URLWithString:createSectionURLString];
    NSDictionary *createSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createSectionURL Parameters:filteredDictionary];
    NSError *error = nil;
    MITestRailSection *createdSection = [[MITestRailSection alloc] initWithDictionary:createSectionURLResponse error:&error];
    return error ? nil : createdSection;
}

- (MITestRailSection *)updateSection:(MITestRailSection *)section {
    NSString *updateSectionURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_section/%d", section.sectionId]];
    NSURL *updateSectionURL = [NSURL URLWithString:updateSectionURLString];
    NSDictionary *updateSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateSectionURL Parameters:[section toDictionary]];
    NSError *error = nil;
    MITestRailSection *updatedSection = [[MITestRailSection alloc] initWithDictionary:updateSectionURLResponse error:&error];
    return error ? nil : updatedSection;
}

- (BOOL)deleteSectionWithId:(int)sectionId {
    NSString *deleteSectionURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_section/%d",sectionId]];
    NSURL *deleteSectionURL = [NSURL URLWithString:deleteSectionURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteSectionURL Parameters:nil];
    return YES;
}

- (MITestRailSection *)getSectionWithId:(int)sectionId {
    NSString *getSectionURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_section/%d",sectionId]];
    NSURL *getSectionURL = [NSURL URLWithString:getSectionURLString];
    NSDictionary *getSectionURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"GET" URL:getSectionURL Parameters:nil];
    NSError *error = nil;
    MITestRailSection *fetchedSection = [[MITestRailSection alloc] initWithDictionary:getSectionURLResponse error:&error];
    return error ? nil : fetchedSection;
}

- (NSArray *)getAllSectionsForProjectWithId:(int)projectId WithSuiteId:(int)suiteId {
    NSString *getAllSectionsURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_sections/%d&suite_id=%d",projectId, suiteId]];
    NSURL *getAllSectionsURL = [NSURL URLWithString:getAllSectionsURLString];
    NSArray *getAllSectionsURLResponse = (NSArray *)[self syncronousRequestWithMethod:@"GET" URL:getAllSectionsURL Parameters:nil];
    NSError *error = nil;
    NSArray *sectionsArray = [MITestRailSection arrayOfModelsFromDictionaries:getAllSectionsURLResponse error:&error];
    return error ? nil : sectionsArray;
}

#pragma mark - Milestone CRUD
- (MITestRailMileStone *)createMileStone:(MITestRailMileStone *)mileStone ForProjectId:(int)projectId {
    NSString *createMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/add_milestone/%d", projectId]];
    NSURL *createMileStoneURL = [NSURL URLWithString:createMileStoneURLString];
    NSDictionary *createMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:createMileStoneURL Parameters:[mileStone toDictionary]];
    NSError *error = nil;
    MITestRailMileStone *createdMileStone = [[MITestRailMileStone alloc] initWithDictionary:createMileStoneURLResponse error:&error];
    return error ? nil : createdMileStone;
}

- (MITestRailMileStone *)updateMileStone:(MITestRailMileStone *)mileStone {
    NSString *updateMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_milestone/%d", mileStone.mileStoneId]];
    NSURL *updateMileStoneURL = [NSURL URLWithString:updateMileStoneURLString];
    NSDictionary *updateMileStoneURLResponse = (NSDictionary *)[self syncronousRequestWithMethod:@"POST" URL:updateMileStoneURL Parameters:[mileStone toDictionary]];
    NSError *error = nil;
    MITestRailMileStone *updatedMileStone = [[MITestRailMileStone alloc] initWithDictionary:updateMileStoneURLResponse error:&error];
    return error ? nil : updatedMileStone;
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
    return error ? nil : mileStonesArray;
}

- (MITestRailMileStone *)getMileStoneWithId:(int)mileStoneId {
    NSString *getMileStoneURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_milestone/%d",mileStoneId]];
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

- (MITestRailUser *)getUserWithId:(int)userId {
    NSString *getUserURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_user/%d", userId]];
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
    NSString *updateProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/update_project/%d", project.projectId]];
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

- (MITestRailProject *)getProjectWithId:(int)projectId {
    NSString *getProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/get_project/%d", projectId]];
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

- (BOOL)deleteProjectWithId:(int)projectId {
    NSString *deleteProjectURLString = [[MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL.absoluteString stringByAppendingPathComponent:[NSString stringWithFormat:@"index.php?/api/v2/delete_project/%d", projectId]];
    NSURL *deleteProjectURL = [NSURL URLWithString:deleteProjectURLString];
    [self syncronousRequestWithMethod:@"POST" URL:deleteProjectURL Parameters:nil];
    return YES;
}

@end
