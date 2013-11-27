//
//  NexumThreadTable.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/19/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumThreadTable.h"

@implementation NexumThreadTable

- (void)updateFrame:(BOOL)isPortrait withOrigin:(int)y andAnimation:(BOOL)animation{
    int screenWidth;
    int screenHeight;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if(isPortrait){
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
    } else {
        screenWidth = screenRect.size.height;
        screenHeight = screenRect.size.width;
    }
    
    CGRect viewFrame = self.frame;
    
    if(0 == y || screenWidth == y || screenHeight == y){
        viewFrame.size.height = screenHeight;
    } else {
        viewFrame.size.height = y;
    }
    
    if(animation){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationCurve:7];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    self.frame = viewFrame;
    
    if(animation){
        [UIView commitAnimations];
    }
}

@end
