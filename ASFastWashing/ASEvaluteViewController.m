//
//  ASEvaluteViewController.m
//  快洗
//
//  Created by yuyang-pc on 12-11-27.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASEvaluteViewController.h"
#import "ASRequest.h"
#import "URL.h"
#import "ASUser.h"
@interface ASEvaluteViewController ()

@end

@implementation ASEvaluteViewController
//@synthesize photo;
//@synthesize photoButton;
@synthesize evaluateText;
@synthesize gradeRate;
@synthesize evaLable;
@synthesize request;
@synthesize shopId;
@synthesize myRow;

-(void)dealloc
{
    //[photo release];
    [shopId release];
    [request release];
    [evaLable release];
    [evaluateText release];
    //[photoButton release];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title=@"商店名";
    self.navigationItem.hidesBackButton = YES;
    
    [request setDelegate:self];
    
    //CGRect rect_screen = [[UIScreen mainScreen]bounds];
    //CGRect bounds = self.view.bounds;
    
    UIImage *listBackground = [[UIImage imageNamed:@"Ebg.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(9, 10, 9, 10)];
    UIImageView * lBgView = [[UIImageView alloc]initWithImage:listBackground];
    lBgView.frame = CGRectMake(12, 8, 296, 152);
    lBgView.contentMode = UIViewContentModeScaleToFill;
    
    UIImage *wline = [[UIImage imageNamed:@"dotBg.png"]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImageView * wlView = [[UIImageView alloc]initWithImage:wline];
    wlView.frame = CGRectMake(0, 44, 296, 2);
    wlView.contentMode = UIViewContentModeScaleToFill;
    [wlView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [lBgView addSubview:wlView];
    
    UIImageView * hlView = [[UIImageView alloc]initWithImage:wline];
    hlView.frame = CGRectMake(95, 0, 2, 44);
    hlView.contentMode = UIViewContentModeScaleToFill;
    [lBgView addSubview:hlView];
     [self.view addSubview:lBgView];
    
    [wlView release];
    [hlView release];
    [lBgView release];
    
    //显示评分lable
    evaLable = [[UILabel alloc]initWithFrame:CGRectMake(16,8, 88, 44)];
    evaLable.text = @"评分:";
    evaLable.backgroundColor = [UIColor clearColor];
    evaLable.font = [UIFont boldSystemFontOfSize:20.0f];
    [evaLable setTextColor:[UIColor brownColor]];
    [evaLable setTextAlignment:NSTextAlignmentCenter];
   [self.view addSubview:evaLable];
    [evaLable release];
    
    
    // Custom Number of Stars
    DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(102, 8, 208, 44) andStars:5 isFractional:YES];
    customNumberOfStars.delegate = self;
    customNumberOfStars.backgroundColor = [UIColor clearColor];
    customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
  	customNumberOfStars.rating = 0;
   	[self.view addSubview:customNumberOfStars];
    [customNumberOfStars release];

    //photo button
//    self.photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    photoButton.frame = CGRectMake(16, 57, 88,97);
//    [photoButton setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
//    [photoButton addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:photoButton];
    
   
     //评价内容
    self.evaluateText = [[[JHStatusTextView alloc]initWithFrame:CGRectMake(16, 57, 288, 97)]autorelease];
    [self.view addSubview:evaluateText];
    evaluateText.delegate = self;
    self.view.backgroundColor = [UIColor blueColor];
    
    //add two button on navigationController
    
    UIImage * wrongIcon = [UIImage imageNamed:@"wrong.png"];
    UIButton * wrongButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 2, 40, 40)];
    [wrongButton setBackgroundImage:wrongIcon forState:UIControlStateNormal];
    [wrongButton addTarget:self action:@selector(wrongPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:wrongButton];
    wrongButton.tag = 1;
    [wrongButton release];
    
    UIImage * rightIcon = [UIImage imageNamed:@"right.png"];
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(272, 2, 40, 40)];
    [rightButton setBackgroundImage:rightIcon forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightButton];
    rightButton.tag = 2;
    [rightButton release];
    
    //获取点击进入的商家ID
    NSMutableArray* selRowOfShopId = [[NSUserDefaults standardUserDefaults] objectForKey:@"EvaShopId"];
    shopId = [selRowOfShopId objectAtIndex:[selRowOfShopId count] - 1];
    
    //获取对店家的
    NSMutableArray* shopEvaluate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyEvaluate"];
   for (int i = 0; i < [shopEvaluate count]; i++)
    {
        NSDictionary* currentShop = [shopEvaluate objectAtIndex:i];
        NSString* currentShopId = [currentShop objectForKey:@"ShopId"];
        if (shopId == currentShopId)
        {
            //[evaluateText.messageTextView resignFirstResponder];
            [evaluateText setText:[currentShop objectForKey:@"EvaText"]];
            self.gradeRate = [[currentShop objectForKey:@"GradeRate"]floatValue];
            customNumberOfStars.rating = gradeRate;
        }
    }
       
      
      //self.photo = readEva.myImage;
      //[self.photoButton setImage:self.photo forState:UIControlStateNormal];
    
    //伸缩键盘
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardShowing)
                                                 name: @"EvaluateViewKeyboardShowingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardMissing)
                                                 name: @"EvaluateViewKeyboardMissingNotice"
                                               object: nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    //获取点击进入的商家ID
    NSMutableArray* selRowOfShopId = [[NSUserDefaults standardUserDefaults] objectForKey:@"EvaShopId"];
    shopId = [selRowOfShopId objectAtIndex:[selRowOfShopId count] - 1];

}
- (void)keyboardShowing
{
    [evaluateText.messageTextView becomeFirstResponder];
}
- (void)keyboardMissing
{
    [evaluateText.messageTextView resignFirstResponder];
   
}
//点击保存按钮，弹出
-(void)saveAlert
{
    UIAlertView* saveAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认保存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    [saveAlert show];
    [saveAlert release];
}



