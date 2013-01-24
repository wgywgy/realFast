//
//  PersonalCenter.m
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//
#import "ASModifyPersonalInformationViewController.h"
#import "ASForgetPasswordViewController.h"
#import "UITableView+ShakeTableView.h"
#import "ASRegisterViewController.h"
#import "ASRevealViewController.h"
#import "ASLogViewController.h"
#import "PersonalCenter.h"
#import "ASAppDelegate.h"
#import "ASRequest.h"
#import "ASUser.h"
#import "URL.h"
#import <QuartzCore/QuartzCore.h>
@interface PersonalCenter ()
@property (assign, nonatomic) BOOL isKeyboardShow;  //键盘正在显示
- (void)revealSidebar;
@end

@implementation PersonalCenter
@synthesize myTextField;
@synthesize loginUser;
@synthesize isKeyboardShow;

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
        UIImage * tmp = [UIImage imageNamed:@"导航按钮.png"];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
        [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:tmp forState:UIControlStateNormal];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
		self.navigationItem.leftBarButtonItem = leftBarButton;
        [leftBarButton release];
        [leftButton release];
	}
	return self;
}
- (void)revealSidebar {
    if (isKeyboardShow) {
        [[self.view viewWithTag:200] resignFirstResponder];
        [[self.view viewWithTag:201] resignFirstResponder];
        self.view.userInteractionEnabled = NO;
        isKeyboardShow = NO;
    }else {
        [[self.view viewWithTag:200] becomeFirstResponder];
        isKeyboardShow = YES;
        self.view.userInteractionEnabled = YES;
    }

	_revealBlock(); 
}
/*
 函数功能：当点击“登录”按钮时调用此方法。
 */
- (IBAction)enter:(id)sender {
    UITextField*tmpUserName= (UITextField*)[self.view viewWithTag:200];
    UITextField*tmpPassword= (UITextField*)[self.view viewWithTag:201];
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *user= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:tmpUserName.text,@"name",tmpPassword.text,@"password", nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    request = [[[ASRequest alloc]initWithRequest:dic andURL:LogIn] autorelease];
    [request setDelegate:self];
    [request startConnectInternet];
    [dic release];
}
#pragma mark - ASRequestDelegate
/*
 函数功能：网络连接成功时，不同返回结果执行不同内容。
 */
-(void)requestDidFinishLoading
{
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([[request.result objectForKey:@"LOGIN"] isEqual:@"YES"]) {
        
        //登录成功
        readuser.isLogin = YES;
        readuser.userId = [request.result objectForKey:@"UserId"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];
        ASModifyPersonalInformationViewController * modifyPersonal = [[ASModifyPersonalInformationViewController alloc]init];
        [self.navigationController pushViewController:modifyPersonal animated:YES];
        [modifyPersonal release];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuViewNotice" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuViewSwitchingNavigationNotice" object:self];

    } else {
        
        //登录失败
        readuser.isLogin = NO;
        [self.myTableView shake];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];
}
/*
 函数功能：当网络请求失败时提示“网络连接错误!”
 */
-(void)requestDidFailWithError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"网络连接错误!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
/*
 函数功能：当点击“忘记密码？”按钮时调用此方法。
 */
