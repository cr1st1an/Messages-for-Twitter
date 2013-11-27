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
    self.webview.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", BACKEND_URL, @"sessions/auth"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [self.webview loadRequest:urlRequest];
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
        
        [NexumBackend apiRequest:@"POST" forPath:@"sessions/auth" withParams:params andBlock:^(BOOL success, NSDictionary *data) {
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
    [self.webview loadRequest:urlRequest];
}

@end
