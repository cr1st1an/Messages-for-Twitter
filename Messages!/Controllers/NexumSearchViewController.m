//
//  NexumSearchViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/13/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumSearchViewController.h"

@interface NexumSearchViewController ()

@end

@implementation NexumSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearTable];
    self.path = @"contacts/suggested";
    
    self.searchBar.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadDataFromPath:self.path withPage:self.page andQuery:self.query];
}

#pragma mark - SearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self clearTable];
    [self.searchBar resignFirstResponder];
    self.path = @"contacts/search";
    self.query = searchBar.text;
    
    [self loadDataFromPath:self.path withPage:self.page andQuery:searchBar.text];
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NexumProfileViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
    nextViewController.profile = [self.profiles objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(0 < [self.profiles count])
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    return [self.profiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProfileCell";
    NexumProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *profile = [self.profiles objectAtIndex:indexPath.row];
    cell.identifier = profile[@"identifier"];
    [cell reuseCellWithProfile:profile andRow:indexPath.row];
    [cell loadImagesWithProfile:profile];
    //[cell performSelector:@selector(loadImagesWithProfile:) withObject:profile afterDelay:0.1];
    
    if([self.profiles count] < (indexPath.row + 20)){
        if([NSNull null] != (NSNull *)self.page){
            [self loadDataFromPath:self.path withPage:self.page andQuery:self.query];
        }
    }
    
    return cell;
}

#pragma mark - Load data

- (void)loadDataFromPath:(NSString *)path withPage:(NSString *)page andQuery:(NSString *)query{
    if(!self.isLoading){
        self.isLoading = YES;
        self.activityRow.alpha = 1;
        
        NSString *params = [NSString stringWithFormat:@"identifier=%@&page=%@&query=%@", [NexumDefaults currentAccount][@"identifier"], page, query];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
            
            [NexumBackend apiRequest:@"GET" forPath:path withParams:params andBlock:^(BOOL success, NSDictionary *data) {
                if(success){
                    self.page = data[@"pagination"][@"next"];
                    [self.profiles addObjectsFromArray:data[@"profiles_data"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self dataDidLoad];
                        [self.tableView reloadData];
                    });
                }
                self.isLoading = NO;
            }];
            
        });
    }
}

- (void)dataDidLoad {
    self.activityRow.alpha = 0;
}

#pragma mark - Actions

- (IBAction)rowButtonAction:(UIButton *)sender {
    NSMutableDictionary *profile = [[self.profiles objectAtIndex:[(NexumProfileCell *)sender tag]] mutableCopy];
    
    BOOL follower = [profile[@"follower"] boolValue];
    BOOL following = [profile[@"following"] boolValue];
    
    if((follower && following) || follower){
        NSArray *data = [NSArray arrayWithObjects:profile[@"identifier"], [NSString stringWithFormat:@"@%@", profile[@"username"]], nil];
        NSArray *keys = [NSArray arrayWithObjects:@"identifier", @"subtitle", nil];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NexumThreadViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ThreadView"];
        nextViewController.thread = [NSDictionary dictionaryWithObjects:data forKeys:keys];
        [self.navigationController pushViewController:nextViewController animated:YES];
    } else {
        [NexumTwitter postStatus:[NSString stringWithFormat:TW_INVITE, profile[@"username"]] onView:self];
    }
}

#pragma mark - Helpers

- (void)clearTable {
    self.profiles = [NSMutableArray array];
    self.isLoading = NO;
    self.page = @"0";
    self.query = @"";
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
}
@end
