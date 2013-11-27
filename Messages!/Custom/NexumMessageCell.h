//
//  NexumMessageCell.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/19/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumMessageCell : UITableViewCell

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) UIView *bubble;
@property (strong, nonatomic) UITextView *message;
@property (strong, nonatomic) UIImageView *point;
@property (strong, nonatomic) UIImageView *picture;

@property (assign, nonatomic) BOOL loadImages;

- (void)reuseCell:(UIInterfaceOrientation)orientation withMessage:(NSDictionary *)message andProfile:(NSDictionary *)profile;
- (void)loadImageswithMessageAndProfile:(NSArray *)objectData;

@end