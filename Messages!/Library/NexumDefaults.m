//
//  NexumSession.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumDefaults.h"

@implementation NexumDefaults


+ (void) addSession:(NSString *) idSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:idSession forKey:@"id_session"];
    [defaults synchronize];
}

+ (void) addAccount:(NSDictionary *)account {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *accounts = [defaults dictionaryForKey:@"accounts"];
    
    NSMutableDictionary *new_accounts = [NSMutableDictionary dictionaryWithDictionary:accounts];
    NSString *new_current = [account objectForKey:@"id_account"];
    
    [new_accounts setObject:account forKey:new_current];
    
    [defaults setObject:new_accounts forKey:@"accounts"];
    [defaults setObject:new_current forKey:@"current"];
    
    [defaults synchronize];
    
}

+ (NSString *) currentSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *idSession = [defaults stringForKey:@"id_session"];
    
    return idSession;
}

+ (NSArray *) currentAccount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *accounts = [defaults dictionaryForKey:@"accounts"];
    NSString *current = [defaults stringForKey:@"current"];
    
    if(nil == accounts)
        accounts = [NSDictionary dictionary];
    
    return [accounts objectForKey:current];
}

@end