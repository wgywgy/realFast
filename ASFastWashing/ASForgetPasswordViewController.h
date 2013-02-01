//
//  ASForgetPasswordViewController.h
//  快洗
//
//  Created by SSD on 12-11-20.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRequestDelegate.h"
@class ASUser;
@class ASRequest;
@interface ASForgetPasswordViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ASRequestDelegate>
{
    UIPickerView *pickerView;
    NSArray *secretQuestion;
    UITextField *myTextField;
    CGRect rect_screen;
    ASUser *user;
    ASRequest *request;
}
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) UIPickerView *pickerView;
@property (retain, nonatomic) NSArray *secretQuestion;
@property (retain, nonatomic) UITextField *myTextField;
@property (retain, nonatomic) ASUser *user;
@end
