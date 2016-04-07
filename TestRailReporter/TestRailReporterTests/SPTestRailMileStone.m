//
//  SPTestRailMileStone.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "SPTestRailMileStone.h"

@interface SPTestRailMileStone ()
@property (nonatomic, strong, readwrite) NSNumber *mileStoneId;
@end

@implementation SPTestRailMileStone
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"completed_on": @"completedOn",
                                                       @"description": @"mileStoneDescription",
                                                       @"due_on":@"dueOn",
                                                       @"id":@"mileStoneId",
                                                       @"is_completed":@"completed",
                                                       @"name":@"name",
                                                       @"project_id":@"projectId",
                                                       @"url":@"mileStoneURL"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *mileStoneDescription = [self toJSONString];
    return mileStoneDescription;
}
@end
