//
//  SPTestRailResult.h
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SPTestRailResult : JSONModel
@property (nonatomic, strong, readonly) NSNumber *resultId;
@property (nonatomic, strong) NSNumber *assignedToId;
@property (nonatomic, strong) NSNumber *createdById;
@property (nonatomic, strong) NSNumber *testId;
@property (nonatomic, strong) NSNumber *statusId;
@property (nonatomic, strong) NSString *defects;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *elapsed;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSDate *createdOn;
@end
