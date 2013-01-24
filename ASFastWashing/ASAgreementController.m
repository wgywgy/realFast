//
//  ASAgreementController.m
//  ASFastWashing
//
//  Created by Hao on 1/16/13.
//  Copyright (c) 2013 SSD. All rights reserved.
//

#import "ASAgreementController.h"
#import "ASShopRegisterController.h"

@interface ASAgreementController ()
{
    CGRect rect_screen;
}
@end

@implementation ASAgreementController
@synthesize textView = _textView ;
@synthesize agree = _agree;
@synthesize cancel = _cancel;

-(void)dealloc
{
    [_textView release];
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
    rect_screen = [[UIScreen mainScreen]bounds];
    self.title = @"快洗洗衣店注册协议";
    
    //左上角返回按钮
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    [left setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [left release];
    
    //按钮背景
    UIImage *registerUp = [UIImage imageNamed:@"登陆"];
    UIImage *registerDown = [UIImage imageNamed:@"登陆按下"];
    UIImage *cancelUp = [UIImage imageNamed:@"注册"];
    UIImage *cancelDown = [UIImage imageNamed:@"注册按下"];
    [_agree setBackgroundImage:registerDown forState:UIControlStateHighlighted];
    [_agree setBackgroundImage:registerUp forState:UIControlStateNormal];
    [_cancel setBackgroundImage:cancelDown forState:UIControlStateHighlighted];
    [_cancel setBackgroundImage:cancelUp forState:UIControlStateNormal];
    
    //背景图片
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(18, 24, 284, (rect_screen.size.height-153))];
    
	view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
	view.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
	view.layer.borderWidth = 5.0;
	view.layer.shadowOffset = CGSizeMake(0, 3);
	view.layer.shadowOpacity = 0.7;
	view.layer.shouldRasterize = YES;
    
    // shadow
    UIBezierPath *path = [UIBezierPath bezierPath];
	
	CGPoint topLeft		 = view.bounds.origin;
	CGPoint bottomLeft	 = CGPointMake(0.0, CGRectGetHeight(view.bounds) + 10);
	CGPoint bottomMiddle = CGPointMake(CGRectGetWidth(view.bounds) / 2, CGRectGetHeight(view.bounds) - 5);
	CGPoint bottomRight	 = CGPointMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) + 10);
	CGPoint topRight	 = CGPointMake(CGRectGetWidth(view.bounds), 0.0);
	
	[path moveToPoint:topLeft];
	[path addLineToPoint:bottomLeft];
	[path addQuadCurveToPoint:bottomRight
				 controlPoint:bottomMiddle];
	[path addLineToPoint:topRight];
	[path addLineToPoint:topLeft];
	[path closePath];
	
	view.layer.shadowPath = path.CGPath;
	
	[self.view insertSubview:view atIndex:0];
    [view release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 功能：返回上一个界面
 */
-(void)goToBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)agree:(id)sender
{
    ASShopRegisterController *shopRegister = [[ASShopRegisterController alloc]init];
    [self.navigationController pushViewController:shopRegister animated:YES];
    [shopRegister release];
}

-(void)disAgree:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
