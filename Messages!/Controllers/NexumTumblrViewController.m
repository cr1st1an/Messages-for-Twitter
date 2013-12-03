//
//  NexumTumblrViewController.m
//  Messages!
//
//  Created by Cristian Castillo on 11/25/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumTumblrViewController.h"

@interface NexumTumblrViewController ()

@end

@implementation NexumTumblrViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Flurry logPageView];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://getmessages.tumblr.com"]];
    [self.webview loadRequest:urlRequest];
}

- (IBAction)refreshAction:(UIBarButtonItem *)sender {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://getmessages.tumblr.com"]];
    [self.webview loadRequest:urlRequest];
}

@end
