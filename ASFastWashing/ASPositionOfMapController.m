//
//  ASPositionOfMapController.m
//  ASFastWashing
//
//  Created by Hao on 12/20/12.
//  Copyright (c) 2012 SSD. All rights reserved.
//

#import "ASPositionOfMapController.h"
#import "ASCommitImageController.h"

@interface ASPositionOfMapController ()

@end

@implementation ASPositionOfMapController
@synthesize dicTwo = _dicTwo;

-(void)dealloc
{
    [_dicTwo release];
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
    //self.navigationItem.leftBarButtonItem.title = @"上一步";
    
    UIButton * right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 35)];
    [right setTitle:@"下一步" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [right setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    [right addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    [right release];
    
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 35)];
    [left setTitle:@"上一步" forState:UIControlStateNormal];
    left.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [left setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [left release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)next
{
    ASCommitImageController *comm = [[ASCommitImageController alloc]init];
    [self.navigationController pushViewController:comm animated:YES];
    [comm release];
}

-(void)goToBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
