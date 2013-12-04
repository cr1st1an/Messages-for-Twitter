//
//  NexumProfileViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/14/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumProfileViewController.h"

@interface NexumProfileViewController ()

@end

@implementation NexumProfileViewController {
    NSMutableArray *_profiles;
    NSDictionary *_nextProfile;
    
    BOOL _isLoading;
    NSString *_dataSource;
    NSString *_page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isChildOfThread){
        UIEdgeInsets inset = [self.tableView contentInset];
        inset.bottom = 49;
        self.tableView.contentInset = inset;
    } else {
        self.isChildOfThread = NO;
    }
    
    NSDictionary *currentAccount = [NexumDefaults currentAccount];
    
    if(nil == self.profile)
        self.profile = currentAccount;
    else
        self.title = self.profile[@"fullname"];
    
    self.username.text = [NSString stringWithFormat:@"@%@", self.profile[@"username"]];
    
    self.description.text = self.profile[@"description"];
    BOOL follower = [self.profile[@"follower"] boolValue];
    BOOL following = [self.profile[@"following"] boolValue];
    BOOL own = [self.profile[@"own"] boolValue];
    if(own){
        self.actionButton.backgroundColor = [UIColor C_f8bf32];
        self.actionButton.tintColor = [UIColor whiteColor];
        [self.actionButton setTitle:@"promote your profile" forState:UIControlStateNormal];
    } else if((follower && following) || follower){
        self.actionButton.backgroundColor = [UIColor C_4fdd86];
        self.actionButton.tintColor = [UIColor whiteColor];
        [self.actionButton setTitle:@"chat" forState:UIControlStateNormal];
    } else {
        self.actionButton.layer.borderColor = [UIColor C_4fdd86].CGColor;
        self.actionButton.layer.borderWidth = 1.0;
        self.actionButton.backgroundColor = [UIColor whiteColor];
        self.actionButton.tintColor = [UIColor C_4fdd86];
        [self.actionButton setTitle:@"invite to chat" forState:UIControlStateNormal];
    }
    
    BOOL verified = [self.profile[@"verified"] boolValue];
    BOOL featured = [self.profile[@"featured"] boolValue];
    BOOL staff = [self.profile[@"staff"] boolValue];
    BOOL protected = [self.profile[@"protected"] boolValue];
    
    if(staff) {
        self.badge.image = [UIImage imageNamed:@"badge_staff"];
    } else if(featured){
        self.badge.image = [UIImage imageNamed:@"badge_featured"];
    } else if(verified) {
        self.badge.image = [UIImage imageNamed:@"badge_verified"];
    } else if(protected) {
        self.badge.image = [UIImage imageNamed:@"badge_protected"];
    } else {
        self.badge.image = nil;
    }
    
    [self clearTable];
    _dataSource = @"following";
    self.followingButton.tintColor = [UIColor whiteColor];
    
    [self loadData];
    [self loadProfileImage];
    [self loadBackImage];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Flurry logPageView];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.description sizeToFit];
    
    self.infoPlaceholder.frame = CGRectMake(self.infoPlaceholder.frame.origin.x, self.infoPlaceholder.frame.origin.y, self.infoPlaceholder.frame.size.width, (self.description.frame.size.height + 64));
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.infoPlaceholder.center = self.mainPlaceholder.center;
    }];
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_profiles count] > indexPath.row) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NexumProfileViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
        nextViewController.profile =[_profiles objectAtIndex:indexPath.row];
        nextViewController.isChildOfThread = self.isChildOfThread;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_profiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProfileCell";
    NexumProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if([_profiles count] > indexPath.row){
        NSDictionary *profile = [_profiles objectAtIndex:indexPath.row];
        cell.identifier = profile[@"identifier"];
        [cell reuseCellWithProfile:profile andRow:indexPath.row];
        [cell performSelector:@selector(loadImagesWithProfile:) withObject:profile afterDelay:0.01];
    }
    
    if([_profiles count] < (indexPath.row + 20)){
        if([NSNull null] != (NSNull *)_page){
            [self loadData];
        }
    }
    
    return cell;
}

#pragma mark - Keyboard notifications

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.description sizeToFit];
    
    self.infoPlaceholder.frame = CGRectMake(self.infoPlaceholder.frame.origin.x, self.infoPlaceholder.frame.origin.y, self.infoPlaceholder.frame.size.width, (self.description.frame.size.height + 74));
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.infoPlaceholder.center = self.mainPlaceholder.center;
    }];
}

#pragma mark - Load data

- (void)loadData {
    if(!_isLoading){
        _isLoading = YES;
        self.activityRow.alpha = 1;
        NSString *params = [NSString stringWithFormat:@"identifier=%@&page=%@", self.profile[@"identifier"], _page];
        if([@"following" isEqualToString:_dataSource]){
            [NexumBackend getContactsFollowing:params withAsyncBlock:^(NSDictionary *data) {
                _page = data[@"pagination"][@"next"];
                [_profiles addObjectsFromArray:data[@"profiles_data"]];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    self.activityRow.alpha = 0;
                    [self.tableView reloadData];
                    _isLoading = NO;
                });
            }];
        } else if([@"followers" isEqualToString:_dataSource]){
            [NexumBackend getContactsFollowers:params withAsyncBlock:^(NSDictionary *data) {
                _page = data[@"pagination"][@"next"];
                [_profiles addObjectsFromArray:data[@"profiles_data"]];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    self.activityRow.alpha = 0;
                    [self.tableView reloadData];
                    _isLoading = NO;
                });
            }];
        }
    }
}

