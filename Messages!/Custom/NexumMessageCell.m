//
//  NexumMessageCell.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/19/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumMessageCell.h"

@implementation NexumMessageCell {
    UIView *_bubble;
    UITextView *_textview;
    UIImageView *_point;
    UIImageView *_picture;
    UIImageView *_badge;
    
    BOOL _loadImages;
}

- (void)reuseCell:(UIInterfaceOrientation)orientation withMessage:(NSDictionary *)message andProfile:(NSDictionary *)profile {
    if(nil == _bubble){
        _bubble = [[UIView alloc] init];
        _bubble.layer.cornerRadius = 15;
        [self addSubview:_bubble];
    }
    
    if(nil == _textview){
        _textview = [[UITextView alloc] init];
        _textview.backgroundColor = [UIColor clearColor];
        _textview.editable = NO;
        _textview.scrollEnabled = NO;
        _textview.font = [UIFont systemFontOfSize:16];
        _textview.clipsToBounds = NO;
        _textview.dataDetectorTypes = UIDataDetectorTypeLink;
        [_bubble addSubview:_textview];
    }
    
    if(nil == _point){
        _point = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 16)];
        [self addSubview:_point];
    }
    
    if(nil == _picture){
        _picture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:_picture];
    }
    
    if(nil == _badge){
        _badge = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
        [self addSubview:_badge];
    }
    
    BOOL sent = [message[@"sent"] boolValue];
    
    CGRect CSRect = [NexumUtil currentScreenRect:orientation];
    
    _textview.text = message[@"text"];
    
    CGRect contentFrame = _textview.frame;
    CGSize contentSize = [_textview sizeThatFits:CGSizeMake((CSRect.size.width - 140), FLT_MAX)];
    if(contentSize.width < (CSRect.size.width - 140))
        contentFrame.size.width = contentSize.width;
    else
        contentFrame.size.width = (CSRect.size.width - 140);
    contentFrame.size.height = contentSize.height;
    contentFrame.origin.x = 10;
    
    
    CGRect bubbleFrame = _bubble.frame;
    bubbleFrame.origin.y = 5;
    bubbleFrame.size.height = contentFrame.size.height;
    bubbleFrame.size.width = contentFrame.size.width + 20;
    
    if(sent) {
        _bubble.backgroundColor = [UIColor C_0aa4dd];
        _textview.textColor = [UIColor whiteColor];
        _textview.tintColor = [UIColor whiteColor];
        bubbleFrame.origin.x = ((CSRect.size.width - 50) - bubbleFrame.size.width);
    } else {
        _bubble.backgroundColor = [UIColor C_d0f2ff];
        _textview.textColor = [UIColor C_032636];
        _textview.tintColor = [UIColor C_032636];
        bubbleFrame.origin.x = 50;
    }
    
    _bubble.frame = bubbleFrame;
    _textview.frame = contentFrame;
    
    if(nil != profile){
        NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
        profilePicture.identifier = profile[@"identifier"];
        profilePicture.pictureURL = profile[@"picture"];
        
        BOOL exists = [[FICImageCache sharedImageCache] imageExistsForEntity:profilePicture withFormatName:@"picture"];
        if(exists){
            _loadImages = NO;
            if([self.identifier isEqualToString:(NSString *)message[@"identifier"]]){
                [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                    if([self.identifier isEqualToString:(NSString *)message[@"identifier"]]){
                        _picture.image = image;
                    }
                }];
            }
        } else {
            _loadImages = YES;
            _picture.image = [UIImage imageNamed:@"placeholder"];
        }
        
        CGRect pointFrame = _point.frame;
        pointFrame.origin.y = bubbleFrame.size.height - (pointFrame.size.height - 5);
        
        CGRect pictureFrame = _picture.frame;
        pictureFrame.origin.y = bubbleFrame.size.height - (pictureFrame.size.height - 5);
        
        CGRect badgeFrame = _badge.frame;
        badgeFrame.origin.y = bubbleFrame.size.height -  (badgeFrame.size.height - 8);
        
        if(sent) {
            _point.image = [UIImage imageNamed:@"point_right"];
            pointFrame.origin.x = (CSRect.size.width - 56);
            pictureFrame.origin.x = (CSRect.size.width - 45);
            badgeFrame.origin.x = ((CSRect.size.width - 2) - badgeFrame.size.width);
        } else {
            _point.image = [UIImage imageNamed:@"point_left"];
            pointFrame.origin.x = (56 - pointFrame.size.width);
            pictureFrame.origin.x = 5;
            badgeFrame.origin.x = 2;
        }
        
        BOOL verified = [profile[@"verified"] boolValue];
        BOOL featured = [profile[@"featured"] boolValue];
        BOOL protected = [profile[@"protected"] boolValue];
        BOOL staff = [profile[@"staff"] boolValue];
        
        if(staff) {
            _badge.image = [UIImage imageNamed:@"badge_staff"];
        } else if(featured){
            _badge.image = [UIImage imageNamed:@"badge_featured"];
        } else if(verified) {
            _badge.image = [UIImage imageNamed:@"badge_verified"];
        } else if(protected) {
            _badge.image = [UIImage imageNamed:@"badge_protected"];
        } else {
            _badge.image = nil;
        }
        
        _point.frame = pointFrame;
        _picture.frame = pictureFrame;
        _badge.frame = badgeFrame;
    } else {
        _loadImages = NO;
        _point.image = nil;
        _picture.image = nil;
        _badge.image = nil;
    }
}

- (void)loadImageswithMessageAndProfile:(NSArray *)objectData {
    if(_loadImages){
        NSDictionary *message  = [objectData objectAtIndex:0];
        NSDictionary *profile = [objectData objectAtIndex:1];
        
        if([self.identifier isEqualToString:(NSString *)message[@"identifier"]]){
            NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
            
            profilePicture.identifier = profile[@"identifier"];
            profilePicture.pictureURL = profile[@"picture"];
            
            [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                if([self.identifier isEqualToString:(NSString *)message[@"identifier"]]){
                    _picture.image = image;
                }
            }];
        }
    }
}

@end
