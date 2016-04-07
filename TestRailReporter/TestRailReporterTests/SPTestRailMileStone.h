//
//  SPTestRailMileStone.h
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SPTestRailMileStone : JSONModel
@property (nonatomic, strong) NSDate<Optional> *completedOn;
@property (nonatomic, strong) NSString *mileStoneDescription;
@property (nonatomic, strong) NSDate<Optional> *dueOn;
@property (nonatomic, strong, readonly) NSNumber *mileStoneId;
@property (nonatomic, getter=isComlpeted) BOOL completed;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSURL *mileStoneURL;
@end
