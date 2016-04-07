//
//  SPTestRailCustomStep.h
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SPTestRailCustomStep : JSONModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *expected;
@end

@protocol SPTestRailCustomStep
@end