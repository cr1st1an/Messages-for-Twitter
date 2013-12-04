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

- (void)reuseCell:(UIInterfaceOrientation)orientation withMessage:(NSDictionary *)message andProfile:(NSDictionary *)profile;
- (void)loadImageswithMessageAndProfile:(NSArray *)objectData;

@end