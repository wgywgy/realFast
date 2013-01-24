//
//  ASUserEvalution.h
//  ASFastWashing
//
//  Created by Admin on 12-12-18.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRequestDelegate.h"
@class ASRequest;

@interface ASUserEvalution : UIViewController<UITableViewDataSource,UITableViewDelegate,ASRequestDelegate>
{
    UITableView *myTableView;
    ASRequest *request;
    NSArray * evalutions;
}
@property(nonatomic,retain)IBOutlet UITableView *myTableView;

@property(copy,nonatomic) NSString * shopId;

@property(nonatomic,retain)NSArray * evalutions;

@end
