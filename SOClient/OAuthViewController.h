//
//  OAuthViewController.h
//  SOClient
//
//  Created by Lacey Vu on 3/28/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OAuthWebViewControllerCompletion)();

@interface OAuthViewController : UIViewController

@property(copy, nonatomic)OAuthWebViewControllerCompletion completion;

+(NSString *)identifier;

@end
