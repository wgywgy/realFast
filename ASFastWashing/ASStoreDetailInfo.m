//
//  ASViewController.m
//  DetilDemo11
//
//  Created by Hao on 12/5/18.
//  Copyright (c) 2018 Hao. All rights reserved.
//

#import "ASStoreDetailInfo.h"
#import "UIImageView+WebCache.h"
#import "ASRequest.h"
#import "myScrollView.h"
#import "ASUser.h"
#import "URL.h"
#import "ShopIntroduction.h"
#import "ASUserEvalution.h"
#import "JPStupidButton.h"
#import "ASShopLocationController.h"

//sina
#import "WBEngine.h"
#import "WBSendView.h"

#define kWBSDKDemoAppKey @"2740796968"
#define kWBSDKDemoAppSecret @"db71188d8c4ea4badb350df899650eea"

//renren
#define DEBUG 1

@interface ASStoreDetailInfo ()

@end

@implementation ASStoreDetailInfo

@synthesize shopId = _shopId;
@synthesize request = _request;
@synthesize couponImages = _couponImages;
@synthesize ShopName = _ShopName;
@synthesize ShopIntro = _ShopIntro;
@synthesize telButton = _telButton;
@synthesize shopTelPhone = _shopTelPhone;
@synthesize myTableView = _myTableView;
@synthesize store = _store;

@synthesize weiBoEngine = _weiBoEngine;
@synthesize sendView = _sendView;
@synthesize renren = _renren;

-(void)dealloc
{
    [_store release];
    [_couponImages release];
    [_myTableView release];
    [_shopTelPhone release];
    [_shopImage release];
    [_mapButton release];
    [_shopId release];
    [_telButton release];
    [_request release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //请求网络数据
        NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId", nil];
    
        _request = [[ASRequest alloc]initWithRequest:dic andURL:ShopDetailInfo];
        [_request setDelegate:self];
        [_request startConnectInternet];
    
        [dic release];
    
    ////////////////
    
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    [left setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [left release];
    //自定义navigationItem  --- 分享按钮和收藏按钮
    
    
    UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    UIImage  * ShareIcon   = [UIImage imageNamed:@"分享.png"];
    UIButton * ShareButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 6, 30, 30)];
    [ShareButton setBackgroundImage:ShareIcon forState:UIControlStateNormal];
    [ShareButton addTarget:self action:@selector(clickShareButton)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIImage  * FavoriteIcon   = [UIImage imageNamed:@"收藏.png"];
    UIButton * FavoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(48, 6, 30, 30)];
    if ([self isInTheLocal:_shopId]) {
        [FavoriteButton setBackgroundImage:[UIImage imageNamed:@"收藏1.png"] forState:UIControlStateNormal];
    }else
    {
     [FavoriteButton setBackgroundImage:FavoriteIcon forState:UIControlStateNormal];
    }
    [FavoriteButton addTarget:self action:@selector(clickFavoriteButton:)
        forControlEvents:UIControlEventTouchUpInside];

    [myView addSubview:ShareButton];
    [myView addSubview:FavoriteButton];
    
    [ShareButton release];
    [FavoriteButton release];

    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:myView];
    self.navigationItem.rightBarButtonItem = myBtn;
    
    [myBtn release];
    [myView release];
    
    self.title = _ShopName;
    
    _ShopIntro =[[NSString alloc]initWithFormat:@"暂无介绍"];
    
    //////////////////////////////////////
    //商店图片
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 12, 300, 100)];
	view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	view.layer.contents = (id)_shopImage.image.CGImage;
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
    
    _ShopIntro = [[NSString alloc]init];
    
    _myTableView.layer.shadowOffset = CGSizeMake(0, 2);
    _myTableView.layer.shadowOpacity = 0.62;
    _myTableView.layer.shadowRadius = 4;
   
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!_telButton) {
        _telButton = [[JPStupidButton alloc]initWithFrame:CGRectMake(10, 352, 300, 43)];
        
        _telButton.titleLabel.text = _shopTelPhone;
        
        [_telButton addTarget:self action:@selector(telphone:) forControlEvents:UIControlEventTouchUpInside];
        
        [_telButton setupLayers];
        
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"i电话.png"]];
        image.frame = CGRectMake(32, 12, 24, 24);
        [_telButton addSubview:image];
        [image release];
        [self.view addSubview:_telButton];
    }
}

/*
 功能：去往地图界面
 */
