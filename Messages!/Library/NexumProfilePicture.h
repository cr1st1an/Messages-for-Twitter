//
//  NexumProfilePicture.h
//  Messages!
//
//  Created by Cristian Castillo on 11/22/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICImageCache.h"
#import "FICEntity.h"
#import "FICUtilities.h"

@interface NexumProfilePicture : NSObject <FICEntity>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *pictureURL;

- (UIImage *)sourceImage;

@end
