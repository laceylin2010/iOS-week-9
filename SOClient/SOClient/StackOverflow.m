//
//  StackOverflow.m
//  SOClient
//
//  Created by Lacey Vu on 3/29/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "StackOverflow.h"
#import "APIService.h"

NSString const *kSOAPIBaseURL = @"https://api.stackexchange.com/2.2/";

@implementation StackOverflow

+(void)searchWithTerm:(NSString * _Nonnull)searchTerm withCompletion:(kNSDictionaryCompletionHandler _Nonnull)completionHandler
{
    NSString *search = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *sortParam = @"activity";
    NSString *orderParam = @"desc";
    
    NSString *searchURL = [NSString stringWithFormat:@"%@search?order=%@&sort=%@&intitle=%@&site=stackoverflow", kSOAPIBaseURL, orderParam, sortParam, search];
    
    [APIService getRequestWithURLString:searchURL withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error == nil) {
            completionHandler(data, nil);
        }
    }];
}

+(void)searchUserWithTerm:(NSString * _Nonnull)searchTerm withCompletion:(kNSDictionaryCompletionHandler _Nonnull)completionHandler
{
    NSString *search = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *sortParam = @"reputation";
    NSString *orderParam = @"desc";
    
    NSString *searchURL = [NSString stringWithFormat:@"%@users?order=%@&sort=%@&inname=%@&site=stackoverflow", kSOAPIBaseURL, orderParam, sortParam, search];
    
//    NSLog(@"%@", searchURL);
    
    [APIService getRequestWithURLString:searchURL withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        completionHandler(data, nil);
    }];
    
}

@end
