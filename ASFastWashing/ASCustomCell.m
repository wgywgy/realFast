//
//  myCell.m
//  主题拨号
//
//  Created by Admin on 12-10-17.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASCustomCell.h"
#import "URL.h"


@implementation ASCustomCell

@synthesize data = _data;
@synthesize logo = _logo;
@synthesize storeName = _storeName;
@synthesize index = _index;
@synthesize ShopAddress = _ShopAddress;


-(void)dealloc
{
    [_ShopAddress release];
    [_data release];
    [_logo release];
    [_storeName release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGRect bounds = self.bounds;
    [self.logo setFrame:
     CGRectMake(8, 8, (bounds.size.height - 16) * 1.21, bounds.size.height -16)];

    self.textLabel.adjustsFontSizeToFitWidth = YES;
    
    if (rect_screen.size.height == 480) {
        [self.storeName setFrame:
         CGRectMake(bounds.size.height * 1.2 - 6, 4,
                    268, bounds.size.height / 2)];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        [self.detailTextLabel setFrame:
         CGRectMake(266, bounds.size.height / 2 - 12,
                    44, 24)];
        [_ShopAddress setFrame:CGRectMake(bounds.size.height * 1.2 - 6 , bounds.size.height / 2 , 272, 32)];
    } else {
        [self.storeName setFrame:
         CGRectMake(bounds.size.height * 1.2 - 6 , 6,
                    268, bounds.size.height / 2)];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        [self.detailTextLabel setFrame:
         CGRectMake(266, bounds.size.height / 2 - 12,
                    44, 24)];
        [_ShopAddress setFrame:CGRectMake(bounds.size.height * 1.2 - 6 , bounds.size.height / 2 + 4, 272, 32)];
    }
    
//    //image边框
//    [self.storeName setFrame:
//     CGRectMake(bounds.size.height, 16,
//                268, bounds.size.height / 2)];
//    
//    [self.ShopAddress setFrame:CGRectMake(bounds.size.height, 36, 268, bounds.size.height/2)];
//    
//    [self.detailTextLabel setFrame:
//     CGRectMake(0, 16,
//                bounds.size.width - 28, bounds.size.height / 2)];
//    
//	self.logo.layer.borderColor = [UIColor lightGrayColor].CGColor;
//	self.logo.layer.borderWidth = 2.0;
    
    
    ///////
    
    _ShopAddress.textColor = [UIColor darkGrayColor];
    _ShopAddress.backgroundColor = [UIColor clearColor];
    _ShopAddress.font = [UIFont systemFontOfSize:12];
    
    self.detailTextLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel.layer.masksToBounds = YES;
	self.detailTextLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.detailTextLabel.layer.borderWidth = 1.2f;
    self.detailTextLabel.layer.cornerRadius = 5;
    self.detailTextLabel.backgroundColor = [UIColor lightGrayColor];
    self.detailTextLabel.alpha = 0.8;
    
    //image边框
    self.logo.layer.masksToBounds = YES;
	self.logo.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.logo.layer.borderWidth = 1.2f;
    self.logo.layer.cornerRadius = 7;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//
//#pragma mark 右边控件显示函数
//
//-(IBAction)showRightView:(id)sender;
//{
//    movingLock = YES;
//    CGRect rect = self.cellView.frame;
//    rect.origin.x = -320;
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    
//    self.cellView.frame = rect;
//    
//    
//    [UIView commitAnimations];
//    
//    [_viewTimer invalidate];
//    movingLock = NO;
//    
//}
//
//-(IBAction)cellViewBack:(id)sender;
//{
//    movingLock = YES;
//    CGRect rect = self.cellView.frame;
//    rect.origin.x = 0;
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//
//
//    self.cellView.frame = rect;
//
//    
//    [UIView commitAnimations];
//    
//    [_viewTimer invalidate];
//    movingLock = NO;
//}
//
//
//
//#pragma  mark 触摸移动事件处理
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    x_Point = [[touches anyObject] locationInView:self.superview].x;
//    last_x_Point = self.cellView.frame.origin.x;
//    [super touchesBegan:touches withEvent:event];
//    
//    //movingLock = YES;
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    int endPointLength = [[touches anyObject] locationInView:self.superview].x - x_Point;
//    
//    CGRect rect = self.cellView.frame;
//    
//    rect.origin.x = last_x_Point + endPointLength;
//    
//    self.cellView.frame = rect;
//    
//    movingLock = YES;
//
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (!movingLock) {
//        [self.delegate didSelectRowAtIndex:_index];
//    }
//    
//    int endPointLength = [[touches anyObject] locationInView:self.superview].x - x_Point;
//    
//    if(endPointLength <= -50)
//    {
//        //show right
//        [self.delegate setMyTableViewScrollEnabled:NO];
//        [self showRightView:nil];
//        [self.delegate setMyTableViewScrollEnabled:YES];
//        return;
//    }else
//    {
//
//    if (movingLock) {
//        [self.delegate setMyTableViewScrollEnabled:NO];
//        [self cellViewBack:nil];
//        [self.delegate setMyTableViewScrollEnabled:YES];
//        return;
//    }
//        
//    }
//    
//}

//#pragma mark UIGestureRecognizerDelegate
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
//    
//    if(movingLock)
//    {
//        return NO;
//    }
//    else
//        return NO;
//}

//#pragma mark 分享按钮
//
//- (IBAction)shareBtnPressed:(id)sender
//{
//    [self.delegate switchContrller];
//}
//
//- (IBAction)CancelTheCollection:(id)sender {
//    [self.delegate CancelTheCollection:self.data];
//}

@end

