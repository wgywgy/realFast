//
//  ASEvaluate.h
//  ASFastWashing
//
//  Created by yuyang-pc on 12-12-10.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASEvaluate : NSObject <NSCoding>
{
    NSString* evaluate;
    NSString* grade;
    NSString* gradeDate;
    NSString* orderId;
    NSString* shopId;
    UIImage* myImage;
}

@property(nonatomic,retain)NSString* evaluate;
@property(nonatomic,retain)NSString* grade;
@property(nonatomic,retain)NSString* gradeDate;
@property(nonatomic,retain)NSString* orderId;
@property(nonatomic,retain)NSString* shopId;
@property(nonatomic,retain)UIImage* myImage;
@end
