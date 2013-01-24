//
//  ASBaseShareViewController.m
//  ASFastWashing
//
//  Created by D on 12-12-5.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASBaseShareViewController.h"

//sina
#import "WBEngine.h"
#import "WBSendView.h"

#define kWBSDKDemoAppKey @"2740796968"
#define kWBSDKDemoAppSecret @"db71188d8c4ea4badb350df899650eea"

//renren
#define DEBUG 1

//QQ
#import "TCWBEngine.h"

@interface ASBaseShareViewController ()

@end

@implementation ASBaseShareViewController
@synthesize weiBoEngine = _weiBoEngine;
@synthesize sendView = _sendView;
@synthesize renren = _renren;
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

-(void)dealloc
{
    [_weiBoEngine release];
    [_renren release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sinaBtnPressed:(UIButton *)sender
{
    WBEngine * engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setDelegate:self];
    [engine setRootViewController:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.weiBoEngine = engine;
    [engine release];
    
    if ([self.weiBoEngine isAuthorizeExpired]) {
        [self.weiBoEngine logIn];
    } else {
        NSString * text = [NSString stringWithFormat:@"如果发布成功，我今天下午就没有白干！%@",[NSURL URLWithString:@"http://user.qzone.qq.com/1375056099?ptlang=2052"]];
        self.sendView = [[[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey
                                                  appSecret:kWBSDKDemoAppSecret
                                                       text:text
                                                      image:[UIImage imageNamed:@"1.png"]]
                         autorelease];
        self.sendView.delegate = self;
        [self.sendView show:YES];
        //        UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"hello" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        //        [myAlert show];
        //        [myAlert release];
    }
    if ([self.weiBoEngine isLoggedIn]) {
        sender.titleLabel.text = @"发布";
    }
}

- (void)myAlertView:(NSString *)text
{
    UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [myAlert show];
    [myAlert release];
}

#pragma mark - WBEngineDelegate Methods

// Log in successfully.
- (void)engineDidLogIn:(WBEngine *)engine
{
    NSString * text = [NSString stringWithFormat:@"如果发布成功，我今天下午就没有白干！%@",
                       [NSURL URLWithString:@"http://user.qzone.qq.com/1375056099?ptlang=2052"]];
    self.sendView = [[[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey
                                              appSecret:kWBSDKDemoAppSecret
                                                   text:text
                                                  image:[UIImage imageNamed:@"1.png"]]
                     autorelease];
    self.sendView.delegate = self;
    [self.sendView show:YES];
}

// If you try to log in with logIn or logInUsingUserID method, and
// there is already some authorization info in the Keychain,
// this method will be invoked.
// You may or may not be allowed to continue your authorization,
// which depends on the value of isUserExclusive.
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"请先登出！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登录失败！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
// Log out successfully.
- (void)engineDidLogOut:(WBEngine *)engine
{
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
//													   message:@"登出成功！"
//													  delegate:self
//											 cancelButtonTitle:@"确定"
//											 otherButtonTitles:nil];
//    [alertView setTag:100];
//	[alertView show];
//	[alertView release];
}
// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"请重新登录！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"requestDidSucceedWithResult: %@", result);}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"requestDidFailWithError: %@", error);
}


#pragma mark - WBSendViewDelegate Methods
//- (void)sendViewWillAppear:(WBSendView *)view
//{
//
//}
//- (void)sendViewDidAppear:(WBSendView *)view
//{
//
//}
//- (void)sendViewWillDisappear:(WBSendView *)view
//{
//
//}
//- (void)sendViewDidDisappear:(WBSendView *)view
//{
//
//}
//- (void)sendViewNotAuthorized:(WBSendView *)view
//{
//
//}
//- (void)sendViewAuthorizeExpired:(WBSendView *)view
//{
//
//}

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    //    [self myAlertView:@"微博发送成功！"];
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"微博发送成功！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
}
- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"微博发送失败！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

//renren
- (IBAction)renrenBtnPressed:(id)sender
{
    //此方法授权会提示有误
    self.renren = [Renren sharedRenren];
    if (![self.renren isSessionValid]) {
        //[self shareRenForSongs];
        [self.renren authorizationWithPermisson:nil andDelegate:self];
    } else {
//        //[self.renren logout:self];
//        [self shareRenForSongs];
    }
    if ([self.renren isSessionValid]) {
        [self shareRenForSongs];
    }
    //    NSArray * permissions = [NSArray arrayWithObjects:@"photo_upload",@"publish_feed", nil];
    //    [self.renren authorizationWithPermisson:permissions andDelegate:self];
    
    //[self shareRenForSongs];
}
-(void)shareRenForSongs
{
    
    //self.renren = [Renren sharedRenren];
    NSString* text = [NSString stringWithFormat:@"大家好！祝大家今天体侧顺利过关！正在研究评论分享中……，嘿嘿，你懂得……"];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"http://share.renren.com/share/361395694/14744176443?from=web_matter",@"url",
                                 @"xxx洗衣店",@"name",
                                 //                                 @"访问我吧",@"action_name",
                                 @"http://share.renren.com/share/361395694/14744176443?from=web_matter",@"action_link",
                                 text,@"description",
                                 @"小时候的照片！",@"caption",
                                 //                                 @"http://fmn.rrimg.com/fmn060/20121112/1035/original_H63V_05f30000b5ae118d.jpg",@"image",
                                 nil];
    [self.renren dialog:@"feed" andParams:params andDelegate:self];
    //    UIImage* image = [UIImage imageNamed:@"1.png"];
    //    NSString *caption = @"这是一张测试图片";
    //    [self.renren publishPhotoSimplyWithImage:image caption:caption];
    
}
#pragma mark - Renren Delegate
/**
 * 授权登录成功时被调用,第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的 Renren 类型对象。 */
- (void)renrenDidLogin:(Renren *)renren
{
    //    [self shareRenForSongs];
#ifdef DEBUG
    NSLog(@"renren = %@",renren);
#endif
    
}
/**
 ￼6
 ￼人人网开放平台
 ￼* 授权登录失败时被调用,第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的 Renren 类型对象。 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{
#ifdef DEBUG
    NSLog(@"error = %@",error);
#endif
}

/**
 * 接口请求成功,第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的 Renren 类型对象。 * @param response 传回接口请求的响应。
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    NSLog(@"response = %@",response);
    //[renren logout:self];
}
/**
 * 用户登出成功后被调用 第三方开发者实现这个方法
 * @param renren 传回代理登出接口请求的 Renren 类型对象。 */
- (void)renrenDidLogout:(Renren *)renren
{
#ifdef DEBUG
    NSLog(@"logout renren = %@",renren);
#endif
}

//QQ
- (IBAction)tengxuPressed:(id)sender {
    TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:@"http://www.qq.com"];
    [engine setRootViewController:self];
    self.weiboEngine = engine;
    [engine release];
    
    [self onLogInOAuthButtonPressed];
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
    TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:@"http://www.qq.com"];
    NSLog(@"self:%@",self);
    [engine setRootViewController:self];
    self.weiboEngine = engine;
    [engine release];

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
