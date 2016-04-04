//
//  MITestRailConfigGroup.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/31/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailConfigGroup.h"

@interface MITestRailConfigGroup ()
@property (nonatomic, strong, readwrite) NSNumber *configGroupId;
@end

@implementation MITestRailConfigGroup
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"configs":@"configurationsSeperated",
                                                       @"id": @"configGroupId",
                                                       @"name": @"name",
                                                       @"project_id": @"projectId"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *configurationDescription = [self toJSONString];
    return configurationDescription;
}
@end
