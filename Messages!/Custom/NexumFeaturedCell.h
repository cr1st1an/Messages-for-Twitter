//
//  NexumFeaturedCell.h
//  Messages!
//
//  Created by Cristian Castillo on 12/1/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumFeaturedCell : UITableViewCell

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UIImageView *badge;
@property (strong, nonatomic) IBOutlet UILabel *fullname;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIButton *button;

- (void)reuseCellWithProfile:(NSDictionary *)profile andRow:(int)row;
- (void)loadImagesWithProfile:(NSDictionary *)profile;

@end
