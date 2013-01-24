//
//  ASShareViewController.m
//  ASFastWashing
//
//  Created by D on 12-12-4.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASShareViewController.h"
#import "TCWBEngine.h"

@interface ASShareViewController ()

@end

@implementation ASShareViewController
@synthesize weiboEngine;
@synthesize logInBtnOAuth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:@"http://www.qq.com"];
    [engine setRootViewController:self];
    self.weiboEngine = engine;
    [engine release];
//    logInBtnOAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [logInBtnOAuth setFrame:CGRectMake(65, 150, 200, 40)];
//    [logInBtnOAuth setTitle:@"发表组件(自带登录功能)" forState:UIControlStateNormal];//没登录就登录，有登录弹界面
//    [logInBtnOAuth addTarget:self action:@selector(onLogInOAuthButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:logInBtnOAuth];

//    [self onLogInOAuthButtonPressed];
    [self.weiboEngine UIBroadCastMsgWithContent:@"qq"
                                       andImage:[UIImage imageNamed:@"test.png"]
                                    parReserved:nil
                                       delegate:self
                                    onPostStart:@selector(postStart)
                                  onPostSuccess:@selector(createSuccess:)
                                  onPostFailure:@selector(createFail:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 分享
- (void)showAlertMessage:(NSString *)msg {
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                       message:msg
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
}

#pragma mark - login callback

//登录成功回调
- (void)onSuccessLogin
{
    [indicatorView stopAnimating];
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error
{
    [indicatorView stopAnimating];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[NSNumber numberWithInteger:[error code]]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error domain]
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [message release];
}

//授权成功回调
- (void)onSuccessAuthorizeLogin
{
    [indicatorView stopAnimating];
    [self onLogInOAuthButtonPressed];
}

- (void)didRequestMutualList:(id)result{
    
}

#pragma mark -  get homeline callback

- (void)successCallBack:(id)result{
    
}

- (void)failureCallBack{
    
}

#pragma mark - method

//点击登录按钮
- (void)onLogin {
    [weiboEngine logInWithDelegate:self
                         onSuccess:@selector(onSuccessLogin)
                         onFailure:@selector(onFailureLogin:)];
}

- (void)onLogout {
    // 注销授权
    if ([weiboEngine logOut]) {
        [self showAlertMessage:@"登出成功！"];
    }else {
        [self showAlertMessage:@"登出失败！"];
    }
}

//点击一键分享(自带登录功能)
- (void)onLogInOAuthButtonPressed
{
    // 分享(自带登录功能)
    [self.weiboEngine UIBroadCastMsgWithContent:@"qq"
                                       andImage:[UIImage imageNamed:@"test.png"]
                                    parReserved:nil
                                       delegate:self
                                    onPostStart:@selector(postStart)
                                  onPostSuccess:@selector(createSuccess:)
                                  onPostFailure:@selector(createFail:)];
    
}

#pragma mark - creatSuccessOrFail

- (void)postStart {
    //    [self showAlertMessage:@"开始发送"];
}

- (void)createSuccess:(NSDictionary *)dict {
    //    NSLog(@"%s %@", __FUNCTION__,dict);
    if ([[dict objectForKey:@"ret"] intValue] == 0) {
        [self showAlertMessage:@"发送成功！"];
    }else {
        [self showAlertMessage:@"发送失败！"];
    }
}

- (void)createFail:(NSError *)error {
    //    NSLog(@"error is %@",error);
    [self showAlertMessage:@"发送失败！"];
}

@end
