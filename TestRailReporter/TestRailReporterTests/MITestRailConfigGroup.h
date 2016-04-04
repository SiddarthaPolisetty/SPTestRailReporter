//
//  MITestRailConfigGroup.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/31/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MITestRailConfig.h"

@interface MITestRailConfigGroup : JSONModel
@property (nonatomic, strong, readonly) NSNumber *configGroupId;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<MITestRailConfig> *configurationsSeperated;
@end
