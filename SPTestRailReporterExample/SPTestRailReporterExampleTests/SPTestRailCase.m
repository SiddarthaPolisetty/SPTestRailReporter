//
//  SPTestRailCase.m
//  SPTestRailReporterExample
//
//  Created by Siddartha Polisetty on 3/24/16.
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

#import "SPTestRailCase.h"

@interface SPTestRailCase ()
@property (nonatomic, strong, readwrite) NSNumber *caseId;
@end

@implementation SPTestRailCase
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

#pragma mark - description
- (NSString *)description {
    NSString *caseDescription = [self toJSONString];
    return caseDescription;
}
@end
