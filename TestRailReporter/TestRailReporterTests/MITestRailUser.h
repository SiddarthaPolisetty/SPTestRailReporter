//
//  MITestRailUser.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MITestRailUser : JSONModel
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong, readonly) NSNumber *userId;
@property (nonatomic, getter=isActive) BOOL active;
@property (nonatomic, strong) NSString *name;
@end
