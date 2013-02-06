//
//  ASWebHelpViewController.m
//  ASFastWashing
//
//  Created by D on 13-2-6.
//  Copyright (c) 2013年 SSD. All rights reserved.
//

#import "ASWebHelpViewController.h"

@interface ASWebHelpViewController ()

@end

@implementation ASWebHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
        [left setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
        [left addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
        self.navigationItem.leftBarButtonItem = leftButton;
        [leftButton release];
        [left release];
        
        self.title = @"使用帮助";

        myWebView.delegate = self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect_screen.size.width, rect_screen.size.height - 64)];
    [self.view addSubview:myWebView];
//    [iWebView setBackgroundColor:[UIColor clearColor]];
    
    [self loadDocument:@"FristJqueryMobile.html"];
}

-(void)loadDocument:(NSString *)docName
{
//    本地测试
    NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
    NSString *path=[mainBundleDirectory stringByAppendingPathComponent:docName];
    
    NSURL *url=[NSURL fileURLWithPath:path];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
//  远程
//    NSURL * url = [NSURL URLWithString:docName];
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    [myWebView loadRequest:request];
}

-(void)goToBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ==== UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"请稍后重试。"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alterview show];
    [alterview release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
