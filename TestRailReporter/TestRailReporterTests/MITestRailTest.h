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
@property (nonatomic) int assignedToId;
@property (nonatomic) int caseId;
@property (nonatomic) int testId;
@property (nonatomic) int priorityId;
@property (nonatomic) int runId;
@property (nonatomic) int statusId;
@property (nonatomic) int typeId;
@property (nonatomic, strong) NSString *customExpected;
@property (nonatomic, strong) NSString *customPreconds;
@property (nonatomic, strong) NSString *estimate;
@property (nonatomic, strong) NSString *estimateForecast;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<MITestRailCustomStep> *customStepsSeparated;
@end
