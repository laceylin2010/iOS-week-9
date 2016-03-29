//
//  User.m
//  SOClient
//
//  Created by Lacey Vu on 3/29/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithDisplayName:(NSString *)displayName profileImageUrl:(NSURL *)profileImageUrl link:(NSURL *)link userID:(int)userID
{
    if (self = [super init]) {
        self.displayName = displayName;
        self.profileImageUrl = profileImageUrl;
        self.link = link;
        self.userID = userID;
    }
    
    return self;
}

@end
