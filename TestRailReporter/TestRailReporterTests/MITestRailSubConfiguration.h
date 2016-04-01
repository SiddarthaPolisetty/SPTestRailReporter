//
//  MITestRailSubConfiguration.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/31/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>
/*
 {
 "group_id": 1,
 "id": 3,
 "name": "Internet Explorer"
 }
 */
@interface MITestRailSubConfiguration : JSONModel
@property (nonatomic) int subConfigurationId;
@property (nonatomic) int groupId;
@property (nonatomic, strong) NSString *name;
@end

@protocol MITestRailSubConfiguration

@end