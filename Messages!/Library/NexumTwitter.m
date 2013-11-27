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
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *sendTweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [sendTweet setInitialText:status];
        [view presentViewController:sendTweet animated:YES completion:nil];
    }
}

+ (void) follow:(NSString *)identifier {
    NSString *params = [NSString stringWithFormat:@"identifier=%@", identifier];
    
    [NexumBackend apiRequest:@"POST" forPath:@"contacts/follow" withParams:params andBlock:^(BOOL success, NSDictionary *data) {}];
}

@end