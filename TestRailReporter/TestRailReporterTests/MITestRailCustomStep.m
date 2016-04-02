//
//  MITestRailCustomStep.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailCustomStep.h"

@implementation MITestRailCustomStep
#pragma mark - initializers
- (instancetype)initWithContent:(NSString *)content Expectation:(NSString *)expectation  {
    if (self = [super init]) {
        _content = content;
        _expected = expectation;
    }
    return self;
}

#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"content": @"content",
                                                       @"expected": @"expected"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *customStepDescription = [self toJSONString];
    return customStepDescription;
}

@end
