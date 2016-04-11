//
//  ViewController.m
//  Example
//
//  Created by Siddartha Polisetty on 4/11/16.
//  Copyright © 2016 Sid Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *homeUrlRequest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://siddarthapolisetty.github.io/SPTestRailReporter"]];
    [self.webView loadRequest:self.homeUrlRequest];
    self.navigationItem.title = @"SPTestRailReporter";
}

- (void)loadHome {
    [self.webView loadRequest:self.homeUrlRequest];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
