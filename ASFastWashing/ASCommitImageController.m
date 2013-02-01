//
//  ASCommitImageController.m
//  ASFastWashing
//
//  Created by Hao on 12/19/12.
//  Copyright (c) 2012 SSD. All rights reserved.
//

#import "ASCommitImageController.h"

@interface ASCommitImageController ()

@end

@implementation ASCommitImageController
@synthesize dicThree = _dicThree;
@synthesize myWebView = _myWebView;
@synthesize activityIndicatorView;

-(void)dealloc
{
    [_dicThree release];
    [_myWebView release];
    [super dealloc];
}

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"注册洗衣店";
    
    //添加左上方按钮    
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 35)];
    [left setTitle:@"上一步" forState:UIControlStateNormal];
    left.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [left setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [left release];
    
    [_myWebView setFrame:[[UIScreen mainScreen] bounds]];
    _myWebView.delegate = self;
    [self loadDocument:@"ShopRegister.html"];
    //[self dismissModalViewControllerAnimated:YES];
}

-(void)loadDocument:(NSString *)docName
{
    NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
    NSString *path=[mainBundleDirectory stringByAppendingPathComponent:docName];
    
    NSURL *url=[NSURL fileURLWithPath:path];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    _myWebView.scalesPageToFit=YES;
    [_myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
