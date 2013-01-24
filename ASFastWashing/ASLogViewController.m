//
//  ASLogViewController.m
//  快洗
//
//  Created by D on 12-11-27.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASLogViewController.h"
#import "ASEvaluteViewController.h"
#import "ASRevealViewController.h"
#import "ASConnectCell.h"
#import "ASEvaluate.h"
#import "ASUser.h"
#import "PersonalCenter.h"
#import "UIImageView+WebCache.h"
#import "URL.h"
#import "ASSubCellViewController.h"


@interface ASLogViewController () <UIFolderTableViewDelegate>
//@property (strong, nonatomic) ASSubCellViewController *subVc;
- (void)revealSidebar;
@end

@implementation ASLogViewController
@synthesize logList;
@synthesize myTableView;
@synthesize shopId;
@synthesize gradeRate;
@synthesize mylable;
@synthesize shopTel;
//@synthesize subVc;


- (id)initWithTitle:(NSString *)   title withRevealBlock:(RevealBlock5)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        _revealBlock = [revealBlock copy];
        UIImage * tmp = [UIImage imageNamed:@"导航按钮.png"];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
        [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:tmp forState:UIControlStateNormal];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
		self.navigationItem.leftBarButtonItem = leftBarButton;
        [leftBarButton release];
        [leftButton release];

        
	}
	return self;
}
- (void)revealSidebar {
    _revealBlock();
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)callMe:(UIButton*)btn
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    //调用系统电话
   NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",shopTel]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    [callWebview release];
}

