//
//  ASDropDown.h
//  快洗
//
//  Created by D on 12-11-19.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDropDown : UIView <UITableViewDataSource, UITableViewDelegate>
{
    //下拉列表
    UITableView * tv;
    //列表数据
    NSArray * tableArray;
//    UITextField * textField;
    //按钮
    UIButton * selectBtn;
    //是否弹出列表
    BOOL isListShow;
    //第二次点击
    BOOL secondClick;
    //table的高度
    CGFloat tableHeight;
    //frame的高度
    CGFloat frameHeight;
}

@property (nonatomic, retain) UITableView * tv;
@property (nonatomic, retain) NSArray * tableArray;
@property (nonatomic, retain) UIButton * selectBtn;
//@property (nonatomic, retain) UITextField * textField;

@end
