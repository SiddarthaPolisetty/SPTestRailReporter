//
//  MITestRailSubConfiguration.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/31/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailSubConfiguration.h"

@implementation MITestRailSubConfiguration
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"subConfigurationId",
                                                       @"name": @"name",
                                                       @"group_id": @"groupId"
                                                       }];
}

#pragma mark - description
- (NSString *)description {
    NSString *subConfigurationDescription = [self toJSONString];
    return subConfigurationDescription;
}
@end
