//
//  ASShopLocationController.m
//  ASFastWashing
//
//  Created by Admin on 13-1-3.
//  Copyright (c) 2013年 SSD. All rights reserved.
//

#import "ASShopLocationController.h"


@interface ASShopLocationController ()

@end

@implementation ASShopLocationController
@synthesize shopName = _shopName;
@synthesize shopTel = _shopTel;
@synthesize shopLocationX = _shopLocationX;
@synthesize shopLocationY = _shopLocationY;
@synthesize myMapView = _myMapView;

- (void)dealloc
{
    [_myMapView release];
    [_shopName release];
    [_shopTel release];
    [_shopLocationX release];
    [_shopLocationY release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * listButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    
    UIImage * listIcon = [UIImage imageNamed:@"列表按钮1.png"];
    [listButton setBackgroundImage:listIcon forState:UIControlStateNormal];
    UIImage * listIconPress = [UIImage imageNamed:@"列表按钮.png"];
    [listButton setBackgroundImage:listIconPress forState:UIControlStateHighlighted];
    
    [listButton addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * listBtnItem = [[UIBarButtonItem alloc]initWithCustomView:listButton];
    self.navigationItem.leftBarButtonItem = listBtnItem;
    [listBtnItem release];
    [listButton release];
    
    //_myMapView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen]bounds].size.height -64);
    
    [self showShopLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showShopLocation
{
    MKPointAnnotation * sin = [[[MKPointAnnotation alloc]init]autorelease];
    sin.coordinate = CLLocationCoordinate2DMake([_shopLocationX doubleValue],[_shopLocationY doubleValue]);
    
    sin.title = _shopName;
    sin.subtitle = [NSString stringWithFormat:@"电话：%@",_shopTel];

    [_myMapView addAnnotation:sin];
}

/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：切换到商店详细信息界面
 ****************************************/
- (IBAction)showList:(id)sender
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.43];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidUnload {
    [self setMyMapView:nil];
    [super viewDidUnload];
}
@end
