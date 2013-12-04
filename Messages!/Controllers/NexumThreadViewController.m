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

@implementation NexumThreadViewController {
    NSMutableArray *_messages;
    NSDictionary *_profile;
    NSDictionary *_account;
    
    UITextView *_sampleText;
    
    BOOL _isLoading;
    BOOL _isScrolling;
    BOOL _isFirstLoad;
    BOOL _animatingRotation;
    CGRect _keyboardFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.thread[@"subtitle"];
    
    UIEdgeInsets inset = [self.tableView contentInset];
    inset.bottom = 40;
    self.tableView.contentInset = inset;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.alpha = 0;
    
    self.activityIndicator.alpha = 1;
    
    _sampleText = [[UITextView alloc] init];
    _sampleText.editable = NO;
    _sampleText.scrollEnabled = NO;
    _sampleText.font = [UIFont systemFontOfSize:16];
    _sampleText.clipsToBounds = NO;
    
    _isLoading = NO;
    _isFirstLoad = YES;
    _isScrolling = NO;
    
    _messages = [[NSMutableArray alloc] init];
    _profile = nil;
    _account = [NexumDefaults currentAccount];
    
    [self.inputBar initFrame:self.interfaceOrientation];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.inputBar.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *params = [NSString stringWithFormat:@"identifier=%@", self.thread[@"identifier"]];
    [NexumBackend getProfiles:params withAsyncBlock:^(NSDictionary *data) {
        _profile = data[@"profile_data"];
    }];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Flurry logPageView];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustViewForKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustViewForKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification:) name:@"pushNotification" object:nil];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushNotification" object:nil];
}

#pragma mark - Data sources

- (IBAction)profileAction:(UIBarButtonItem *)sender {
    if(nil != _profile){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NexumProfileViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
        nextViewController.profile = _profile;
        nextViewController.isChildOfThread = YES;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

- (void)loadData {
    if(!_isLoading){
        _isLoading = YES;
        
        NSString *params = [NSString stringWithFormat:@"identifier=%@", self.thread[@"identifier"]];
        [NexumBackend getMessages:params withAsyncBlock:^(NSDictionary *data) {
            _messages = [NSMutableArray arrayWithArray:data[@"messages_data"]];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
                self.activityIndicator.alpha = 0;
                [self scrollToBottom];
                _isLoading = NO;
            });
        }];
    }
}

#pragma mark - UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect CSRect = [NexumUtil currentScreenRect:self.interfaceOrientation];
    
    NSDictionary *message = [_messages objectAtIndex:indexPath.row];
    _sampleText.text = message[@"text"];
    CGSize messageSize = [_sampleText sizeThatFits:CGSizeMake((CSRect.size.width - 150), FLT_MAX)];
    
    return (messageSize.height +  10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageCell";
    NexumMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *message = [_messages objectAtIndex:indexPath.row];
    NSDictionary *nextMessage = nil;
    
    if((indexPath.row + 1) < [_messages count]){
        nextMessage = [_messages objectAtIndex:(indexPath.row + 1)];
    }
    
    NSDictionary *profile = nil;
    BOOL sent = [message[@"sent"] boolValue];
    BOOL sentNext = [nextMessage[@"sent"] boolValue];
    if(nil == nextMessage || sent != sentNext){
        if(sent){
            profile = _account;
        } else {
            profile = _profile;
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
    _animatingRotation = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    _animatingRotation = NO;
    
    [self.inputBar updateFrame:self.interfaceOrientation withOrigin:_keyboardFrame.origin.y andAnimation:YES];
    [self.tableView updateFrame:self.interfaceOrientation withOrigin:_keyboardFrame.origin.y andAnimation:YES];
    [self.tableView reloadData];
}

- (void)adjustViewForKeyboardNotification:(NSNotification *)notification {
    NSDictionary *notificationInfo = [notification userInfo];
    
    _keyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardFrame = [self.view convertRect:_keyboardFrame fromView:self.view.window];

    [self.inputBar updateFrame:self.interfaceOrientation withOrigin:_keyboardFrame.origin.y andAnimation:(!_animatingRotation)];
    [self.tableView updateFrame:self.interfaceOrientation withOrigin:_keyboardFrame.origin.y andAnimation:(!_animatingRotation)];
    [self scrollToBottom];
}

#pragma mark - Send button

- (void)sendMessage {
    NSMutableDictionary *newMessage = [NSMutableDictionary dictionary];
    [newMessage setValue:[self.inputBar textValue] forKey:@"text"];
    [newMessage setValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"identifier"];
    [newMessage setValue:[NSNumber numberWithBool:YES] forKey:@"sent"];
    
    [_messages addObject:newMessage];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:nil waitUntilDone:YES];

    NSString *params = [NSString stringWithFormat:@"identifier=%@&text=%@", _profile[@"identifier"], [self.inputBar textValue]];
    [NexumBackend postMessages:params];
    [self.inputBar textClear];
}

#pragma mark - Util

-(void)scrollToBottom {
    if(!_isScrolling){
        _isScrolling = YES;
        if(_isFirstLoad){
            CGRect CSRect = [NexumUtil currentScreenRect:self.interfaceOrientation];
            
            if(CSRect.size.height < (self.tableView.contentSize.height + self.inputBar.frame.size.height + self.navigationController.navigationBar.frame.size.height)){
                [self.tableView setContentOffset:CGPointMake(0, (self.tableView.contentSize.height - self.tableView.frame.size.height + self.inputBar.frame.size.height))];
                [self.tableView setNeedsLayout];
                
            }
            self.tableView.alpha = 1;
            _isFirstLoad = NO;
            _isScrolling = NO;
        } else {
            if(1 < [_messages count]){
                NSIndexPath* bottomIndex = [NSIndexPath indexPathForRow:([_messages count]-1) inSection:0];
                [self.tableView scrollToRowAtIndexPath:bottomIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            _isScrolling = NO;
        }
    }
}

#pragma mark - Push notification

-(void)pushNotification:(NSNotification *)notification{
    NSDictionary *data = notification.userInfo;
    if([(NSString *)_account[@"identifier"] isEqualToString:(NSString *)data[@"recipient"]]){
        if([(NSString *)_profile[@"identifier"] isEqualToString:(NSString *)data[@"sender"]]){
            [self loadData];
        }
    }
}

@end