- (void)forgetPassword:(id)sender {
    [[self.view viewWithTag:200] resignFirstResponder];
    ASForgetPasswordViewController *forgetPasswordViewController = [[ASForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
    [forgetPasswordViewController release];
}

/*
 函数功能：当点击“注册”按钮时调用此方法。
 */
- (IBAction)login:(id)sender {
    ASRegisterViewController *registerViewController = [[ASRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
    [registerViewController release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)keyboardShowing
{
    [[self.view viewWithTag:200] becomeFirstResponder];
    isKeyboardShow = YES;
//    self.view.userInteractionEnabled = YES;
}
- (void)keyboardMissing
{
    [[self.view viewWithTag:200] resignFirstResponder];
    [[self.view viewWithTag:201] resignFirstResponder];
    isKeyboardShow = NO;
//    self.view.userInteractionEnabled = NO;
}
- (void)userInteractionEnabled
{
    self.view.userInteractionEnabled = YES;
}
- (void)userInteractionAbled
{
    self.view.userInteractionEnabled = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage  *registeredButtonOn = [UIImage imageNamed:@"注册.png"];
    UIImage  * registeredButtonOff = [UIImage imageNamed:@"注册按下.png"];
    [self.registeredButton setBackgroundImage:registeredButtonOff forState:UIControlStateHighlighted];
    [self.registeredButton setBackgroundImage:registeredButtonOn forState:UIControlStateNormal];
    
    UIImage  *loginButtonOn = [UIImage imageNamed:@"登陆.png"];
    UIImage  * loginButtonOff = [UIImage imageNamed:@"登陆按下.png"];
    [self.loginButton setBackgroundImage:loginButtonOff forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:loginButtonOn forState:UIControlStateNormal];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"导航栏.png"];
    if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    //添加右上角“忘记密码”按钮
    UIButton *forgetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 30)];
    [forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPasswordButton addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPasswordButton setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    UIBarButtonItem *forgetPassword = [[UIBarButtonItem alloc]initWithCustomView:forgetPasswordButton];
    self.navigationItem.rightBarButtonItem = forgetPassword;
    [forgetPassword release];
    [forgetPasswordButton release];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardShowing)
                                                 name: @"PersonalCenterKeyboardShowingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardMissing)
                                                 name: @"PersonalCenterKeyboardMissingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionEnabled)
                                                 name: @"userInteractionEnabledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionAbled)
                                                 name: @"userInteractionAbledNotice"
                                               object: nil];
    self.navigationItem.title = @"快洗";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
    
    self.myTableView.sectionFooterHeight = 0;
    loginUser = [[ASUser alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:loginUser] forKey:@"user"];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    self.myTextField = nil;
    [self setRegisteredButton:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= 2)
    {
        row = 0;
    }
    NSUInteger newIndex[] = {0, row};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex
                                                         length:2];
    UITableViewCell *nextCell = [self.myTableView cellForRowAtIndexPath:newPath];
    [newPath release];
    
    UITextField *textField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
    [textField becomeFirstResponder];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(50, 12, 200, 25)];
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        [textField addTarget:self
                      action:@selector(textFieldDone:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 30, 30)];
        imageView.tag = 60;
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    UIImageView *imageViews = (UIImageView*)[cell viewWithTag:60];
    myTextField = nil;
    for (UIView *oneView in cell.contentView.subviews)
    {
        if ([oneView isMemberOfClass:[UITextField class]])
            myTextField = (UITextField *)oneView;
    }
    switch (indexPath.row) {
        case 0:
            myTextField.placeholder = @"用户名：";
            myTextField.inputView = UIKeyboardTypeDefault;
            [myTextField becomeFirstResponder];
            UIImage *cons1 = [UIImage imageNamed:@"32.png"];
            imageViews.image = cons1;
            break;
        case 1:
            myTextField.placeholder = @"密码：";
            myTextField.secureTextEntry = YES;
            myTextField.returnKeyType = UIReturnKeyDone;
            UIImage *cons2 = [UIImage imageNamed:@"键盘.png"];
            imageViews.image = cons2;
            break;
        default:
            break;
    }
    [myTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    myTextField.tag = indexPath.row + 200;
    return cell;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (textField.text != nil)
    {
        if (200 == textField.tag)
        {
            readuser.userName = textField.text;
        }else if (201 == textField.tag)
        {
            readuser.password = textField.text;
        }
    }
    textField.superview.backgroundColor = [UIColor clearColor];
    //保存到本地
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //BUG 边缘
    textField.superview.backgroundColor = [UIColor colorWithRed:250.0/255 green:249.0/255 blue:222.0/255 alpha:1];
}
//限制textfield长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // return NO to not change text
    // 用户名不大于8位
    if (textField.text != nil)
    {
        if (200 == textField.tag)
        {
            loginUser.userName = textField.text;
        }else if (201 == textField.tag)
        {
            loginUser.password = textField.text;
        }
    }
//    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:loginUser] forKey:@"user"];
    
    //用户名不大于12位
    if(strlen([textField.text UTF8String]) >= 12 && range.length != 1 && textField.tag == 200)
    {
        return NO;
    }
    // 密码不大于于15位
    if(strlen([textField.text UTF8String]) >= 15 && range.length != 1 && textField.tag == 201)
    {
        return NO;
    }
    return YES;
}


/*
 函数功能：点击View的其他区域隐藏软键盘。
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self.view viewWithTag:200] resignFirstResponder];
    [myTextField resignFirstResponder];
}
@end
