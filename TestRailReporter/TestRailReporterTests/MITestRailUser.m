//
//  MITestRailUser.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailUser.h"

@interface MITestRailUser ()
@property (nonatomic, strong, readwrite) NSNumber *userId;
@end

@implementation MITestRailUser
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"email": @"email",
                                                       @"id":@"userId",
                                                       @"is_active":@"active",
                                                       @"name":@"name"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *userDescription = [self toJSONString];
    return userDescription;
}
@end
