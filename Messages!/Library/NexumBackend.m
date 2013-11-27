//
//  NexumBackend.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumBackend.h"

@implementation NexumBackend

+ (void) apiRequest:(NSString *)method forPath:(NSString *)path withParams:(NSString *)params andBlock:(void (^)(BOOL success, NSDictionary *data)) block {
    
    
    NSString *endpoint = nil;
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] init];
    [URLRequest setHTTPMethod:method];
    if([method isEqualToString:@"POST"]){
        endpoint = [NSString stringWithFormat:@"%@%@", BACKEND_URL, path];
        
        NSData *HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        NSString *contentLength = [NSString stringWithFormat:@"%d", [HTTPBody length]];
        
        [URLRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [URLRequest setValue:contentLength forHTTPHeaderField:@"Content-Length"];
        [URLRequest setHTTPBody:HTTPBody];
    } else {
        endpoint = [NSString stringWithFormat:@"%@%@?%@", BACKEND_URL, path, params];
    }
    [URLRequest setURL:[NSURL URLWithString:endpoint]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:URLRequest queue:queue completionHandler:^(NSURLResponse *URLResponse, NSData *responseData, NSError *error) {
        if ([responseData length] > 0){
            NSError *JSONErrorResponse = nil;
            id JSONResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&JSONErrorResponse];
            BOOL success = [JSONResponse[@"success"] boolValue];
            block(success, JSONResponse);
        } else {
            block(NO, nil);
        }
    }];
}

@end
