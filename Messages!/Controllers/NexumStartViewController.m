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
    [Flurry logPageView];
    
    if(nil == [NexumDefaults currentSession]){
        [self presentSignin];
    } else {
        [self sessionStart];
        [self performSelector:@selector(presentSignin) withObject:nil afterDelay:5.0];    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)presentSignin {
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.titleImage.alpha = 1;
        self.signinButton.alpha = 1;
    }];
}

- (void)requestLogin {
    [self performSegueWithIdentifier: @"requestLogin" sender:self];
}

- (void)sessionStart {
    NSString *uiid = [[[[UIDevice alloc] init] identifierForVendor] UUIDString];
    NSString *params = [NSString stringWithFormat:@"id_session=%@&uiid=%@", [NexumDefaults currentSession], uiid];
    [NexumBackend postSessions:params withAsyncBlock:^(NSDictionary *data) {
        BOOL success = [data[@"success"] boolValue];
        if(success){
            [NexumDefaults addAccount:data[@"account_data"]];
            [NexumBackend postWorkers01];
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
            [Flurry setUserID:data[@"account_data"][@"identifier"]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self openApp];
            });
        } else {
            [NexumDefaults addSession:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self presentSignin];
            });
        }
    }];
}

- (void)openApp {
    [self performSegueWithIdentifier: @"openApp" sender:self];
}

- (IBAction)signinAction:(UIButton *)sender {
    if(nil == [NexumDefaults currentSession]){
        [self requestLogin];
    } else {
        [self sessionStart];
    }
}

@end
