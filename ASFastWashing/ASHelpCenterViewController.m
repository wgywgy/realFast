//
//  ASViewController.m
//  HelpingCenterDemo1
//
//  Created by WangM on 18-1-1.
//  Copyright (c) 2018年 Alpha Studio. All rights reserved.
//

#import "ASHelpCenterViewController.h"
#import "Reachability.h"
#import "ASAgreementController.h"

@interface ASHelpCenterViewController ()
- (void)revealSidebar;
@end

@implementation ASHelpCenterViewController
@synthesize aboutUsViewController,shopHelpRegisterController;

- (void)dealloc
{
    [aboutUsViewController release];
    [shopHelpRegisterController release];
    [m_arrayData release];
    [m_tableView release];
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock1)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(revealSidebar)];
        
		self.navigationItem.leftBarButtonItem = left;
        [left release];
	}
	return self;
}
- (void)revealSidebar {
	_revealBlock();
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //返回按钮
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"导航栏.png"];
    if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    UIImage * tmp = [UIImage imageNamed:@"导航按钮.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:tmp forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    [leftButton release];
    
    CGRect tableViewFrame = CGRectMake(0, 10, 320, 200);
    m_tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundView = nil;
    [m_tableView setBackgroundColor:[UIColor clearColor]];
    
    
    m_arrayData = [[NSArray alloc]initWithObjects:@"觉得软件不错,给个评分吧",@"检查更新",@"清除缓存",@"关于我们",nil];
    
    m_tableView.scrollEnabled = NO;
    m_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_tableView];
    
    buttonHelp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonHelp.frame = CGRectMake(10, 240, 300, 50);
    UILabel * labelHelp = [[UILabel alloc] init];
    labelHelp.frame = CGRectMake(133, 15, 60, 20);
    labelHelp.text = @"帮助";
    labelHelp.backgroundColor = [UIColor clearColor];
    labelHelp.font = [UIFont fontWithName:@"Arial" size:14.0];
    [buttonHelp addSubview:labelHelp];
    buttonHelp.titleLabel.textColor = [UIColor blackColor];
    [buttonHelp addTarget:self action:@selector(helpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [labelHelp release];
    
    buttonRegister = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonRegister.frame = CGRectMake(10, 300, 300, 50);
    UILabel * labelRegister = [[UILabel alloc] init];
    labelRegister.frame = CGRectMake(113, 15, 100, 20);
    labelRegister.text = @"注册洗衣店";
    labelRegister.backgroundColor = [UIColor clearColor];
    labelRegister.font = [UIFont fontWithName:@"Arial" size:14.0];
    [buttonRegister addSubview:labelRegister];
    buttonRegister.titleLabel.textColor = [UIColor blackColor];
    [buttonRegister addTarget:self action:@selector(registerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [labelRegister release];
    
    [self.view addSubview:buttonHelp];
    [self.view addSubview:buttonRegister];
    
    [buttonHelp release];
    [buttonRegister release];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"water.jpg"]]];
    
    
    //清除缓冲的数据
    int huanchongSize = [[SDImageCache sharedImageCache] getSize];
    NSLog(@"图片缓存大小 %d",huanchongSize);
    NSString * cleanHuanchong = [NSString stringWithFormat:@"%dKB",huanchongSize];
    
    m_arraryCellValue = [[NSMutableArray alloc] initWithObjects:@"",@"",cleanHuanchong,@"",nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionEnabled)
                                                 name: @"userInteractionEnabledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionAbled)
                                                 name: @"userInteractionAbledNotice"
                                               object: nil];
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(254, 55, 50, 50);
    [self.view addSubview:activityIndicatorView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    
    aboutUsViewController = [[ASAboutUsViewController alloc] init];
    shopHelpRegisterController = [[ASShopRegisterController alloc] init];
}

- (void)userInteractionEnabled
{
    self.view.userInteractionEnabled = YES;
}
- (void)userInteractionAbled
{
    self.view.userInteractionEnabled = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    //if (!buttonHelp&&!buttonRegister) {
                
    //}
}

