//
//  ASRequest.m
//  快洗
//
//  Created by Admin on 12-11-21.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASRequest.h"
#import "URL.h"
//#define ASDEBUG 0


@implementation ASRequest

@synthesize request = _request;
@synthesize url = _url;
@synthesize infoData = _infoData;
@synthesize result = _result;

-(void)dealloc
{
    [_request release];
    [_url release];
    [_infoData release];
    [_result release];
    [super dealloc];
}

-(id)init
{
    return [self initWithRequest:nil andURL:nil];
}
/*
 功能: 初始化，并开始请求数据
 */
-(id)initWithRequest:(NSDictionary *)oneRequest andURL:(NSString *)oneUrl
{
    if (self = [super init]) {
        _request = [[NSDictionary alloc]initWithDictionary:oneRequest];
        _url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@",Ip,oneUrl]];
        _result = [[NSDictionary alloc]init];
        _infoData = [[NSMutableData alloc]init];
    }
    
//    NSLog(@"%@",self.url);
    
    return  self;
}

/*
 功能: 初始化，并开始请求数据
 */
-(id)initWithURL:(NSString *)oneUrl
{
    if (self = [super init]) {
        _request = [[NSDictionary alloc]init];
        _url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",oneUrl]];
        _result = [[NSDictionary alloc]init];
        _infoData = [[NSMutableData alloc]init];
    }
    
    return  self;
}

-(void)setDelegate:(id<ASRequestDelegate>)del
{
    delegate = del;
}

#pragma mark NSURLConnection 代理实现
/*
 功能：开始连接
 */
-(BOOL)startConnectInternet
{
    NSData * postData= [NSJSONSerialization dataWithJSONObject:_request options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString * postString = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:self.url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
    
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [req setHTTPMethod:@"POST"];
    
    [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postString release];
    
    NSURLConnection * conn = [[[NSURLConnection alloc] initWithRequest:req delegate:self]autorelease];
    
    //创建成功
    if (conn) {
        return YES;
        
    }
    else
    {
        [conn release];
        return NO;
    }

}

/*
 功能：接收数据
 */
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [_infoData appendData:data];
}
/*
 功能：数据有误，清空以前的数据
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   [_infoData setLength:0];
}
/*
 功能：请求数据完成，解析数据，显示数据
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  
//   NSString * ss = [[NSString alloc]initWithData:_infoData encoding:NSUTF8StringEncoding];  //可以删除
    

//    NSLog(@"%@",ss);  //可以删除

    self.result = [NSJSONSerialization JSONObjectWithData:_infoData options:NSJSONReadingMutableLeaves error:nil];
    
 //   [ss release];
    
    if (delegate && [delegate respondsToSelector:@selector(requestDidFinishLoading)]) {
        [delegate requestDidFinishLoading];
    }
    
}
/*
 功能：连接失败
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];

    if (delegate && [delegate respondsToSelector:@selector(requestDidFailWithError)]) {
        [delegate requestDidFailWithError];
    }
}

@end
