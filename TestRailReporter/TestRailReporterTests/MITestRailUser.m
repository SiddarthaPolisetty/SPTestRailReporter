//
//  MITestRailUser.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailUser.h"

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

#pragma mark - description
- (NSString *)description {
    NSString *userDescription = [NSString stringWithFormat:@"<User id = %d, name = %@, email =  %@, active = %d>", self.userId, self.name, self.email, self.isActive];
    return userDescription;
}
@end
