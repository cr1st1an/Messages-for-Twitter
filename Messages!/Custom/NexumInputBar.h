//
//  NexumInputBar.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/17/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumInputBar : UIView <UITextViewDelegate>


@property (strong, nonatomic) UIButton *sendButton;

- (void)initFrame:(UIInterfaceOrientation)orientation;
- (void)updateFrame:(UIInterfaceOrientation)orientation withOrigin:(int)y andAnimation:(BOOL)animation;
- (NSString*)textValue;
- (void)textClear;

@end
