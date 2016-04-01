//
//  MITestRailConfiguration.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/31/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MITestRailSubConfiguration.h"

@interface MITestRailConfiguration : JSONModel
@property (nonatomic) int configurationId;
@property (nonatomic) int projectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<MITestRailSubConfiguration> *configurationsSeperated;
@end
