//
//  ASMenuViewController.m
//  ASFastWashing
//
//  Created by SSD on 12-11-28.
//  Copyright (c) 2012年 SSD. All rights reserved.
//


#import "ASMenuViewController.h"
#import "ASMenuCell.h"
#import "ASRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASUser.h"
#import "URL.h"
#import "PersonalCenter.h"
#import "ASAppDelegate.h"
#import "ASModifyPersonalInformationViewController.h"

#pragma mark -
#pragma mark Implementation
@implementation ASMenuViewController

#pragma mark Memory Management
- (id)initWithSidebarViewController:(ASRevealViewController *)sidebarVC
						withHeaders:(NSArray *)headers
					withControllers:(NSArray *)controllers
					  withCellInfos:(NSArray *)cellInfos {
	if (self = [super initWithNibName:nil bundle:nil]) {
		_sidebarVC = sidebarVC;
		_headers = headers;
		_controllers = controllers;
		_cellInfos = cellInfos;
		_sidebarVC.sidebarViewController = self;
	}
	return self;
}
/*
 函数功能：由“登录”或“注册”跳转到？“我的订单”
*/
- (void)switchingNavigation
{
    _sidebarVC.contentViewController = _controllers[1][2];
    [_sidebarVC toggleSidebar:NO duration:kASRevealSidebarDefaultAnimationDuration];
}
/*
 函数功能：由“我的订单”跳转到“登录”
 */
- (void)switching
{
    _sidebarVC.contentViewController = _controllers[0][0];
    [_sidebarVC toggleSidebar:NO duration:kASRevealSidebarDefaultAnimationDuration];
}
/*
 函数功能：点击“注销登录”按钮时注销当前用户
*/
- (void)cancellationLogin:(id)sender
{
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (readuser.isLogin == YES) {
        readuser.isLogin = NO;
        readuser.userName = nil;
        readuser.password = nil;
        readuser.question = nil;
        readuser.answer = nil;
        readuser.address = nil;
        readuser.userId = nil;
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];
        UITableViewCell *tmp = (UITableViewCell*)[self.view viewWithTag:20];
        tmp.textLabel.text = @"点击登录";
        UIButton *buttonTmp = (UIButton*)[self.view viewWithTag:100];
        buttonTmp.enabled = NO;
        buttonTmp.hidden = YES;
        ASAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate application:nil didFinishLaunchingWithOptions:nil];
    }else {
        UIButton *buttonTmp = (UIButton*)[self.view viewWithTag:100];
        buttonTmp.enabled = YES;
        buttonTmp.hidden = NO;
    }
}
#pragma mark UIViewController
- (BOOL)shouldAutorotate
{
    return NO;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, CGRectGetHeight(self.view.bounds));
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.view.layer.masksToBounds = YES;
//    self.view.layer.cornerRadius = 8.0f;
	_menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, CGRectGetHeight(self.view.bounds) - 44.0f)
												  style:UITableViewStylePlain];
	_menuTableView.delegate = self;
	_menuTableView.dataSource = self;
	_menuTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_menuTableView.backgroundColor = [UIColor clearColor];
	_menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.layer.masksToBounds = YES;
