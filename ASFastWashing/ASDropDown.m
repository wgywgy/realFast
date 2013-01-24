//
//  ASDropDown.m
//  快洗
//
//  Created by D on 12-11-19.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASDropDown.h"
#import <QuartzCore/QuartzCore.h>

@implementation ASDropDown
@synthesize tv = _tv,
            tableArray = _tableArray,
            selectBtn = _selectBtn;

- (void)dealloc
{
    [_tv release];
    [_tableArray release];
    [_selectBtn release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    frameHeight = 95;
    tableHeight = frameHeight;
    frame.size.height = 32.0f;
    
    if (self = [super initWithFrame:frame]) {
        isListShow = NO;
        secondClick = NO;
        
        self.tv = [[[UITableView alloc]initWithFrame:CGRectMake(0, 32, frame.size.width, 0)]autorelease];
        self.tv.delegate = self;
        self.tv.dataSource = self;
//        self.tv.backgroundColor = [UIColor grayColor];
        self.tv.separatorColor = [UIColor lightGrayColor];
        self.tv.hidden = YES;
        //TableView 不能滚动
        self.tv.bounces = NO;
        //bug
//        [self.tv setAlpha:0.7];
        
//        self.tv.layer.shadowOffset = CGSizeMake(0, 3);
//        self.tv.layer.shadowOpacity = 0.7;
//        self.tv.layer.shouldRasterize = YES;
        
        UIImage * listBackground =
        [[UIImage alloc] initWithContentsOfFile:
          [[NSBundle mainBundle]pathForResource:@"listBg" ofType:@"png"]];
        [listBackground resizableImageWithCapInsets:UIEdgeInsetsMake(2, 10, 2, 10)];
        
        UIImageView * listBgView = [[UIImageView alloc]initWithImage:listBackground];
        listBgView.frame = CGRectMake(0, 0,
                                      110, 95);
        listBgView.contentMode = UIViewContentModeScaleToFill;
        
        self.tv.backgroundView = listBgView;
        self.tv.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.tv];

        //增加UIButton
        self.selectBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 32)]autorelease];
        UIImage * BtnBackground = [UIImage imageNamed:@"button.png"];
        [self.selectBtn setTitle:@"按距离排序" forState:UIControlStateNormal];
        self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.selectBtn setBackgroundImage:BtnBackground forState:UIControlStateNormal];
        [self.selectBtn addTarget:self action:@selector(dropDown) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectBtn];
    }
    return self;
}

- (void)dropDown
{
    [self.selectBtn resignFirstResponder];
    //显示list
    if (isListShow) {
        //改变按钮状态
        if ((secondClick = ~secondClick))
        {
            isListShow = NO;
            self.tv.hidden = YES;
            
            CGRect sf = self.frame;
            sf.size.height = 32;
            self.frame = sf;
            
            CGRect frame = self.tv.frame;
            frame.size.height = 0;
            self.tv.frame = frame;
            secondClick = NO;
        }
        
    } else {
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        //把dropDownList放到前面，防止被其他控件遮住
        [self.superview bringSubviewToFront:self];
        self.tv.hidden = NO;
        isListShow = YES;
        
        CGRect frame = self.tv.frame;
        frame.size.height = 0;
        self.tv.frame = frame;
        frame.size.height = tableHeight;
        [UIView  beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];

        self.frame = sf;
        self.tv.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]autorelease];
    }
    
    cell.textLabel.text = [self.tableArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

//设置tableviewcell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectBtn setTitle:[self.tableArray objectAtIndex:indexPath.row]
                    forState:UIControlStateNormal];
    isListShow = NO;
    self.tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 32;
    self.frame = sf;
    
    CGRect frame = self.tv.frame;
    frame.size.height = 0;
    self.tv.frame = frame;
}

@end
