//
//  NexumAlphaViewController.h
//  Messages!
//
//  Created by Cristian Castillo on 11/25/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumAlphaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webview;

- (IBAction)refreshAction:(UIBarButtonItem *)sender;

@end
