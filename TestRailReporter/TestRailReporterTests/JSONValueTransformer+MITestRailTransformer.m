//
//  JSONValueTransformer+MITestRailTransformer.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "JSONValueTransformer+MITestRailTransformer.h"

@implementation JSONValueTransformer (MITestRailTransformer)

- (NSDate *)NSDateFromNSString:(NSString*)string {
    NSTimeInterval interval=[string longLongValue];
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    NSTimeInterval interval = [date timeIntervalSince1970];
    return  [NSString stringWithFormat:@"%f", interval];
}
@end
