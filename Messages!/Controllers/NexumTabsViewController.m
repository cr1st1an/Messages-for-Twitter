//
//  NexumTabsViewController.m
//  Messages!
//
//  Created by Cristian Castillo on 11/28/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumTabsViewController.h"

@interface NexumTabsViewController ()

@end

@implementation NexumTabsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Flurry logPageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification:) name:@"pushNotification" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushNotification" object:nil];
}

- (void)pushNotification:(NSNotification *)notification {
    NSDictionary *currentAccount = [NexumDefaults currentAccount];
    NSDictionary *data = notification.userInfo;
    if([(NSString *)currentAccount[@"identifier"] isEqualToString:(NSString *)data[@"recipient"]]){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [[self.tabBar.items objectAtIndex:1] setBadgeValue:@" "];
    }
}

@end
