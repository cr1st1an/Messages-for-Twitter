//
//  NexumLoginViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumLoginViewController.h"

@interface NexumLoginViewController ()

@end

@implementation NexumLoginViewController

- (void)viewDidLoad {
    self.twitterWebview.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", BACKEND_URL, @"sessions/auth"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [self.twitterWebview loadRequest:urlRequest];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSDictionary *urlGet = [NexumUtil paramsOfURL:webView.request.URL];
    
    if(nil != [urlGet objectForKey:@"oauth_verifier"]){
        NSString *params = [NSString stringWithFormat:@"uiid=%@&client=%@&version=%@&oauth_token=%@&oauth_verifier=%@",
                            [[[[UIDevice alloc] init] identifierForVendor] UUIDString],
                            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"],
                            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                            [urlGet objectForKey:@"oauth_token"],
                            [urlGet objectForKey:@"oauth_verifier"]
                            ];
        
        [NexumBackend postSessionsAuth:params withAsyncBlock:^(NSDictionary *data) {
            BOOL success = [data[@"success"] boolValue];
            if(success){
                [NexumDefaults addSession:data[@"id_session"]];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (IBAction)refreshAction:(id)sender {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", BACKEND_URL, @"sessions/auth"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [self.twitterWebview loadRequest:urlRequest];
}

@end
