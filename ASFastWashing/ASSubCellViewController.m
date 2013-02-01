//
//  ASSubCellViewController.m
//  ASFastWashing
//
//  Created by yuyang-pc on 13-1-16.
//  Copyright (c) 2013年 SSD. All rights reserved.
//

#import "ASSubCellViewController.h"

@interface ASSubCellViewController ()

@end

@implementation ASSubCellViewController
@synthesize logView;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tmall_bg_furley.png"]];
    UIView* subCell = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)]autorelease];
    subCell.backgroundColor = [UIColor clearColor];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    callBtn.frame = CGRectMake(15, 8, 80, 44);
    [callBtn addTarget:self.logView
                action:@selector(callMe:)
  forControlEvents:UIControlEventTouchUpInside];
    [callBtn setTitle:@"打电话" forState:UIControlStateNormal];

    [subCell addSubview:callBtn];
    
    
    
    UIButton *eBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [eBt setTitle:@"去评价" forState:UIControlStateNormal];
    eBt.frame = CGRectMake(225, 8, 80, 44);
    [eBt addTarget:self.logView
                action:@selector(goEvaluate:)
      forControlEvents:UIControlEventTouchUpInside];
   [subCell addSubview:eBt];
    
    
    [self.view addSubview:subCell];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
