//
//  ASShopLocationController.h
//  ASFastWashing
//
//  Created by Admin on 13-1-3.
//  Copyright (c) 2013年 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ASShopLocationController : UIViewController
{
}
@property (retain, nonatomic) NSString * shopName;
@property (retain, nonatomic) NSString * shopTel;
@property (retain, nonatomic) NSString * shopLocationX;
@property (retain, nonatomic) NSString * shopLocationY;

@property (retain, nonatomic) IBOutlet MKMapView *myMapView;

@end
