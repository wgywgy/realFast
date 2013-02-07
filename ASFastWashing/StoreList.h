//
//  FirstViewController.h
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "NSDictionary+DeepCopy.h"
#import "ASRequest.h"
#import "ASSwitch.h"
#import "ASMyMapViewController.h"
//#import "RRSGlowLabel.h"
#import "EGORefreshTableFooterView.h"

typedef void (^RevealBlock4)();

@class DropDownList;
@interface StoreList : UIViewController
                    <UISearchBarDelegate,
                    UITableViewDataSource, UITableViewDelegate,
                    UIScrollViewDelegate,
                    ASRequestDelegate,
                    EGORefreshTableFooterDelegate,
                    CLLocationManagerDelegate,
                    MKMapViewDelegate,
                    UIGestureRecognizerDelegate>
{
    EGORefreshTableFooterView *_refreshHeaderView;
    BOOL _reloading;
    NSInteger gradeListCount;
    NSInteger distanceListCount;
    NSInteger collectListCount;
    float distanceListHeight;
    float gradeListHeight;
    float collectListHeight;
    
    NSMutableDictionary * storeName;
    NSDictionary * allStore;
    NSMutableArray * index;
    NSValue * distance;
    NSValue * grade;
    NSArray * test;
    CGRect rect_screen;
    NSMutableArray * storeDistance;
    NSMutableArray * storeGrade;
    NSMutableArray * storeCollect;
    DropDownList * drop;
    int listType;
    UITapGestureRecognizer * singleTap;
    BOOL isSelectSort;
    UIButton * left;
    UIButton * mid;
    UIButton * right;
    UIImage * unSelectImage;
    UIImage * SelectImage;
    UISearchBar *mySearchBar;
    UIImageView * select;
    UIButton * mySearchBtn;
//    UIButton * toTop;
    UIImage * glass;
    UIImage * searchBg;
    UIView * glassView;
    UIView * searchBgView;
    NSString * imageName;
    UIImage * noLogo;
    NSMutableArray * localList;
    
    UIImageView * myView;
    
    BOOL navIsHidden;
    
    CGFloat tmpY;
    BOOL second;
    BOOL isSearchView;
    
    NSString * mySearchTerm;
    NSMutableArray * searchHistory;
    
    //map location manager
    CLLocationManager * _locManager;
    NSString * locatedAt;
    
    //titleView
//    RRSGlowLabel *label;
    CLLocation * newlocation;
    
    NSString * addr;

    CGPoint beginOffset;
    CGFloat currentOffset;
    ASMyMapViewController * mapViewCtrl;
@private
    ASRequest * request;
	RevealBlock4 _revealBlock;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock4)revealBlock;
@property (retain, nonatomic) IBOutlet UIView *myView;
@property (nonatomic, retain) NSMutableArray * index;
@property (nonatomic,retain) NSArray * test;
@property (nonatomic,copy) NSMutableDictionary * storeName;
@property (nonatomic,copy) NSDictionary * allStore;
@property (nonatomic,retain) NSValue * distance;
@property (nonatomic,retain) NSValue * grade;
@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) NSMutableArray * storeDistance;
@property (retain, nonatomic) NSMutableArray * storeGrade;
@property (retain, nonatomic) NSMutableArray * storeCollect;
@property (retain, nonatomic) NSMutableArray * searchHistory;

@end
