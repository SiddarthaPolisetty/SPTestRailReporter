//
//  MITestRailTest.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailTest.h"
/*
 @property (nonatomic) int assignedToId;
 @property (nonatomic) int caseId;
 @property (nonatomic) int testId;
 @property (nonatomic) int priorityId;
 @property (nonatomic) int runId;
 @property (nonatomic) int statusId;
 @property (nonatomic) int typeId;
 @property (nonatomic, strong) NSString *customExpected;
 @property (nonatomic, strong) NSString *customPreconds;
 @property (nonatomic, strong) NSString *estimate;
 @property (nonatomic, strong) NSString *estimateForecast;
 @property (nonatomic, strong) NSString *title;
 @property (nonatomic, strong) NSArray<MITestRailCustomStep> *customStepsSeparated;
 
 {
	@"assignedto_id": @"",
	@"case_id": @"",
	@"custom_expected": @"",
	@"custom_preconds": @"",
	@"custom_steps_separated": @"",
	@"estimate": @"",
	@"estimate_forecast": @"",
	@"id": @"",
	@"priority_id": @"",
	@"run_id": @"",
	@"status_id": @"",
	@"title": @"",
	@"type_id": @""
 }
 */
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
