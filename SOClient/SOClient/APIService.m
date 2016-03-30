//
//  APIService.m
//  SOClient
//
//  Created by Lacey Vu on 3/29/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "APIService.h"
#import <AFNetworking/AFNetworking.h>

@implementation APIService

+(void)getRequestWithURLString:(NSString * _Nonnull)url withCompletion:(kNSDataCompletionHandler)completionHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(responseObject, nil);
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"ERROR: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, error);
        });
    }];
}

@end
