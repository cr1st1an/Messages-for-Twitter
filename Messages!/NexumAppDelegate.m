//
//  NDIAppDelegate.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/11/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumAppDelegate.h"

@implementation NexumAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor C_1ab4ef];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor C_1ab4ef_T]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITableView appearance] setBackgroundColor:[UIColor C_f8f8f8]];
    [[UITableView appearance] setSeparatorColor:[UIColor C_ededea]];
    
    [[UIRefreshControl appearance] setTintColor:[UIColor C_cccccc]];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor C_f8f8f8];
    [[UITableViewCell appearance] setSelectedBackgroundView:selectionColor];
    
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor C_f8f8f8_T]];
    [[UITabBar appearance] setTintColor:[UIColor C_74d2f6]];
    
    FICImageFormat *profilePicture = [[FICImageFormat alloc] init];
    profilePicture.name = @"picture";
    profilePicture.family = @"profile";
    profilePicture.style = FICImageFormatStyle32BitBGRA;
    profilePicture.imageSize = CGSizeMake(73, 73);
    profilePicture.maximumCount = 1280;
    profilePicture.devices = FICImageFormatDevicePhone | FICImageFormatDevicePad;
    
    NSArray *imageFormats = @[profilePicture];
    
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    [sharedImageCache setFormats:imageFormats];
    [sharedImageCache setDelegate:self];
    
    //[sharedImageCache reset];
    
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:FLURRY_API_KEY];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if(nil != [NexumDefaults currentSession]){
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - Push callbacks

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    NSString *deviceToken = [[[[newDeviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSString *params = [NSString stringWithFormat:@"device_token=%@", deviceToken];
    [NexumBackend postAccountsDeviceToken:params];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];
}

#pragma mark - FICImageCacheDelegate

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *sourceImage = [(NexumProfilePicture *)entity sourceImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sourceImage);
        });
    });
}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id<FICEntity>)entity {
    return NO;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage {
    NSLog(@"%@", errorMessage);
}

@end
