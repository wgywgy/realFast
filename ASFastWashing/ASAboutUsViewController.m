//
//  ASAboutUsViewController.m
//  ASFastWashing
//
//  Created by WangM on 12-12-19.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASAboutUsViewController.h"

@interface ASAboutUsViewController ()

@end

@implementation ASAboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
-(IBAction)returnHelpCenter:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    //返回帮助中心页面
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 35)];
    [left setTitle:@"帮助中心" forState:UIControlStateNormal];
    left.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [left setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    [left addTarget:self action:@selector(returnHelpCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [left release];
    
    self.title = @"关于我们";
    rect_screen = [[UIScreen mainScreen]bounds];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UILabel * label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(140, rect_screen.size.height/2-64-135, 160, 30);
    label1.text = @"快洗!";
    label1.font = [UIFont fontWithName:@"Arial" size:30.0];
    label1.textColor = [UIColor grayColor];
    
    UILabel * label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(140, rect_screen.size.height/2-64-100, 160, 30);
    label2.text = @"让生活更美好~";
    label2.font = [UIFont fontWithName:@"Arial" size:20.0];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImage * starImage = [UIImage imageNamed:@"star_highlighted@2x.png"];
    UIImageView * starImageView = [[UIImageView alloc] initWithImage:starImage];
    starImageView.frame = CGRectMake(50, rect_screen.size.height/2-64-135, 60, 60);
    
    [self.view addSubview:starImageView];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [starImageView release];
    [label1 release];
    [label2 release];
    
    
    UIView * line=[[UIView alloc]init];//在20，150的位置添加一条280像素长，1像素高的线。
    line.frame = CGRectMake(0,rect_screen.size.height/2-64,320,4);
    NSLog(@"%f",rect_screen.size.height);
    line.backgroundColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1];
    //line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    [line release];
    
    buttonConnectUs = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonConnectUs setTitle:@"联系我们" forState:UIControlStateNormal];
    buttonConnectUs.frame = CGRectMake(20, rect_screen.size.height/2-64+100, 280, 50);
    [buttonConnectUs addTarget:self action:@selector(connectUsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonConnectUs];
    [buttonConnectUs setImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
    
    [buttonConnectUs setTitle:@"正在呼叫" forState:UIControlStateHighlighted];
    buttonConnectUs.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [buttonConnectUs setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonConnectUs setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
    [buttonConnectUs setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 20)];
    //[buttonConnectUs setBackgroundColor:[UIColor grayColor]];
    [buttonConnectUs release];
    
    UILabel * label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(80, rect_screen.size.height-140, 160, 30);
    label3.text = @"萤火公司 版权所有";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont fontWithName:@"Arial" size:15];
    [self.view addSubview:label3];
    [label3 release];
    
    UILabel * label4 = [[UILabel alloc] init];
    label4.frame = CGRectMake(40, rect_screen.size.height-110, 320, 30);
    label4.text = @"Copyright © 2012 快洗. All rights reserved.";
    label4.font = [UIFont fontWithName:@"Arial" size:13];
    [self.view addSubview:label4];
    [label4 release];
    
    
    //请求网络数据
    request = [[ASRequest alloc]initWithRequest:nil andURL:@"telephone.php"];
    [request setDelegate:self];
    [request startConnectInternet];
    [request release];
}

/*
 功能：当数据接收完以后调用
 */
-(void)requestDidFinishLoading
{
    NSLog(@"%@,%@",[request.result class],request.result);
    NSString* telePhone = [request.result objectForKey:@"telePhone"];
    [buttonConnectUs setTitle:telePhone forState:UIControlStateNormal];
}
/*
 功能：当数据接收出错以后调用
 */
-(void)requestDidFailWithError
{
    NSLog(@"error favorites");
}


-(IBAction)connectUsButtonPressed:(id)sender
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    //调用系统电话
    NSString* tel = [request.result objectForKey:@"telePhone"];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",tel]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    [callWebview release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
