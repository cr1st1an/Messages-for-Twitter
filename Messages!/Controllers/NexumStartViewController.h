//
//  NexumStartViewController.h
//  Messages!
//
//  Created by Cristian Castillo on 11/27/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NexumStartViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *titleImage;
@property (strong, nonatomic) IBOutlet UIButton *signinButton;

- (IBAction)signinAction:(UIButton *)sender;

@end