-(IBAction)goEvaluate:(UIButton*)btn
{
    //判断是否登陆
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if (readuser.isLogin) {
        ASEvaluteViewController* detailEvaluate=[[ASEvaluteViewController alloc]init];
        [self.navigationController pushViewController:detailEvaluate animated:YES];
        [detailEvaluate release];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"您还没有登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];

}

#pragma mark -- tabview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [logList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHight = (rect_screen.size.height - 64) / 5;
    float cellWidth = 2 * (rect_screen.size.height - 64) / 15;
    static NSString * cellId = @"ASConnectCellIdentifier";
    
   
    ASConnectCell * cell =  [[[ASConnectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        //cell.opaque = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView*  starImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(cellHight * 1.2 - 6, cellWidth, 93, 17)];
    
    NSString* oneUrl = [[NSBundle mainBundle] pathForResource:@"one" ofType:@"png"];
    NSString* twoUrl = [[NSBundle mainBundle]pathForResource:@"two" ofType:@"png"];
    NSString* threeUrl = [[NSBundle mainBundle] pathForResource:@"three" ofType:@"png"];
    NSString* fourUrl = [[NSBundle mainBundle]pathForResource:@"four" ofType:@"png"];
    NSString* fiveUrl = [[NSBundle mainBundle]pathForResource:@"five" ofType:@"png"];
    
    NSInteger row=[indexPath row];
    
    //按联系时间逐个获取商家信息
    NSDictionary *recentShop = [logList objectAtIndex:[logList count] - row - 1];
    shopTel = [recentShop objectForKey:@"ShopTel"];
    
    NSString * imageName = [recentShop objectForKey:@"ShopLogo"];
    NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@",Ip,imageName]];
    //如果商家logo获取失败，用此图片代替
    NSBundle *bundle = [NSBundle mainBundle];
    NSString * placeholderImage = [bundle pathForResource:@"star" ofType:@"jpeg"];
    
    cell.shopLable.text = [recentShop objectForKey:@"ShopName"];//商家名
    cell.timeLable.text = [recentShop objectForKey:@"CallTime"];//联系时间
    [cell.logo setImageWithURL:url placeholderImage:[UIImage imageWithContentsOfFile:placeholderImage]];
    [url release];
    shopId = [recentShop objectForKey:@"ShopId"];
   
    //获取对店家的评价
    NSMutableArray* shopEvaluate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyEvaluate"];
   for (int i = [shopEvaluate count] - 1; i >= 0; i--)
    {
        NSDictionary* currentShop = [shopEvaluate objectAtIndex:i];
        NSString* currentShopId = [currentShop objectForKey:@"ShopId"];
        if (shopId == currentShopId)
        {
            gradeRate = [[currentShop objectForKey:@"GradeRate"]intValue];//星星个数
            break;
        }
    }

    if (gradeRate)
    {
        switch (gradeRate) {
            case 1:
                [starImageView1 setImage:[UIImage imageWithContentsOfFile:oneUrl]];
                [cell.contentView addSubview:starImageView1];
                [starImageView1 release];
                gradeRate = 0;
                break;
            case 2:
                [starImageView1 setImage:[UIImage imageWithContentsOfFile:twoUrl]];
                [cell.contentView addSubview:starImageView1];
                [starImageView1 release];
                gradeRate = 0;
                break;
            case 3:
                [starImageView1 setImage:[UIImage imageWithContentsOfFile:threeUrl]];
                [cell.contentView addSubview:starImageView1];
                [starImageView1 release];
                gradeRate = 0;
                break;
            case 4:
                [starImageView1 setImage:[UIImage imageWithContentsOfFile:fourUrl]];
                [cell.contentView addSubview:starImageView1];
                [starImageView1 release];
                gradeRate = 0;
                break;
            case 5:
                [starImageView1 setImage:[UIImage imageWithContentsOfFile:fiveUrl]];
                [cell.contentView addSubview:starImageView1];
                [starImageView1 release];
                gradeRate = 0;
                break;
            default:
                [starImageView1 release];
                break;
        }
    }
    else
    {
        [starImageView1 release];
        mylable = [[UILabel alloc]initWithFrame:CGRectMake( 1.2 * (rect_screen.size.height - 64) / 5 - 6, cellWidth, 85, 17)];
        [mylable setText:@"未评价"];
        [mylable setFont:[UIFont systemFontOfSize:10]];
        [mylable setTextColor:[UIColor grayColor]];
        mylable.backgroundColor = [UIColor clearColor];
        [mylable setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [cell.contentView addSubview:mylable];
        [mylable release];
    }
    
    //cell background
    NSString *bgImgPath = nil;
    if (indexPath.row % 2 == 0) {
        bgImgPath = [[NSBundle mainBundle] pathForResource:@"lightbg" ofType:@"png"];
    } else {
        bgImgPath = [[NSBundle mainBundle] pathForResource:@"darkbg" ofType:@"png"];
    }
    
    UIImage *bgImg = [[UIImage imageWithContentsOfFile:bgImgPath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
    
    cell.backgroundView = [[[UIImageView alloc] initWithImage:bgImg] autorelease];
    cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.backgroundView.frame = cell.bounds;
    cell.textLabel.backgroundColor = [UIColor clearColor];
   
   return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (rect_screen.size.height - 64) / 5;
}

-(void)viewWillAppear:(BOOL)animated
{
    //获取最近联系商家信息
    NSMutableArray* recentConnect  = [[NSUserDefaults standardUserDefaults] objectForKey:@"RecentConnect"];
    self.logList = [[[NSMutableArray alloc]initWithArray:recentConnect]autorelease];
    
    if ([logList count] == 0) {
        [myTableView setAlpha:0];
    }
    else
    {
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 35)];
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
        [editButton setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
        editButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        UIBarButtonItem *editbarButton = [[UIBarButtonItem alloc]initWithCustomView:editButton];
        self.navigationItem.rightBarButtonItem = editbarButton;
        [editbarButton release];
        [editButton release];

        [myTableView setAlpha:1];
        [myTableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的订单";
    rect_screen = [[UIScreen mainScreen]bounds];
    [myTableView setEditing:NO animated:YES];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"导航栏.png"];
    if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }

    //获取最近联系商家信息
    NSMutableArray* recentConnect  = [[NSUserDefaults standardUserDefaults] objectForKey:@"RecentConnect"];
    
    self.logList = [[[NSMutableArray alloc]initWithArray:recentConnect]autorelease];
    self.navigationItem.hidesBackButton = YES;
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"购物车" ofType:@"png"];
    UIView * view = [[UIView alloc]initWithFrame:self.view.frame];
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:path]];
    imageView.frame = CGRectMake( 60 , ((rect_screen.size.height - 64) / 2 ) - 130, 200, 200);
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(90 ,((rect_screen.size.height - 64) / 2 ) + 100 , 160 , 40)];
    lable.text = @"您联系记录为空";
    [lable setFont:[UIFont systemFontOfSize:22]];
    [lable setTextColor:[UIColor grayColor]];
    lable.backgroundColor = [UIColor clearColor];
    
    [view addSubview:lable];
    [view addSubview:imageView];
    [lable release];
    
    [self.view insertSubview:view atIndex:0];
    [imageView release];
    [view release];
    
    if ([logList count] == 0)
    {
        [myTableView setAlpha:0];
    }
    
   

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionEnabled)
                                                 name: @"userInteractionEnabledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionAbled)
                                                 name: @"userInteractionAbledNotice"
                                               object: nil];

}

