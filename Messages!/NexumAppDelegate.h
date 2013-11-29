//
//  NDIAppDelegate.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/11/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FICImageCache.h"
#import "Flurry.h"

@interface NexumAppDelegate : UIResponder <UIApplicationDelegate, FICImageCacheDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
