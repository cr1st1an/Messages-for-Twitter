//
//  NexumThreadViewController.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/16/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NexumInputBar.h"
#import "NexumThreadTable.h"
#import "NexumMessageCell.h"
#import "NexumProfileViewController.h"

@interface NexumThreadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *thread;

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *profile;
@property (strong, nonatomic) NSDictionary *account;

@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isScrolling;
@property (assign, nonatomic) BOOL isFirstLoad;
@property (assign, nonatomic) BOOL animatingRotation;
@property (assign, nonatomic) CGRect keyboardFrame;
@property (strong, nonatomic) UITextView *sampleText;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet NexumInputBar *inputBar;
@property (weak, nonatomic) IBOutlet NexumThreadTable *tableView;

- (IBAction)profileAction:(UIBarButtonItem *)sender;

- (void)loadData;
- (void)scrollToBottom;

- (void)pushNotification:(NSNotification *)notification;

@end