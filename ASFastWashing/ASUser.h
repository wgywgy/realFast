//
//  ASUser.h
//  快洗
//
//  Created by SSD on 12-11-20.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASUser : NSObject <NSCoding>

{
    NSString *userName; //用户名
    NSString *password; //用户密码
    NSString *question; //用户密保问题
    NSString *answer;   //用户密保答案
    NSString *address;  //用户地址
    NSString *userId;   //用户ID
    BOOL isLogin;       //是否登录
}
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *question;
@property (retain, nonatomic) NSString *answer;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *userId;
@property (assign, nonatomic) BOOL isLogin;
@end
