//
//  MITestRailSuite.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailSuite.h"
/*
 @property (nonatomic) int suiteId;
 @property (nonatomic, strong) NSString *suiteName;
 @property (nonatomic, strong) NSString *suiteDescription;
 @property (nonatomic) int projectId;
 @property (nonatomic, strong) NSURL *suiteURL;
 
 {
	"description": "..",
	"id": 1,
	"name": "Setup & Installation",
	"project_id": 1,
	"url": "http://<server>/testrail/index.php?/suites/view/1"
 "completed_on" = "<null>";
 description = "These test cases are specific to Docs@work Android Client";
 id = 253;
 "is_baseline" = 0;
 "is_completed" = 0;
 "is_master" = 0;
 }
 */
@interface MITestRailSuite ()
@property (nonatomic, readwrite) int suiteId;
@end

@implementation MITestRailSuite

#pragma mark - initializers
- (instancetype)initWithName:(NSString *)name Description:(NSString *)description ProjectId:(int)projectId {
    if (self = [super init]) {
        _suiteName = name;
        _suiteDescription= description;
        _projectId = projectId;
    }
    return self;
}

#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"suiteDescription",
                                                       @"id": @"suiteId",
                                                       @"name": @"suiteName",
                                                       @"project_id": @"projectId",
                                                       @"url": @"suiteURL",
                                                       @"completed_on": @"completedOn",
                                                       @"is_baseline": @"baseline",
                                                       @"is_completed": @"completed",
                                                       @"is_master": @"master"
                                                       }];
}

#pragma mark - description
- (NSString *)description {
    NSString *projectDescription = [NSString stringWithFormat:@"<Suite id = %d, name = %@, url =  %@, projectId = %d, description = %@>", self.suiteId, self.suiteName, self.suiteURL, self.projectId, self.suiteDescription];
    return projectDescription;
}


@end
