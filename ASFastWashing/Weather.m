//
//  Weather.m
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "Weather.h"

@interface Weather ()

@end

@implementation Weather

@synthesize city = _city;
@synthesize temp1 = _temp1;
@synthesize weather = _weather;
@synthesize time = _time;
@synthesize img1 = _img1;
@synthesize img2 = _img2;
@synthesize currentCity = _currentCity;
@synthesize weatherInfo = _weatherInfo;
@synthesize activityIndicator = _activityIndicator;
@synthesize activityIndicator3 = _activityIndicator3;
@synthesize activityIndicator4 = _activityIndicator4;
@synthesize activityIndicator5 = _activityIndicator5;
@synthesize myPageControl = _myPageControl;
@synthesize weatherInfoData = _weatherInfoData;
@synthesize selectCityPicker = _selectCityPicker;
@synthesize myModelView = _myModelView;

@synthesize temp3 = _temp3;
@synthesize temp4 = _temp4;
@synthesize temp5 = _temp5;
@synthesize weather3 = _weather3;
@synthesize weather4 = _weather4;
@synthesize weather5 = _weather5;
@synthesize wind3 = _wind3;
@synthesize wind4 = _wind4;
@synthesize wind5 = _wind5;
@synthesize week = _week;
@synthesize date_y = _date_y;
@synthesize date_y3 = _date_y3;
@synthesize date_y4 = _date_y4;
@synthesize date_y5 = _date_y5;
@synthesize img3 = _img3;
@synthesize img4 = _img4;
@synthesize img5 = _img5;
@synthesize img6 = _img6;
@synthesize img7 = _img7;
@synthesize img8 = _img8;
@synthesize index_cl = _index_cl;
@synthesize index_d = _index_d;
@synthesize index_uv = _index_uv;
@synthesize selectCityField = _selectCityField;
@synthesize dictionary = _dictionary;
@synthesize data = _data;
@synthesize cityName = _cityName;
@synthesize cityList = _cityList;

-(void)dealloc
{
    
    [_dictionary release];
    [_data release];
    [_cityName release];
    [_cityList release];
    
    [_city release];
    [_temp1 release];
    [_weather release];
    [_time release];
    [_img1 release];
    [_img2 release];
    [_currentCity release];
    [_weatherInfo release];
    [_activityIndicator release];
    [_activityIndicator3 release];
    [_activityIndicator4 release];
    [_activityIndicator5 release];
    [_myPageControl release];
    [_weatherInfoData release];
    [_selectCityField release];
    [_selectCityPicker release];
    [_myModelView release];
    
    [_img3 release];
    [_img4 release];
    [_img5 release];
    [_img6 release];
    [_img7 release];
    [_img8 release];
    [_index_cl release];
    [_index_d release];
    [_index_uv release];
    [_wind3 release];
    [_wind4 release];
    [_wind5 release];
    [_week release];
    [_date_y release];
    [_date_y3 release];
    [_date_y4 release];
    [_date_y5 release];
    [_weather3 release];
    [_weather4 release];
    [_weather5 release];
    [_temp3 release];
    [_temp4 release];
    [_temp5 release];
    [super dealloc];
}
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock2)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
	}
	return self;
}
- (void)revealSidebar {
	_revealBlock();
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    // [_calendarView updateCalendarToNow];
}

