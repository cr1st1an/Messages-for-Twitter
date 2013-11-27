//
//  NexumSession.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NexumDefaults : NSObject

+ (void) addSession:(NSString *) idSession;
+ (void) addAccount: (NSDictionary *) account;
+ (NSString *) currentSession;
+ (NSDictionary *) currentAccount;

@end