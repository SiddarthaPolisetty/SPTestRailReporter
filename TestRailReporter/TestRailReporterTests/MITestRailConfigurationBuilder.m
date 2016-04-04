//
//  MITestRailConfigurationBuilder.m
//  TestRailReporter
//
//  Created by Siddartha Polisetty on 3/30/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "MITestRailConfigurationBuilder.h"
#import "NSData+Base64.h"

@implementation MITestRailConfigurationBuilder
+ (instancetype)sharedConfigurationBuilder {
    static dispatch_once_t onceToken = 0;
    static MITestRailConfigurationBuilder *sharedConfigurationBuilder = nil;
    dispatch_once(&onceToken, ^{
        sharedConfigurationBuilder = [[self alloc] initPrivate];
    });
    
    return sharedConfigurationBuilder;
}


- (instancetype)initPrivate {
    if (self = [super init]) {
        _testRailBaseURL = nil;
        _userName = nil;
        _password = nil;
    }
    return self;
}

- (instancetype)init {
    [NSException raise:@"Invalid Initializer" format:@"Please use [MITestRailConfigurationBuilder sharedConfigurationBuilder]"];
    return nil;
}

- (NSString *)valueForAuthHeader {
    NSMutableString *authHeader = [NSMutableString stringWithString:@"Basic "];
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", self.userName, self.password];
    NSData *authData = [authenticationString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedAuthString = [authData base64EncodedString];
    [authHeader appendString:encodedAuthString];
    return authHeader;
}
@end