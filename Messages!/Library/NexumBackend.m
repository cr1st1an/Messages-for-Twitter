//
//  NexumBackend.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/12/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumBackend.h"

@implementation NexumBackend

+ (void)getContactsFollowers:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"GET" forPath:@"contacts/followers" withParams:params];
        block(data);
    });
}

+ (void)getContactsFollowing:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"GET" forPath:@"contacts/following" withParams:params];
        block(data);
    });
}

+ (void)getContactsSearch:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"GET" forPath:@"contacts/search" withParams:params];
        block(data);
    });
}

+ (void)getContactsSuggested:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"GET" forPath:@"contacts/suggested" withParams:params];
        block(data);
    });
}

+ (void)getMessages:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"GET" forPath:@"messages" withParams:params];
        block(data);
    });
}

+ (void)getProfiles:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"GET" forPath:@"profiles" withParams:params];
        block(data);
    });
}

+ (void)getPurchasesRecentWithAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"GET" forPath:@"purchases/recent" withParams:@""];
        block(data);
    });
}

+ (void)getThreadsWithAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"GET" forPath:@"threads" withParams:@""];
        block(data);
    });
}



+ (void)postAccountsDeviceToken:(NSString *)params {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        [NexumBackend apiRequest:@"POST" forPath:@"accounts/device_token" withParams:params];
    });
}
+ (void)postContactsBlock:(NSString *)params {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        [NexumBackend apiRequest:@"POST" forPath:@"contacts/block" withParams:params];
    });
}

+ (void)postContactsFollow:(NSString *)params {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        [NexumBackend apiRequest:@"POST" forPath:@"contacts/follow" withParams:params];
    });
}

+ (void)postContactsUnblock:(NSString *)params {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        [NexumBackend apiRequest:@"POST" forPath:@"contacts/unblock" withParams:params];
    });
}

+ (void)postContactsUnfollow:(NSString *)params {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        [NexumBackend apiRequest:@"POST" forPath:@"contacts/unfollow" withParams:params];
    });
}

+ (void)postMessages:(NSString *)params {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        [NexumBackend apiRequest:@"POST" forPath:@"messages" withParams:params];
    });
}

+ (void)postPurchases:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"POST" forPath:@"purchases" withParams:params];
        block(data);
    });
}

+ (void)postSessions:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"POST" forPath:@"sessions" withParams:params];
        block(data);
    });
}

+ (void)postSessionsAuth:(NSString *)params withAsyncBlock:(void (^)(NSDictionary *data))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSDictionary *data = [NexumBackend apiRequest:@"POST" forPath:@"sessions/auth" withParams:params];
        block(data);
    });
}

+ (void)postStatusesUpdate:(NSString *)params {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        [NexumBackend apiRequest:@"POST" forPath:@"statuses/update" withParams:params];
    });
}

+ (void)postWorkers01 {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        [NexumBackend apiRequest:@"POST" forPath:@"workers/01" withParams:@""];
    });
}


+ (NSDictionary *)apiRequest:(NSString *)method forPath:(NSString *)path withParams:(NSString *)params {
    [Flurry logEvent:[NSString stringWithFormat:@"%@/%@",method,path] timed:YES];
    
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
    [URLRequest setURL:[NSURL URLWithString:[endpoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSURLResponse *URLResponse;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&URLResponse error:&error];
    
    id JSONResponse = nil;
    if ([responseData length] > 0){
        NSError *JSONErrorResponse = nil;
        JSONResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&JSONErrorResponse];
    }
    
    [Flurry endTimedEvent:[NSString stringWithFormat:@"%@/%@",method,path] withParameters:nil];
    return JSONResponse;
}

@end
