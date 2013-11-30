//
//  NexumUtil.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumUtil.h"

@implementation NexumUtil

+ (CGRect)currentScreenRect:(UIInterfaceOrientation)orientation {
    CGRect currentScreenRect;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if((BOOL)UIDeviceOrientationIsPortrait(orientation)){
        currentScreenRect.size.width = screenRect.size.width;
        currentScreenRect.size.height = screenRect.size.height;
    } else {
        currentScreenRect.size.width = screenRect.size.height;
        currentScreenRect.size.height = screenRect.size.width;
    }
    
    return currentScreenRect;
}

+ (NSMutableDictionary *)paramsOfURL:(NSURL *)URL {
    NSString * query = [URL query];
    NSArray * pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    for (NSString * pair in pairs) {
        NSArray * bits = [pair componentsSeparatedByString:@"="];
        NSString * key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString * value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        [params setObject:value forKey:key];
    }
    return params;
}

+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original {
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 0);
    CGRect rect = CGRectMake(0, 0, original.size.width, original.size.height);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    [original drawInRect:rect];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundedImage;
}

@end