//
//  ASUser.m
//  快洗
//
//  Created by SSD on 12-11-20.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASUser.h"

@implementation ASUser

@synthesize userName;
@synthesize password;
@synthesize question;
@synthesize answer;
@synthesize address;
@synthesize userId;
@synthesize isLogin;

- (void)dealloc
{
    [userName release];
    [password release];
    [address release];
    [question release];
    [answer release];
    [userId release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"user"];
        self.password = [aDecoder decodeObjectForKey:@"passWord"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.question = [aDecoder decodeObjectForKey:@"question"];
        self.answer = [aDecoder decodeObjectForKey:@"answer"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:userName forKey:@"user"];
    [aCoder encodeObject:address forKey:@"address"];
    [aCoder encodeObject:password forKey:@"password"];
    [aCoder encodeObject:question forKey:@"question"];
    [aCoder encodeObject:answer forKey:@"answer"];
    [aCoder encodeObject:userId forKey:@"userId"];
    [aCoder encodeBool:isLogin forKey:@"isLogin"];
}
@end
