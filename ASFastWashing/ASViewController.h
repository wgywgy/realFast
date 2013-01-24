//
//  ASViewController.h
//  WYYShareTest
//
//  Created by Parker on 12-11-23.
//  Copyright (c) 2012年 河北师范大学软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBEngine.h"
#import "WBSendView.h"

@interface ASViewController : UIViewController
<WBEngineDelegate ,WBSendViewDelegate> 

@property (nonatomic , retain) WBEngine *weiBoEngine;
@property (nonatomic , retain) WBSendView * sendView;
- (IBAction)sinaBtnPressed:(id)sender;
@end
