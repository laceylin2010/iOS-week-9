//
//  AppDelegate.m
//  SOClient
//
//  Created by Lacey Vu on 3/28/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "AppDelegate.h"
#import "OAuthViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self checkForAccessToken];
    
    return YES;
}

-(void)checkForAccessToken
{
    //change to keychain
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *accessToken = [userDefaults stringForKey:@"accessToken"];
    
    if (!accessToken) {
        [self fetchAccessToken];
    }
}


-(void)fetchAccessToken
{
    UIViewController *rootViewController = self.window.rootViewController;
    OAuthViewController *oAuthVC = [[OAuthViewController alloc]init];
    
    __weak typeof (oAuthVC) weakOAuth = oAuthVC;
    
    oAuthVC.completion = ^() {
        [weakOAuth.view removeFromSuperview];
        [weakOAuth removeFromParentViewController];
    };

    [rootViewController addChildViewController:oAuthVC];
    [rootViewController.view addSubview:oAuthVC.view];
    
    [rootViewController didMoveToParentViewController:rootViewController];
}



@end
