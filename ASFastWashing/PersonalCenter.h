//
//  PersonalCenter.h
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRequestDelegate.h"
@class ASRequest;
@class ASUser;

typedef void (^RevealBlock)();
@interface PersonalCenter : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ASRequestDelegate>
{
    UITextField *myTextField;
    ASRequest *request;
    ASUser *loginUser;
@private
	RevealBlock _revealBlock;
}
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock;

@property (strong, nonatomic) IBOutlet UIButton *registeredButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) UITextField *myTextField;
@property (retain, nonatomic) ASUser *loginUser;
@end
