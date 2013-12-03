//
//  NexumFeaturedViewController.m
//  Messages!
//
//  Created by Cristian Castillo on 12/1/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumFeaturedViewController.h"

@interface NexumFeaturedViewController ()

@end

@implementation NexumFeaturedViewController {
    SystemSoundID soundEffect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.buyButton setBackgroundImage:[[UIImage imageNamed:@"back_buy"] stretchableImageWithLeftCapWidth:80 topCapHeight:45] forState:UIControlStateNormal];
    [self.buyButton setBackgroundImage:[[UIImage imageNamed:@"back_buy_tap"] stretchableImageWithLeftCapWidth:80 topCapHeight:45] forState:UIControlStateHighlighted];
    [self clearTable];
    [self loadData];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Flurry logPageView];
    
    [self reloadProfile];
    [self loadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self reloadProfile];
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
    static NSString *CellIdentifier = @"FeaturedCell";
    NexumFeaturedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *profile = [self.profiles objectAtIndex:indexPath.row];
    cell.identifier = profile[@"identifier"];
    [cell reuseCellWithProfile:profile andRow:indexPath.row];
    [cell performSelector:@selector(loadImagesWithProfile:) withObject:profile afterDelay:0.01];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NexumProfileViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
    nextViewController.profile =[self.profiles objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (IBAction)buyAction {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"featured" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &soundEffect);
    
    [NexumBackend postPurchases:@"" withAsyncBlock:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self clearTable];
            [self loadData];
            AudioServicesPlaySystemSound(soundEffect);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });
    }];
}

- (void)clearTable {
    self.profiles = [NSMutableArray array];
    self.isLoading = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
}

- (void)loadData {
    if(!self.isLoading){
        self.isLoading = YES;
        self.activityRow.alpha = 1;
        [NexumBackend getPurchasesRecentWithAsyncBlock:^(NSDictionary *data) {
            self.profiles = data[@"profiles_data"];
            self.featuredProfile = [self.profiles objectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^ {
                self.activityRow.alpha = 0;
                [self reloadProfile];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                self.isLoading = NO;
            });
        }];
    }
}

- (void)reloadProfile {
    if(![self.featuredIdentifier isEqualToString:(NSString *)self.featuredProfile[@"identifier"]]){
        BOOL verified = [self.featuredProfile[@"verified"] boolValue];
        BOOL featured = [self.featuredProfile[@"featured"] boolValue];
        BOOL staff = [self.featuredProfile[@"staff"] boolValue];
        BOOL protected = [self.featuredProfile[@"protected"] boolValue];
        
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
        
        self.featuredIdentifier = (NSString *)self.featuredProfile[@"identifier"];
        
        self.username.text = [NSString stringWithFormat:@"@%@", self.featuredProfile[@"username"]];
        self.description.text = self.featuredProfile[@"description"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
            NSData *backData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.featuredProfile[@"back"]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                UIImage *backImage = [UIImage imageWithData:backData];
                [UIView animateWithDuration:0.25 animations:^{
                    self.back.alpha = 0;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.back.image = backImage;
                        self.back.alpha = 1;
                    }];
                }];
            });
        });
        
        
        NexumProfilePicture *profilePicture = [[NexumProfilePicture alloc] init];
        profilePicture.identifier = self.featuredProfile[@"identifier"];
        profilePicture.pictureURL = self.featuredProfile[@"picture"];
        [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            [UIView animateWithDuration:1.0 animations:^(void) {
                self.picture.image = image;
            }];
        }];
    }
    
    [self.description sizeToFit];
    self.infoPlaceholder.frame = CGRectMake(self.infoPlaceholder.frame.origin.x, self.infoPlaceholder.frame.origin.y, self.infoPlaceholder.frame.size.width, (self.description.frame.size.height + 64));
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.infoPlaceholder.center = self.mainPlaceholder.center;
    }];
}

@end
