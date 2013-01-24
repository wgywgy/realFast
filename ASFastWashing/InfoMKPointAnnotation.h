//
//  InfoMKPointAnnotation.h
//  ASFastWashing
//
//  Created by D on 12-12-26.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface InfoMKPointAnnotation : MKPointAnnotation
{
    NSString * storeId;
    NSString * storeName;
    NSString * storeTel;
}

@property (nonatomic, retain) NSString * storeId;
@property (nonatomic, retain) NSString * storeName;
@property (nonatomic, retain) NSString * storeTel;

@end
