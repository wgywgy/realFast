//
//  ShopIntroduction.m
//  ASFastWashing
//
//  Created by Hao on 12/16/12.
//  Copyright (c) 2012 SSD. All rights reserved.
//

#import "ShopIntroduction.h"

@interface ShopIntroduction ()
{

}
@end

@implementation ShopIntroduction
@synthesize textView = _textView , shopName = _shopName;
@synthesize introduction = _introduction;

-(void)dealloc
{
    [_textView release];
    [_introduction release];
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
    self.title = _shopName;
    
    rect_screen = [[UIScreen mainScreen]bounds];

    _textView.text = _introduction;
    
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    [left setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [left release];
    
    //背景图片
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(18, 24, 284, (rect_screen.size.height-93))];
    
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

/*
 功能：返回上一个界面
 */
-(void)goToBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
