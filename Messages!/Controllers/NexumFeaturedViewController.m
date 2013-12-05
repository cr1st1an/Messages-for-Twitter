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
    SystemSoundID _soundEffect;
    SKProduct *_product;
    
    NSDictionary *_featuredProfile;
    NSString *_featuredIdentifier;
    NSArray *_profiles;
    
    BOOL _isLoading;
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
    
    if([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] isEqualToString:APPSTORE_ID]){
        SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject:[NSString stringWithFormat:@"%@.001", APPSTORE_ID]]];
        request.delegate = self;
        [request start];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Flurry logPageView];
    
    [self loadData];
    [self centerProfile];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self centerProfile];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(0 < [_profiles count])
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    return [_profiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FeaturedCell";
    NexumFeaturedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([_profiles count] > indexPath.row) {
        NSDictionary *profile = [_profiles objectAtIndex:indexPath.row];
        cell.identifier = profile[@"identifier"];
        [cell reuseCellWithProfile:profile andRow:indexPath.row];
        [cell performSelector:@selector(loadImagesWithProfile:) withObject:profile afterDelay:0.01];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([_profiles count] > indexPath.row){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NexumProfileViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
        nextViewController.profile =[_profiles objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

- (IBAction)buyAction {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"featured" ofType:@"m4r"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &_soundEffect);
    
    if([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] isEqualToString:APPSTORE_ID]){
        if(nil != _product){
            [self.buyButton setTitle:@"unlocking..." forState:UIControlStateNormal];
            SKPayment *newPayment = [SKPayment paymentWithProduct:_product];
            [[SKPaymentQueue defaultQueue] addPayment:newPayment];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not available"
                                                        message:@"This feature is only available through the App Store  "
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (IBAction)profileAction:(UIButton *)sender {
    if(nil != _featuredProfile){
        BOOL following = [_featuredProfile[@"following"] boolValue];
        BOOL own = [_featuredProfile[@"own"] boolValue];
        if(!following && !own){
            [NexumTwitter follow:_featuredProfile[@"identifier"]];
            [self loadData];
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            NexumProfileViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
            nextViewController.profile = _featuredProfile;
            [self.navigationController pushViewController:nextViewController animated:YES];

        }
    }
}

- (void)clearTable {
    _profiles = [NSArray array];
    _isLoading = NO;
    [self.tableView reloadData];
}

- (void)loadData {
    if(!_isLoading){
        _isLoading = YES;
        self.activityRow.alpha = 1;
        [NexumBackend getPurchasesRecentWithAsyncBlock:^(NSDictionary *data) {
            _profiles = data[@"profiles_data"];
            _featuredProfile = [_profiles objectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^ {
                self.activityRow.alpha = 0;
                [self reloadProfile];
                [self centerProfile];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                _isLoading = NO;
            });
        }];
    }
}

- (void)reloadProfile {
    if(nil != _featuredProfile && ![_featuredIdentifier isEqualToString:(NSString *)_featuredProfile[@"identifier"]]){
        BOOL verified = [_featuredProfile[@"verified"] boolValue];
        BOOL featured = [_featuredProfile[@"featured"] boolValue];
        BOOL staff = [_featuredProfile[@"staff"] boolValue];
        BOOL protected = [_featuredProfile[@"protected"] boolValue];
        
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
        
        _featuredIdentifier = (NSString *)_featuredProfile[@"identifier"];
        
        self.username.text = [NSString stringWithFormat:@"@%@", _featuredProfile[@"username"]];
        self.description.text = _featuredProfile[@"description"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
            NSData *backData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_featuredProfile[@"back"]]];
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
        profilePicture.identifier = _featuredProfile[@"identifier"];
        profilePicture.pictureURL = _featuredProfile[@"picture"];
        [[FICImageCache sharedImageCache] retrieveImageForEntity:profilePicture withFormatName:@"picture" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            [UIView animateWithDuration:1.0 animations:^(void) {
                self.picture.image = image;
            }];
        }];
    }
}

- (void)centerProfile {
    if(nil != _featuredIdentifier){
        [self.description sizeToFit];
        self.infoPlaceholder.frame = CGRectMake(self.infoPlaceholder.frame.origin.x, self.infoPlaceholder.frame.origin.y, self.infoPlaceholder.frame.size.width, (self.description.frame.size.height + 64));
        [UIView animateWithDuration:0.25 animations:^(void) {
            self.infoPlaceholder.center = self.mainPlaceholder.center;
        }];
    }
}

- (IBAction)rowButtonAction:(UIButton *)sender {
    NSDictionary *profile = [_profiles objectAtIndex:[(NexumProfileCell *)sender tag]];
    
    BOOL following = [profile[@"following"] boolValue];
    BOOL own = [profile[@"own"] boolValue];
    if(!following && !own){
        [NexumTwitter follow:profile[@"identifier"]];
    }
}

#pragma mark - StoreKit delegates

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    _product = [myProduct objectAtIndex:0];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction {
    [self.buyButton setTitle:@"BECOME FEATURED" forState:UIControlStateNormal];
    
    NSString *params = [NSString stringWithFormat:@"date=%@&product=%@&transaction=%@&title=%@&price=%@",
                        transaction.transactionDate,
                        transaction.payment.productIdentifier,
                        transaction.transactionIdentifier,
                        _product.localizedTitle,
                        _product.price
                        ];
    
    [NexumBackend postPurchases:params withAsyncBlock:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self clearTable];
            [self loadData];
            AudioServicesPlaySystemSound(_soundEffect);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });
    }];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction {
    [self.buyButton setTitle:@"BECOME FEATURED" forState:UIControlStateNormal];
    
    NSString *message;
    if (transaction.error.code == SKErrorPaymentCancelled) {
        message = @"It's ok, maybe next time.";
    } else {
        message = @"Could not complete the transaction, you have not been charged.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not unlocked"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
