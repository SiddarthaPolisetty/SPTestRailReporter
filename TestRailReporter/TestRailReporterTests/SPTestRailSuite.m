//
//  SPTestRailSuite.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "SPTestRailSuite.h"

@interface SPTestRailSuite ()
@property (nonatomic, strong, readwrite) NSNumber *suiteId;
@end

@implementation SPTestRailSuite

#pragma mark - initializers
- (instancetype)initWithName:(NSString *)name Description:(NSString *)description ProjectId:(NSNumber *)projectId {
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