//提示还没有评价
-(void)promptAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有评论或打分" delegate:self cancelButtonTitle:@"去评论" otherButtonTitles:nil,nil];
    [self.evaluateText.messageTextView becomeFirstResponder];
    [alert show];
    [alert release];
}


- (IBAction)wrongPressed
{
    for (UIButton * aButton in self.navigationController.navigationBar.subviews) {
        if (aButton.tag == 1 || aButton.tag == 2) {
            [aButton removeFromSuperview];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//点击评价的勾
- (IBAction)okPressed:(id)sender
{
    [evaluateText.messageTextView resignFirstResponder];
    NSString* placeholderText = [evaluateText getText];
    NSString* defaultPlaceholderText = @"亲说点什么...";
    if ([placeholderText isEqualToString:defaultPlaceholderText] || gradeRate == 0) {
        
        [self promptAlert];
    }

    else{
    [self saveAlert];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ASRequestDelegate

/*
 功能：当数据接收完以后调用
 */
-(void)requestDidFinishLoading
{
    [self wrongPressed];
}
/*
 功能：当数据接收出错以后调用
 */
-(void)requestDidFailWithError

{
    UIAlertView* webAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接失败" delegate:self cancelButtonTitle:@"请检查网络设置" otherButtonTitles:nil, nil];
    [webAlert show];
    [webAlert release];
}


#pragma mark Delegate implementation of NIB instatiated DLStarRatingControl
-(void)newRating:(DLStarRatingControl *)control :(NSInteger)rating
{
    gradeRate = rating;
    switch (gradeRate) {
        case 1:
            [evaLable setText:@"很不满意"];
            break;
        case 2:
            [evaLable setText:@"不太满意"];
            break;
        case 3:
            [evaLable setText:@"满意"];
            break;
        case 4:
            [evaLable setText:@"挺满意"];
            break;
        case 5:
            [evaLable setText:@"非常满意"];
            break;
            
        default:
            break;
    }
    NSLog(@"%d",rating);
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [evaluateText.messageTextView becomeFirstResponder];
    }
    else
    {
        //UIImage* evaImage = self.photo;
        
        //评价时间
        NSDate *date = [NSDate date];
        NSDateFormatter* tmpFor = [[NSDateFormatter alloc]init];
        [tmpFor setDateFormat:@"YYYY-MM-DD"];
        NSString* strDate = [tmpFor stringFromDate:date];
        [tmpFor release];
        NSLog(@"现在时间是: %@",strDate);
        [self EvaluateOfShop:strDate];
    }
}

- (void)EvaluateOfShop:(NSString *)nowTime
{
    //获取数据
    NSString* tmp = [NSString stringWithFormat:@"%d",gradeRate];
    NSString* evaStr = [evaluateText getText];
    
    NSData * data  = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    ASUser *readuser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"用户ID %@",readuser.userId);
    
   NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
    NSArray * ShopData = [preferences objectForKey:@"MyEvaluate"];
    if (ShopData) {
        NSMutableArray * data = [NSMutableArray arrayWithArray:ShopData];
        NSDictionary* evaluateDic = [[NSDictionary alloc]initWithObjectsAndKeys:evaStr,@"EvaText",tmp,@"GradeRate",shopId,@"ShopId", nil];
        [data addObject:evaluateDic];
        [evaluateDic release];
        [preferences setObject:data forKey:@"MyEvaluate"];
       
      
        //保存到数据库
         NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:evaStr,@"Evaluate",tmp,@"Grade",nowTime,@"GradeDate",readuser.userId,@"UserId",shopId,@"ShopId", nil];
        
        request = [[ASRequest alloc]initWithRequest:dic andURL:SubmitMyEvaluate];
        [request setDelegate:self];
        [request startConnectInternet];
        [dic release];

    }
    else
    {
        NSDictionary* evaluateDic = [[NSDictionary alloc]initWithObjectsAndKeys:evaStr,@"EvaText",tmp,@"GradeRate",shopId,@"ShopId", nil];
        NSArray * data = [[NSArray alloc]initWithObjects:evaluateDic, nil];
        [preferences setObject:data forKey:@"MyEvaluate"];
        [data release];
        [evaluateDic release];
        
        //保存到数据库
        NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:evaStr,@"Evaluate",tmp,@"Grade",nowTime,@"GradeDate",readuser.userId,@"UserId",shopId,@"ShopId", nil];
        
        request = [[ASRequest alloc]initWithRequest:dic andURL:SubmitMyEvaluate];
        [request setDelegate:self];
        [request startConnectInternet];
        [dic release];
    }
    [preferences synchronize];
    
}


#pragma mark -  JHStatusTextViewDelegate
-(void)statusTextView:(JHStatusTextView *)textView postedMessage:(NSString *)message
{
    return;
}

@end

//点击photoButton按钮，弹出
//- (IBAction)choosePhoto:(id)sender
//{
//    [evaluateText.messageTextView resignFirstResponder];
//    UIActionSheet *choosePhotoActionSheet;
//
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择照片", @"")
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:NSLocalizedString(@"去拍照", @""), NSLocalizedString(@"去图库", @""), nil];
//    } else {
//        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:NSLocalizedString(@"去图库", @""), nil];
//    }
//
//    [choosePhotoActionSheet showInView:self.view];
//    [choosePhotoActionSheet setTag:2];
//    [choosePhotoActionSheet release];
//}


