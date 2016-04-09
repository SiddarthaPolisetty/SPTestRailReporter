//
//  SPTestRailConfigurationBuilder.m
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

#import "SPTestRailConfigurationBuilder.h"
#import "NSData+Base64.h"

@implementation SPTestRailConfigurationBuilder
+ (instancetype)sharedConfigurationBuilder {
    static dispatch_once_t onceToken = 0;
    static SPTestRailConfigurationBuilder *sharedConfigurationBuilder = nil;
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
    [NSException raise:@"Invalid Initializer" format:@"Please use [SPTestRailConfigurationBuilder sharedConfigurationBuilder]"];
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
