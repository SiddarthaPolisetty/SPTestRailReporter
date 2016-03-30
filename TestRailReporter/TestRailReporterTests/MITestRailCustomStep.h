//
//  MITestRailCustomStep.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MITestRailCustomStep : JSONModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *expected;
@end

@protocol MITestRailCustomStep
@end