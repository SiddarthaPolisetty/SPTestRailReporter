//
//  SPTestRailCase.h
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SPTestRailCustomStep.h"

@interface SPTestRailCase : JSONModel
@property (nonatomic, strong) NSNumber *createdByUserId;
@property (nonatomic, strong) NSNumber *updatedByUserId;
@property (nonatomic, strong, readonly) NSNumber *caseId;
@property (nonatomic, strong) NSNumber *milestoneId;
@property (nonatomic, strong) NSNumber *priorityId;
@property (nonatomic, strong) NSNumber *sectionId;
@property (nonatomic, strong) NSNumber *suiteId;
@property (nonatomic, strong) NSNumber *typeId;
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
@property (nonatomic, strong) NSArray<SPTestRailCustomStep> *customStepsSeperated;
@end
