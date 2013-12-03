//
//  NexumProfilePicture.m
//  Messages!
//
//  Created by Cristian Castillo on 11/22/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumProfilePicture.h"

@implementation NexumProfilePicture

- (UIImage *)sourceImage {
    NSURL *requestURL = [NSURL URLWithString:self.pictureURL];
    NSData *pictureData = [NSData dataWithContentsOfURL:requestURL];
    UIImage *sourceImage = [UIImage imageWithData:pictureData];
    return sourceImage;
}

- (NSString *)UUID {
    CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString(self.identifier);
    NSString *UUID = FICStringWithUUIDBytes(UUIDBytes);
    return UUID;
}

- (NSString *)sourceImageUUID {
    if([NSNull null] == (NSNull *)self.pictureURL){
        self.pictureURL = @"";
    }

    
    CFUUIDBytes sourceImageUUIDBytes = FICUUIDBytesFromMD5HashOfString(self.pictureURL);
    NSString *sourceImageUUID = FICStringWithUUIDBytes(sourceImageUUIDBytes);
    return sourceImageUUID;
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
    if([NSNull null] == (NSNull *)self.pictureURL){
        self.pictureURL = @"";
    }
    
    return [NSURL URLWithString:self.pictureURL];
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef context, CGSize contextSize) {
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        CGContextClearRect(context, contextBounds);
        
        UIImage *rounded = [NexumUtil imageWithRoundedCornersSize:36 usingImage:image];
        
        UIGraphicsPushContext(context);
        [rounded drawInRect:contextBounds];
        UIGraphicsPopContext();
    };
    
    return drawingBlock;
}

@end