/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：编辑收藏夹
 ****************************************/
-(IBAction)toggleEdit:(id)sender
{
    [self.myTableView setEditing:!self.myTableView.editing animated:YES];
    if (self.myTableView.editing) {
        
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
        
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 35)];
        [editButton setTitle:@"删除全部" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(removeAllConnect:) forControlEvents:UIControlEventTouchUpInside];
        [editButton setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
        editButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        UIBarButtonItem *editbarButton = [[UIBarButtonItem alloc]initWithCustomView:editButton];
        self.navigationItem.leftBarButtonItem = editbarButton;
        [editbarButton release];
        [editButton release];

    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        
        UIImage * tmp = [UIImage imageNamed:@"导航按钮.png"];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
        [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:tmp forState:UIControlStateNormal];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
		self.navigationItem.leftBarButtonItem = leftBarButton;
        [leftBarButton release];
        [leftButton release];

    }
    
}

/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：清除所有收藏的商店
 ****************************************/
-(IBAction)removeAllConnect:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"删除所有联系" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        int num = [myTableView numberOfRowsInSection:0];
        for (int i = 0; i<num; i++)
        {
            [self CancelTheConnect:0];
        }
       [myTableView reloadData];
       [myTableView setAlpha:0];
    }
}

//删除cell
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSUInteger row = [indexPath row];
        
        [self CancelTheConnect:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if ([logList count] == 0)
        {
            [myTableView setAlpha:0];
        }
        else
            [myTableView setAlpha:1];
}

- (void)CancelTheConnect:(NSInteger)row
{   
    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
    NSArray * connectData = [preferences objectForKey:@"RecentConnect"];
    if (connectData)
    {
        NSMutableArray * connectShop = [NSMutableArray arrayWithArray:connectData];
        [connectShop removeObjectAtIndex:row];
        [logList removeObjectAtIndex:row];
        [preferences setObject:connectShop forKey:@"RecentConnect"];
    }
    [preferences synchronize];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [shopTel release];
    [mylable release];
    [myTableView release];
    //[subVc release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
}


//去评价
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //保存所选店家的ID
    NSInteger row = [indexPath row];
    NSDictionary* selectShop = [logList objectAtIndex:[logList count] - row - 1];
    NSString* selectShopId = [selectShop objectForKey:@"ShopId"];
    
    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
    NSArray * EvaShopId = [preferences objectForKey:@"EvaShopId"];
        if (EvaShopId)
        {
            NSMutableArray * evaShopId = [NSMutableArray arrayWithArray:EvaShopId];
           [evaShopId addObject:selectShopId];
            [preferences setObject:evaShopId forKey:@"EvaShopId"];
        }
        else
        {
            NSArray * evaShopId = [[NSArray alloc]initWithObjects:selectShopId, nil];
            [preferences setObject:evaShopId forKey:@"EvaShopId"];
            [evaShopId release];
        }
        [preferences synchronize];
        
 
    //去除选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
     ASSubCellViewController* subVc = [[[ASSubCellViewController alloc]
                                     initWithNibName:NSStringFromClass([ASSubCellViewController class])
                                     bundle:nil] autorelease];
    
    
    self.myTableView.scrollEnabled = NO;
    UIFolderTableView *subfolderTableView = (UIFolderTableView *)tableView;
    [subfolderTableView openFolderAtIndexPath:indexPath WithContentView:subVc.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                }
                           completionBlock:^{
                               // completed actions
                               self.myTableView.scrollEnabled = YES;
                           }];

}

-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (rect_screen.size.height - 64) / 5 ;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuViewSwitchingNotice" object:self];
    }
}

- (void)userInteractionEnabled
{
    self.view.userInteractionEnabled = YES;
}
- (void)userInteractionAbled
{
    self.view.userInteractionEnabled = NO;
}

@end
