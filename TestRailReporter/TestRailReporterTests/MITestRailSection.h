//
//  MITestRailSection.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MITestRailSection : JSONModel
@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSString *sectionDescription;
@property (nonatomic, strong) NSNumber *displayOrder;
@property (nonatomic, strong, readonly) NSNumber *sectionId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSNumber *suiteId;
@end
