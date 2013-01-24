//
//  ASModifyPersonalInformationViewController.h
//  ASFastWashing
//
//  Created by SSD on 12-12-8.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRequestDelegate.h"
@class ASRequest;

typedef void (^RevealBlock6)();
@interface ASModifyPersonalInformationViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ASRequestDelegate>
{
    ASRequest *request;
    UITableView *myTableView;
    UITextField *myTextField;
    CGRect rect_screen;
@private
	RevealBlock6 _revealBlock;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, assign) CGRect rect_screen;
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock6)revealBlock;
@end
