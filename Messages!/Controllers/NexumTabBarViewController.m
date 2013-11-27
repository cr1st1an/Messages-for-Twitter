//
//  NexumTabBarViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumTabBarViewController.h"

@interface NexumTabBarViewController ()

@end

@implementation NexumTabBarViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(nil == [NexumDefaults currentSession]){
        [self showLoginWebView];
    } else {
        NSString *uiid = [[[[UIDevice alloc] init] identifierForVendor] UUIDString];
        NSString *params = [NSString stringWithFormat:@"id_session=%@&uiid=%@", [NexumDefaults currentSession], uiid];
        
        [NexumBackend apiRequest:@"POST" forPath:@"sessions" withParams:params andBlock:^(BOOL success, NSDictionary *data) {
            if(success){
                [NexumDefaults addAccount:data[@"account_data"]];
                [NexumBackend apiRequest:@"POST" forPath:@"workers/01" withParams:@"" andBlock:^(BOOL success, NSDictionary *data) {}];
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
            } else {
                [NexumDefaults addSession:nil];
                [self performSelectorOnMainThread:@selector(showLoginWebView) withObject:nil waitUntilDone:YES];
            }
        }];
    }
}

- (void)showLoginWebView{
    [self performSegueWithIdentifier: @"showLogin" sender:self];
}

@end
