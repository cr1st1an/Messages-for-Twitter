//
//  NexumFeaturedCell.m
//  Messages!
//
//  Created by Cristian Castillo on 12/1/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumFeaturedCell.h"

@implementation NexumFeaturedCell {
    BOOL _loadImages;
}


- (void)reuseCellWithProfile:(NSDictionary *)profile andRow:(int)row {
    BOOL following = [profile[@"following"] boolValue];
    BOOL own = [profile[@"own"] boolValue];
    
    self.button.tag = row;
    if(own){
        [self.button setBackgroundImage:nil forState:UIControlStateNormal];
        [self.button setBackgroundImage:nil forState:UIControlStateHighlighted];
    } else if(following){
        [self.button setBackgroundImage:[UIImage imageNamed:@"following"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"following"] forState:UIControlStateHighlighted];
    } else {
        [self.button setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"follow_tap"] forState:UIControlStateHighlighted];
    }
    
    self.fullname.text = profile[@"fullname"];
    self.username.text = [NSString stringWithFormat:@"@%@", profile[@"username"]];
    self.button.tag = row;
    
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
    
    BOOL verified = [profile[@"verified"] boolValue];
    BOOL featured = [profile[@"featured"] boolValue];
    BOOL staff = [profile[@"staff"] boolValue];
    BOOL protected = [profile[@"protected"] boolValue];
    if(staff) {
        self.badge.image = [UIImage imageNamed:@"badge_staff"];
    } else if(featured){
        self.badge.image = [UIImage imageNamed:@"badge_featured"];
    } else if(verified) {
        self.badge.image = [UIImage imageNamed:@"badge_verified"];
    } else if(protected) {
        self.badge.image = [UIImage imageNamed:@"badge_protected"];
    } else {
        self.badge.image = nil;
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
