//
//  StackOverflow.h
//  SOClient
//
//  Created by Lacey Vu on 3/29/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kNSDictionaryCompletionHandler)(NSDictionary * _Nullable data, NSError * _Nullable error);

@interface StackOverflow : NSObject

+(void)searchWithTerm:(NSString * _Nonnull)searchTerm withCompletion:(kNSDictionaryCompletionHandler _Nonnull)completionHandler;
+(void)searchUserWithTerm:(NSString * _Nonnull)searchTerm withCompletion:(kNSDictionaryCompletionHandler _Nonnull)completionHandler;

@end
