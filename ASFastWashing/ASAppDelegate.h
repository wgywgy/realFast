//
//  ASAppDelegate.h
//  ASFastWashing
//
//  Created by SSD on 12-11-28.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASRevealViewController;
@interface ASAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ASRevealViewController *revealController;
@end
