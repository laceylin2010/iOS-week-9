//
//  APIService.h
//  SOClient
//
//  Created by Lacey Vu on 3/29/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kNSDataCompletionHandler)(NSDictionary * _Nullable data, NSError *_Nullable error);

@interface APIService : NSObject

+(void)getRequestWithURLString:(NSString * _Nonnull)url withCompletion:(kNSDataCompletionHandler _Nullable)completionHandler;

@end