-(void)activeIndicatorStart
{
    [_activityIndicator startAnimating];
    [_activityIndicator3 startAnimating];
    [_activityIndicator4 startAnimating];
    [_activityIndicator5 startAnimating];
}
-(void)activeIndicatorStop
{
    [_activityIndicator stopAnimating];
    [_activityIndicator3 stopAnimating];
    [_activityIndicator4 stopAnimating];
    [_activityIndicator5 stopAnimating];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"天气";
    
    [self activeIndicatorStart];
    
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
    
    UIButton * right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 62, 30)];
    [right setTitle:@"切换城市" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [right setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
    [right addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    [right release];
    
    _weatherInfoData = [[NSMutableData alloc]initWithCapacity:0];
    
    //请求城市天气数据
    [self requestWeatherInfo:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionEnabled)
                                                 name: @"userInteractionEnabledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionAbled)
                                                 name: @"userInteractionAbledNotice"
                                               object: nil];
    
    //重新设置坐标
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    int hight = rect_screen.size.height;
    if (hight>480) {
        _temp1.frame = CGRectMake(20, 170, 280, 92);
    }
    
    //pickerView设置
    
    _selectCityPicker = [[UIPickerView alloc] init];
    [_selectCityPicker sizeToFit];
    _selectCityPicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _selectCityPicker.delegate = self;
    _selectCityPicker.dataSource = self;
    _selectCityPicker.showsSelectionIndicator = YES;
    
    _data = [[NSMutableArray alloc]initWithCapacity:0];
    //读取数据
    NSString * path = [[NSBundle mainBundle]pathForResource:@"ProvinceCity" ofType:@"plist"];
    
    _dictionary =[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    NSString * path2 = [[NSBundle mainBundle]pathForResource:@"cityList" ofType:@"plist"];
    
    //读取所有所有城市id信息
    _cityList = [[NSDictionary alloc]initWithContentsOfFile:path2];
    
    NSArray * sourse = [_dictionary allKeys];
    
    [_data addObject:sourse];
    
    NSArray * value = [_dictionary objectForKey:[sourse objectAtIndex:0]];
    
    [_data addObject:value];
    
    _cityName = [[_data objectAtIndex:1]objectAtIndex:[_selectCityPicker selectedRowInComponent:1]];
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(missingKeyboard) name:@"WeatherKeyboardMissingNotice" object:nil];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日"];
    _date_y.text = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    ///////
    _weather.text = @"";
    _temp3.text = @"";
    _temp4.text = @"";
    _temp5.text = @"";
    ///////////////////
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
    int temp = [dateParts weekday]-1;
    [calendar release];
    
    NSArray * weeks = [NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日", nil];
    
    _date_y3.text = [NSString stringWithFormat:@"%@",[weeks objectAtIndex:temp]];
    
    //往后推迟一天，并且判断是否越界
    temp = (temp + 1)>6?0:(temp+1);
    
    _date_y4.text = [NSString stringWithFormat:@"%@",[weeks objectAtIndex:temp]];
    //往后推迟一天，并且判断是否越界
    temp = (temp + 1)>6?0:(temp+1);
    
    _date_y5.text = [NSString stringWithFormat:@"%@",[weeks objectAtIndex:temp]];
    
    _wind3.text = [_weatherInfo objectForKey:@"wind2"];
    _wind4.text = [_weatherInfo objectForKey:@"wind3"];
    _wind5.text = [_weatherInfo objectForKey:@"wind4"];
    
}
-(void)missingKeyboard
{
    [_selectCityField resignFirstResponder];
    _selectCityField.text = @"";
}

- (void)userInteractionEnabled
{
    self.view.userInteractionEnabled = YES;
}
- (void)userInteractionAbled
{
    self.view.userInteractionEnabled = NO;
}

/*
 功能：请求城市天气数据
 */
- (void)requestWeatherInfo:(NSArray*)currentCity
{
    
    // [self activeIndicatorStart];
    [_weatherInfoData setLength:0];
    
    if (currentCity == nil) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"currentCity" ofType:@"plist"];
        _currentCity = [[NSArray alloc]initWithContentsOfFile:path];
        _city.text = [_currentCity objectAtIndex:0];
    }else
    {
        _currentCity = currentCity;
    }
    //读取当前城市id信息
    
    NSLog(@"%@",_currentCity);
    
    //请求的网址
    NSString *urlString = [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",[_currentCity objectAtIndex:1]];
    
    [_weatherInfoData setLength:0];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:5.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    [connection release];
    [request release];
}

/*
 功能：接收数据
 */
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [_weatherInfoData appendData:data];
}
/*
 功能：请求数据完成，解析数据，显示数据
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError * err = nil;
    NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:_weatherInfoData options:NSJSONReadingMutableLeaves error:&err];
    NSLog(@"%@    %@",[err description],_weatherInfoData);
    if (err == nil) {
        self.weatherInfo = [rootDic objectForKey:@"weatherinfo"];
        [self showInformation];
    }else
    {
        [self activeIndicatorStop];
        
        UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"网络请求失败，请重试！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [myAlert show];
        [myAlert release];
    }
    [_weatherInfoData setLength:0];
}
/*
 功能：数据有误，清空以前的数据
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_weatherInfoData setLength:0];
}
/*
 功能：连接失败，错误提示
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self activeIndicatorStop];
    [_weatherInfoData setLength:0];
    UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:@"网络请求失败，请重试！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [myAlert show];
    [myAlert release];
}
- (void)showInformation
{
    
    _city.text = [_weatherInfo objectForKey:@"city"];
    
    NSString * s = [_weatherInfo objectForKey:@"temp1"];
    _temp1.text = [s stringByReplacingOccurrencesOfString:@"~" withString:@"      "];
    
    NSString * ss = [_weatherInfo objectForKey:@"temp2"];
    _temp3.text = [ss stringByReplacingOccurrencesOfString:@"~" withString:@"  "];
    
    NSString * sss = [_weatherInfo objectForKey:@"temp3"];
    _temp4.text = [sss stringByReplacingOccurrencesOfString:@"~" withString:@"  "];
    
    NSString * ssss = [_weatherInfo objectForKey:@"temp4"];
    _temp5.text = [ssss stringByReplacingOccurrencesOfString:@"~" withString:@"  "];
    
    _weather.text = [_weatherInfo objectForKey:@"weather1"];
    _weather3.text = [_weatherInfo objectForKey:@"weather2"];
    _weather4.text = [_weatherInfo objectForKey:@"weather3"];
    _weather5.text = [_weatherInfo objectForKey:@"weather4"];
    
    _index_uv.text = [_weatherInfo objectForKey:@"index_uv"];
    _index_d.text = [NSString stringWithFormat:@"温馨提示：%@",[_weatherInfo objectForKey:@"index_d"]];
    _index_cl.text = [_weatherInfo objectForKey:@"index_cl"];
    
    _week.text = [_weatherInfo objectForKey:@"week"];
    
    
    
    NSInteger num;
    
    for (int i = 1; i<=8; i++) {
        num = [[_weatherInfo objectForKey:[NSString stringWithFormat:@"img%d",i]] integerValue];
        
        if (num==99) {
            num = 0;
        }
        
        NSString * imageName =[NSString stringWithFormat:@"a%d.gif",num];
        
        UIImageView * view = (UIImageView *)[self.view viewWithTag:100+i];
        
        view.image = [UIImage imageNamed:imageName];
    }
    
    [self activeIndicatorStop];
}

/*
 功能：让textfield作为第一响应者，显示选择城市界面
 */
