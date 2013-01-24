//
//  ASRegisterViewController.m
//  快洗
//
//  Created by SSD on 12-11-12.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASRegisterViewController.h"
#import "ASModifyPersonalInformationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASUser.h"
#import "UITableView+ShakeTableView.h"
#import "ASBlurredModel.h"
#import "ASRequest.h"
#import "URL.h"

@interface ASRegisterViewController ()
@property (retain, nonatomic) NSString *str;
@end

@implementation ASRegisterViewController
@synthesize myTableView = _myTableView;
@synthesize statusOfAgree;
@synthesize pickerView;
@synthesize secretQuestion;
@synthesize myTextField;
@synthesize user;
@synthesize rect_screen;
@synthesize str;

/*
 函数功能：当点击“注册”按钮时调用此方法。
 */
- (IBAction)registerPressed:(id)sender {
    for (int i = 50; i<55; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:i];
        [textField resignFirstResponder];
    }
    //网络请求
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user.userName,@"name",user.password,@"password",user.question,@"question",user.answer,@"answer",user.address,@"address", nil];
    request = [[[ASRequest alloc]initWithRequest:dic andURL:Register] autorelease];
    [request setDelegate:self];
    [request startConnectInternet];
    [dic release];
}
#pragma mark - ASRequestDelegate
-(void)requestDidFinishLoading
{
    if ([[request.result objectForKey:@"ERROR"]isEqual:@"YES"]) {
        //注册失败时
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else if ([[request.result objectForKey:@"ERROR"]isEqual:@"FORMATERROR"]){
        //输入数据不合法时，表格抖动。
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"数据长度不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if ([[request.result objectForKey:@"ERROR"]isEqual:@"EMPTY"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"请填写必要信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if([[request.result objectForKey:@"ERROR"]isEqual:@"ALREADY EXISTS"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"用户名已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if ([[request.result objectForKey:@"ERROR"]isEqual:@"NO"]) {

        //注册成功
        user.userId = [request.result objectForKey:@"UserId"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
        NSString *tmp = [NSString stringWithFormat:@"%@%@",user.userName,@"注册成功"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:tmp delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
        [alert release];
        user.isLogin = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    } else if([[request.result objectForKey:@"ERROR"]isEqual:@"ALREADY EXISTS"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"用户名已存在" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
-(void)requestDidFailWithError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"网络连接错误!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        //发送通知
        for (UIButton * aButton in self.navigationController.navigationBar.subviews) {
            if (aButton.tag == 1 || aButton.tag == 2) {
                [aButton removeFromSuperview];
            }
        }
        NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuViewSwitchingNotice" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuViewNotice" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuViewSwitchingNavigationNotice" object:self];
        ASModifyPersonalInformationViewController * modifyPersonal = [[ASModifyPersonalInformationViewController alloc]init];
        [self.navigationController pushViewController:modifyPersonal animated:YES];
        [modifyPersonal release];

        readuser.isLogin = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];
    }
}

- (void)keyboardShowing
{
    [[self.view viewWithTag:50] becomeFirstResponder];
}
- (void)keyboardMissing
{
    [[self.view viewWithTag:50] resignFirstResponder];
    [[self.view viewWithTag:51] resignFirstResponder];
    [[self.view viewWithTag:52] resignFirstResponder];
    [[self.view viewWithTag:53] resignFirstResponder];
    [[self.view viewWithTag:54] resignFirstResponder];
}
/*
 函数功能：当点击“取消”按钮时调用此方法。
 */
- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 函数功能：当点击密码框中的按钮时显示密码。
 */
- (IBAction)showHiddenPressed:(UIButton*)sender {
    UITextField *textField = (UITextField*)[self.view viewWithTag:51];
    if (statusOfAgree == NO) { //statusOfAgree == NO
        [sender setTitle:@"显示" forState:UIControlStateNormal];
        textField.secureTextEntry = YES;
        statusOfAgree = YES;
    }else{
        [sender setTitle:@"隐藏" forState:UIControlStateNormal];
        textField.secureTextEntry = NO;
        statusOfAgree = NO;
    }
}
/*
 函数功能：当点击pickerview键盘上的“下一项”时下一项变为第一响应者。
 */
- (void)nextField:(id)sender
{
    UIButton *next = (UIButton*)[self.view viewWithTag:81];
    
    id firstResponder = [self getFirstResponder];
    NSUInteger tag = [firstResponder tag];
    if (tag == 54)
    {
        next.enabled = NO;
        next.backgroundColor = [UIColor redColor];
    }else{
        next.enabled = YES;
        tag++;
    }
    NSUInteger nextTag = tag;
    UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
    if (nextTag == 52) {
        UITextField *tmp = (UITextField *)[self.view viewWithTag:52];
        tmp.text = str;
    }
    [nextField becomeFirstResponder];
}
/*
 函数功能：当点击pickerview键盘上的“上一项”时上一项变为第一响应者。
 */
- (void)previousField:(id)sender
{
    UIButton *previous = (UIButton*)[self.view viewWithTag:80];
    id firstResponder = [self getFirstResponder];
    NSUInteger tag = [firstResponder tag];
    if (tag == 0) {
        tag = 52;
    }
    if (tag == 50) {
        previous.enabled = NO;
    }else
    {
        previous.enabled = YES;
        tag--;
    }
    NSUInteger nextTag = tag;
    UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
    if (nextTag == 52) {
        UITextField *tmp = (UITextField *)[self.view viewWithTag:52];
        tmp.text = str;
    }
    [nextField becomeFirstResponder];
}
/*
 函数功能：当点击“确定”时调用，提交注册。
 */
- (void)confirmKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    [firstResponder resignFirstResponder];
}
/*
 函数功能：得到当前响应者。
 */
- (id)getFirstResponder
{
    NSUInteger index = 50;
    while (index <= 54) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}
/*
 函数功能：定义 iPhone4 视图的相应位置。
 */
- (void)animateView:(NSUInteger)tag
{
    CGRect bounds = [self.myTableView bounds];
    switch (tag) {
        case 50:
            bounds.origin.y = 0;
            break;
        case 51:
            bounds.origin.y = 0;
            break;
        case 52:
            bounds.origin.y = 28;
            break;
        case 53:
            bounds.origin.y = 56;
            break;
        case 54:
            bounds.origin.y = 112;
            break;
        default:
            break;
    }
    [self.myTableView setBounds:bounds];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    str = @"我的名字";
    user = [[ASUser alloc] init];
    user.isLogin = NO;
    rect_screen = [[UIScreen mainScreen]bounds];
    //添加tableView
    self.myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))          style:UITableViewStyleGrouped]autorelease];
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = YES;
	self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	self.myTableView.backgroundColor = [UIColor clearColor];
	self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:self.myTableView];
    //保存到本地
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"注册快洗账号";
    NSArray *array = [[NSArray alloc] initWithObjects:@"我的名字", @"我最爱的人名字", @"我的第一所小学", @"我的第一所初中", @"我的第一所高中", nil];
    self.secretQuestion = array;
    [array release];
    self.myTableView.sectionFooterHeight = 0;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardShowing)
                                                 name: @"RegisterViewKeyboardShowingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardMissing)
                                                 name: @"RegisterViewKeyboardMissingNotice"
                                               object: nil];
    UIImage * wrongIcon = [UIImage imageNamed:@"wrong.png"];
    UIButton * wrongButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, 44, 44)];
    [wrongButton setBackgroundImage:wrongIcon forState:UIControlStateNormal];
    [wrongButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:wrongButton];
    wrongButton.tag = 1;
    [wrongButton release];
