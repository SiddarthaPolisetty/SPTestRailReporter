//
//  MITestRailTest.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MITestRailCustomStep.h"

@interface MITestRailTest : JSONModel
@property (nonatomic, strong) NSNumber *assignedToId;
@property (nonatomic, strong) NSNumber *caseId;
@property (nonatomic, strong, readonly) NSNumber *testId;
@property (nonatomic, strong) NSNumber *priorityId;
@property (nonatomic, strong) NSNumber *runId;
@property (nonatomic, strong) NSNumber *statusId;
@property (nonatomic, strong) NSNumber *typeId;
@property (nonatomic, strong) NSString *customExpected;
@property (nonatomic, strong) NSString *customPreconds;
@property (nonatomic, strong) NSString *estimate;
@property (nonatomic, strong) NSString *estimateForecast;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<MITestRailCustomStep> *customStepsSeparated;
@end
