//
//  Help.m
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "Help.h"
#import "ASHelpScrollVIew.h"
#import "URL.h"

#define kTelNum @"15131198768"
@interface Help ()

@end

@implementation Help

//@synthesize myButton;

-(void)dealloc
{
    //[myButton release];
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
-(void)wrongButtonPress
{
    for (UIButton * aButton in self.navigationController.navigationBar.subviews) {
        if (aButton.tag == 110) {
            [aButton removeFromSuperview];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIImage* returnButtonImage = [UIImage imageNamed:@"wrong.png"];
    UIButton* returnButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 2, 40, 40)];
    [returnButton setImage:returnButtonImage forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(wrongButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [returnButton setTag:110];
    [self.navigationController.navigationBar addSubview:returnButton];
    [returnButton release];
    

//    CGRect myButtonRect = CGRectMake(12, 355, 296, 44);
//    myButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    myButton.frame = myButtonRect;
//    [myButton setTitle:kTelNum forState:UIControlStateNormal];
//    [myButton setImage:[UIImage imageNamed:@"call.png"]  forState:UIControlStateNormal];
//    [myButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 250)];
//    
//    [myButton setTitle:@"正在呼叫" forState:UIControlStateHighlighted];
//    myButton.titleLabel.font = [UIFont systemFontOfSize:30.0f];
//    [myButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    //[myButton titleRectForContentRect:CGRectMake(66, 0, 162, 44)];
//    [myButton addTarget:self action:@selector(callMe:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:myButton];
    
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(200, 0, 120, 50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont systemFontOfSize:25.0]];
    [titleText setText:@"FastWash"];
    self.navigationItem.titleView=titleText;
    [titleText release];
    

    
    CGRect rect = CGRectMake(12, 8, 296, 400);
    ASHelpScrollVIew *ScrollView = [[ASHelpScrollVIew alloc] initWithFrame:rect];
    ScrollView.datasource = self;
    [self.view addSubview:ScrollView];
    [ScrollView release];
    
//    //请求网络数据
//    request = [[ASRequest alloc]initWithRequest:nil andURL:@"telephone.php"];
//    [request setDelegate:self];
//    [request startConnectInternet];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark myScrollView Delegate

- (NSInteger)numberOfPages
{
    return 5;
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    NSString * url;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 296, 400)];
    switch (index) {
        case 0:
             url = [[NSBundle mainBundle] pathForResource:@"9" ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:url];
            break;
        case 1:
            url = [[NSBundle mainBundle] pathForResource:@"10" ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:url];
            break;
        case 2:
            url = [[NSBundle mainBundle] pathForResource:@"12" ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:url];
            break;
        case 3:
            url = [[NSBundle mainBundle] pathForResource:@"14" ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:url];
            break;
        case 4:
            url = [[NSBundle mainBundle] pathForResource:@"17" ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:url];
            break;
        default:
            break;
    }
    
return [imageView autorelease];
    
}

/*
 功能：当数据接收完以后调用
 */
//-(void)requestDidFinishLoading
//{
//    NSLog(@"%@,%@",[request.result class],request.result);
//    NSString* telePhone = [request.result objectForKey:@"telePhone"];
//   
//    if ([telePhone isEqualToString:kTelNum]) {
//         [myButton setTitle:kTelNum forState:UIControlStateNormal];
//    }
//    else
//    {
//         [myButton setTitle:telePhone forState:UIControlStateNormal];
//    }
//   
//}
/*
 功能：当数据接收出错以后调用
 */
//-(void)requestDidFailWithError
//{
//    NSLog(@"error favorites");
//}

/*
 功能：联系我们
 */

//-(IBAction)callMe:(id)sender
//{
//    UIWebView*callWebview =[[UIWebView alloc] init];
//    //调用系统电话
//    NSString* tel = [request.result objectForKey:@"telePhone"];
//    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",tel]];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    [self.view addSubview:callWebview];
//    [callWebview release];
//}
@end
