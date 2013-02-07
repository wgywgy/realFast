//
//  ASAppDelegate.m
//  ASFastWashing
//
//  Created by SSD on 12-11-28.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASMenuCell.h"
#import "ASRevealViewController.h"
#import "ASMenuViewController.h"
#import "ASLogViewController.h"
#import "Weather.h"
#import "StoreList.h"
#import "PersonalCenter.h"
#import "Favorites.h"
#import "Introduce.h"
#import "ASUser.h"
#import "ASHelpCenterViewController.h"
#import "ASModifyPersonalInformationViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface ASAppDelegate ()

@property (nonatomic, retain) ASMenuViewController *menuController;
@end


@implementation ASAppDelegate
@synthesize revealController,menuController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
	
	UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
	self.revealController = [[ASRevealViewController alloc] initWithNibName:nil bundle:nil];
	self.revealController.view.backgroundColor = bgColor;
	
	RevealBlock revealBlock = ^(){
		[self.revealController toggleSidebar:!self.revealController.sidebarShowing
									duration:kASRevealSidebarDefaultAnimationDuration];
	};
	
	NSArray *headers = @[
    [NSNull null],
    @""
	];
	NSArray *isLoginControllers =
    @[
      @[
          [[UINavigationController alloc] initWithRootViewController:
           [[ASModifyPersonalInformationViewController alloc] initWithTitle:@"修改个人信息" withRevealBlock:revealBlock]]
          ],
      @[
          [[UINavigationController alloc] initWithRootViewController:[[StoreList alloc] initWithTitle:@"今日天气" withRevealBlock:revealBlock]],
          [[UINavigationController alloc] initWithRootViewController:[[Weather alloc] initWithTitle:@"洗衣店" withRevealBlock:revealBlock]],
          [[UINavigationController alloc] initWithRootViewController:[[ASLogViewController alloc] initWithTitle:@"我的订单" withRevealBlock:revealBlock]],
          [[UINavigationController alloc] initWithRootViewController:[[Favorites alloc] initWithTitle:@"收藏夹" withRevealBlock:revealBlock]],
          [[UINavigationController alloc] initWithRootViewController:[[ASHelpCenterViewController alloc]initWithTitle:@"帮助中心" withRevealBlock:revealBlock]]
          ]
      ];
    NSArray *isNotLoginControllers =
    @[
    @[
    [[UINavigationController alloc] initWithRootViewController:[[PersonalCenter alloc] initWithTitle:@"修改个人信息" withRevealBlock:revealBlock]]
    ],
    @[
    [[UINavigationController alloc] initWithRootViewController:[[StoreList alloc] initWithTitle:@"洗衣店" withRevealBlock:revealBlock]],
    [[UINavigationController alloc] initWithRootViewController:[[Weather alloc] initWithTitle:@"今日天气" withRevealBlock:revealBlock]],
    [[UINavigationController alloc] initWithRootViewController:[[ASLogViewController alloc] initWithTitle:@"我的订单" withRevealBlock:revealBlock]],
    [[UINavigationController alloc] initWithRootViewController:[[Favorites alloc] initWithTitle:@"收藏夹" withRevealBlock:revealBlock]],
    [[UINavigationController alloc] initWithRootViewController:[[ASHelpCenterViewController alloc]initWithTitle:@"帮助中心" withRevealBlock:revealBlock]]]];
    
	NSArray *isNotLogincellInfos = @[
    @[
        @{@"CellImage": [UIImage imageNamed:@"32.png"], @"CellText": NSLocalizedString(@"点击登录", @"")}
    ],
    @[
        @{@"CellImage": [UIImage imageNamed:@"洗衣店.png"], @"CellText": NSLocalizedString(@"洗衣店", @"")},
        @{@"CellImage": [UIImage imageNamed:@"天气.png"], @"CellText": NSLocalizedString(@"今日天气", @"")},
        @{@"CellImage": [UIImage imageNamed:@"订单.png"], @"CellText": NSLocalizedString(@"我的订单", @"")},
        @{@"CellImage": [UIImage imageNamed:@"我的收藏.png"], @"CellText": NSLocalizedString(@"收藏夹", @"")},
        @{@"CellImage": [UIImage imageNamed:@"问号.png"], @"CellText": NSLocalizedString(@"帮助与设置", @"")},]];
    
    //读取用户信息
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *isLogincellInfos = @[
    @[
    @{@"CellImage": [UIImage imageNamed:@"32.png"], @"CellText": NSLocalizedString(readuser.userName, @"")}
    ],
    @[
    @{@"CellImage": [UIImage imageNamed:@"洗衣店.png"], @"CellText": NSLocalizedString(@"洗衣店", @"")},
    @{@"CellImage": [UIImage imageNamed:@"天气.png"], @"CellText": NSLocalizedString(@"今日天气", @"")},
    @{@"CellImage": [UIImage imageNamed:@"订单.png"], @"CellText": NSLocalizedString(@"我的订单", @"")},
    @{@"CellImage": [UIImage imageNamed:@"我的收藏.png"], @"CellText": NSLocalizedString(@"收藏夹", @"")},
    @{@"CellImage": [UIImage imageNamed:@"问号.png"], @"CellText": NSLocalizedString(@"帮助与设置", @"")},]];
	
	// Add drag feature to each root navigation controller
    if (readuser.isLogin) {
        [isLoginControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
                    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.revealController
                                                                                                 action:@selector(dragContentView:)];
                    panGesture.cancelsTouchesInView = YES;
                    [((UINavigationController *)obj2).view addGestureRecognizer:panGesture];
            }];
        }];
        self.menuController = [[ASMenuViewController alloc] initWithSidebarViewController:revealController withHeaders:headers withControllers:isLoginControllers withCellInfos:isLogincellInfos];
    }else {
        [isNotLoginControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
                    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.revealController
                                                                                                 action:@selector(dragContentView:)];
                    panGesture.cancelsTouchesInView = YES;
                    [((UINavigationController *)obj2).view addGestureRecognizer:panGesture];
            }];
        }];
        self.menuController = [[ASMenuViewController alloc] initWithSidebarViewController:revealController withHeaders:headers withControllers:isNotLoginControllers withCellInfos:isNotLogincellInfos];
    }
	
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //添加标志，判断是否为第一次启动程序
    //    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
    //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    //    }
    
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    //    {
    //        Introduce *appStartController = [[Introduce alloc] init];
    //        self.window.rootViewController = appStartController;
    //[appStartController release];
    //    }
    //    else
    //    {
    self.window.rootViewController = self.revealController;
    //    }
    [self.window makeKeyAndVisible];
    
#pragma mark == shareSDK
    [ShareSDK registerApp:@"520520test"];
    
    return YES;
}

#pragma mark == shareSDK 
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
