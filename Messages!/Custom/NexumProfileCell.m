//
//  NexumProfileCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumProfileCell.h"

@implementation NexumProfileCell

- (void)reuseCellWithProfile:(NSDictionary *)profile andRow:(int)row {
    self.loadImages = YES;
    
    BOOL follower = [profile[@"follower"] boolValue];
    BOOL following = [profile[@"following"] boolValue];
    BOOL own = [profile[@"own"] boolValue];
    
    self.fullname.text = profile[@"fullname"];
    self.username.text = [NSString stringWithFormat:@"@%@", profile[@"username"]];
    self.button.tag = row;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.button.alpha = 1;
    if(own){
        self.button.alpha = 0;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if((follower && following) || follower){
        [self.button setBackgroundImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"chat_tap"] forState:UIControlStateHighlighted];
    } else {
        [self.button setBackgroundImage:[UIImage imageNamed:@"invite"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"invite_tap"] forState:UIControlStateHighlighted];
    }
    
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
        self.picture.image = [UIImage imageNamed:@"placeholder"];
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
