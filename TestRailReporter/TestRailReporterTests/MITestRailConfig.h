//
//  MITestRailConfig.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/31/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MITestRailConfig : JSONModel
@property (nonatomic, strong, readonly) NSNumber *configId;
@property (nonatomic, strong) NSNumber *groupId;
@property (nonatomic, strong) NSString *name;
@end

@protocol MITestRailConfig

@end