//
//  NexumThreadTable.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/19/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumThreadTable : UITableView

@property (assign, nonatomic) float animationDuration;

- (void)updateFrame:(BOOL)isPortrait withOrigin:(int)y andAnimation:(BOOL)animation;

@end
