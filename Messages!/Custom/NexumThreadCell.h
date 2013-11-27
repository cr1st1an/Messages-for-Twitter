//
//  NexumThreadCell.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumThreadCell : UITableViewCell

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) IBOutlet UIView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *preview;
@property (strong, nonatomic) IBOutlet UILabel *timeago;

@property (assign, nonatomic) BOOL loadImages;

- (void)reuseCellWithThread:(NSDictionary *)thread;
- (void)loadImagesWithThread:(NSDictionary *)thread;

@end
