//
//  OAuthViewController.m
//  SOClient
//
//  Created by Lacey Vu on 3/28/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "OAuthViewController.h"
@import WebKit;
@import Security;

NSString const *kClientID = @"6793";
NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog?";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";


@interface OAuthViewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation OAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupWebView];
}

-(void)setupWebView
{
    self.webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    
    NSString *stackURLString = [NSString stringWithFormat:@"%@client_id=%@&redirect_uri=%@", kBaseURL, kClientID, kRedirectURI];
    NSURL *stackURL = [NSURL URLWithString:stackURLString];
    
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:stackURL]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest *request = navigationAction.request;
    NSURL *requestURL = request.URL;
    
    NSLog(@"%@", requestURL);
    
    if ([requestURL.description containsString:@"access_token"]) {
        NSLog(@"YAY!! We have a token!");
        
        [self getAndStoreAccessTokenFromURL:requestURL];
        
        if (self.completion) {
            self.completion();
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

-(void)getAndStoreAccessTokenFromURL:(NSURL *)url
{
    NSCharacterSet *seperatingCharacters = [NSCharacterSet characterSetWithCharactersInString:@"#&?"];
    
    NSArray *urlComponents = [[url description]componentsSeparatedByCharactersInSet:seperatingCharacters];
    
    for (NSString *component in urlComponents) {
        NSArray *componentArray = [component componentsSeparatedByString:@"="];
        
        if (componentArray.count >= 2) {
            NSString *key = componentArray[0];
            NSString *value = componentArray[1];
            
            if (key && value) {
                NSLog(@"key: %@, Value: %@", key, value);
                [self saveStringToUserDefaults:value ForKey:key];
            }
        }
    }
}


//crashes the app when trying to save to keychain
//-(BOOL)saveStringToKeychain:(NSString *)value ForKey:(NSString *)key
//{
//    NSMutableDictionary *keychain = [[NSMutableDictionary alloc]init];
//    [keychain[(id)kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:value] objectForKey:key];
//    SecItemDelete((CFDictionaryRef)keychain);
//    SecItemAdd((CFDictionaryRef)keychain, NULL);
//    return SecItemAdd((CFDictionaryRef)keychain, NULL) == errSecSuccess;
//}


-(void)saveStringToUserDefaults:(NSString *)value ForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

+(NSString *)identifier
{
    return @"OAuthViewController";
}

@end
