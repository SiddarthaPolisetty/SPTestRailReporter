//
//  MITestRailPlan.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailPlan.h"

@implementation MITestRailPlan
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"assignedto_id": @"assignedToId",
                                                       @"blocked_count": @"blockedCount",
                                                       @"completed_on": @"completedOn",
                                                       @"created_by": @"createdById",
                                                       @"created_on": @"createdOn",
                                                       @"description": @"planDescription",
                                                       @"entries": @"",
                                                       @"failed_count": @"failedCount",
                                                       @"id": @"planId",
                                                       @"is_completed": @"completed",
                                                       @"milestone_id": @"milestoneId",
                                                       @"name": @"name",
                                                       @"passed_count": @"passedCount",
                                                       @"project_id": @"projectId",
                                                       @"retest_count": @"retestCount",
                                                       @"untested_count": @"untestedCount",
                                                       @"url": @"planURL"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *planDescription = [self toJSONString];
    return planDescription;
}
@end
