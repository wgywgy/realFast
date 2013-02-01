//
//  myCell.h
//  主题拨号
//
//  Created by Admin on 12-10-17.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCustomCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    BOOL movingLock;
    BOOL leftMoving;
    BOOL rightMoving;
    NSInteger index;
 }

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,retain)NSDictionary * data; //商店的数据信息
@property(nonatomic,retain)IBOutlet UILabel * storeName;   //商店名称

@property(nonatomic,retain)IBOutlet UIImageView * logo; //商店图标

@property(nonatomic,retain)IBOutlet UILabel *ShopAddress;  //商店地址


@end