- (IBAction)gotoMapView:(id)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.43];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    ASShopLocationController * mapViewCtrl = [[ASShopLocationController alloc]init];
    mapViewCtrl.shopName = _ShopName;
    mapViewCtrl.shopTel = _shopTelPhone;
    mapViewCtrl.shopLocationX = [_store objectForKey:@"ShopPosX"];
    mapViewCtrl.shopLocationY = [_store objectForKey:@"ShopPosY"];
    [self.navigationController pushViewController:mapViewCtrl animated:NO];
    [mapViewCtrl release];
}

/*
 功能：返回上一个界面
 */
-(void)goToBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 功能：分享商店
 */
-(void)clickShareButton
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"微博分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"新浪微博分享" otherButtonTitles:@"人人微博分享", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //新浪微博分享
        [self sinaBtnPressed:nil];
    }else if(buttonIndex == 1){
        //人人微博分享
        [self renrenBtnPressed:nil];
    }
}

/*
 功能：收藏商店
 */
-(IBAction)clickFavoriteButton:(id)sender
{
    //收藏按钮
    [self isInTheLocal:_shopId];
    UIButton * FavoriteButton = (UIButton*)sender;
    
    if (isIntheLocal) {
        //取消收藏
        [FavoriteButton setBackgroundImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
        
        [self CancelTheCollection];
        
        NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId",@"-1",@"method",nil];
        
        _request = [[ASRequest alloc]initWithRequest:dic andURL:CollectionShop];
        [_request startConnectInternet];
        
        [dic release];
        
        isIntheLocal = NO;
        
    } else {
        [self SaveShopToLocal]; //收藏商店
        
        [FavoriteButton setBackgroundImage:[UIImage imageNamed:@"收藏1.png"] forState:UIControlStateNormal];
        
        NSDictionary * value = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId",@"+1",@"method",nil];
        _request = [[ASRequest alloc]initWithRequest:value andURL:CollectionShop];
        [_request startConnectInternet];
        [value release];
        
        isIntheLocal = YES;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark touchDetailDelegate

/*
 功能：打电话
 */
-(IBAction)telphone:(id)sender
{
//    NSString *deviceType = [UIDevice currentDevice].model;
//    
//    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
//        
//         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不能打电话" delegate:nil cancelButtonTitle:@"好的,知道了" otherButtonTitles:nil,nil];
//         
//         [alert show];
//         [alert release];
//        return;
//        
//    }else {
    
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString * nowTime = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    NSDictionary * dic;
    if(readuser.userId)
    {
        dic = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId",nowTime,@"OrderDate",readuser.userId,@"UserId",nil];
    }
    else
    {
        dic = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId",nowTime,@"OrderDate",nil];
    }
    
    //插入一条订单记录
    
    NSLog(@"%@",dic);
    _request = [[ASRequest alloc]initWithRequest:dic andURL:CreateOrder];
    [_request startConnectInternet];
    [dic release];
    
    //使拨打完电话后返回应用
    UIWebView*callWebview =[[UIWebView alloc] init];
    //调用系统电话
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[_store objectForKey:@"ShopTel"]]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    [callWebview release];
    //保存最近联系记录
    [self RecentConnectShop:nowTime];
        
    }
    
//}

#pragma mark ASRequestDelegate

/*
 功能：当数据接收完以后调用
 */
-(void)requestDidFinishLoading
{
    NSLog(@"%@",_request.result);
    
    if ([[_request.result objectForKey:@"ERROR"]isEqualToString:@"NO"])
    {
        return;
    }else
    {
        _store = [[NSDictionary alloc]initWithDictionary: _request.result];
    }
    
    _ShopIntro = [_request.result objectForKey:@"ShopIntro"];

    [_mapButton setTitle:[_request.result objectForKey:@"ShopAddr"] forState:UIControlStateNormal];
    
    NSString * imageName = [_request.result objectForKey:@"ShopImage"];
    

    NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@",Ip,imageName]];
        
    [_shopImage setImageWithURL:url];
    
    [url release];
    
    if (![[_request.result objectForKey:@"ShopCoupon"]isEqualToString:@""]) {
        
        NSString * images = [_request.result objectForKey:@"ShopCoupon"];
        _couponImages = [[images componentsSeparatedByString:@"@"]retain];
        
        CGRect rect = CGRectMake(10, 121, 300, 90);
        myScrollView *ScrollView = [[myScrollView alloc] initWithFrame:rect];
        ScrollView.datasource = self;
        
        ScrollView.layer.shadowOffset = CGSizeMake(0, 2);
        ScrollView.layer.shadowOpacity = 0.62;
        ScrollView.layer.shadowRadius = 4;
        
        [self.view addSubview:ScrollView];
        [ScrollView release];
    }else
    {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 121, 300, 90)];
        image.image = [UIImage imageNamed:@"暂无优惠信息.png"];
        [self.view addSubview:image];
        [image release];
    }
    
    ShopAveGrade = [[_request.result objectForKey:@"ShopAveGrade"]doubleValue];
    
    [_myTableView reloadData];
 

}
/*
 功能：当数据接收出错以后调用
 */
