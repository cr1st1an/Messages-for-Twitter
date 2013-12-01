//
//  NexumBackend.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NexumBackend : NSObject


+ (void)getContactsFollowers:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block;
+ (void)getContactsFollowing:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block;
+ (void)getContactsSearch:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block;
+ (void)getContactsSuggested:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block;
+ (void)getMessages:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block;
+ (void)getProfiles:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block;
+ (void)getThreads:(void (^)(NSDictionary *data))block;

+ (void)postAccountsDeviceToken:(NSString *)params;
+ (void)postStatusesUpdate:(NSString *)params;
+ (void)postContactsBlock:(NSString *)params;
+ (void)postContactsFollow:(NSString *)params;
+ (void)postContactsUnblock:(NSString *)params;
+ (void)postContactsUnfollow:(NSString *)params;
+ (void)postMessages:(NSString *)params;
+ (void)postSessions:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block;
+ (void)postSessionsAuth:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block;
+ (void)postWorkers01;

+ (NSDictionary *)apiRequest:(NSString *)type forPath:(NSString *)path withParams:(NSString *)params;

@end