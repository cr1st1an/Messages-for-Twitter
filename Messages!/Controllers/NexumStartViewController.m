//
//  NexumStartViewController.m
//  Messages!
//
//  Created by Cristian Castillo on 11/27/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumStartViewController.h"

@interface NexumStartViewController ()

@end

@implementation NexumStartViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(nil == [NexumDefaults currentSession]){
        [self requestLogin];
    } else {
        [self sessionStart];
    }
}

- (void)requestLogin {
    [self performSegueWithIdentifier: @"requestLogin" sender:self];
}

- (void)sessionStart {
    NSString *uiid = [[[[UIDevice alloc] init] identifierForVendor] UUIDString];
    NSString *params = [NSString stringWithFormat:@"id_session=%@&uiid=%@", [NexumDefaults currentSession], uiid];
    
    [NexumBackend apiRequest:@"POST" forPath:@"sessions" withParams:params andBlock:^(BOOL success, NSDictionary *data) {
        if(success){
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                
                [NexumDefaults addAccount:data[@"account_data"]];
                [NexumBackend apiRequest:@"POST" forPath:@"workers/01" withParams:@"" andBlock:^(BOOL success, NSDictionary *data) {}];
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self openApp];
                });
                
            });
            
        } else {
            [NexumDefaults addSession:nil];
            [self requestLogin];
        }
    }];
}

- (void)openApp {
    [self performSegueWithIdentifier: @"openApp" sender:self];
}

@end
