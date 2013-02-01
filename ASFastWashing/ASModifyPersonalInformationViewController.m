//
//  ASModifyPersonalInformationViewController.m
//  ASFastWashing
//
//  Created by SSD on 12-12-8.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASModifyPersonalInformationViewController.h"
#import "UITableView+ShakeTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "ASAppDelegate.h"
#import "ASRevealViewController.h"
#import "ASRequest.h"
#import "PersonalCenter.h"
#import "ASUser.h"
#import "URL.h"

@interface ASModifyPersonalInformationViewController ()
@property (assign, nonatomic) BOOL isKeyboardShow;  //键盘正在显示
- (void)revealSidebar;
@end

@implementation ASModifyPersonalInformationViewController
@synthesize myTableView = _myTableView;
@synthesize isKeyboardShow;
@synthesize rect_screen;

- (void)dealloc{
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock6)revealBlock {
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
    ASAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (isKeyboardShow) {
        [appDelegate.revealController toggleSidebar:YES duration:kASRevealSidebarDefaultAnimationDuration];
        [[self.view viewWithTag:150] resignFirstResponder];
        [[self.view viewWithTag:151] resignFirstResponder];
        [[self.view viewWithTag:152] resignFirstResponder];
        isKeyboardShow = NO;
    } else {
        [appDelegate.revealController toggleSidebar:NO duration:kASRevealSidebarDefaultAnimationDuration];
        [[self.view viewWithTag:150] becomeFirstResponder];
        isKeyboardShow = YES;
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
 函数功能：显示键盘
*/
- (void)keyboardShowing
{
    [[self.view viewWithTag:150] becomeFirstResponder];
    isKeyboardShow = YES;
}
/*
 函数功能：隐藏键盘
 */
- (void)keyboardMissing
{
    [[self.view viewWithTag:150] resignFirstResponder];
    [[self.view viewWithTag:151] resignFirstResponder];
    [[self.view viewWithTag:152] resignFirstResponder];
    isKeyboardShow = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"导航栏.png"];
    if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    isKeyboardShow = YES;
    rect_screen = [[UIScreen mainScreen]bounds];
    self.navigationItem.title = @"修改信息";
    //添加导航栏按钮
    UIImage * tmp = [UIImage imageNamed:@"导航按钮.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:tmp forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    [leftButton release];
    //注册键盘弹出消息
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardShowing)
                                                 name: @"ModifyPersonalKeyboardShowingNotice"
                                               object: nil];
    //注册键盘消失消息
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardMissing)
                                                 name: @"ModifyPersonalKeyboardMissingNotice"
                                               object: nil];

    //添加右上角“注销登录”按钮
//    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 35)];
//    [cancelButton setTitle:@"注销登录" forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancellationLoginPressed) forControlEvents:UIControlEventTouchUpInside];
//    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
//    cancelButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
//    UIBarButtonItem *cancellationLogin = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
//    self.navigationItem.rightBarButtonItem = cancellationLogin;
//    [cancellationLogin release];
//    [cancelButton release];
    
    //添加tableView
    self.myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))          style:UITableViewStyleGrouped] autorelease];
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = YES;
	self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	self.myTableView.backgroundColor = [UIColor clearColor];
	self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:self.myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UITextField *textField = [[[UITextField alloc] initWithFrame: CGRectMake(50, 12, 200, 25)] autorelease];
        textField.clearsOnBeginEditing = NO;
//        [textField setDelegate:self];
        [textField addTarget:self
                      action:@selector(textFieldDone:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 32, 32)];
        imageView.tag = 60;
        [cell.contentView addSubview:imageView];
        [imageView release];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
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
            myTextField.placeholder = @"原密码";
            myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            myTextField.secureTextEntry = YES;
            UIImage *cons1 = [UIImage imageNamed:@"键盘.png"];
            imageViews.image = cons1;
            [myTextField becomeFirstResponder];
            break;
        case 1:
            myTextField.placeholder = @"新密码";
            myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            myTextField.secureTextEntry = YES;
            UIImage *cons2 = [UIImage imageNamed:@"键盘.png"];
            imageViews.image = cons2;
            break;
        case 2:
            myTextField.placeholder = @"地址:";
            UIImage *cons3 = [UIImage imageNamed:@"地址.png"];
            imageViews.image = cons3;
            break;
        default:
            break;
    }
    myTextField.tag = indexPath.row+150;
    myTextField.delegate = self;
    [myTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    return cell;
}
-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= 3)
        row = 0;
    NSUInteger newIndex[] = {0, row};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex
                                                         length:2];
    UITableViewCell *nextCell = [self.myTableView cellForRowAtIndexPath:newPath];
    [newPath release];
    
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return NO;
 }

