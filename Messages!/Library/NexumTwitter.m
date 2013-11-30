//
//  NexumTwitter.m
//  Messages!
//
//  Created by Cristian Castillo on 11/25/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumTwitter.h"

@implementation NexumTwitter

+ (void) postStatus:(NSString *)status onView:(UIViewController *)view {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invited!" message:status delegate:self cancelButtonTitle:@"Thanks" otherButtonTitles:nil];
    [message show];
    
    NSString *params = [NSString stringWithFormat:@"status=%@", status];
    [NexumBackend apiRequest:@"POST" forPath:@"statuses/update" withParams:params andBlock:^(BOOL success, NSDictionary *data) {}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex %d", buttonIndex);
}

+ (void) follow:(NSString *)identifier {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Followed" message:@"It will appear on your lists in a couple of minutes." delegate:self cancelButtonTitle:@"Thanks" otherButtonTitles:nil];
    [message show];
    
    NSString *params = [NSString stringWithFormat:@"identifier=%@", identifier];
    [NexumBackend apiRequest:@"POST" forPath:@"contacts/follow" withParams:params andBlock:^(BOOL success, NSDictionary *data) {}];
}

+ (void) unfollow:(NSString *)identifier {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unfollowed" message:@"It will dissapear from your lists in a couple of minutes." delegate:self cancelButtonTitle:@"Thanks" otherButtonTitles:nil];
    [message show];
    
    NSString *params = [NSString stringWithFormat:@"identifier=%@", identifier];
    
    [NexumBackend apiRequest:@"POST" forPath:@"contacts/unfollow" withParams:params andBlock:^(BOOL success, NSDictionary *data) {}];
}

+ (void) block:(NSString *)identifier {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Blocked" message:@"Use the official app to unblock." delegate:self cancelButtonTitle:@"Thanks" otherButtonTitles:nil];
    [message show];
    
    NSString *params = [NSString stringWithFormat:@"identifier=%@", identifier];
    
    [NexumBackend apiRequest:@"POST" forPath:@"contacts/block" withParams:params andBlock:^(BOOL success, NSDictionary *data) {}];
}

+ (void) unblock:(NSString *)identifier {
    NSString *params = [NSString stringWithFormat:@"identifier=%@", identifier];
    
    [NexumBackend apiRequest:@"POST" forPath:@"contacts/unblock" withParams:params andBlock:^(BOOL success, NSDictionary *data) {}];
}

@end