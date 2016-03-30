//
//  MITestRailSuite.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MITestRailSuite : JSONModel
@property (nonatomic, readonly) int suiteId;
@property (nonatomic, strong) NSString *suiteName;
@property (nonatomic, strong) NSString<Optional> *suiteDescription;
@property (nonatomic) int projectId;
@property (nonatomic, strong) NSURL *suiteURL;
@property (nonatomic, strong) NSDate<Optional> *completedOn;
@property (nonatomic, getter=isCompleted) BOOL completed;
@property (nonatomic, getter=isBaseline) BOOL baseline;
@property (nonatomic, getter=isMaster) BOOL master;
- (instancetype)initWithName:(NSString *)name Description:(NSString *)description ProjectId:(int)projectId;
@end
