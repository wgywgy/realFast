//
//  ASShopRegisterViewController.m
//  ASFastWashing
//
//  Created by Hao on 1/2/13.
//  Copyright (c) 2013 SSD. All rights reserved.
//

#import "ASShopRegisterController.h"
#import "ASPositionOfMapController.h"

@interface ASShopRegisterController ()
{
    CGRect rect_screen;
}
@property(nonatomic,assign)CGRect rect_screen;
@end

@implementation ASShopRegisterController

@synthesize tableImage = _tableImage;
@synthesize shopIntro = _shopIntro;
@synthesize shopName = _shopName;
@synthesize shopTel = _shopTel;
@synthesize dic = _dic;
@synthesize rect_screen;

-(void)dealloc
{
    [_tableImage release];
    [_shopTel release];
    [_shopIntro release];
    [_shopName release];
    [_dic release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
    
    //navbaritem
    UIButton * right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 35)];
    [right setTitle:@"下一步" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [right setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    [right addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    [right release];
    
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 66, 35)];
    [left setTitle:@"上一步" forState:UIControlStateNormal];
    left.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [left setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [left release];
    
    self.title = @"注册洗衣店";
    
    rect_screen = [[UIScreen mainScreen]bounds];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"最后背景.png"];
    _tableImage = [[UIImageView alloc]initWithImage:backgroundImage];
    _tableImage.frame = CGRectMake(8, 12, 304, 88);
    [self.view addSubview:_tableImage];
    
    _shopIntro = [[CustomTextView alloc]initWithFrame:CGRectMake(8, 112, 304, 125)];
    [self.view addSubview:_shopIntro];
    [_shopIntro release];
    
    _shopName = [[UITextField alloc]initWithFrame:CGRectMake(50, 22, 250, 38)];
    _shopName.placeholder = @"商店名称";
    _shopName.borderStyle = UITextBorderStyleNone;
    _shopName.enabled = YES;
    UIImage *shopImage = [UIImage imageNamed:@"i洗衣店.png"];
    UIImageView *shopImageView = [[UIImageView alloc]initWithImage:shopImage];
    shopImageView.frame = CGRectMake(13, 8, 24, 24);
    [_tableImage addSubview:shopImageView];
    _shopTel = [[UITextField alloc]initWithFrame:CGRectMake(50, 67, 250, 38)];
    _shopTel.placeholder = @"商店电话";
    _shopTel.borderStyle = UITextBorderStyleNone;
    _shopTel.enabled = YES;
    _shopTel.keyboardType = UIKeyboardTypeNumberPad;
    UIImage *telImage = [UIImage imageNamed:@"i电话.png"];
    UIImageView *telImageView = [[UIImageView alloc]initWithImage:telImage];
    telImageView.frame = CGRectMake(13, 54, 24, 24);
    [_tableImage addSubview:telImageView];
    [_tableImage addSubview:shopImageView];
    [_tableImage addSubview:_shopName];
    [_tableImage addSubview:_shopTel];
    [_tableImage release];
    [self.view addSubview:_shopName];
    [self.view addSubview:_shopTel];
    [_shopTel release];
    [_shopName release];
    [shopImageView release];
    [telImageView release];

    _shopName.tag = 200;
    _shopTel.tag = 201;
    _shopIntro.tag = 202;
    
    _shopName.delegate = self;
    _shopTel.delegate = self;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardShowing)
                                                 name: @"ShopRegisterKeyboardShowingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardMissing)
                                                 name: @"ShopRegisterKeyboardMissingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionEnabled)
                                                 name: @"userInteractionEnabledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionAbled)
                                                 name: @"userInteractionAbledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(nextField:)
                                                 name: @"next"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(previousField:)
                                                 name: @"previous"
                                               object: nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(animateViewTextView)
                                                  name:@"animateViewTextView"
                                                object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(hideKeyboard:)
                                                  name:@"hide"
                                                object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)next:(id)sender
{
    _dic = [[NSDictionary alloc]initWithObjectsAndKeys:_shopName.text,@"shopName",_shopTel.text,@"shopTel",[_shopIntro getText],@"shopIntro", nil];
    ASPositionOfMapController *position = [[ASPositionOfMapController alloc]init];
    position.dicTwo = _dic;
    [_dic release];
    [self.navigationController pushViewController:position animated:YES];
    [position release];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (rect_screen.size.height == 480)
    {
        [self animateView:textField.tag];
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
    UIBarButtonItem* hide = [[[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘"
                                                              style:UIBarButtonItemStyleBordered target:self
                                                             action:@selector(hideKeyboard:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:superior,underneath,spaceBarItem,hide, nil]];
    textField.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (temp.length > 11) {
        textField.text = [temp substringToIndex:11];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"%@",[touch.view description]);
}

/*
 函数功能：当点击pickerview键盘上的“下一项”时下一项变为第一响应者。
 */
- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    NSUInteger tag = [firstResponder tag];
    NSUInteger nextTag = tag == 202 ? 200 : tag + 1;
    if (nextTag!=202) {
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        return;
    }
    [_shopIntro.messageTextView becomeFirstResponder];
}
/*
 函数功能：当点击pickerview键盘上的“上一项”时上一项变为第一响应者。
 */
- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    NSUInteger tag = [firstResponder tag];
    NSUInteger nextTag = tag == 200 ? 202 : tag - 1;
    if (nextTag!=202) {
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        return;
    }
    [_shopIntro.messageTextView becomeFirstResponder];
}
/*
 函数功能：当点击“确定”时调用，提交注册。
 */
- (void)hideKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    [firstResponder resignFirstResponder];
    CGRect bounds = [self.view bounds];
    bounds.origin.y = 0;
    [self.view setBounds:bounds];
}

/*
 函数功能：得到当前响应者。
 */
- (id)getFirstResponder
{
    NSUInteger index = 200;
    while (index <= 201) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    return _shopIntro.messageTextView;
}
/*
 函数功能：定义视图的相应位置。
 */
- (void)animateView:(NSUInteger)tag
{
    CGRect bounds = [self.view bounds];
    switch (tag) {
        case 200:
            bounds.origin.y = 0;
            break;
        case 201:
            bounds.origin.y = 10;
            break;
    }
    [self.view setBounds:bounds];
}
-(void)animateViewTextView
{
    CGRect bounds = [self.view bounds];
    bounds.origin.y = 108;
    [self.view setBounds:bounds];
}

-(void)goToBackView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)keyboardShowing
{
    [[self.view viewWithTag:200] becomeFirstResponder];
}
- (void)keyboardMissing
{
    [[self.view viewWithTag:200] resignFirstResponder];
    [[self.view viewWithTag:201] resignFirstResponder];
    [[self.view viewWithTag:202] resignFirstResponder];
}

@end