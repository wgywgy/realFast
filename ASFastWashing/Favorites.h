//
//  Favorites.h
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASRequestDelegate.h"


@class ASRequest;
@class ASStore;

typedef void (^RevealBlock3)();
@interface Favorites : UIViewController
                    <UITableViewDataSource,
                    UITableViewDelegate,
                    UISearchBarDelegate,
                    ASRequestDelegate,
                    UIActionSheetDelegate,UIScrollViewDelegate>
{
@private
	RevealBlock3 _revealBlock;
}
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock3)revealBlock;
@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) NSMutableArray * stores;
@property (retain, nonatomic) ASRequest * request;
@end
