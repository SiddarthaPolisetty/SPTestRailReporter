//
//  SPTestRailTest.h
//  SPTestRailReporter
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
#import "SPTestRailCustomStep.h"

@interface SPTestRailTest : JSONModel
@property (nonatomic, strong) NSNumber *assignedToId;
@property (nonatomic, strong) NSNumber *caseId;
@property (nonatomic, strong, readonly) NSNumber *testId;
@property (nonatomic, strong) NSNumber *priorityId;
@property (nonatomic, strong) NSNumber *runId;
@property (nonatomic, strong) NSNumber *statusId;
@property (nonatomic, strong) NSNumber *typeId;
@property (nonatomic, strong) NSString *customExpected;
@property (nonatomic, strong) NSString *customPreconds;
@property (nonatomic, strong) NSString *estimate;
@property (nonatomic, strong) NSString *estimateForecast;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<SPTestRailCustomStep> *customStepsSeparated;
@end
