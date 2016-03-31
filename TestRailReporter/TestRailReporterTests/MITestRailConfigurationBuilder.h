//
//  MITestRailConfigurationBuilder.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITestRailConfigurationBuilder : NSObject
+ (instancetype)sharedConfigurationBuilder;
- (NSString *)valueForAuthHeader;
@property (nonatomic, strong) NSURL *testRailBaseURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@end
