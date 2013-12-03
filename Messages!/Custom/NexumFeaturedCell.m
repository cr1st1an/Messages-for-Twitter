//
//  NexumFeaturedCell.m
//  Messages!
//
//  Created by Cristian Castillo on 12/1/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumFeaturedCell.h"

@implementation NexumFeaturedCell


- (void)reuseCellWithProfile:(NSDictionary *)profile andRow:(int)row {
    //BOOL following = [profile[@"following"] boolValue];
    BOOL verified = [profile[@"verified"] boolValue];
    BOOL featured = [profile[@"featured"] boolValue];
    BOOL staff = [profile[@"staff"] boolValue];
    BOOL protected = [profile[@"protected"] boolValue];
    
    self.fullname.text = profile[@"fullname"];
    self.username.text = [NSString stringWithFormat:@"@%@", profile[@"username"]];
    self.button.tag = row;
    
    NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
    
    profilePicture.identifier = profile[@"identifier"];
    profilePicture.pictureURL = profile[@"picture"];
    
    BOOL exists = [[FICImageCache sharedImageCache] imageExistsForEntity:profilePicture withFormatName:@"picture"];
    if(exists){
        self.loadImages = NO;
        if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)profile[@"identifier"]]){
                    self.picture.image = image;
                }
            }];
        }
    } else {
        self.loadImages = YES;
        self.picture.image = [UIImage imageNamed:@"placeholder"];
    }
    
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
    if(self.loadImages){
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
