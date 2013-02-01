//
//  Introduce.h
//  快洗
//
//  Created by yuyang-pc on 12-11-26.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Introduce : UIViewController<UIScrollViewDelegate>
@property(nonatomic,retain)IBOutlet UIScrollView* myScrollView;
@property(nonatomic,retain)IBOutlet UIPageControl* myPageControl;
@property(nonatomic,retain)IBOutlet UIButton* LogoInBtn;
@property(nonatomic,retain)IBOutlet UIButton* StoreListBtn;

-(IBAction)LogoIn:(id)sender;
-(IBAction)StoreList:(id)sender;
@end
