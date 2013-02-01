//
//  ASMyMapViewController.h
//  快洗
//
//  Created by D on 12-11-22.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASRequest.h"
#import "DropDownList.h"

@class Annotation;
@interface ASMyMapViewController : UIViewController
                                    <CLLocationManagerDelegate,
                                    MKMapViewDelegate,
                                    UISearchBarDelegate,
                                    ASRequestDelegate,ASSwitch >
{
    //map view
    MKMapView * myMapView;
    
    //map location manager
    CLLocationManager * _locManager;
    //pin
    MKPointAnnotation * point;
    
    CGRect rect_screen;
    
    UIActivityIndicatorView * activityView;
    
    ASRequest * request;
    
    int distance;
    
//    MapDropDown * drop;
    
    BOOL tmp;
    
    NSMutableArray * pinArray;
    
    UIGestureRecognizer * singleTap;
    
    DropDownList * Drop;
    UIButton * search;
    UIButton * locate;
    UISearchBar * mySearchBar;
    
    int myRange;
}

@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (nonatomic,retain) MKPointAnnotation * point;
@property (assign, nonatomic) BOOL tmp;

@end
