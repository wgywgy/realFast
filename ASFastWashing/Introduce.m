//
//  Introduce.m
//  快洗
//
//  Created by yuyang-pc on 12-11-26.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "Introduce.h"
#import "PersonalCenter.h"
#import "ASRevealViewController.h"
#import "ASMenuViewController.h"
#import "ASRegisterViewController.h"
#import "Weather.h"
#import "StoreList.h"
#import "ASLogViewController.h"

#import <QuartzCore/QuartzCore.h>
@interface Introduce ()

@end

@implementation Introduce
@synthesize myScrollView;
@synthesize myPageControl;
@synthesize LogoInBtn;
@synthesize StoreListBtn;


-(void)dealloc
{
    [LogoInBtn release];
    [StoreListBtn release];
    [myScrollView release];
    [myPageControl release];
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
    myPageControl.numberOfPages = 5;
    myPageControl.currentPage = 0;
    myScrollView.contentSize = CGSizeMake(self.view.bounds.size.width*5, 460);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)LogoIn:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//    [self.myPageControl setHidden:YES];
//    [self.StoreListBtn setHidden:YES];
//    [self.LogoInBtn setHidden:YES];
    
    ASRevealViewController* logoIn = [[[ASRevealViewController alloc]initWithNibName:@"ASRegisterViewController" bundle:nil] autorelease];
    [self presentViewController:logoIn animated:NO completion:nil];
}
-(IBAction)StoreList:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//    [self.myPageControl setHidden:YES];
//    [self.StoreListBtn setHidden:YES];
//    [self.LogoInBtn setHidden:YES];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.38;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionFade;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    NSLog(@"%@",sender.superview);

    StoreList *storeList = [[[StoreList alloc]initWithNibName:@"View" bundle:nil] autorelease];
    [self presentViewController:storeList animated:NO completion:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageWidth=self.view.bounds.size.width;
    int page=scrollView.contentOffset.x/pageWidth;
    myPageControl.currentPage = page;
}
@end