- (void)viewWillAppear:(BOOL)animated
{
    int size = [[SDImageCache sharedImageCache] getSize];
    NSLog(@"图片缓存大小 %d",size);
    
    double size1 = (double)size/1024/80;
    NSString * strHuanCunSize = [[NSString alloc] initWithFormat:@"%.1fMB",size1];
    
    [m_arraryCellValue removeObjectAtIndex:2];
    [m_arraryCellValue insertObject:strHuanCunSize atIndex:2];
    
    [m_tableView reloadData];
    
    [strHuanCunSize release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrayData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString * SectionsTableIdentifier = @"tableCellIdentifier";
    ASHelpCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    if (cell==nil) {
        NSArray* array = [[NSBundle mainBundle]loadNibNamed:@"ASHelpCenterCell" owner:self options:nil];
        for (id object in array) {
            if ([object isKindOfClass:[ASHelpCenterCell class]]) {
                cell = object;
            }
        }
        //不选中
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.cellName.text = [m_arrayData objectAtIndex:row];
    cell.cellName.textAlignment = NSTextAlignmentCenter;
    cell.cellName.backgroundColor=[UIColor clearColor];
    cell.cellName.font = [UIFont fontWithName:@"Arial" size:14.0];
    
    NSLog(@"[m_arraryCellValue objectAtIndex:row] : %@",[m_arraryCellValue objectAtIndex:row]);
    
    cell.cellValue.text = [m_arraryCellValue objectAtIndex:row];
    cell.cellValue.textAlignment = NSTextAlignmentRight;
    cell.cellValue.font = [UIFont fontWithName:@"Arial" size:10.0];
    cell.cellValue.textColor = [UIColor blueColor];
    
    if ([[m_arraryCellValue objectAtIndex:row] isEqualToString:@"0.0MB"]) {
        cell.cellValue.text = @"暂无缓存";
        cell.cellValue.textColor = [UIColor grayColor];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
   
    
    //给个评分
    if (row == 0) {
        //评分
        NSString * appID = @APP_ID;
        NSString * strURL = [NSString stringWithFormat: @"https://itunes.apple.com/cn/app/teng-xun-wei-bohd/id%@?mt=8",appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
        //撰写评论链接：@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=应用程序ID"
    }
    
    //检查更新
    else if (row == 1) {
        [activityIndicatorView startAnimating] ;
        [self checkUpdate];
    }
    
    //清除缓存
    else if (row == 2) {
        
        int size1 = [[SDImageCache sharedImageCache] getSize];
        NSLog(@"图片缓存大小 %d",size1);
        
        if (size1 == 0) {
            UIAlertView * sdImageCacheAlertView = [[UIAlertView alloc] initWithTitle:@"没有缓存可以清理" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [sdImageCacheAlertView show];
            [sdImageCacheAlertView release];
        }
        else{
        
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] cleanDisk];
        
            int size = [[SDImageCache sharedImageCache] getSize];
            NSLog(@"图片缓存大小 %d",size);

            UIAlertView * sdImageCacheAlertView = [[UIAlertView alloc] initWithTitle:@"清除完毕" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [sdImageCacheAlertView show];
  
            [m_arraryCellValue removeObjectAtIndex:2];
            [m_arraryCellValue insertObject:@"0.0MB" atIndex:2];
            
            [sdImageCacheAlertView release];
            
            NSLog(@"%@",m_arraryCellValue);
            
            }
    }
    
    //关于我们
    else if (row == 3) {
        
        [self.navigationController pushViewController:aboutUsViewController animated:YES];
    }
    //让tabelview的cell不一直处于选中状态
    [m_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [m_tableView reloadData];
}

-(IBAction)helpButtonPressed:(id)sender
{
    Help * helpViewController = [[Help alloc] init];
    [self.navigationController pushViewController:helpViewController animated:YES];
    [helpViewController release];
}

-(IBAction)registerButtonPressed:(id)sender
{
    Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
    if ([r isReachable]) {
        [self next];
    }else{
        [self NetError];
    }
}

-(void)NetError
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"没有连接到网络！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)next
{
    ASAgreementController *agreeController = [[ASAgreementController alloc]init];
    [self.navigationController pushViewController:agreeController animated:YES];
    [agreeController release];
}

-(void)requestDidFinishLoading
{
    NSLog(@"%@",m_request.result);
    
    //当前设备上的app版本号
    NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"当前设备上的app版本号 : %@",currentVersion);
    
    //获取itunes上最新的app版本号
    NSArray *infoArray = [m_request.result objectForKey:@"results"];
    
    if ([infoArray count]) {
         NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
         NSString * lastVersion = [releaseInfo objectForKey:@"version"];
         //NSString * trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
        
         NSLog(@"itunes上最新的app版本号 : %@",lastVersion);
        
         if (![lastVersion isEqualToString:currentVersion]) {
             //trackViewUrl = [releaseInfo objectForKey:@"trackVireUrl"];
             
             [activityIndicatorView stopAnimating];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即前往更新", nil];
             [alert show];
             [alert release];
             
         }
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // 立即更新按钮
        NSLog(@"立即更新");
        
        NSString * appID = @APP_ID;
        NSString * strURL = [NSString stringWithFormat: @"https://itunes.apple.com/cn/app/teng-xun-wei-bohd/id%@?mt=8",appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
    }
    else { // 稍后再说按钮
        NSLog(@"稍后再说");
    }
}

-(void)requestDidFailWithError
{
    NSLog(@"requestDidFailWithError");
}

-(void)checkUpdate
{
    NSString * appID = @APP_ID;
    NSString * URL = [NSString stringWithFormat: @"https://itunes.apple.com/lookup?id=%@",appID];
    
    m_request = [[ASRequest alloc] initWithURL:URL];
    [m_request setDelegate:self];
    [m_request startConnectInternet];
}

@end

