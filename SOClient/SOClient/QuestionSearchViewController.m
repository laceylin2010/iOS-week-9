//
//  QuestionSearchViewController.m
//  SOClient
//
//  Created by Lacey Vu on 3/28/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflow.h"
#import "JSONParser.h"
#import "Question.h"

@interface QuestionSearchViewController ()


@end

@implementation QuestionSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [StackOverflow searchWithTerm:@"iOS" withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"DATA: %@", data);
                NSArray *questions = [JSONParser questionsArrayFromDictionary:data];
                
                for (Question *question in questions) {
                    NSLog(@"%@", question.title);
                }
            }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

+(NSString *)identifier
{
    return @"QuestionSearchViewController";
}

@end
