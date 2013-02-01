//
//  ASBaseShareViewController.h
//  ASFastWashing
//
//  Created by D on 12-12-5.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"

@class TCWBEngine;

@interface ASBaseShareViewController : UIViewController
                                    <WBEngineDelegate, WBSendViewDelegate,
                                    RenrenDelegate,
                                    UIAlertViewDelegate>
{
    TCWBEngine                  *weiboEngine;
    UIActivityIndicatorView     *indicatorView;
    UIButton                    *btnLogout;
}

//QQ
@property (nonatomic, retain) TCWBEngine * weiboEngine;
//@property (nonatomic, retain) UIButton * logInBtnOAuth;
@property (nonatomic, retain) IBOutlet UIButton *logInBtnOAuth;

- (void)showAlertMessage:(NSString *)msg;

//sina
@property (nonatomic , retain) WBEngine *weiBoEngine;
@property (nonatomic , retain) WBSendView * sendView;
- (IBAction)sinaBtnPressed:(id)sender;

//renren
@property (nonatomic , retain) Renren *renren;
-(void)shareRenForSongs;

@end
