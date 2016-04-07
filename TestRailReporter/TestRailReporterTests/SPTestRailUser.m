//
//  SPTestRailUser.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "SPTestRailUser.h"

@interface SPTestRailUser ()
@property (nonatomic, strong, readwrite) NSNumber *userId;
@end

@implementation SPTestRailUser
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
