//
//  NexumInputBar.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/17/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumInputBar.h"

@implementation NexumInputBar

- (void)initFrame:(UIInterfaceOrientation)orientation {
    if (self) {
        CGRect CSRect = [NexumUtil currentScreenRect:orientation];
        
        self.backgroundColor = [UIColor C_eaeced];
        
        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CSRect.size.width, 40)];
        self.backgroundImage.image = [[UIImage imageNamed:@"back_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [self addSubview:self.backgroundImage];
        
        self.inputField = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, (CSRect.size.width - 75), 35)];
        self.inputField.backgroundColor = [UIColor clearColor];
        [self.inputField setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:self.inputField];
        
        self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake((CSRect.size.width - 65), 0, 65, 40)];
        self.sendButton.enabled = NO;
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor C_1ab4ef] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor C_ccd6dd] forState:UIControlStateDisabled];
        [self addSubview:self.sendButton];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake((CSRect.size.width - 65), 5, 65, 20)];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.countLabel];
        
        self.inputField.delegate = self;
    }
}

- (void)updateFrame:(UIInterfaceOrientation)orientation withOrigin:(int)y andAnimation:(BOOL)animation {
    CGRect CSRect = [NexumUtil currentScreenRect:orientation];
    
    CGRect viewFrame = self.frame;
    CGRect backgroundFrame = self.backgroundImage.frame;
    CGRect inputFrame = self.inputField.frame;
    CGRect countFrame = self.countLabel.frame;
    CGRect sendFrame = self.sendButton.frame;
   
    
    if(0 == y || CSRect.size.width == y || CSRect.size.height == y){
        viewFrame.origin.y = (CSRect.size.height - viewFrame.size.height);
    } else {
        viewFrame.origin.y = (y - viewFrame.size.height);
    }
    
    viewFrame.size.width = CSRect.size.width;
    backgroundFrame.size.width = CSRect.size.width;
    inputFrame.size.width = (CSRect.size.width - 75);
    countFrame.origin.x = (CSRect.size.width - 65);
    sendFrame.origin.x = (CSRect.size.width - 65);
    
    
    if(animation){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationCurve:7];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    
    self.frame = viewFrame;
    self.backgroundImage.frame = backgroundFrame;
    self.inputField.frame = inputFrame;
    self.countLabel.frame = countFrame;
    self.sendButton.frame = sendFrame;
    
    
    if(animation){
        [UIView commitAnimations];
    }
    
    self.currentWidth = CSRect.size.width;
    [self updateTextViewHeight:self.inputField WithAnimation:animation];
}

#pragma mark - TextField actions

- (NSString*)textValue {
    return self.inputField.text;
}

- (void)textClear {
    self.inputField.text = @"";
    [self updateTextViewHeight:self.inputField WithAnimation:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateTextViewHeight:textView WithAnimation:YES];
}

- (void)updateTextViewHeight:(UITextView *)textView WithAnimation:(BOOL)animation {
    int textLength = [textView.text length];
    
    if(0 < textLength && 140 > textLength){
        self.sendButton.enabled = YES;
    } else {
        self.sendButton.enabled = NO;
    }
    
    if(140 < textLength){
        self.countLabel.textColor = [UIColor redColor];
    } else{
        self.countLabel.textColor = [UIColor C_666666];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%d", (140 - textLength)];
    
    CGSize size = [self.inputField sizeThatFits:CGSizeMake((self.currentWidth - 75), FLT_MAX)];
    int numberOfLines = (size.height - 16)/self.inputField.font.lineHeight;
        
    if(8 < numberOfLines) {
        numberOfLines = 8;
    }
    
    if(2 < numberOfLines){
        self.countLabel.alpha = 1;
    } else {
        self.countLabel.alpha = 0;
    }
    
    int newContentHeight;
    if(1 < numberOfLines){
        newContentHeight = (numberOfLines * self.inputField.font.lineHeight) + 13;
    } else{
        newContentHeight = 30;
    }
    
    CGRect inputFrame = self.inputField.frame;
    
    if(inputFrame.size.height != newContentHeight){
        CGRect barFrame = self.frame;
        CGRect backgroundFrame = self.backgroundImage.frame;
        CGRect sendFrame = self.sendButton.frame;
        
        barFrame.origin.y = barFrame.origin.y - ((newContentHeight + 10) - barFrame.size.height);
        barFrame.size.height = newContentHeight + 10;
        
        backgroundFrame.size.height = newContentHeight + 10;
        
        inputFrame.size.height = newContentHeight;
        
        sendFrame.origin.y = barFrame.size.height - self.sendButton.frame.size.height;
        
        if(animation){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:self.animationDuration];
            [UIView setAnimationCurve:7];
            [UIView setAnimationBeginsFromCurrentState:YES];
        }
        
        self.frame = barFrame;
        self.backgroundImage.frame = backgroundFrame;
        self.inputField.frame = inputFrame;
        self.sendButton.frame = sendFrame;
        
        if(animation){
            [UIView commitAnimations];
        }
    }
}

@end