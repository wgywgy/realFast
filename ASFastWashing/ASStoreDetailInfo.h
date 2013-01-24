//
//  ASViewController.h
//  DetilDemo11
//
//  Created by Hao on 12/5/18.
//  Copyright (c) 2018 Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRequestDelegate.h"
#import "myScrollView.h"

#import "WBEngine.h"
#import "WBSendView.h"



@class ASRequest;
@class touchView;
@class JPStupidButton;

@interface ASStoreDetailInfo : UIViewController<UITableViewDataSource,UITableViewDelegate,ASRequestDelegate,
                                                myScrollViewDatasource,UIActionSheetDelegate,
                                                WBEngineDelegate, WBSendViewDelegate,
                                                RenrenDelegate,
                                                UIAlertViewDelegate>
{
    
    NSDictionary * store;
    NSString * shopId;
    NSString * shopTelPhone;
    BOOL isIntheLocal;  //是否已经收藏在了本地
    double ShopAveGrade; //商店评分
    
    UIActivityIndicatorView     *indicatorView;
    UIButton                    *btnLogout;
}

@property (retain, nonatomic) NSDictionary * store;
@property (retain, nonatomic) ASRequest * request;
@property (retain, nonatomic) NSArray * couponImages;

@property (retain, nonatomic) IBOutlet UIImageView *shopImage; //商店图片
@property (retain, nonatomic) IBOutlet UIButton *mapButton;   //相应地图的button
@property (retain, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)showShopIntro:(id)sender;
- (IBAction)showShopEvaluate:(id)sender;

@property (copy, nonatomic) NSString * shopId;

@property (copy, nonatomic) NSString * shopTelPhone;

@property (copy, nonatomic) NSString *ShopName;

@property (retain, nonatomic) NSString *ShopIntro;

@property (retain, nonatomic) IBOutlet JPStupidButton *telButton;


//打电话
-(IBAction)telphone:(id)sender;

//sina
@property (nonatomic , retain) WBEngine *weiBoEngine;
@property (nonatomic , retain) WBSendView * sendView;
- (IBAction)sinaBtnPressed:(id)sender;

//renren
@property (nonatomic , retain) Renren *renren;
-(void)shareRenForSongs;

@end
