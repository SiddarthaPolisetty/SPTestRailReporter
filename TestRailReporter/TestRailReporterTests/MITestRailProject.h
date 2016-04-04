//
//  MITestRailProject.h
//  DocsAtWork
//
//  Created by Siddartha Polisetty on 3/22/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "JSONModel.h"

typedef NS_ENUM(NSInteger, MITestRailSuiteMode) {
    MITestRailSuiteModeSingleSuite = 1,
    MITestRailSuiteModeSingleSuitePlusBaseLines,
    MITestRailSuiteModeMultipleSuites
};

@interface MITestRailProject : JSONModel
@property (nonatomic, strong, readonly) NSNumber *projectId;
@property (nonatomic, strong) NSDate *completedOn;
@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSString *announcement;
@property (nonatomic) BOOL showAnnouncement;
@property (nonatomic) BOOL completed;
@property (nonatomic) NSInteger suiteMode;
@property (nonatomic , strong, readonly) NSURL *projectURL;

- (instancetype)initWithName:(NSString *)name Announcement:(NSString *)announcement Mode:(MITestRailSuiteMode)suiteMode;
@end

@protocol MITestRailProject
@end
