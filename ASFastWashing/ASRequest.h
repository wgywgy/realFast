//
//  ASRequest.h
//  快洗
//
//  Created by Admin on 12-11-21.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASRequestDelegate.h"
@interface ASRequest : NSObject
{
    NSDictionary * request;  //请求
    NSURL * url;             //url地址
    NSMutableData * infoData;//临时数据
    id result;   //返回的结果
    id<ASRequestDelegate>delegate; //代理
}
@property(nonatomic,retain)NSDictionary * request;
@property(nonatomic,retain)id result;
@property(nonatomic,retain)NSURL * url;
@property(nonatomic,retain)NSMutableData * infoData;

-(void)setDelegate:(id<ASRequestDelegate>)del;
-(id)initWithRequest:(NSDictionary *)oneRequest andURL:(NSString *)oneUrl;
-(id)initWithURL:(NSString *)oneUrl;
-(BOOL)startConnectInternet;  //开始网络请求
@end
