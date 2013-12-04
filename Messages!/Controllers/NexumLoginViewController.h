//
//  NexumLoginViewController.h
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumLoginViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *twitterWebview;

- (IBAction)refreshAction:(id)sender;
- (IBAction)stopAction:(UIBarButtonItem *)sender;

@end