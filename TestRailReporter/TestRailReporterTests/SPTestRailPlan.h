//
//  SPTestRailPlan.h
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SPTestRailPlanEntry.h"

@interface SPTestRailPlan : JSONModel
@property (nonatomic, strong) NSNumber *assignedToId;
@property (nonatomic, strong) NSNumber *blockedCount;
@property (nonatomic, strong) NSNumber *createdById;
@property (nonatomic, strong) NSNumber *failedCount;
@property (nonatomic, strong, readonly) NSNumber *planId;
@property (nonatomic, strong) NSNumber *milestoneId;
@property (nonatomic, strong) NSNumber *passedCount;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSNumber *retestCount;
@property (nonatomic, strong) NSNumber *untestedCount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *planDescription;
@property (nonatomic, strong) NSURL *planURL;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSDate *completedOn;
@property (nonatomic, getter=isCompleted) BOOL completed;
@property (nonatomic, strong) NSArray<SPTestRailPlanEntry> *entries;
@end
