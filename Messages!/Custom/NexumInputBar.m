//
//  NexumInputBar.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/17/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumInputBar.h"

@implementation NexumInputBar {
    UIImageView *_backgroundImage;
    UITextView *_inputField;
    UILabel *_countLabel;
    
    float _animationDuration;
    int _currentWidth;
}

- (void)initFrame:(UIInterfaceOrientation)orientation {
    if (self) {
        CGRect CSRect = [NexumUtil currentScreenRect:orientation];
        
        self.backgroundColor = [UIColor C_eaeced];
        
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CSRect.size.width, 40)];
        _backgroundImage.image = [[UIImage imageNamed:@"back_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [self addSubview:_backgroundImage];
        
        _inputField = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, (CSRect.size.width - 75), 35)];
        _inputField.backgroundColor = [UIColor clearColor];
        [_inputField setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_inputField];
        
        self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake((CSRect.size.width - 65), 0, 65, 40)];
        self.sendButton.enabled = NO;
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor C_1ab4ef] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor C_ccd6dd] forState:UIControlStateDisabled];
        [self addSubview:self.sendButton];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake((CSRect.size.width - 65), 5, 65, 20)];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_countLabel];
        
        _inputField.delegate = self;
    }
}

- (void)updateFrame:(UIInterfaceOrientation)orientation withOrigin:(int)y andAnimation:(BOOL)animation {
    CGRect CSRect = [NexumUtil currentScreenRect:orientation];
    
    CGRect viewFrame = self.frame;
    CGRect backgroundFrame = _backgroundImage.frame;
    CGRect inputFrame = _inputField.frame;
    CGRect countFrame = _countLabel.frame;
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
        [UIView setAnimationDuration:_animationDuration];
        [UIView setAnimationCurve:7];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    
    self.frame = viewFrame;
    _backgroundImage.frame = backgroundFrame;
    _inputField.frame = inputFrame;
    _countLabel.frame = countFrame;
    self.sendButton.frame = sendFrame;
    
    
    if(animation){
        [UIView commitAnimations];
    }
    
    _currentWidth = CSRect.size.width;
    [self updateTextViewHeight:_inputField WithAnimation:animation];
}

#pragma mark - TextField actions

- (NSString*)textValue {
    return _inputField.text;
}

- (void)textClear {
    _inputField.text = @"";
    [self updateTextViewHeight:_inputField WithAnimation:YES];
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
        _countLabel.textColor = [UIColor redColor];
    } else{
        _countLabel.textColor = [UIColor C_666666];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%d", (140 - textLength)];
    
    CGSize size = [_inputField sizeThatFits:CGSizeMake((_currentWidth - 75), FLT_MAX)];
    int numberOfLines = (size.height - 16)/_inputField.font.lineHeight;
        
    if(8 < numberOfLines) {
        numberOfLines = 8;
    }
    
    if(2 < numberOfLines){
        _countLabel.alpha = 1;
    } else {
        _countLabel.alpha = 0;
    }
    
    int newContentHeight;
    if(1 < numberOfLines){
        newContentHeight = (numberOfLines * _inputField.font.lineHeight) + 13;
    } else{
        newContentHeight = 30;
    }
    
    CGRect inputFrame = _inputField.frame;
    
    if(inputFrame.size.height != newContentHeight){
        CGRect barFrame = self.frame;
        CGRect backgroundFrame = _backgroundImage.frame;
        CGRect sendFrame = self.sendButton.frame;
        
        barFrame.origin.y = barFrame.origin.y - ((newContentHeight + 10) - barFrame.size.height);
        barFrame.size.height = newContentHeight + 10;
        
        backgroundFrame.size.height = newContentHeight + 10;
        
        inputFrame.size.height = newContentHeight;
        
        sendFrame.origin.y = barFrame.size.height - self.sendButton.frame.size.height;
        
        if(animation){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:_animationDuration];
            [UIView setAnimationCurve:7];
            [UIView setAnimationBeginsFromCurrentState:YES];
        }
        
        self.frame = barFrame;
        _backgroundImage.frame = backgroundFrame;
        _inputField.frame = inputFrame;
        self.sendButton.frame = sendFrame;
        
        if(animation){
            [UIView commitAnimations];
        }
    }
}

@end