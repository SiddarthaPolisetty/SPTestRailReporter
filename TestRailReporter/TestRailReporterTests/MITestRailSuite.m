//
//  MITestRailSuite.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailSuite.h"

@interface MITestRailSuite ()
@property (nonatomic, readwrite) int suiteId;
@end

@implementation MITestRailSuite

#pragma mark - initializers
- (instancetype)initWithName:(NSString *)name Description:(NSString *)description ProjectId:(int)projectId {
    if (self = [super init]) {
        _name = name;
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
                                                       @"name": @"name",
                                                       @"project_id": @"projectId",
                                                       @"url": @"suiteURL",
                                                       @"completed_on": @"completedOn",
                                                       @"is_baseline": @"baseline",
                                                       @"is_completed": @"completed",
                                                       @"is_master": @"master"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *suiteDescription = [self toJSONString];
    return suiteDescription;
}


@end
