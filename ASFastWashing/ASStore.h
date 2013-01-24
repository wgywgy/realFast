//
//  ASStore.h
//  快洗
//
//  Created by D on 12-11-13.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASStore : NSObject <NSCoding>
{
    NSString * storeName;
    NSString * storeTel;
    NSString * address;
    NSString * collectNum;
    NSString * grade;
    NSString * distance;
    NSString * logo;
}

@property (nonatomic, copy) NSString * storeName;
@property (nonatomic, copy) NSString * storeTel;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * collectNum;
@property (nonatomic, copy) NSString * grade;
@property (nonatomic, copy) NSString * distance;
@property (nonatomic, copy) NSString * logo;

@end