-(void)requestDidFailWithError
{
    NSLog(@"error favorites");
    _store = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId",_ShopName,@"ShopName",_shopTelPhone,@"ShopTel", nil];
}

#pragma mark myScrollView Delegate

- (NSInteger)numberOfPages
{
    return [_couponImages count]-1;
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    NSLog(@"%@",_couponImages);
    NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@/%@",Ip,[_couponImages objectAtIndex:0],[_couponImages objectAtIndex:index+1]]];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 90)];
    [imageView setImageWithURL:url];
    [url release];
    return [imageView autorelease];
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([indexPath row]==0) {
//        return 60;
//    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString * SectionsTableIdentifier = @"tableCellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SectionsTableIdentifier]autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (row==0) {
        cell.textLabel.text = @"商店介绍";
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.text = _ShopIntro;
        if (cell.detailTextLabel.text.length>30) {
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0];
        }
    }else
    {
        cell.textLabel.text = @"用户评价";
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.text = @"                        ";
    
        if (ShopAveGrade!=0) {
            
            int aveGrade = (int)(ShopAveGrade!=0?ShopAveGrade:1);
            
            UIImageView*  starImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 33, 17, 17)];
            UIImageView*  starImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(29, 33, 17, 17)];
            UIImageView*  starImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(48, 33, 17, 17)];
            UIImageView*  starImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(67, 33, 17, 17)];
            UIImageView*  starImageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(86, 33, 17, 17)];
            
            NSString* emptyImageUrl = [[NSBundle mainBundle] pathForResource:@"star" ofType:@"png"];
            NSString* fullImageUrl = [[NSBundle mainBundle]pathForResource:@"star_highlighted" ofType:@"png"];
            NSString* halfImageUrl = [[NSBundle mainBundle]pathForResource:@"star_half" ofType:@"png"];
            [starImageView1 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            [starImageView2 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            [starImageView3 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            [starImageView4 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            [starImageView5 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            switch (aveGrade) {
                case 1:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    if (ShopAveGrade>1) {
                        [starImageView2 setImage:[UIImage imageWithContentsOfFile:halfImageUrl]];
                    }
                    break;
                case 2:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    [starImageView2 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    if (ShopAveGrade>2) {
                        [starImageView3 setImage:[UIImage imageWithContentsOfFile:halfImageUrl]];
                    }
                    break;
                    
                case 3:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView2 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView3 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    if (ShopAveGrade>3) {
                        [starImageView4 setImage:[UIImage imageWithContentsOfFile:halfImageUrl]];
                    }
                    break;
                    
                case 4:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView2 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView3 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView4 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    if (ShopAveGrade>4) {
                        [starImageView5 setImage:[UIImage imageWithContentsOfFile:halfImageUrl]];
                    }
                    break;
                    
                case 5:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView2 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView3 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView4 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView5 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    break;
                    
                default:
                    break;
            }
            [cell.contentView addSubview:starImageView1];
            [starImageView1 release];
            [cell.contentView addSubview:starImageView2];
            [starImageView2 release];
            [cell.contentView addSubview:starImageView3];
            [starImageView3 release];
            [cell.contentView addSubview:starImageView4];
            [starImageView4 release];
            [cell.contentView addSubview:starImageView5];
            [starImageView5 release];

        }else
        {
            cell.detailTextLabel.text = @"暂无评价";
        }

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //去除选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath row]==0) {
        [self showShopIntro:nil];
    }else
    {
        [self showShopEvaluate:nil];
    }
}


#pragma mark ASUserDefault

//保存最近联系
- (void)RecentConnectShop:(NSString *)nowTime
{
    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
    
    NSArray * ShopData = [preferences objectForKey:@"RecentConnect"];
    if (ShopData) {
        NSMutableArray * data = [NSMutableArray arrayWithArray:ShopData];

        NSDictionary * shop = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId",_ShopName,@"ShopName",nowTime,@"CallTime",_shopTelPhone,@"ShopTel",[_store objectForKey:@"ShopImage"],@"ShopLogo",nil];
        [data addObject:shop];
        [shop release];
        [preferences setObject:data forKey:@"RecentConnect"];
    }
    else
    {
        NSDictionary * shop = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId",_ShopName,@"ShopName",nowTime,@"CallTime",_shopTelPhone,@"ShopTel",[_store objectForKey:@"ShopImage"],@"ShopLogo",nil];
        NSArray * data = [[NSArray alloc]initWithObjects:shop, nil];
        [preferences setObject:data forKey:@"RecentConnect"];
        [data release];
        [shop release];
    }
    [preferences synchronize];
    
}

- (void)CancelTheCollection   //取消收藏
{
    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
    
    NSArray * ShopData = [preferences objectForKey:@"LocalShop"];
    if (ShopData) {
        NSMutableArray * shop = [NSMutableArray arrayWithArray:ShopData];
        for (NSDictionary * object in shop) {
            NSLog(@"%@",[object objectForKey:@"ShopId"]);
            if ([[object objectForKey:@"ShopId"]isEqualToString:_shopId])
            {
                [shop removeObject:object];
                break;
            }
        }
        
        [preferences setObject:shop forKey:@"LocalShop"];
    }
    [preferences synchronize];
    
}

//判断商店是否已经被收藏
- (BOOL)isInTheLocal:(NSString * )ID
{
    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
    
    NSArray * ShopData = [preferences objectForKey:@"LocalShop"];
    if (ShopData) {
        for (NSDictionary * object in ShopData) {
            NSLog(@"%@",[object objectForKey:@"ShopId"]);
            if ([[object objectForKey:@"ShopId"]isEqualToString:ID])
            {
                //收藏夹里已经收藏了这个商店
                NSLog(@"%@",[object objectForKey:@"ShopId"]);
                isIntheLocal = YES;
                return YES;
            }
        }
        isIntheLocal = NO;
        return NO;
    }
    else
    {
        isIntheLocal = NO;
        return NO;
    }
}


//商店信息保存到本地
- (void)SaveShopToLocal
{
    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];

    NSArray * ShopData = [preferences objectForKey:@"LocalShop"];
    if (ShopData) {
        NSMutableArray * data = [NSMutableArray arrayWithArray:ShopData];
        [data addObject:_store];
        [preferences setObject:data forKey:@"LocalShop"];
        NSLog(@"%@",data);
    }
    else
    {
        NSArray * data = [[NSArray alloc]initWithObjects:_store, nil];
        [preferences setObject:data forKey:@"LocalShop"];
        [data release];
    }
    [preferences synchronize];
}

////图片保存到本地 key为图片id
//- (void)SaveImageToLocal:(UIImage *)image Keys:(NSString *)key
//{
//    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
//
//    if ([preferences objectForKey:key]) {
//        return;
//    }
//    
//    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
//    
//    [preferences synchronize];
//    
//}

////判断本地是否有id为key的图片
//- (BOOL)LocalHaveImage:(NSString *)key
//{
//    if ([key isEqualToString:@""]) {
//        return NO;
//    }
//    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
//    NSData * imgData = [preferences objectForKey:key];
//    if (imgData) {
//        return YES;
//    }
//    else
//        return NO;
//}

////获得本地id为key的图片
//- (UIImage *)GetImageFromLocal:(NSString *)key
//{
//    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
//    NSData * imgData = [preferences objectForKey:key];
//    if (imgData) {
//        UIImage * image = [UIImage imageWithData:imgData];
//        return image;
//    } else {
//        NSLog(@"no local picture!");
//        return nil;
//    }
//}

- (IBAction)showShopIntro:(id)sender {
    ShopIntroduction * shopIntro = [[ShopIntroduction alloc]init];
    shopIntro.shopName = _ShopName;
    shopIntro.introduction = _ShopIntro;
    [self.navigationController pushViewController:shopIntro animated:YES];
    [shopIntro release];
}

- (IBAction)showShopEvaluate:(id)sender {
    ASUserEvalution * evaluate = [[ASUserEvalution alloc]init];
    evaluate.shopId = _shopId;
    [self.navigationController pushViewController:evaluate animated:YES];
    [evaluate release];
}

#pragma mark -- sina
- (IBAction)sinaBtnPressed:(UIButton *)sender
{
    WBEngine * engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setDelegate:self];
    [engine setRootViewController:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.weiBoEngine = engine;
    [engine release];
    
    if ([self.weiBoEngine isAuthorizeExpired]) {
        [self.weiBoEngine logIn];
    } else {
        NSString * text = [NSString stringWithFormat:@"如果发布成功，我今天下午就没有白干！%@",[NSURL URLWithString:@"http://user.qzone.qq.com/1375056099?ptlang=2052"]];
        self.sendView = [[[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey
                                                  appSecret:kWBSDKDemoAppSecret
                                                       text:text
                                                      image:[UIImage imageNamed:@"1.png"]]
                         autorelease];
        self.sendView.delegate = self;
        [self.sendView show:YES];
        //        UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"hello" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        //        [myAlert show];
        //        [myAlert release];
    }
    if ([self.weiBoEngine isLoggedIn]) {
        sender.titleLabel.text = @"发布";
    }
}

- (void)myAlertView:(NSString *)text
{
    UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [myAlert show];
    [myAlert release];
}

#pragma mark - WBEngineDelegate Methods

// Log in successfully.
- (void)engineDidLogIn:(WBEngine *)engine
{
    NSString * text = [NSString stringWithFormat:@"如果发布成功，我今天下午就没有白干！%@",
                       [NSURL URLWithString:@"http://user.qzone.qq.com/1375056099?ptlang=2052"]];
    self.sendView = [[[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey
                                              appSecret:kWBSDKDemoAppSecret
                                                   text:text
                                                  image:[UIImage imageNamed:@"1.png"]]
                     autorelease];
    self.sendView.delegate = self;
    [self.sendView show:YES];
}

// If you try to log in with logIn or logInUsingUserID method, and
// there is already some authorization info in the Keychain,
// this method will be invoked.
// You may or may not be allowed to continue your authorization,
// which depends on the value of isUserExclusive.
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"请先登出！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登录失败！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
// Log out successfully.
- (void)engineDidLogOut:(WBEngine *)engine
{
    //    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
    //													   message:@"登出成功！"
    //													  delegate:self
    //											 cancelButtonTitle:@"确定"
    //											 otherButtonTitles:nil];
    //    [alertView setTag:100];
    //	[alertView show];
    //	[alertView release];
}
// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"请重新登录！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"requestDidSucceedWithResult: %@", result);
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"requestDidFailWithError: %@", error);
}

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"微博发送成功！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
}
- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"微博发送失败！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark --RenRen
- (IBAction)renrenBtnPressed:(id)sender
{
    //此方法授权会提示有误
    self.renren = [Renren sharedRenren];
    if (![self.renren isSessionValid]) {
        //[self shareRenForSongs];
        [self.renren authorizationWithPermisson:nil andDelegate:self];
    } else {
        //        //[self.renren logout:self];
        //        [self shareRenForSongs];
    }
    if ([self.renren isSessionValid]) {
        [self shareRenForSongs];
    }
    //    NSArray * permissions = [NSArray arrayWithObjects:@"photo_upload",@"publish_feed", nil];
    //    [self.renren authorizationWithPermisson:permissions andDelegate:self];
    
    //[self shareRenForSongs];
}
-(void)shareRenForSongs
{
    //self.renren = [Renren sharedRenren];
    NSString * text = [NSString stringWithFormat:@"大家好！祝大家今天体侧顺利过关！正在研究评论分享中……，嘿嘿，你懂得……"];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"http://share.renren.com/share/361395694/14744176443?from=web_matter",@"url",
                                 @"xxx洗衣店",@"name",
                                 //                                 @"访问我吧",@"action_name",
                                 @"http://share.renren.com/share/361395694/14744176443?from=web_matter",@"action_link",
                                 text,@"description",
                                 @"小时候的照片！",@"caption",
                                 //                                 @"http://fmn.rrimg.com/fmn060/20121112/1035/original_H63V_05f30000b5ae118d.jpg",@"image",
                                 nil];
    [self.renren dialog:@"feed" andParams:params andDelegate:self];
    //    UIImage* image = [UIImage imageNamed:@"1.png"];
    //    NSString *caption = @"这是一张测试图片";
    //    [self.renren publishPhotoSimplyWithImage:image caption:caption];
    
}
#pragma mark - Renren Delegate
/**
 * 授权登录成功时被调用,第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的 Renren 类型对象。 */
- (void)renrenDidLogin:(Renren *)renren
{
    //    [self shareRenForSongs];
#ifdef DEBUG
    NSLog(@"renren = %@",renren);
#endif
    
}
/**
 ￼6
 ￼人人网开放平台
 ￼* 授权登录失败时被调用,第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的 Renren 类型对象。 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{
#ifdef DEBUG
    NSLog(@"error = %@",error);
#endif
}

/**
 * 接口请求成功,第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的 Renren 类型对象。 * @param response 传回接口请求的响应。
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    NSLog(@"response = %@",response);
    //[renren logout:self];
}
/**
 * 用户登出成功后被调用 第三方开发者实现这个方法
 * @param renren 传回代理登出接口请求的 Renren 类型对象。 */
- (void)renrenDidLogout:(Renren *)renren
{
#ifdef DEBUG
    NSLog(@"logout renren = %@",renren);
#endif
}

@end
