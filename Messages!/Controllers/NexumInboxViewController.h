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

@interface NexumInboxViewController : UITableViewController

@property (strong, nonatomic) NSArray *threads;
@property (strong, nonatomic) NSDictionary *nextThread;

@property (assign, nonatomic) BOOL isLoading;

- (void)loadData;
- (void)clearTable;

- (void)pushNotification:(NSNotification *)notification;

@end
