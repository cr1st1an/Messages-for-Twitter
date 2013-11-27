//
//  NexumBackend.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NexumBackend : NSObject

+ (void) apiRequest:(NSString *)type forPath:(NSString *)path withParams:(NSString *)params andBlock:(void (^)(BOOL success, NSDictionary *data)) block;

@end