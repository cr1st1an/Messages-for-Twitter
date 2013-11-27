//
//  NexumThreadTable.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/19/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumThreadTable.h"

@implementation NexumThreadTable

- (void)updateFrame:(UIInterfaceOrientation)orientation withOrigin:(int)y andAnimation:(BOOL)animation{
    
    CGRect CSRect = [NexumUtil currentScreenRect:orientation];
    
    CGRect viewFrame = self.frame;
    
    if(0 == y || CSRect.size.width == y || CSRect.size.height == y){
        viewFrame.size.height = CSRect.size.height;
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
