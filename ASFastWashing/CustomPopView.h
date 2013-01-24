//
//  CustomPopView.h
//  myMap
//
//  Created by D on 12-11-21.
//  Copyright (c) 2012年 AlphaStudio. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomPopView : MKPinAnnotationView

@property (strong, nonatomic)UIView * callView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)animateCalloutAppearance;
@end
