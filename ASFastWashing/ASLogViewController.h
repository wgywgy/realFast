//
//  ASLogViewController.h
//  快洗
//
//  Created by D on 12-11-27.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"

typedef void (^RevealBlock5)();
@interface ASLogViewController : UIViewController
                                <UITableViewDataSource, UITableViewDelegate,
                                  UIActionSheetDelegate,  UIAlertViewDelegate>
{
    NSMutableArray * logList;
    CGRect rect_screen;
    NSString* shopId;
    NSInteger gradeRate;
    UILabel* mylable;
    NSString* shopTel;
@private
	RevealBlock5 _revealBlock;
}
@property (retain, nonatomic) IBOutlet UIFolderTableView *myTableView;
@property (retain, nonatomic) NSMutableArray * logList;
@property (assign,nonatomic)NSString* shopId;
@property (assign,nonatomic)NSInteger gradeRate;
@property (retain,nonatomic)UILabel* mylable;
@property (retain,nonatomic)NSString* shopTel;

-(IBAction)toggleEdit:(id)sender;
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock5)revealBlock;
@end