- (IBAction)press:(id)sender
{
    [_selectCityField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark scrollView代理
/*
 功能：切换pageControl的显示页数
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x / 320);
    
    self.myPageControl.currentPage = page;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //view
    CGRect rect = [[UIScreen mainScreen]bounds];
    if (!_myModelView) {
        _myModelView = [[UIView alloc]initWithFrame:rect];
        
        [_myModelView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.55]];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
  	[window addSubview:_myModelView];
    
    //当指定的单元格需要编辑时，自定义pickerview键盘
    
    _selectCityField.inputView = _selectCityPicker;
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* cancle = [[[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                style:UIBarButtonItemStyleBordered target:self
                                                               action:@selector(cancleSelectCity:)] autorelease];
    
    UIBarButtonItem *spaceBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil] autorelease];
    UIBarButtonItem* select = [[[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                style:UIBarButtonItemStyleBordered target:self
                                                               action:@selector(resignKeyboar:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancle,spaceBarItem,select, nil]];
    _selectCityField.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
    
    return YES;
}
/*
 函数功能：当单元格编辑完成时,清空数据（无用的输入信息）
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _selectCityField.text = @"";
}
/*
 函数功能：隐藏键盘，放弃选择的城市
 */
-(void)cancleSelectCity:(id)sender
{
    [_selectCityField resignFirstResponder];
    [_myModelView removeFromSuperview];
    _selectCityField.text = @"";
}
/*
 函数功能：隐藏键盘，保存选择的城市
 */
- (void)resignKeyboar:(id)sender
{
    [_selectCityField resignFirstResponder];
    [_myModelView removeFromSuperview];
    NSString * cityId = [_cityList objectForKey:self.cityName];
    
    if (cityId == nil) {
        return;
    }
    
    //写入文件
    NSArray * city = [[NSArray alloc]initWithObjects:self.cityName ,cityId,nil];
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"currentCity" ofType:@"plist"];
    
    [city writeToFile:path atomically:YES];
    
    [self activeIndicatorStart];
    
    //重新开始请求城市。
    [self requestWeatherInfo:city];
    
    [city release];
    
    _selectCityField.text = @"";
}

/*
 功能：两个picker
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

/*
 功能：设置这两个picker 的 Rows Count
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [(NSArray*)[_data objectAtIndex:component]count];
}

/*
 功能：设置这两个picker 的宽度值
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (0==component) {
        return 170.0;
    }
    else
    {
        return 150.0;
    }
}
/*
 功能：设置每行的title
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_data objectAtIndex:component]objectAtIndex:row];
}

/*
 功能：当选择一个省份时，刷新数据
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (0==component) {
        NSString * str =[[_data objectAtIndex:component]objectAtIndex:row];
        
        NSArray * tmp = [self.dictionary objectForKey:str];
        
        [_data removeObjectAtIndex:1];
        [_data addObject:tmp];
        
        [pickerView reloadComponent:1];
    }
    
    _cityName =[[_data objectAtIndex:1]objectAtIndex:[_selectCityPicker selectedRowInComponent:1]];
    
}
@end
