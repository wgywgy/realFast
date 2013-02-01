//
//  ASShareViewController.h
//  ASFastWashing
//
//  Created by D on 12-12-4.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCWBEngine;
@interface ASShareViewController : UIViewController <UIAlertViewDelegate>
{
    TCWBEngine                  *weiboEngine;
    UIActivityIndicatorView     *indicatorView;
    UIButton                    *btnLogout;
}

@property (nonatomic, retain) TCWBEngine * weiboEngine;
//@property (nonatomic, retain) UIButton * logInBtnOAuth;
@property (nonatomic, retain) IBOutlet UIButton *logInBtnOAuth;

- (void)showAlertMessage:(NSString *)msg;
@end
