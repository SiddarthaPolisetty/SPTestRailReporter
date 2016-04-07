//
//  SPTestRailSuite.h
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 3/24/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface SPTestRailSuite : JSONModel
@property (nonatomic, strong, readonly) NSNumber *suiteId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *suiteDescription;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSURL *suiteURL;
@property (nonatomic, strong) NSDate *completedOn;
@property (nonatomic, getter=isCompleted) BOOL completed;
@property (nonatomic, getter=isBaseline) BOOL baseline;
@property (nonatomic, getter=isMaster) BOOL master;
- (instancetype)initWithName:(NSString *)name Description:(NSString *)description ProjectId:(NSNumber *)projectId;
@end
