//
//  SPTestRailUserTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/1/16.
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

#import <XCTest/XCTest.h>
#import "SPTestRailReporter.h"
#import "SPTestRailConfigurationBuilder.h"

@interface SPTestRailUserTests : XCTestCase

@end

@implementation SPTestRailUserTests

- (void)setUp {
    [super setUp];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [SPTestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
}

- (void)testUsersAPI {
    NSError *error = nil;
    //step 1 : get all users
    NSArray *users = [[SPTestRailReporter sharedReporter] getAllUsersError:&error];
    for (SPTestRailUser *user in users) {
        NSLog(@"%@", user);
    }
    //step 2 : get user by id
    SPTestRailUser *user = [users firstObject];
    SPTestRailUser *userById = [[SPTestRailReporter sharedReporter] getUserWithId:user.userId Error:&error];
    XCTAssertTrue(user.userId == userById.userId, @"Mismatch");
    //step 3 : get user by email
    SPTestRailUser *userByEmail = [[SPTestRailReporter sharedReporter] getUserWithEmail:user.email Error:&error];
    XCTAssertTrue(user.userId == userByEmail.userId, @"Mismatch");
}
@end
