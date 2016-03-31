//
//  MITestRailPlan.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MITestRailPlanEntry.h"

@interface MITestRailPlan : JSONModel
@property (nonatomic) int assignedToId;
@property (nonatomic) int blockedCount;
@property (nonatomic) int createdById;
@property (nonatomic) int failedCount;
@property (nonatomic) int planId;
@property (nonatomic) int milestoneId;
@property (nonatomic) int passedCount;
@property (nonatomic) int projectId;
@property (nonatomic) int retestCount;
@property (nonatomic) int untestedCount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *planDescription;
@property (nonatomic, strong) NSURL *planURL;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSDate *completedOn;
@property (nonatomic, getter=isCompleted) BOOL completed;
@property (nonatomic, strong) NSArray<MITestRailPlanEntry> *entries;
@end
