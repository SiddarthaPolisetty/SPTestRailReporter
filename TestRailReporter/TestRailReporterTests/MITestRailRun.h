//
//  MITestRailRun.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MITestRailRun : JSONModel
@property (nonatomic) int runId;
@property (nonatomic) int suiteId;
@property (nonatomic) int projectId;
@property (nonatomic) int failedCount;
@property (nonatomic) int retestCount;
@property (nonatomic) int untestedCount;
@property (nonatomic) int blockedCount;
@property (nonatomic) int passedCount;
@property (nonatomic) int planId;
@property (nonatomic) int assignedToId;
@property (nonatomic) int mileStoneId;
@property (nonatomic) int createdById;
@property (nonatomic) BOOL includeAll;
@property (nonatomic, getter=isCompleted) BOOL completed;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *runDescription;
@property (nonatomic, strong) NSString *config;
@property (nonatomic, strong) NSDate *completedOn;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSURL *runURL;
@property (nonatomic, strong) NSArray *configIds;
@end

@protocol MITestRailRun

@end
