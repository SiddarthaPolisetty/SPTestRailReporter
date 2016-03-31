//
//  MITestRailResult.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MITestRailResult : JSONModel
@property (nonatomic) int resultId;
@property (nonatomic) int assignedToId;
@property (nonatomic) int createdById;
@property (nonatomic) int testId;
@property (nonatomic) int statusId;
@property (nonatomic, strong) NSString *defects;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *elapsed;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSDate *createdOn;
@end
