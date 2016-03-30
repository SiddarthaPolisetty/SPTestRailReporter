//
//  MITestRailSection.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailSection.h"

@implementation MITestRailSection
#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"depth": @"depth",
                                                       @"description":@"sectionDescription",
                                                       @"id":@"sectionId",
                                                       @"display_order":@"displayOrder",
                                                       @"parent_id":@"parentId",
                                                       @"suite_id":@"suiteId",
                                                       @"name":@"name"
                                                       }];
}

#pragma mark - description
- (NSString *)description {
    NSString *sectionDescription = [NSString stringWithFormat:@"<Section id = %d, name = %@, description = %@, depth =  %d, suite id = %d>", self.sectionId, self.name,self.sectionDescription ,self.depth, self.suiteId];
    return sectionDescription;
}
@end
