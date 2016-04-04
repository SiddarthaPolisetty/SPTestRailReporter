//
//  MITestRailTest.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailTest.h"

@interface MITestRailTest ()
@property (nonatomic, strong, readwrite) NSNumber *testId;
@end

@implementation MITestRailTest
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"assignedto_id": @"assignedToId",
                                                       @"case_id": @"caseId",
                                                       @"custom_expected": @"customExpected",
                                                       @"custom_preconds": @"customPreconds",
                                                       @"custom_steps_separated": @"customStepsSeparated",
                                                       @"estimate": @"estimate",
                                                       @"estimate_forecast": @"estimateForecast",
                                                       @"id": @"testId",
                                                       @"priority_id": @"priorityId",
                                                       @"run_id": @"runId",
                                                       @"status_id": @"statusId",
                                                       @"title": @"title",
                                                       @"type_id": @"typeId"
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *testDescription = [self toJSONString];
    return testDescription;
}

@end
