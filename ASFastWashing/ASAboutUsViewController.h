//
//  ASAboutUsViewController.h
//  ASFastWashing
//
//  Created by WangM on 12-12-19.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRequest.h"

@interface ASAboutUsViewController : UIViewController<ASRequestDelegate>
{
    ASRequest *request;
    UIButton * buttonConnectUs;
    
    CGRect rect_screen;
}

@end