/*
 函数功能：当点击“注销登录”按钮时，注销当前用户。
 */
//- (void)cancellationLoginPressed
//{
//    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
//    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    readuser.isLogin = NO;
//    readuser.userName = nil;
//    readuser.password = nil;
//    readuser.question = nil;
//    readuser.answer = nil;
//    readuser.address = nil;
//    readuser.userId = nil;
//    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];
//    [[self.view viewWithTag:150] resignFirstResponder];
//    [[self.view viewWithTag:151] resignFirstResponder];
//    [[self.view viewWithTag:152] resignFirstResponder];
////    PersonalCenter *personal = [[PersonalCenter alloc]init];
////    [self.navigationController pushViewController:personal animated:YES];
////    [personal release];
//    ASAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    [appDelegate application:nil didFinishLaunchingWithOptions:nil];
//}
#pragma mark - keyboardDoneButtonView
/*
 函数功能：当点击“下一项”时调用，使光标跳到下一行。
 */
- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    NSUInteger tag = [firstResponder tag];
    NSUInteger nextTag = tag == 152 ? 150 : tag + 1;
    if (rect_screen.size.height == 480)
    {
        [self animateView:nextTag];
    }
    UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
    [nextField becomeFirstResponder];
}
/*
 函数功能：当点击“上一项”时调用，使光标跳到上一行。
 */
- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    NSUInteger tag = [firstResponder tag];
    NSUInteger nextTag = tag == 150 ? 152 : tag - 1;
    if (rect_screen.size.height == 480)
    {
        [self animateView:nextTag];
    }
    UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
    [nextField becomeFirstResponder];
}
/*
 函数功能：当点击“保存”时调用。
 */
- (void)saveKeyboard:(id)sender
{
    UITextField *password = (UITextField*)[self.view viewWithTag:150];
    UITextField *theNewPassword = (UITextField*)[self.view viewWithTag:151];
    UITextField *address = (UITextField*)[self.view viewWithTag:152];
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (theNewPassword.text.length != 0) {
        //网络请求
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:readuser.userName,@"UserName",password.text,@"Password",theNewPassword.text,@"newPassword",address.text,@"address", nil];
        request = [[[ASRequest alloc]initWithRequest:dic andURL:ResetPassWord] autorelease];
        [request setDelegate:self];
        [request startConnectInternet];
        [dic release];
    }else{
        [self.myTableView shake];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];

}
/*
 函数功能：得到当前响应者。
 */
- (id)getFirstResponder
{
    NSUInteger index = 150;
    while (index <= 152) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}
/*
 函数功能：定义视图的相应位置。
 */
- (void)animateView:(NSUInteger)tag
{
    CGRect bounds = [self.myTableView bounds];
    switch (tag) {
        case 150:
            bounds.origin.y = 0;
            break;
        case 151:
            bounds.origin.y = 0;
            break;
        case 152:
            bounds.origin.y = 28;
            break;
        default:
            break;
    }
    [self.myTableView setBounds:bounds];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (rect_screen.size.height == 480) {
        NSUInteger tag = [textField tag];
        [self animateView:tag];
    }
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* underneath = [[[UIBarButtonItem alloc] initWithTitle:@"下一项"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(nextField:)] autorelease];
    
    UIBarButtonItem* superior = [[[UIBarButtonItem alloc] initWithTitle:@"上一项"
                                                                  style:UIBarButtonItemStyleBordered target:self
                                                                 action:@selector(previousField:)] autorelease];
    UIBarButtonItem *spaceBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil] autorelease];
    UIBarButtonItem* hide = [[[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                              style:UIBarButtonItemStyleBordered target:self
                                                             action:@selector(saveKeyboard:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:superior,underneath,spaceBarItem,hide, nil]];
    textField.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
}
#pragma mark - ASRequestDelegate
/*
 函数功能：网络连接成功时，不同返回结果执行不同内容。
*/
-(void)requestDidFinishLoading
{
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([[request.result objectForKey:@"ERROR"]isEqual:@"NO"]) {
        //修改成功
        UITextField *theNewPassword = (UITextField*)[self.view viewWithTag:151];
        UITextField *address = (UITextField*)[self.view viewWithTag:152];
        user.password = theNewPassword.text;
        user.address = address.text;
        user.isLogin = YES;
        NSString *tmp = [NSString stringWithFormat:@"%@%@",user.userName,@"修改成功"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:tmp delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    } else {
        [myTableView shake];
    }
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


@end