//    _menuTableView.layer.cornerRadius = 8.0f;
	[self.view addSubview:_menuTableView];
    
    //添加“注销登录”按钮
    UIButton *cancellationLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 44.0f, 320, 44)];
    cancellationLogin.tag = 100;
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (readuser.isLogin == YES) {
        cancellationLogin.enabled = YES;
        cancellationLogin.hidden = NO;
    }else {
        cancellationLogin.enabled = NO;
        cancellationLogin.hidden = YES;
    }
    [cancellationLogin setTitle:@"注销登录" forState:UIControlStateNormal];
    cancellationLogin.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancellationLogin.contentEdgeInsets = UIEdgeInsetsMake(0,52, 0, 0);
    [cancellationLogin addTarget:self action:@selector(cancellationLogin:) forControlEvents:UIControlEventTouchUpInside];
    cancellationLogin.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.2f)];
    cancellationLogin.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    cancellationLogin.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    cancellationLogin.titleLabel.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
    topLine.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(76.0f/255.0f) alpha:1.0f];
    [cancellationLogin.titleLabel.superview addSubview:topLine];
    
    UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
    topLine2.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(77.0f/255.0f) alpha:1.0f];
    [cancellationLogin.titleLabel.superview addSubview:topLine2];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
    bottomLine.backgroundColor = [UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f];
    [cancellationLogin.titleLabel.superview addSubview:bottomLine];
    [self.view addSubview:cancellationLogin];
    
    //注册状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stateChange)
                                                 name: @"MenuViewNotice"
                                               object: nil];
    //注册导航切换通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(switchingNavigation)
                                                 name: @"MenuViewSwitchingNavigationNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(switching)
                                                 name: @"MenuViewSwitchingNotice"
                                               object: nil];
}

- (void)viewWillAppear:(BOOL)animated {
	self.view.frame = CGRectMake(0.0f, 0.0f,320.0f, CGRectGetHeight(self.view.bounds));
	[self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown)
    ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    : YES;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_cellInfos[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ASMenuCell";
    ASMenuCell *cell = (ASMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ASMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
	cell.textLabel.text = info[@"CellText"];
	cell.imageView.image = info[@"CellImage"];
    if (indexPath.section == 0) {
        cell.tag = 20;
    }
    return cell;
}

#pragma mark UITableViewDelegate

//section之间的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (_headers[section] == [NSNull null]) ? 0.0f : 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 15.0f)];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = headerView.bounds;
		gradient.colors = @[
        (id)[UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f].CGColor,
        (id)[UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f].CGColor,
		];
		[headerView.layer insertSublayer:gradient atIndex:0];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.8f)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(78.0f/255.0f) green:(86.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f];
		[headerView addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 15.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(36.0f/255.0f) green:(42.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f];
		[headerView addSubview:bottomLine];
	}
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (user.isLogin == YES && indexPath.section == 0 && indexPath.row == 0) {
        _sidebarVC.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ASModifyPersonalInformationViewController alloc] init]];
        [_sidebarVC toggleSidebarForCell:NO duration:kASRevealSidebarDefaultAnimationDuration completion:nil];
    } else{
        _sidebarVC.contentViewController = _controllers[indexPath.section][indexPath.row];
        [_sidebarVC toggleSidebarForCell:NO duration:kASRevealSidebarDefaultAnimationDuration completion:nil];
    }
}

#pragma mark Public Methods
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    NSIndexPath *tmp = [NSIndexPath indexPathForRow:0 inSection:1];
	[_menuTableView selectRowAtIndexPath:tmp animated:animated scrollPosition:scrollPosition];
	if (scrollPosition == UITableViewScrollPositionNone) {
		[_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
	}
    _sidebarVC.contentViewController = _controllers[1][0];
}
/*
 函数功能：实时状态更新
*/
-(void)stateChange
{
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    UITableViewCell *tmp = (UITableViewCell*)[self.view viewWithTag:20];
    UIButton *buttonTmp = (UIButton*)[self.view viewWithTag:100];
    if (readuser.isLogin) {
        tmp.textLabel.text = readuser.userName;
        NSIndexPath *tmp = [NSIndexPath indexPathForRow:2 inSection:1];
        [_menuTableView selectRowAtIndexPath:tmp animated:YES scrollPosition:UITableViewScrollPositionNone];
        buttonTmp.enabled = YES;
        buttonTmp.hidden = NO;
    } else{
        tmp.textLabel.text = @"点击登录";
        NSIndexPath *tmp = [NSIndexPath indexPathForRow:0 inSection:1];
        [_menuTableView selectRowAtIndexPath:tmp animated:YES scrollPosition:UITableViewScrollPositionNone];
        buttonTmp.enabled = NO;
        buttonTmp.hidden = YES;
    }
}

@end