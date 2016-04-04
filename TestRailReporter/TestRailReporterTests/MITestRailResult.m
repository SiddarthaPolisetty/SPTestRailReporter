//
//  MITestRailResult.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailResult.h"

@interface MITestRailResult ()
@property (nonatomic, strong, readwrite) NSNumber *resultId;
@end

@implementation MITestRailResult
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"assignedto_id": @"assignedToId",
                                                       @"comment": @"comment",
                                                       @"created_by": @"createdById",
                                                       @"created_on": @"",
                                                       @"defects": @"defects",
                                                       @"elapsed": @"elapsed",
                                                       @"id": @"resultId",
                                                       @"status_id": @"statusId",
                                                       @"test_id": @"testId",
                                                       @"version": @"version"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *resultDescription = [self toJSONString];
    return resultDescription;
}
@end