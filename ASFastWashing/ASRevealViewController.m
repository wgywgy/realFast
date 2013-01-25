//
//  ASRevealViewController.m
//  ASFastWashing
//
//  Created by SSD on 12-11-28.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PersonalCenter.h"
#pragma mark -
#pragma mark Constants
const NSTimeInterval kASRevealSidebarDefaultAnimationDuration = 0.25;
const CGFloat kASRevealSidebarWidth = 268.0f;
const CGFloat kASRevealSidebarFlickVelocity = 1000.0f;


#pragma mark -
#pragma mark Private Interface
@interface ASRevealViewController ()
@property (nonatomic, readwrite, getter = isSidebarShowing) BOOL sidebarShowing;
- (void)hideSidebar;
@end
#pragma mark -
#pragma mark Implementation
@implementation ASRevealViewController

#pragma mark Properties
@synthesize sidebarShowing;
@synthesize sidebarViewController;
@synthesize contentViewController;
- (void)setSidebarViewController:(UIViewController *)svc {
	if (sidebarViewController == nil) {
		svc.view.frame = _sidebarView.bounds;
		sidebarViewController = svc;
		[self addChildViewController:sidebarViewController];
		[_sidebarView addSubview:sidebarViewController.view];
		[sidebarViewController didMoveToParentViewController:self];
	} else if (sidebarViewController != svc) {
		svc.view.frame = _sidebarView.bounds;
		[sidebarViewController willMoveToParentViewController:nil];
		[self addChildViewController:svc];
		[self transitionFromViewController:sidebarViewController
						  toViewController:svc
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[sidebarViewController removeFromParentViewController];
									[svc didMoveToParentViewController:self];
									sidebarViewController = svc;
								}
		 ];
	}
}

- (void)setContentViewController:(UIViewController *)cvc {
	if (contentViewController == nil) {
		cvc.view.frame = _contentView.bounds;
		contentViewController = cvc;
		[self addChildViewController:contentViewController];
		[_contentView addSubview:contentViewController.view];
		[contentViewController didMoveToParentViewController:self];
	} else if (contentViewController != cvc) {
		cvc.view.frame = _contentView.bounds;
		[contentViewController willMoveToParentViewController:nil];
		[self addChildViewController:cvc];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:contentViewController
						  toViewController:cvc
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[contentViewController removeFromParentViewController];
									[cvc didMoveToParentViewController:self];
									contentViewController = cvc;
								}
         ];
	}
}

#pragma mark Memory Management
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.sidebarShowing = NO;
		_tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidebar)];
		_tapRecog.cancelsTouchesInView = YES;
		
		self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		
		_sidebarView = [[UIView alloc] initWithFrame:self.view.bounds];
		_sidebarView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_sidebarView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:_sidebarView];
		
		_contentView = [[UIView alloc] initWithFrame:self.view.bounds];
		_contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_contentView.backgroundColor = [UIColor clearColor];
		_contentView.layer.masksToBounds = NO;
        _contentView.layer.cornerRadius = 8.0f;
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
		_contentView.layer.shadowOffset = CGSizeMake(-3.0f, 0.0f);
		_contentView.layer.shadowOpacity = 1.0f;
		_contentView.layer.shadowRadius = 2.5f;
        self.view.layer.masksToBounds = YES;
//        self.view.layer.cornerRadius = 8.0f;
		_contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_contentView.bounds].CGPath;
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.backBarButtonItem = backBarButtonItem;
		[self.view addSubview:_contentView];
    }
    return self;
}

