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
@property (nonatomic, readonly) int projectId;
@property (nonatomic, strong) NSDate<Optional> *completedOn;
@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSString<Optional> *announcement;
@property (nonatomic) BOOL showAnnouncement;
@property (nonatomic) BOOL completed;
@property (nonatomic) int suiteMode;
@property (nonatomic , strong, readonly) NSURL *projectURL;

- (instancetype)initWithName:(NSString *)name Announcement:(NSString *)announcement Mode:(MITestRailSuiteMode)suiteMode;
@end

@protocol MITestRailProject
@end
