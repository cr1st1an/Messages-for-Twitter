//
//  NexumSearchViewController.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NexumProfileCell.h"
#import "NexumProfileViewController.h"

@interface NexumSearchViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *activityRow;

@property (strong, nonatomic) NSMutableArray *profiles;
@property (strong, nonatomic) NSDictionary *nextProfile;

@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) double lastCellRequest;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *page;

- (void)loadDataFromPath:(NSString *)path withPage:(NSString *)page andQuery:(NSString *)query;
- (void)dataDidLoad;
- (void)clearTable;

- (IBAction)rowButtonAction:(UIButton *)sender;

@end