//
//  ASRevealViewController.h
//  ASFastWashing
//
//  Created by SSD on 12-11-28.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSTimeInterval kASRevealSidebarDefaultAnimationDuration;
extern const CGFloat kASRevealSidebarWidth;

@interface ASRevealViewController : UIViewController {
@private
	UIView *_sidebarView;
	UIView *_contentView;
	UITapGestureRecognizer *_tapRecog;
}

@property (nonatomic, readonly, getter = isSidebarShowing) BOOL sidebarShowing;
@property (strong, nonatomic) UIViewController *sidebarViewController;
@property (strong, nonatomic) UIViewController *contentViewController;

- (void)dragContentView:(UIPanGestureRecognizer *)panGesture;
- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration;
- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
- (void)toggleSidebarForCell:(BOOL)show duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
