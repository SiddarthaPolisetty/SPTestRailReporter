//
//  MITestRailRun.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailRun.h"
@implementation MITestRailRun
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
                                                       @"url" : @"runURL"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
