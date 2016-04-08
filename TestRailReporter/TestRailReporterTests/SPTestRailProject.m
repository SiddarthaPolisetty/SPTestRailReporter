//
//  SPTestRailProject.m
//  DocsAtWork
//
//  Created by Siddartha Polisetty on 3/22/16.
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

#import "SPTestRailProject.h"

@interface SPTestRailProject ()
@property (nonatomic, strong, readwrite) NSNumber *projectId;
@property (nonatomic , strong, readwrite) NSURL *projectURL;
@end

@implementation SPTestRailProject
#pragma mark - initializers
- (instancetype)init {
    NSString *uniqueIdentifier = [[NSUUID UUID] UUIDString];
    NSString *projectName = [NSString stringWithFormat:@"Project-%@",uniqueIdentifier];
    NSString *projectAnnouncement = [NSString stringWithFormat:@"Announcement for Project-%@",uniqueIdentifier];
    return [self initWithName:projectName Announcement:projectAnnouncement Mode:SPTestRailSuiteModeSingleSuite];
}

- (instancetype)initWithName:(NSString *)name Announcement:(NSString *)announcement Mode:(SPTestRailSuiteMode)suiteMode {
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
