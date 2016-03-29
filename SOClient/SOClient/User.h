//
//  User.h
//  SOClient
//
//  Created by Lacey Vu on 3/29/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject

@property(strong, nonatomic)NSString *displayName;
@property(strong, nonatomic)NSURL *profileImageUrl;
@property(strong, nonatomic)UIImage *profileImage;
@property(strong, nonatomic)NSURL *link;
@property(nonatomic)int userID;

-(instancetype)initWithDisplayName:(NSString *)displayName profileImageUrl:(NSURL *)profileImageUrl link:(NSURL *)link userID:(int)userID;

@end
