//
//  MITestRailSection.h
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/29/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MITestRailSection : JSONModel
@property (nonatomic) int depth;
@property (nonatomic, strong) NSString *sectionDescription;
@property (nonatomic) int displayOrder;
@property (nonatomic) int sectionId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int parentId;
@property (nonatomic) int suiteId;
@end