#pragma mark - Actions

- (IBAction)optionsAction:(UIBarButtonItem *)sender {
    BOOL follower = [self.profile[@"follower"] boolValue];
    BOOL following = [self.profile[@"following"] boolValue];
    BOOL own = [self.profile[@"own"] boolValue];
    
    if(own){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"cancel"
                                      destructiveButtonTitle:@"logout"
                                      otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    } else {
        NSString *relationshipAction = nil;
        NSString *title = nil;
        if(following){
            relationshipAction = @"unfollow";
        } else {
            relationshipAction = @"follow";
        }
        if(follower){
            title = [NSString stringWithFormat:@"@%@ is following you", self.profile[@"username"]];
        } else {
            title = [NSString stringWithFormat:@"@%@ is not following you", self.profile[@"username"]];
        }
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:title
                                      delegate:self
                                      cancelButtonTitle:@"cancel"
                                      destructiveButtonTitle:@"block"
                                      otherButtonTitles: relationshipAction, nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"logout"]) {
        [NexumDefaults addSession:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if  ([buttonTitle isEqualToString:@"follow"]) {
        [NexumTwitter follow:self.profile[@"identifier"]];
    } else if  ([buttonTitle isEqualToString:@"unfollow"]) {
        [NexumTwitter unfollow:self.profile[@"identifier"]];
    } else if  ([buttonTitle isEqualToString:@"block"]) {
        [NexumTwitter block:self.profile[@"identifier"]];
    }
}

- (IBAction)dinamicAction:(id)sender {
    BOOL follower = [self.profile[@"follower"] boolValue];
    BOOL following = [self.profile[@"following"] boolValue];
    BOOL own = [self.profile[@"own"] boolValue];
    
    if(own){
        [self.tabBarController setSelectedIndex:0];
    } else if((follower && following) || follower){
        NSArray *data = [NSArray arrayWithObjects:self.profile[@"identifier"], [NSString stringWithFormat:@"@%@", self.profile[@"username"]], nil];
        NSArray *keys = [NSArray arrayWithObjects:@"identifier", @"subtitle", nil];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NexumThreadViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ThreadView"];
        nextViewController.thread = [NSDictionary dictionaryWithObjects:data forKeys:keys];
        [self.navigationController pushViewController:nextViewController animated:YES];
    } else {
        [NexumTwitter postStatus:[NSString stringWithFormat:TW_INVITE, self.profile[@"username"]] onView:self];
    }
}

- (IBAction)followingAction:(id)sender {
    [self clearTable];
    _dataSource = @"following";
    self.followersButton.tintColor = [UIColor C_22a1d9];
    self.followingButton.tintColor = [UIColor whiteColor];
    [self loadData];
}

- (IBAction)followersAction:(id)sender {
    [self clearTable];
    _dataSource = @"followers";
    self.followingButton.tintColor = [UIColor C_22a1d9];
    self.followersButton.tintColor = [UIColor whiteColor];
    [self loadData];
}

- (IBAction)rowButtonAction:(id)sender {
    NSDictionary *profile = [_profiles objectAtIndex:[(NexumProfileCell *)sender tag]];
    
    BOOL follower = [profile[@"follower"] boolValue];
    BOOL following = [profile[@"following"] boolValue];
    BOOL own = [profile[@"own"] boolValue];
    
    if((follower && following) || follower){
        NSArray *data = [NSArray arrayWithObjects:profile[@"identifier"], [NSString stringWithFormat:@"@%@", profile[@"username"]], nil];
        NSArray *keys = [NSArray arrayWithObjects:@"identifier", @"subtitle", nil];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NexumThreadViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ThreadView"];
        nextViewController.thread = [NSDictionary dictionaryWithObjects:data forKeys:keys];
        [self.navigationController pushViewController:nextViewController animated:YES];
    } else if(!own) {
        [NexumTwitter postStatus:[NSString stringWithFormat:TW_INVITE, profile[@"username"]] onView:self];
    }
}

#pragma mark - Helpers

- (void)clearTable {
    _profiles = [NSMutableArray array];
    _isLoading = NO;
    _page = @"0";
    [self.tableView reloadData];
}

- (void)loadProfileImage {
    NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
    
    profilePicture.identifier = self.profile[@"identifier"];
    profilePicture.pictureURL = self.profile[@"picture"];
    
    [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        [UIView animateWithDuration:1.0 animations:^(void) {
            self.picture.image = image;
        }];
    }];
}

- (void)loadBackImage {
    if (![self.profile[@"back"] isEqualToString:@""] ){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
            NSData *backData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profile[@"back"]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                UIImage *backImage = [UIImage imageWithData:backData];
                [UIView animateWithDuration:1.0 animations:^(void) {
                    self.back.image = backImage;
                    self.back.alpha = 1;
                }];
            });
        });
    } else {
        [UIView animateWithDuration:1.0 animations:^(void) {
            self.back.alpha = 1;
        }];
    }
}

@end
