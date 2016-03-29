//
//  JSONParser.m
//  SOClient
//
//  Created by Lacey Vu on 3/29/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "JSONParser.h"
#import "User.h"
#import "Question.h"

@implementation JSONParser


+(NSMutableArray * _Nullable)questionsArrayFromDictionary:(NSDictionary * _Nullable)dictionary
{
    NSMutableArray *result = [NSMutableArray new];
    if (dictionary) {
        NSMutableArray *items = dictionary[@"items"];
        if (items) {
            for (NSDictionary *questionDictionary in items) {
                Question *newQuestion = [self questionFromDictionary:questionDictionary];
                
                if (newQuestion != nil) {
                    [result addObject:newQuestion];
                }
            }
        }
        
    }
    
    return result;
}

+(Question * _Nullable)questionFromDictionary:(NSDictionary *)questionDictionary
{
    NSString *title = questionDictionary[@"title"];
    NSNumber *questionID = questionDictionary[@"question_id"];
    NSNumber *score = questionDictionary[@"score"];
    BOOL isAnswered = [questionDictionary[@"isAnswered"]isEqualToNumber:@1];

    NSDictionary *ownerDictionary = questionDictionary[@"ownder"];
    User *owner = [self userFromDictionary:ownerDictionary];
    
    return [[Question alloc]initWithTitle:title owner:owner questionID:questionID.intValue score:score.intValue isAnswered:isAnswered];
}

+(User * _Nullable)userFromDictionary:(NSDictionary *)userDictionary
{
    NSString *displayName = userDictionary[@"display_name"];
    NSString *profileImageUrlString = userDictionary[@"profile_image"];
    NSString *linkURLString = userDictionary[@"link"];
    NSNumber *userID = userDictionary[@"user_id"];
    NSURL *profileImageURL = [NSURL URLWithString:profileImageUrlString];
    NSURL *link = [NSURL URLWithString:linkURLString];

    
    return [[User alloc]initWithDisplayName:displayName profileImageUrl:profileImageURL link:link userID:userID.intValue];
    
}

@end