#pragma mark UIViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    return (toInterfaceOrientation == UIDeviceOrientationPortrait);
}
- (BOOL)shouldAutorotate
{
    return NO;
}
#pragma mark Public Methods
- (void)dragContentView:(UIPanGestureRecognizer *)panGesture {
	CGFloat translation = [panGesture translationInView:self.view].x;
	if (panGesture.state == UIGestureRecognizerStateChanged) {
		if (sidebarShowing) {
			if (translation > 0.0f) {
				_contentView.frame = CGRectOffset(_contentView.bounds, kASRevealSidebarWidth, 0.0f);
				self.sidebarShowing = YES;
			} else if (translation < -kASRevealSidebarWidth) {
				_contentView.frame = _contentView.bounds;
				self.sidebarShowing = NO;
			} else {
				_contentView.frame = CGRectOffset(_contentView.bounds, (kASRevealSidebarWidth + translation), 0.0f);
			}
		} else {
			if (translation < 0.0f) {
				_contentView.frame = _contentView.bounds;
				self.sidebarShowing = NO;
			} else if (translation > kASRevealSidebarWidth) {
				_contentView.frame = CGRectOffset(_contentView.bounds, kASRevealSidebarWidth, 0.0f);
				self.sidebarShowing = YES;
			} else {
				_contentView.frame = CGRectOffset(_contentView.bounds, translation, 0.0f);
			}
		}
	} else if (panGesture.state == UIGestureRecognizerStateEnded) {
		CGFloat velocity = [panGesture velocityInView:self.view].x;
		BOOL show = (fabs(velocity) > kASRevealSidebarFlickVelocity)
        ? (velocity > 0)
        : (translation > (kASRevealSidebarWidth / 2));
        if (show) {
			_contentView.frame = CGRectOffset(_contentView.bounds, kASRevealSidebarWidth, 0.0f);
			[_contentView addGestureRecognizer:_tapRecog];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalCenterKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifyPersonalKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterViewKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EvaluateViewKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgetPasswordViewKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShopRegisterKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInteractionAbledNotice" object:self];
            
		} else {
            CGRect frame = _contentView.frame;
            frame.origin.x = _contentView.bounds.size.width;
            
            [UIView animateWithDuration:kASRevealSidebarDefaultAnimationDuration
                             animations:^{
                                 _contentView.frame = _contentView.bounds;
                             }];
            [_contentView removeGestureRecognizer:_tapRecog];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalCenterKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifyPersonalKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EvaluateViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgetPasswordViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShopRegisterKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInteractionEnabledNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tmpChangeNotice" object:self];
		}
		self.sidebarShowing = show;
	}
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration {
	[self toggleSidebar:show duration:duration completion:^(BOOL finshed){}];
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
	void (^animations)(void) = ^{
		if (show) {
			_contentView.frame = CGRectOffset(_contentView.bounds, kASRevealSidebarWidth, 0.0f);
			[_contentView addGestureRecognizer:_tapRecog];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalCenterKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifyPersonalKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterViewKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EvaluateViewKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgetPasswordViewKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShopRegisterMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewKeyboardMissingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInteractionAbledNotice" object:self];

		} else {
            [_contentView removeGestureRecognizer:_tapRecog];
            [_contentView removeGestureRecognizer:_tapRecog];
			_contentView.frame = _contentView.bounds;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalCenterKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifyPersonalKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EvaluateViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgetPasswordViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInteractionEnabledNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tmpChangeNotice" object:self];
		}
		self.sidebarShowing = show;
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:completion];
	} else {
		animations();
		completion(YES);
	}
}
- (void)toggleSidebarForCell:(BOOL)show duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
	void (^animations)(void) = ^{
		if (!show) {
            [_contentView removeGestureRecognizer:_tapRecog];
            CGRect frame = _contentView.frame;
            frame.origin.x = _contentView.bounds.size.width;
            
            [UIView animateWithDuration:kASRevealSidebarDefaultAnimationDuration animations:^{
                _contentView.frame = frame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kASRevealSidebarDefaultAnimationDuration
                                 animations:^{
                                     _contentView.frame = _contentView.bounds;
                                 }];
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalCenterKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifyPersonalKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EvaluateViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgetPasswordViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewKeyboardShowingNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInteractionEnabledNotice" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tmpChangeNotice" object:self];
		}
		self.sidebarShowing = show;
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:completion];
	} else {
		animations();
		completion(YES);
	}
}
#pragma mark Private Methods
- (void)hideSidebar {
	[self toggleSidebar:NO duration:kASRevealSidebarDefaultAnimationDuration];
}
#pragma mark - 
@end
