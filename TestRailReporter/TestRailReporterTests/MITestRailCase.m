//
//  MITestRailCase.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailCase.h"

@implementation MITestRailCase
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"created_by": @"createdByUserId",
                                                       @"updated_by": @"updatedByUserId",
                                                       @"id": @"caseId",
                                                       @"milestone_id": @"milestoneId",
                                                       @"priority_id": @"priorityId",
                                                       @"section_id": @"sectionId",
                                                       @"suite_id": @"suiteId",
                                                       @"type_id": @"typeId",
                                                       @"created_on": @"createdOn",
                                                       @"custom_expected": @"customExpected",
                                                       @"custom_preconds": @"customPreconds",
                                                       @"custom_steps": @"customSteps",
                                                       @"estimate": @"estimate",
                                                       @"estimate_forecast": @"estimateForecast",
                                                       @"updated_on": @"updatedOn",
                                                       @"refs": @"refs",
                                                       @"title": @"title"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
