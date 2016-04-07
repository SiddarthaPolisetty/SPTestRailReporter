//
//  SPTestRailPlanEntry.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "SPTestRailPlanEntry.h"

@interface SPTestRailPlanEntry ()
@property (nonatomic, strong, readwrite) NSString *planEntryId;
@end

@implementation SPTestRailPlanEntry
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"planEntryId",
                                                       @"name": @"name",
                                                       @"suite_id": @"suiteId"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

#pragma mark - description
- (NSString *)description {
    NSString *planEntryDescription = [self toJSONString];
    return planEntryDescription;
}
@end
