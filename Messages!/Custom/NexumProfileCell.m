//
//  NexumProfileCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumProfileCell.h"

@implementation NexumProfileCell {
    BOOL _follower;
    BOOL _following;
    BOOL _own;
    BOOL _verified;
    BOOL _featured;
    BOOL _protected;
    BOOL _staff;
    
    BOOL _loadImages;
}

- (void)reuseCellWithProfile:(NSDictionary *)profile andRow:(int)row {
    _follower = [profile[@"follower"] boolValue];
    _following = [profile[@"following"] boolValue];
    _own = [profile[@"own"] boolValue];
    _verified = [profile[@"verified"] boolValue];
    _featured = [profile[@"featured"] boolValue];
    _protected = [profile[@"protected"] boolValue];
    _staff = [profile[@"staff"] boolValue];
    
    self.fullname.text = profile[@"fullname"];
    self.username.text = [NSString stringWithFormat:@"@%@", profile[@"username"]];
    
    self.button.tag = row;
    if(_own){
        [self.button setBackgroundImage:nil forState:UIControlStateNormal];
        [self.button setBackgroundImage:nil forState:UIControlStateHighlighted];
    } else if((_follower && _following) || _follower){
        [self.button setBackgroundImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"chat_tap"] forState:UIControlStateHighlighted];
    } else {
        [self.button setBackgroundImage:[UIImage imageNamed:@"invite"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"invite_tap"] forState:UIControlStateHighlighted];
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
    
    NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
    
    profilePicture.identifier = profile[@"identifier"];
    profilePicture.pictureURL = profile[@"picture"];
    
    BOOL exists = [[FICImageCache sharedImageCache] imageExistsForEntity:profilePicture withFormatName:@"picture"];
    if(exists){
        _loadImages = NO;
        if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
                    self.picture.image = image;
                }
            }];
        }
    } else {
        _loadImages = YES;
        self.picture.image = [UIImage imageNamed:@"placeholder"];
    }
}

- (void)loadImagesWithProfile: (NSDictionary *) profile{
    if(_loadImages){
        if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
            NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
            
            profilePicture.identifier = profile[@"identifier"];
            profilePicture.pictureURL = profile[@"picture"];
            
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
                    self.picture.image = image;
                }
            }];
        }
    }
}

@end
