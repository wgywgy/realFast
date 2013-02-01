//
//  ASViewController.m
//  WYYShareTest
//
//  Created by Parker on 12-11-23.
//  Copyright (c) 2012年 河北师范大学软件学院. All rights reserved.
//

#import "ASViewController.h"
#import "WBEngine.h"
#import "WBSendView.h"

#define kWBSDKDemoAppKey @"2740796968"
#define kWBSDKDemoAppSecret @"db71188d8c4ea4badb350df899650eea"

@implementation ASViewController
@synthesize weiBoEngine = _weiBoEngine;
@synthesize sendView = _sendView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [_weiBoEngine release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    WBEngine * engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setDelegate:self];
    [engine setRootViewController:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.weiBoEngine = engine;
    [engine release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)logOut:(id)sender
{
    [self.weiBoEngine logOut];
}
- (IBAction)sinaBtnPressed:(id)sender
{    
    if ([self.weiBoEngine isAuthorizeExpired]) {
        [self.weiBoEngine logIn];
    }
    else
    {
        NSString * text = [NSString stringWithFormat:@"如果发布成功，我今天下午就没有白干！%@",[NSURL URLWithString:@"http://user.qzone.qq.com/1375056099?ptlang=2052"]];
        self.sendView = [[[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:text image:[UIImage imageNamed:@"1.png"]]autorelease];
        self.sendView.delegate = self;
        [self.sendView show:YES];  
//        UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"hello" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//        [myAlert show];
//        [myAlert release];
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
    NSString * text = [NSString stringWithFormat:@"如果发布成功，我今天下午就没有白干！%@",[NSURL URLWithString:@"http://user.qzone.qq.com/1375056099?ptlang=2052"]];
    self.sendView = [[[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:text image:[UIImage imageNamed:@"1.png"]]autorelease];
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
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登出成功！"
													  delegate:self
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
    [alertView setTag:100];
	[alertView show];
	[alertView release];
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

@end
