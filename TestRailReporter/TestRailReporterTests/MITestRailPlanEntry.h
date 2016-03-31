//
//  MITestRailPlanEntry.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MITestRailRun.h"

@interface MITestRailPlanEntry : JSONModel
@property (nonatomic, strong) NSString *entryId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int suiteId;
@property (nonatomic, strong) NSArray<MITestRailRun> *runs;
@end

@protocol MITestRailPlanEntry
@end