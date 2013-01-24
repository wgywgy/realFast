//
//  ASViewController.h
//  HelpingCenterDemo1
//
//  Created by WangM on 18-1-1.
//  Copyright (c) 2018年 Alpha Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Help.h"
#import "ASAboutUsViewController.h"
#import "ASShopRegisterController.h"
#import "ASRequest.h"
#import "JPStupidButton.h"
#import "SDImageCache.h"
#import "ASHelpCenterCell.h"

#define APP_ID "417187788" 
@class ASRequest;

typedef void (^RevealBlock1)();
@interface ASHelpCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ASRequestDelegate>
{
    UITableView * m_tableView;
    NSArray * m_arrayData;
    NSMutableArray * m_arraryCellValue;
    @private
	RevealBlock1 _revealBlock;
    
    //UIAlertView * m_alertViewUpdate;
    
    ASRequest * m_request;
    
    UIButton * buttonHelp;
    UIButton * buttonRegister;
    
    UIActivityIndicatorView * activityIndicatorView;
}
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock1)revealBlock;
@property(nonatomic,retain)ASAboutUsViewController * aboutUsViewController;
@property(nonatomic,retain)ASShopRegisterController * shopHelpRegisterController;
@end
