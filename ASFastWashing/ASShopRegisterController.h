//
//  ASShopRegisterViewController.h
//  ASFastWashing
//
//  Created by Hao on 1/2/13.
//  Copyright (c) 2013 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"

@interface ASShopRegisterController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain)UIImageView *tableImage;
@property(nonatomic,retain)UITextField *shopName;
@property(nonatomic,retain)UITextField *shopTel;
@property(nonatomic,retain)CustomTextView *shopIntro;

@property(nonatomic,retain)NSDictionary *dic;
@end