//
    UIImage * rightIcon = [UIImage imageNamed:@"right.png"];
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(272, 0, 44, 44)];
    [rightButton setBackgroundImage:rightIcon forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(registerPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightButton];
    rightButton.tag = 2;
    [rightButton release];
}

- (IBAction)cancel:(id)sender
{
    for (UIButton * aButton in self.navigationController.navigationBar.subviews) {
        if (aButton.tag == 1 || aButton.tag == 2) {
            [aButton removeFromSuperview];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_login release];
    [_myTableView release];
    [secretQuestion release];
    [pickerView release];
    [super dealloc];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= 5)
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UITextField *textField = [[[UITextField alloc] initWithFrame: CGRectMake(50, 12, 200, 25)] autorelease];
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        [textField addTarget:self
                      action:@selector(textFieldDone:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 32, 32)];
        imageView.tag = 60;
        [cell.contentView addSubview:imageView];
        [imageView release];
        UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(250, 0, 44, 44)] autorelease];
        button.tag = 61;
        [cell.contentView addSubview:button];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
    }
    UIImageView *imageViews = (UIImageView*)[cell viewWithTag:60];
    UITextField *textField = nil;
    UIButton *button = (UIButton*)[cell viewWithTag:61];
    for (UIView *oneView in cell.contentView.subviews)
    {
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
    switch (indexPath.row) {
        case 0:
            textField.placeholder = @"用户名：6-12位";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            UIImage *cons1 = [UIImage imageNamed:@"32.png"];
            imageViews.image = cons1;
            [textField becomeFirstResponder];
            break;
        case 1:
            textField.placeholder = @"密码：6-12位";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.secureTextEntry = YES;
            statusOfAgree = YES;
            [button setTitle:@"显示" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showHiddenPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *cons2 = [UIImage imageNamed:@"键盘.png"];
            imageViews.image = cons2;
            break;
        case 2:
            [button setTitle:@"密保问题" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(206, 0, 88, 44);
            textField.text = @"我的名字";
            UIImage *cons3 = [UIImage imageNamed:@"问号1.png"];
            imageViews.image = cons3;
            break;
        case 3:
            textField.placeholder = @"密保答案";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            UIImage *cons4 = [UIImage imageNamed:@"灯泡.png"];
            imageViews.image = cons4;
            break;
        case 4:
            textField.placeholder = @"地址：(可选填)";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            UIImage *cons5 = [UIImage imageNamed:@"地址.png"];
            imageViews.image = cons5;
            break;
        default:
            break;
    }
    textField.tag = indexPath.row+50;
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    return cell;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    if (rect_screen.size.height == 480) {
        [self animateView:tag];
    }else{
        
        CGRect bounds = [self.myTableView bounds];
        if (tag == 54) {
            bounds.origin.y = 28;
        }else {
            bounds.origin.y = 0;
        }
        [self.myTableView setBounds:bounds];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 52) {//当指定的单元格需要编辑时，自定义pickerview键盘
        pickerView = [[UIPickerView alloc] init];
        [pickerView sizeToFit];
        pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        textField.inputView = pickerView;
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
        UIBarButtonItem* hide = [[[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘"
                                                                  style:UIBarButtonItemStyleBordered target:self
                                                                 action:@selector(confirmKeyboard:)] autorelease];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:superior,underneath,spaceBarItem,hide, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
        [keyboardDoneButtonView release];
    }else{
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleBlack;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* underneath = [[[UIBarButtonItem alloc] initWithTitle:@"下一项"
                                                                        style:UIBarButtonItemStyleBordered target:self
                                                                       action:@selector(nextField:)] autorelease];
        underneath.tag = 81;
        
        UIBarButtonItem* superior = [[[UIBarButtonItem alloc] initWithTitle:@"上一项"
                                                                      style:UIBarButtonItemStyleBordered target:self
                                                                     action:@selector(previousField:)] autorelease];
        underneath.tag = 80;
        UIBarButtonItem *spaceBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil] autorelease];
        UIBarButtonItem* hide = [[[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘"
                                                                  style:UIBarButtonItemStyleBordered target:self
                                                                 action:@selector(confirmKeyboard:)] autorelease];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:superior,underneath,spaceBarItem,hide, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
        [keyboardDoneButtonView release];
        return YES;
    }
    return YES;
}
/*
 函数功能：当单元格编辑完成时,自动调用。
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (50 == textField.tag){
        user.userName = textField.text;
    }else if (51 == textField.tag){
        user.password = textField.text;
    }else if (52 == textField.tag){
        user.question = textField.text;
        str = textField.text;
    }else if (53 == textField.tag){
        user.answer = textField.text;
    }else if (54 == textField.tag){
        user.address = textField.text;
    }
    //保存到本地
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
}

//限制textfield长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // return NO to not change text
    // 用户名不大于12位
    if(strlen([textField.text UTF8String]) >= 12 && range.length != 1 && textField.tag == 50)
    {
        return NO;
    }
    // 密码不大于于15位
    if(strlen([textField.text UTF8String]) >= 15 && range.length != 1 && textField.tag == 51)
    {
        return NO;
    }
    return YES;
}

#pragma mark - UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [secretQuestion count];
}
#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [secretQuestion objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITextField* text = (UITextField *)[self.view viewWithTag:52];
    text.text = [secretQuestion objectAtIndex:row];
}
@end
