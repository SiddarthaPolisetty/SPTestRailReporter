//
//  MITestRailConfig.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/31/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailConfig.h"

@interface MITestRailConfig ()
@property (nonatomic, strong, readwrite) NSNumber *configId;
@end

@implementation MITestRailConfig
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"configId",
                                                       @"name": @"name",
                                                       @"group_id": @"groupId"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *subConfigurationDescription = [self toJSONString];
    return subConfigurationDescription;
}
@end
