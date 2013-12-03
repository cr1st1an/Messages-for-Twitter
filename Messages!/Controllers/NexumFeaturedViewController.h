//
//  NexumFeaturedViewController.h
//  Messages!
//
//  Created by Cristian Castillo on 12/1/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NexumFeaturedCell.h"
#import "NexumProfileViewController.h"

@interface NexumFeaturedViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *featuredProfile;
@property (strong, nonatomic) NSString *featuredIdentifier;
@property (strong, nonatomic) NSArray *profiles;

@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UIView *mainPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *infoPlaceholder;
@property (strong, nonatomic) IBOutlet UIImageView *badge;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *description;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIView *activityRow;

@property (assign, nonatomic) BOOL isLoading;

- (IBAction)buyAction;

- (void)clearTable;
- (void)loadData;
- (void)reloadProfile;

@end
