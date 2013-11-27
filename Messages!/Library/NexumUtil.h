//
//  NexumUtil.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NexumUtil : NSObject

+(NSMutableDictionary *) getParamsOfURL: (NSURL *)URL;
+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original;

@end
