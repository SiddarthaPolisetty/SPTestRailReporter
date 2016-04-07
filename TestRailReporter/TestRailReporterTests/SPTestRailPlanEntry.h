//
//  SPTestRailPlanEntry.h
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SPTestRailRun.h"

@interface SPTestRailPlanEntry : JSONModel
@property (nonatomic, strong, readonly) NSString *planEntryId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *suiteId;
@property (nonatomic, strong) NSArray<SPTestRailRun> *runs;
@end

@protocol SPTestRailPlanEntry
@end