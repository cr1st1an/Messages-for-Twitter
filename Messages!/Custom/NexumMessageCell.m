//
//  NexumMessageCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/19/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumMessageCell.h"

@implementation NexumMessageCell

- (void)reuseCell:(BOOL)isPortrait withMessage:(NSDictionary *)message andProfile:(NSDictionary *)profile {
    self.loadImages = YES;
    BOOL sent = [message[@"sent"] boolValue];
    
    self.backgroundColor = [UIColor clearColor];
    
    int screenWidth;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if(isPortrait){
        screenWidth = screenRect.size.width;
    } else {
        screenWidth = screenRect.size.height;
    }
    
    if(nil == self.point){
        self.point = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 16)];
        [self addSubview:self.point];
    }
    
    if(nil == self.bubble){
        self.bubble = [[UIView alloc] init];
        self.bubble.layer.cornerRadius = 15;
        [self addSubview:self.bubble];
    }
    
    if(nil == self.message){
        self.message = [[UITextView alloc] init];
        self.message.backgroundColor = [UIColor clearColor];
        self.message.editable = NO;
        self.message.scrollEnabled = NO;
        self.message.font = [UIFont systemFontOfSize:16];
        self.message.clipsToBounds = NO;
        self.message.dataDetectorTypes = UIDataDetectorTypeLink;
        [self.bubble addSubview:self.message];
    }
    
    if(nil == self.picture){
        self.picture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:self.picture];
    }
    
    self.message.text = message[@"text"];
    
    
    CGRect messageFrame = self.message.frame;
    CGSize messageSize = [self.message sizeThatFits:CGSizeMake((screenWidth - 140), FLT_MAX)];
    if(messageSize.width < (screenWidth - 140))
        messageFrame.size.width = messageSize.width;
    else
        messageFrame.size.width = (screenWidth - 140);
    messageFrame.size.height = messageSize.height;
    messageFrame.origin.x = 10;
    
    
    CGRect bubbleFrame = self.bubble.frame;
    bubbleFrame.origin.y = 5;
    bubbleFrame.size.height = messageFrame.size.height;
    bubbleFrame.size.width = messageFrame.size.width + 20;
    
    CGRect pointFrame = self.point.frame;
    pointFrame.origin.y = bubbleFrame.size.height - (pointFrame.size.height - 5);
    
    CGRect pictureFrame = self.picture.frame;
    pictureFrame.origin.y = bubbleFrame.size.height - (pictureFrame.size.height - 5);
    
    if(sent) {
        self.bubble.backgroundColor = [UIColor C_0aa4dd];
        self.message.textColor = [UIColor whiteColor];
        self.message.tintColor = [UIColor whiteColor];
        self.point.image = [UIImage imageNamed:@"point_right"];
        pointFrame.origin.x = (screenWidth - 56);
        bubbleFrame.origin.x = ((screenWidth - 50) - bubbleFrame.size.width);
        pictureFrame.origin.x = (screenWidth - 45);
    } else {
        self.bubble.backgroundColor = [UIColor C_d0f2ff];
        self.message.textColor = [UIColor C_032636];
        self.message.tintColor = [UIColor C_032636];
        self.point.image = [UIImage imageNamed:@"point_left"];
        pointFrame.origin.x = (56 - pointFrame.size.width);
        bubbleFrame.origin.x = 50;
        pictureFrame.origin.x = 5;
    }
    
    self.bubble.frame = bubbleFrame;
    self.message.frame = messageFrame;
    self.point.frame = pointFrame;
    self.picture.frame = pictureFrame;
    
    self.picture.alpha = 0;
    if(nil != profile){
        self.point.alpha = 1;
        
        NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
        
        profilePicture.identifier = profile[@"identifier"];
        profilePicture.pictureURL = profile[@"picture"];
        
        BOOL exists = [[FICImageCache sharedImageCache] imageExistsForEntity:profilePicture withFormatName:@"picture"];
        if(exists){
            self.loadImages = NO;
            if([self.identifier isEqualToString:(NSString *)message[@"identifier"]]){
                [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                    if([self.identifier isEqualToString:(NSString *)message[@"identifier"]]){
                        self.picture.image = image;
                        self.picture.alpha = 1;
                    }
                }];
            }
        } else {
            self.picture.image = [UIImage imageNamed:@"placeholder"];
        }
    } else {
        self.loadImages = NO;
        self.point.alpha = 0;
    }
}

- (void)loadImageswithMessageAndProfile:(NSArray *)objectData {
    if(self.loadImages){
        NSDictionary *message  = [objectData objectAtIndex:0];
        NSDictionary *profile = [objectData objectAtIndex:1];
        
        if([self.identifier isEqualToString:(NSString *)message[@"identifier"]]){
            NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
            
            profilePicture.identifier = profile[@"identifier"];
            profilePicture.pictureURL = profile[@"picture"];
            
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)message[@"identifier"]]){
                    self.picture.image = image;
                }
            }];
        }
    }
}

@end
