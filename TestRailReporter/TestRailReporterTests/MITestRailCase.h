//
//  MITestRailCase.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MITestRailCustomStep.h"

@interface MITestRailCase : JSONModel
@property (nonatomic) int createdByUserId;
@property (nonatomic) int updatedByUserId;
@property (nonatomic) int caseId;
@property (nonatomic) int milestoneId;
@property (nonatomic) int priorityId;
@property (nonatomic) int sectionId;
@property (nonatomic) int suiteId;
@property (nonatomic) int typeId;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSString *customExpected;
@property (nonatomic, strong) NSString *customPreconds;
@property (nonatomic, strong) NSString *customSteps;
@property (nonatomic, strong) NSArray *customStepsSeparated;
@property (nonatomic, strong) NSString *estimate;
@property (nonatomic, strong) NSString *estimateForecast;
@property (nonatomic, strong) NSDate *updatedOn;
@property (nonatomic, strong) NSString *refs;//comma seperated strings
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<MITestRailCustomStep> *customStepsSeperated;
@end
