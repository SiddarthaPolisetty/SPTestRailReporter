//
//  SPTestRailRun.m
//  SPTestRailReporterExample
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright (c) 2016 Siddartha Polisetty
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "SPTestRailRun.h"

@interface SPTestRailRun ()
@property (nonatomic, strong, readwrite) NSNumber *runId;
@end

@implementation SPTestRailRun
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"runId",
                                                       @"suite_id": @"suiteId",
                                                       @"project_id": @"projectId",
                                                       @"failed_count": @"failedCount",
                                                       @"retest_count": @"retestCount",
                                                       @"untested_count": @"untestedCount",
                                                       @"blocked_count": @"blockedCount",
                                                       @"passed_count": @"passedCount",
                                                       @"plan_id": @"planId",
                                                       @"assignedto_id": @"assignedToId",
                                                       @"milestone_id": @"mileStoneId",
                                                       @"created_by" : @"createdById",
                                                       @"include_all" : @"includeAll",
                                                       @"is_completed" : @"completed",
                                                       @"name" : @"name",
                                                       @"description" : @"runDescription",
                                                       @"config" : @"config",
                                                       @"completed_on" : @"completedOn",
                                                       @"created_on" : @"createdOn",
                                                       @"url" : @"runURL",
                                                       @"config_ids" : @"configIds",
                                                       @"case_ids" : @"caseIds"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *runDescription = [self toJSONString];
    return runDescription;
}
@end
