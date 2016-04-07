//
//  SPTestRailRun.h
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SPTestRailRun : JSONModel
@property (nonatomic, strong, readonly) NSNumber *runId;
@property (nonatomic, strong) NSNumber *suiteId;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSNumber *failedCount;
@property (nonatomic, strong) NSNumber *retestCount;
@property (nonatomic, strong) NSNumber *untestedCount;
@property (nonatomic, strong) NSNumber *blockedCount;
@property (nonatomic, strong) NSNumber *passedCount;
@property (nonatomic, strong) NSNumber *planId;
@property (nonatomic, strong) NSNumber *assignedToId;
@property (nonatomic, strong) NSNumber *mileStoneId;
@property (nonatomic, strong) NSNumber *createdById;
@property (nonatomic) BOOL includeAll;
@property (nonatomic, getter=isCompleted) BOOL completed;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *runDescription;
@property (nonatomic, strong) NSString *config;
@property (nonatomic, strong) NSDate *completedOn;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSURL *runURL;
@property (nonatomic, strong) NSArray *configIds;
@property (nonatomic, strong) NSArray *caseIds;
@end

@protocol SPTestRailRun

@end
