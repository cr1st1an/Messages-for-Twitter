//
//  NexumThreadCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumThreadCell.h"

@implementation NexumThreadCell {
    BOOL _opened;
    BOOL _verified;
    BOOL _featured;
    BOOL _protected;
    BOOL _staff;
    
    BOOL _loadImages;
}

- (void)reuseCellWithThread:(NSDictionary *)thread {
    _opened = [thread[@"opened"] boolValue];
    _verified = [thread[@"profile_data"][@"verified"] boolValue];
    _featured = [thread[@"profile_data"][@"featured"] boolValue];
    _protected = [thread[@"profile_data"][@"protected"] boolValue];
    _staff = [thread[@"profile_data"][@"staff"] boolValue];
    
    if(_opened){
        self.indicator.backgroundColor = [UIColor C_ededea];
    } else {
        self.indicator.backgroundColor = [UIColor C_4fdd86];
    }
    
    if(_staff) {
        self.badge.image = [UIImage imageNamed:@"badge_staff"];
    } else if(_featured){
        self.badge.image = [UIImage imageNamed:@"badge_featured"];
    } else if(_verified) {
        self.badge.image = [UIImage imageNamed:@"badge_verified"];
    } else if(_protected) {
        self.badge.image = [UIImage imageNamed:@"badge_protected"];
    } else {
        self.badge.image = nil;
    }
    
    self.title.text = thread[@"title"];
    self.preview.text = [NSString stringWithFormat:@"%@\n\n", thread[@"preview"]];
    self.timeago.text = thread[@"timeago"];
    
    NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
    profilePicture.identifier = thread[@"identifier"];
    profilePicture.pictureURL = thread[@"picture"];
    
    BOOL exists = [[FICImageCache sharedImageCache] imageExistsForEntity:profilePicture withFormatName:@"picture"];
    if(exists){
        _loadImages = NO;
        if([self.identifier isEqualToString:(NSString *)thread[@"identifier"]]){
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)thread[@"identifier"]]){
                    self.picture.image = image;
                }
            }];
        }
    } else {
        _loadImages = YES;
        self.picture.image = [UIImage imageNamed:@"placeholder"];
    }
}

- (void)loadImagesWithThread:(NSDictionary *)thread {
    if(_loadImages){
        if([self.identifier isEqualToString:(NSString *)thread[@"identifier"]]){
            NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
            
            profilePicture.identifier = thread[@"identifier"];
            profilePicture.pictureURL = thread[@"picture"];
            
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)thread[@"identifier"]]){
                    self.picture.image = image;
                }
            }];
        }
    }
}

@end
