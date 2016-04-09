//
//  SPTestRailPlan.h
//  SPTestRailReporterExample
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright (c) 2016 Siddartha Polisetty
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <JSONModel/JSONModel.h>
#import "SPTestRailPlanEntry.h"

@interface SPTestRailPlan : JSONModel
@property (nonatomic, strong) NSNumber *assignedToId;
@property (nonatomic, strong) NSNumber *blockedCount;
@property (nonatomic, strong) NSNumber *createdById;
@property (nonatomic, strong) NSNumber *failedCount;
@property (nonatomic, strong, readonly) NSNumber *planId;
@property (nonatomic, strong) NSNumber *milestoneId;
@property (nonatomic, strong) NSNumber *passedCount;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSNumber *retestCount;
@property (nonatomic, strong) NSNumber *untestedCount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *planDescription;
@property (nonatomic, strong) NSURL *planURL;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSDate *completedOn;
@property (nonatomic, getter=isCompleted) BOOL completed;
@property (nonatomic, strong) NSArray<SPTestRailPlanEntry> *entries;
@end
