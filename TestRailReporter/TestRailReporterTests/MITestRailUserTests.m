//
//  MITestRailUserTests.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 4/1/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITestRailReporter.h"
#import "MITestRailConfigurationBuilder.h"

@interface MITestRailUserTests : XCTestCase

@end

@implementation MITestRailUserTests

- (void)setUp {
    [super setUp];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].testRailBaseURL = [NSURL URLWithString:@"https://siddarthapolisetty.testrail.net"];
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].userName = @"siddarthpolishetty@yahoo.com";
    [MITestRailConfigurationBuilder sharedConfigurationBuilder].password = @"Test1234!";
}

- (void)testUsersAPI {
    NSError *error = nil;
    //step 1 : get all users
    NSArray *users = [[MITestRailReporter sharedReporter] getAllUsersError:&error];
    for (MITestRailUser *user in users) {
        NSLog(@"%@", user);
    }
    //step 2 : get user by id
    MITestRailUser *user = [users firstObject];
    MITestRailUser *userById = [[MITestRailReporter sharedReporter] getUserWithId:user.userId Error:&error];
    XCTAssertTrue(user.userId == userById.userId, @"Mismatch");
    //step 3 : get user by email
    MITestRailUser *userByEmail = [[MITestRailReporter sharedReporter] getUserWithEmail:user.email Error:&error];
    XCTAssertTrue(user.userId == userByEmail.userId, @"Mismatch");
}
@end
