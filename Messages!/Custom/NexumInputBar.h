//
//  NexumInputBar.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/17/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumInputBar : UIView <UITextViewDelegate>

@property (strong, nonatomic) UIImageView *backgroundImage;
@property (strong, nonatomic) UITextView *inputField;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UILabel *countLabel;

@property (assign, nonatomic) BOOL isPortrait;
@property (assign, nonatomic) float animationDuration;
@property (assign, nonatomic) int currentWidth;

- (void)initFrame:(BOOL)isPortrait;
- (void)updateFrame:(BOOL)isPortrait withOrigin:(int)y andAnimation:(BOOL)animation;
- (void)updateTextViewHeight:(UITextView *)textView WithAnimation:(BOOL)animation;
- (NSString*)textValue;
- (void)textClear;

@end
