//
//  ASRenrenViewController.h
//  WYYShareTest
//
//  Created by Parker on 12-11-23.
//  Copyright (c) 2012年 河北师范大学软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASRenrenViewController : UIViewController
<RenrenDelegate>

@property (nonatomic , retain) Renren *renren;

-(void)shareRenForSongs;

@end
