//
//  SPTestRailUserTests.m
//  SPTestRailReporter
//
//  Created by Siddartha Polisetty on 4/1/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
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
