//
//  NexumThreadCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumThreadCell.h"

@implementation NexumThreadCell

- (void)reuseCellWithThread:(NSDictionary *)thread {
    
    
    BOOL opened = [thread[@"opened"] boolValue];
    
    if(opened){
        self.indicator.backgroundColor = [UIColor C_ededea];
    } else {
        self.indicator.backgroundColor = [UIColor C_4fdd86];
    }
    
    self.title.text = thread[@"title"];
    self.preview.text = [NSString stringWithFormat:@"%@\n\n", thread[@"preview"]];
    self.timeago.text = thread[@"timeago"];
    
    NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
    
    profilePicture.identifier = thread[@"identifier"];
    profilePicture.pictureURL = thread[@"picture"];
    
    BOOL exists = [[FICImageCache sharedImageCache] imageExistsForEntity:profilePicture withFormatName:@"picture"];
    if(exists){
        self.loadImages = NO;
        if([self.identifier isEqualToString:(NSString *)thread[@"identifier"]]){
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)thread[@"identifier"]]){
                    self.picture.image = image;
                }
            }];
        }
    } else {
        self.loadImages = YES;
        self.picture.image = [UIImage imageNamed:@"placeholder"];
    }
    [self setNeedsLayout];
}

- (void)loadImagesWithThread:(NSDictionary *)thread {
    if(self.loadImages){
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
    [self setNeedsLayout];
}

@end
