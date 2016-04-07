//
//  SPTestRailRun.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "SPTestRailRun.h"

@interface SPTestRailRun ()
@property (nonatomic, strong, readwrite) NSNumber *runId;
@end

@implementation SPTestRailRun
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"runId",
                                                       @"suite_id": @"suiteId",
                                                       @"project_id": @"projectId",
                                                       @"failed_count": @"failedCount",
                                                       @"retest_count": @"retestCount",
                                                       @"untested_count": @"untestedCount",
                                                       @"blocked_count": @"blockedCount",
                                                       @"passed_count": @"passedCount",
                                                       @"plan_id": @"planId",
                                                       @"assignedto_id": @"assignedToId",
                                                       @"milestone_id": @"mileStoneId",
                                                       @"created_by" : @"createdById",
                                                       @"include_all" : @"includeAll",
                                                       @"is_completed" : @"completed",
                                                       @"name" : @"name",
                                                       @"description" : @"runDescription",
                                                       @"config" : @"config",
                                                       @"completed_on" : @"completedOn",
                                                       @"created_on" : @"createdOn",
                                                       @"url" : @"runURL",
                                                       @"config_ids" : @"configIds",
                                                       @"case_ids" : @"caseIds"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *runDescription = [self toJSONString];
    return runDescription;
}
@end