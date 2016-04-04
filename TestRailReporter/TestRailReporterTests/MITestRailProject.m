//
//  MITestRailProject.m
//  DocsAtWork
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailProject.h"

@interface MITestRailProject ()
@property (nonatomic, strong, readwrite) NSNumber *projectId;
@property (nonatomic , strong, readwrite) NSURL *projectURL;
@end

@implementation MITestRailProject
#pragma mark - initializers
- (instancetype)init {
    NSString *uniqueIdentifier = [[NSUUID UUID] UUIDString];
    NSString *projectName = [NSString stringWithFormat:@"Project-%@",uniqueIdentifier];
    NSString *projectAnnouncement = [NSString stringWithFormat:@"Announcement for Project-%@",uniqueIdentifier];
    return [self initWithName:projectName Announcement:projectAnnouncement Mode:MITestRailSuiteModeSingleSuite];
}

- (instancetype)initWithName:(NSString *)name Announcement:(NSString *)announcement Mode:(MITestRailSuiteMode)suiteMode {
    if (self = [super init]) {
        _name = name;
        _announcement = announcement;
        _suiteMode = suiteMode;
    }
    return self;
}

#pragma mark - JSON serialize/de-serialize utils
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"projectId",
                                                       @"name": @"name",
                                                       @"announcement": @"announcement",
                                                       @"completed_on": @"completedOn",
                                                       @"is_completed": @"completed",
                                                       @"show_announcement": @"showAnnouncement",
                                                       @"suite_mode" : @"suiteMode",
                                                       @"url": @"projectURL"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
#pragma mark - description
- (NSString *)description {
    NSString *projectDescription = [self toJSONString];
    return projectDescription;
}
@end
