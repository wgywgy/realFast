//
//  ASForgetPasswordViewController.m
//  快洗
//
//  Created by SSD on 12-11-20.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASForgetPasswordViewController.h"
#import "ASUser.h"
#import "UITableView+ShakeTableView.h"
#import "ASRequest.h"
#import "URL.h"
@interface ASForgetPasswordViewController ()
//@property (retain, nonatomic) NSString *str;
@end

@implementation ASForgetPasswordViewController
@synthesize pickerView;
@synthesize secretQuestion;
@synthesize myTextField;
@synthesize user;
//@synthesize str;
/*
 函数功能：当点击键盘上的toolbar“确定”时调用，提交注册。
 */
- (void)confirmKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    [firstResponder resignFirstResponder];
}
/*
 函数功能：当导航栏确定按钮点击时，响应该事件。
 */
- (void)ensureButtonPressed:(id)sender
{
    [myTextField resignFirstResponder];
    
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    UITextField* tmp100 = (UITextField *)[self.view viewWithTag:100];
    readuser.userName = tmp100.text;
    UITextField* tmp101 = (UITextField *)[self.view viewWithTag:101];
    readuser.question = tmp101.text;
    UITextField* tmp102 = (UITextField *)[self.view viewWithTag:102];
    readuser.answer = tmp102.text;
    UITextField* tmp103 = (UITextField *)[self.view viewWithTag:103];
    readuser.password = tmp103.text;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:readuser.userName,@"name",readuser.password,@"newPassword",readuser.question,@"question",readuser.answer,@"answer", nil];
    request = [[[ASRequest alloc]initWithRequest:dic andURL:PassWordRetake] autorelease];
    [request setDelegate:self];
    [request startConnectInternet];
    [dic release];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];
}
/*
 函数功能：当导航栏“登录”按钮被点击时，响应该事件
*/
- (void)loginButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - ASRequestDelegate
/*
 函数功能：网络请求成功时，根据不同的返回值，做出不同的响应事件
*/
-(void)requestDidFinishLoading
{
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([[request.result objectForKey:@"ERROR"]isEqual:@"NO"]) {
        //修改成功
        NSString *tmp = [NSString stringWithFormat:@"%@%@",readuser.userName,@"修改成功"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:tmp delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        [alert release];
        readuser.isLogin = YES;
    } else {
        //输入数据不合法时，表格抖动。
        [self.myTableView shake];
    }
}
/*
 函数功能：网络请求失败时，根据响应事件。
*/
-(void)requestDidFailWithError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"网络连接错误!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
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
 函数功能：键盘显示。
*/
- (void)keyboardShowing
{
    [[self.view viewWithTag:100] becomeFirstResponder];
}
/*
 函数功能：键盘隐藏。
 */
- (void)keyboardMissing
{
    [[self.view viewWithTag:100] resignFirstResponder];
    [[self.view viewWithTag:101] resignFirstResponder];
    [[self.view viewWithTag:102] resignFirstResponder];
    [[self.view viewWithTag:103] resignFirstResponder];
}
/*
 函数功能：回到上一级
*/
- (void)goToBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = [[ASUser alloc] init];
    user.isLogin = NO;
    rect_screen = [[UIScreen mainScreen]bounds];
    //添加左上方返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    [backButton addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[[UIImage imageNamed:@"返回按钮.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    [backBarButton release];
    [backButton release];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardShowing)
                                                 name: @"ForgetPasswordViewKeyboardShowingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardMissing)
                                                 name: @"ForgetPasswordViewKeyboardMissingNotice"
                                               object: nil];
    //保存到本地
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
    //读取数据
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.navigationItem.title = @"找回密码";
    //添加右上角确定按钮
    UIButton *ensureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [ensureButton addTarget:self action:@selector(ensureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [ensureButton setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    ensureButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    UIBarButtonItem *ensureBarButton = [[UIBarButtonItem alloc]initWithCustomView:ensureButton];
    self.navigationItem.rightBarButtonItem = ensureBarButton;
    [ensureBarButton release];
    [ensureButton release];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensureButtonPressed:)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//    [rightBarButtonItem release];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"我的名字", @"我最爱的人名字", @"我的第一所小学", @"我的第一所初中", @"我的第一所高中", nil];
    self.secretQuestion = array;
    [array release];
    self.myTableView.sectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myTableView release];
    [pickerView release];
    [secretQuestion release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}
/*
 函数功能：pickerview确定按钮响应事件
 */
- (void)pickerDoneClicked:(id)sender{
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= 4)
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
        UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(50, 12, 200, 25)];
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        [textField addTarget:self
                      action:@selector(textFieldDone:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 32, 32)];
        imageView.tag = 60;
        [cell.contentView addSubview:imageView];
        [imageView release];
        UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(250, 0, 44, 44)] autorelease];
        button.tag = 61;
        [cell.contentView addSubview:button];
        
    }
    UIImageView *imageViews = (UIImageView*)[cell viewWithTag:60];
    UIButton *button = (UIButton*)[cell viewWithTag:61];
    myTextField = nil;
    for (UIView *oneView in cell.contentView.subviews)
    {
        if ([oneView isMemberOfClass:[UITextField class]])
            myTextField = (UITextField *)oneView;
    }
    switch (indexPath.row) {
        case 0:
            myTextField.placeholder = @"用户名";
            NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
            ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            myTextField.text = readuser.userName;
            [myTextField becomeFirstResponder];
            UIImage *cons1 = [UIImage imageNamed:@"32.png"];
            imageViews.image = cons1;
            break;
        case 1:
            [button setTitle:@"密保问题" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(206, 0, 88, 44);
            myTextField.text = @"我的名字";
            UIImage *cons2 = [UIImage imageNamed:@"问号1.png"];
            imageViews.image = cons2;
            break;
        case 2:
            myTextField.placeholder = @"问题答案";
            myTextField.keyboardType = UIKeyboardTypeDefault;
            UIImage *cons3 = [UIImage imageNamed:@"灯泡.png"];
            imageViews.image = cons3;
            break;
        case 3:
            myTextField.placeholder = @"新密码";
            myTextField.secureTextEntry = YES;
            UIImage *cons4 = [UIImage imageNamed:@"键盘.png"];
            imageViews.image = cons4;
            break;
        default:
            break;
    }
    myTextField.tag = indexPath.row + 100;
    [myTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    return cell;
}
/*
 函数功能：当点击pickerview键盘上的“下一项”时下一项变为第一响应者。
 */
- (void)nextField:(id)sender
{
    UIButton *next = (UIButton*)[self.view viewWithTag:81];
    id firstResponder = [self getFirstResponder];
    NSUInteger tag = [firstResponder tag];
    if (tag == 103) {
        next.enabled = NO;
    }else{
        next.enabled = YES;
        tag++;
    }
    NSUInteger nextTag = tag;
    UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
    [nextField becomeFirstResponder];
    if (rect_screen.size.height == 480) {
        [self animateView:nextTag];
    }
}
/*
 函数功能：当点击pickerview键盘上的“上一项”时上一项变为第一响应者。
 */
- (void)previousField:(id)sender
{
    UIButton *previous = (UIButton*)[self.view viewWithTag:80];
    id firstResponder = [self getFirstResponder];
    NSUInteger tag = [firstResponder tag];
    if (tag == 100) {
        previous.enabled = NO;
    }else if(tag == 0) {
        previous.enabled = YES;
        tag = 100;
    }else{
        tag--;
    }
    NSUInteger nextTag = tag;
    UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
//    if (nextTag == 101) {
//        UITextField *tmp = (UITextField *)[self.view viewWithTag:101];
//        tmp.text = str;
//    }else{
//        UITextField *tmp = (UITextField *)[self.view viewWithTag:101];
//        str = tmp.text;
//    }
    [nextField becomeFirstResponder];
    if (rect_screen.size.height == 480) {
        [self animateView:nextTag];
    }
}
/*
 函数功能：获得当前响应者。
*/
- (id)getFirstResponder
{
    NSUInteger index = 100;
    while (index <= 103) {
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
    if (tag == 102 || tag == 103) {
        bounds.origin.y = 56;
    }else {
        bounds.origin.y = 0;
    }
    [self.myTableView setBounds:bounds];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101) {//当指定的单元格需要编辑时，自定义pickerview键盘
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
        superior.tag = 80;
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
//限制textfield长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // return NO to not change text
    // 用户名不大于12位
    if(strlen([textField.text UTF8String]) >= 100 && range.length != 1 && textField.tag == 50)
    {
        return NO;
    }
    // 密码不大于于15位
    if(strlen([textField.text UTF8String]) >= 103 && range.length != 1 && textField.tag == 51)
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
    UITextField* text = (UITextField *)[self.view viewWithTag:101];
    text.text = [secretQuestion objectAtIndex:row];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (100 == textField.tag) {
        readuser.userName = textField.text;
    }else if (101 == textField.tag){
        readuser.question = textField.text;
    }else if (102 == textField.tag){
        readuser.answer = textField.text;
    }else if (103 == textField.tag){
        readuser.password = textField.text;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:readuser] forKey:@"user"];
}
@end