//#pragma mark - UIActionSheetDelegate
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag == 2) {
//        NSUInteger sourceType = 0;
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            switch (buttonIndex) {
//                case 0:
//                    sourceType = UIImagePickerControllerSourceTypeCamera;
//                    break;
//                case 1:
//                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    break;
//                case 2:
//                    [evaluateText.messageTextView becomeFirstResponder];
//                    return;
//            }
//        }
//        else
//        {
//            if (buttonIndex == 1)
//            {
//                [evaluateText.messageTextView becomeFirstResponder];
//                return;
//            }
//            else
//            {
//                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            }
//        }
//        
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.allowsEditing = YES;
//        imagePickerController.sourceType = sourceType;
//        [self presentModalViewController:imagePickerController animated:YES];
//    }
//    else{
//        if (buttonIndex == 0)
//        {
//            //获取数据
//            NSString* tmp = [NSString stringWithFormat:@"%d",gradeRate];
//            NSString* evaStr = [evaluateText getText];
//            //UIImage* evaImage = self.photo;
//            
//            NSDate *date = [NSDate date];
//            NSDateFormatter* tmpFor = [[NSDateFormatter alloc]init];
//            [tmpFor setDateFormat:@"YYYY-MM-DD HH:MM:SS"];
//            NSString* strDate = [tmpFor stringFromDate:date];
//            
//            NSLog(@"现在时间是: %@",strDate);
//            
//            ASEvaluate* evaluateRecord = [[ASEvaluate alloc]init];
//            evaluateRecord.evaluate = evaStr;
//            evaluateRecord.grade = tmp;
//            //evaluateRecord.myImage = evaImage;
//            evaluateRecord.gradeDate = strDate;
//            
//            //保存在本地
//            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:evaluateRecord] forKey:@"myEvaluate"];
//            
//            //保存到数据库
//            NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:evaStr,@"Evaluate",tmp,@"Grade",strDate,@"GradeDate",@"6",@"OrderId", nil];
//            request.request = dic;
//            request.url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@",Ip,SubmitMyEvaluate]];;
//            
//            [request startConnectInternet];
//            [dic release];
// 
//        }
//    }
//	
//}


//#pragma mark - UIImagePickerControllerDelegate

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//	[picker dismissModalViewControllerAnimated:YES];
//	self.photo = [info objectForKey:UIImagePickerControllerEditedImage];
//	[self.photoButton setImage:self.photo forState:UIControlStateNormal];
//}
//
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissModalViewControllerAnimated:YES];
//}

//#pragma mark - JHStatusTextViewDelegate
//
//-(void)textViewShowActionSheet
//{
//    [self okPressed:nil];
//}

