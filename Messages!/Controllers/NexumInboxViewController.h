//
//  NexumInboxViewController.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NexumThreadCell.h"
#import "NexumThreadViewController.h"
#import "NexumSearchViewController.h"

@interface NexumInboxViewController : UITableViewController

@property (strong, nonatomic) NSArray *threads;

@property (assign, nonatomic) BOOL isLoading;

@property (weak, nonatomic) IBOutlet UIView *activityRow;

- (void)loadData;
- (void)dataDidLoad;
- (void)clearTable;

- (IBAction)searchAction:(UIBarButtonItem *)sender;

- (void)pushNotification:(NSNotification *)notification;

@end
