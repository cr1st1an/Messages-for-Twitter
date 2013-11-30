//
//  NexumTwitter.h
//  Messages!
//
//  Created by Cristian Castillo on 11/25/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <Social/Social.h>
#import <Foundation/Foundation.h>

@interface NexumTwitter : NSObject <UIAlertViewDelegate>

+ (void) postStatus:(NSString *)status onView:(UIViewController *)view;
+ (void) follow:(NSString *)identifier;

@end
