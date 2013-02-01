//
//  ASRegisterViewController.h
//  快洗
//
//  Created by SSD on 12-11-12.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRequestDelegate.h"
@class ASRequest;
@class ASUser;

@interface ASRegisterViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,
UITextFieldDelegate,UIPickerViewDelegate,
UIPickerViewDataSource,UIAlertViewDelegate,ASRequestDelegate>
{
    BOOL statusOfAgree;
    UITextField *myTextField;
    UIPickerView *pickerView;
    NSArray *secretQuestion;
    UITableView *myTableView;
    CGRect rect_screen;
    ASRequest *request;
    ASUser *user;
}
@property (retain, nonatomic) UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UIButton *login;             //注册按钮
@property (assign, nonatomic) BOOL statusOfAgree;
@property (retain, nonatomic) UITextField *myTextField;
@property (retain, nonatomic) UIPickerView *pickerView;
@property (retain, nonatomic) NSArray *secretQuestion;
@property (retain, nonatomic) ASUser *user;
@property (assign, nonatomic) CGRect rect_screen;
@end
