//
//  NexumAlphaViewController.m
//  Messages!
//
//  Created by Cristian Castillo on 11/25/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumAlphaViewController.h"

@interface NexumAlphaViewController ()

@end

@implementation NexumAlphaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://getmessages.tumblr.com"]];
    [self.webview loadRequest:urlRequest];
}

- (IBAction)refreshAction:(UIBarButtonItem *)sender {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://getmessages.tumblr.com"]];
    [self.webview loadRequest:urlRequest];
}

@end
