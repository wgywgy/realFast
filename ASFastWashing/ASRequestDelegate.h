//
//  ASRequestDelegate.h
//  ASFastWashing
//
//  Created by Admin on 12-12-3.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASRequestDelegate <NSObject>
-(void)requestDidFinishLoading;
-(void)requestDidFailWithError;
@end
