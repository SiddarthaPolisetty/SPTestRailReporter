//
//  MITestRailMileStone.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailMileStone.h"
@implementation MITestRailMileStone
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

#pragma mark - description
- (NSString *)description {
    NSString *mileStoneDescription = [NSString stringWithFormat:@"<MileStone id = %d, name = %@, url =  %@, projectId = %d, description = %@, completed on = %@, due on = %@>", self.mileStoneId, self.name, self.mileStoneURL, self.projectId, self.mileStoneDescription, self.completedOn, self.dueOn];
    return mileStoneDescription;
}
@end
