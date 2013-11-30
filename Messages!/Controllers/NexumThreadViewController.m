//
//  NexumThreadViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/16/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumThreadViewController.h"

@interface NexumThreadViewController ()

@end

@implementation NexumThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.thread[@"subtitle"];
    
    UIEdgeInsets inset = [self.tableView contentInset];
    inset.bottom = 40;
    self.tableView.contentInset = inset;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.alpha = 0;
    
    self.activityIndicator.alpha = 1;
    
    self.sampleText = [[UITextView alloc] init];
    self.sampleText.editable = NO;
    self.sampleText.scrollEnabled = NO;
    self.sampleText.font = [UIFont systemFontOfSize:16];
    self.sampleText.clipsToBounds = NO;
    
    self.isLoading = NO;
    self.isFirstLoad = YES;
    self.isScrolling = NO;
    
    self.messages = [[NSMutableArray alloc] init];
    self.profile = nil;
    self.account = [NexumDefaults currentAccount];
    
    [self.inputBar initFrame:self.interfaceOrientation];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.inputBar.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *params = [NSString stringWithFormat:@"identifier=%@", self.thread[@"identifier"]];
    [NexumBackend apiRequest:@"GET" forPath:@"profiles" withParams:params andBlock:^(BOOL success, NSDictionary *data) {
        if(success){
            self.profile = data[@"profile_data"];
        }
    }];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustViewForKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustViewForKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification:) name:@"pushNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self loadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushNotification" object:nil];
}

#pragma mark - Data sources

- (IBAction)profileAction:(UIBarButtonItem *)sender {
    if(nil != self.profile){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NexumProfileViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
        nextViewController.profile = self.profile;
        nextViewController.isChildOfThread = YES;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

- (void)loadData {
    if(!self.isLoading){
        self.isLoading = YES;
        
        NSString *params = [NSString stringWithFormat:@"identifier=%@", self.thread[@"identifier"]];
        [NexumBackend apiRequest:@"GET" forPath:@"messages" withParams:params andBlock:^(BOOL success, NSDictionary *data) {
            if(success){
                self.messages = [NSMutableArray arrayWithArray:data[@"messages_data"]];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(dataDidLoad) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:nil waitUntilDone:YES];
            }
            self.isLoading = NO;
        }];
    }
}

- (void)dataDidLoad {
    self.activityIndicator.alpha = 0;
}

#pragma mark - UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect CSRect = [NexumUtil currentScreenRect:self.interfaceOrientation];
    
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    self.sampleText.text = message[@"text"];
    CGSize messageSize = [self.sampleText sizeThatFits:CGSizeMake((CSRect.size.width - 150), FLT_MAX)];
    
    return (messageSize.height +  10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageCell";
    NexumMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    NSDictionary *nextMessage = nil;
    
    if((indexPath.row + 1) < [self.messages count]){
        nextMessage = [self.messages objectAtIndex:(indexPath.row + 1)];
    }
    
    NSDictionary *profile = nil;
    BOOL sent = [message[@"sent"] boolValue];
    BOOL sentNext = [nextMessage[@"sent"] boolValue];
    if(nil == nextMessage || sent != sentNext){
        if(sent){
            profile = self.account;
        } else {
            profile = self.profile;
        }
    }
    
    cell.identifier = message[@"identifier"];
    [cell reuseCell:self.interfaceOrientation withMessage:message andProfile:profile];
    if(nil != profile){
        [cell performSelector:@selector(loadImageswithMessageAndProfile:) withObject:[NSArray arrayWithObjects:message, profile, nil] afterDelay:0.1];
    }
    
    return cell;
}

#pragma mark - Keyboard notifications

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.animatingRotation = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.animatingRotation = NO;
    
    [self.inputBar updateFrame:self.interfaceOrientation withOrigin:self.keyboardFrame.origin.y andAnimation:YES];
    [self.tableView updateFrame:self.interfaceOrientation withOrigin:self.keyboardFrame.origin.y andAnimation:YES];
    [self.tableView reloadData];
}

- (void)adjustViewForKeyboardNotification:(NSNotification *)notification {
    NSDictionary *notificationInfo = [notification userInfo];
    
    self.keyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame = [self.view convertRect:self.keyboardFrame fromView:self.view.window];

    [self.inputBar updateFrame:self.interfaceOrientation withOrigin:self.keyboardFrame.origin.y andAnimation:(!self.animatingRotation)];
    [self.tableView updateFrame:self.interfaceOrientation withOrigin:self.keyboardFrame.origin.y andAnimation:(!self.animatingRotation)];
    [self scrollToBottom];
}

#pragma mark - Send button

- (void)sendMessage {
    NSMutableDictionary *newMessage = [NSMutableDictionary dictionary];
    [newMessage setValue:[self.inputBar textValue] forKey:@"text"];
    [newMessage setValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"identifier"];
    [newMessage setValue:[NSNumber numberWithBool:YES] forKey:@"sent"];
    
    [self.messages addObject:newMessage];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:nil waitUntilDone:YES];

    NSString *params = [NSString stringWithFormat:@"identifier=%@&text=%@", self.profile[@"identifier"], [self.inputBar textValue]];
    [NexumBackend apiRequest:@"POST" forPath:@"messages" withParams:params andBlock:^(BOOL success, NSDictionary *data) {}];
    [self.inputBar textClear];
}

#pragma mark - Util

-(void)scrollToBottom {
    if(!self.isScrolling){
        self.isScrolling = YES;
        if(self.isFirstLoad){
            CGRect CSRect = [NexumUtil currentScreenRect:self.interfaceOrientation];
            
            if(CSRect.size.height < (self.tableView.contentSize.height + self.inputBar.frame.size.height + self.navigationController.navigationBar.frame.size.height)){
                [self.tableView setContentOffset:CGPointMake(0, (self.tableView.contentSize.height - self.tableView.frame.size.height + self.inputBar.frame.size.height))];
                [self.tableView setNeedsLayout];
                
            }
            self.tableView.alpha = 1;
            self.isFirstLoad = NO;
            self.isScrolling = NO;
        } else {
            if(1 < [self.messages count]){
                NSIndexPath* bottomIndex = [NSIndexPath indexPathForRow:([self.messages count]-1) inSection:0];
                [self.tableView scrollToRowAtIndexPath:bottomIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            self.isScrolling = NO;
        }
    }
}

#pragma mark - Push notification

-(void)pushNotification:(NSNotification *)notification{
    NSDictionary *data = notification.userInfo;
    if([(NSString *)self.account[@"identifier"] isEqualToString:(NSString *)data[@"recipient"]]){
        if([(NSString *)self.profile[@"identifier"] isEqualToString:(NSString *)data[@"sender"]]){
            [self loadData];
        }
    }
}

@end
