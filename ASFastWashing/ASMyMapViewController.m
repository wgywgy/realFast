//
//  ASMyMapViewController.m
//  快洗
//
//  Created by D on 12-11-22.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASMyMapViewController.h"
#import "Annotation.h"
//#import "CustomPopView.h"
#import "ASStoreDetailInfo.h"
#import "URL.h"
#import "ASAppDelegate.h"
#import "ASRevealViewController.h"
#import "InfoMKPointAnnotation.h"

#import <QuartzCore/QuartzCore.h>


@interface ASMyMapViewController ()

@end

@implementation ASMyMapViewController
@synthesize point = _point,tmp,mySearchBar = _mySearchBar;
- (void)dealloc
{
    [_point release];
    [_mySearchBar release];
    [_locManager release];
    [myMapView release];
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_locManager startUpdatingLocation];
}

- (void) startRequestwithRange:(int)range
{
    NSDictionary * dic = nil;
    NSString * lat = [NSString stringWithFormat:@"%f",myMapView.userLocation.location.coordinate.latitude];
    NSString * lng = [NSString stringWithFormat:@"%f",myMapView.userLocation.location.coordinate.longitude];
    
//    NSLog(@"%@",pinArray);
    [myMapView removeAnnotations:pinArray];

    //不限距离
    if (range == 0) {
        dic =
        [[NSDictionary alloc]initWithObjectsAndKeys:@"石家庄",@"CityName",lat,@"lat",lng,@"lng",@"0",@"range", nil];
        myRange = range;
    }
    if (range == 1) {
        dic =
        [[NSDictionary alloc]initWithObjectsAndKeys:@"石家庄",@"CityName",lat,@"lat",lng,@"lng",@"1000",@"range", nil];
        myRange = range;
    }
    if (range == 3) {
        dic =
        [[NSDictionary alloc]initWithObjectsAndKeys:@"石家庄",@"CityName",lat,@"lat",lng,@"lng",@"3000",@"range", nil];
        myRange = range;
    }
    
    request = [[ASRequest alloc]initWithRequest:dic andURL:MapSearch];
    //    NSLog(@"%@",dic);
    [dic release];
    [request setDelegate:self];
    //    [dic release];
    [request startConnectInternet];

}
- (void)tmpChange{
    tmp = YES;
}
- (void)revealSidebar {
    ASAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (tmp) {
        [appDelegate.revealController toggleSidebar:YES duration:kASRevealSidebarDefaultAnimationDuration];
        tmp = NO;
    }else {
        [appDelegate.revealController toggleSidebar:NO duration:kASRevealSidebarDefaultAnimationDuration];
        tmp = YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    //确保导航栏按钮判断进入
    tmp = YES;
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(tmpChange)
                                                 name: @"tmpChangeNotice"
                                               object: nil];
    UIButton * listButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    
    UIImage * listIcon = [UIImage imageNamed:@"列表按钮1.png"];
    [listButton setBackgroundImage:listIcon forState:UIControlStateNormal];
    UIImage * listIconPress = [UIImage imageNamed:@"列表按钮.png"];
    [listButton setBackgroundImage:listIconPress forState:UIControlStateHighlighted];
    
    [listButton addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * listBtnItem = [[UIBarButtonItem alloc]initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = listBtnItem;
    [listBtnItem release];
    [listButton release];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    //添加导航栏按钮
    UIImage * navBtn = [UIImage imageNamed:@"导航按钮.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:navBtn forState:UIControlStateNormal];
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftButton release];
    [leftBarButton release];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionEnabled)
                                                 name: @"userInteractionEnabledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionAbled)
                                                 name: @"userInteractionAbledNotice"
                                               object: nil];
    
    rect_screen = [[UIScreen mainScreen]bounds];
    //生成MAPVIEW
    myMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, rect_screen.size.height -64)];
    myMapView.delegate = self;
    //定位前隐藏
    myMapView.hidden = true;
    myMapView.showsUserLocation = YES;
    //位置管理器
    _locManager = [[CLLocationManager alloc]init];
    [_locManager setDelegate:self];
    [_locManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    //每10M更新位置
    _locManager.distanceFilter = 10.0f;
    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(104, 260, 320, 32)];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"正在加载地图...";
//    [self.view addSubview:label];
//    [label release];
//    
//    UIActivityIndicatorView* activityIndicatorView = [ [ UIActivityIndicatorView  alloc ]
//                                                      initWithFrame:CGRectMake(140.0,210.0,36.0,36.0)];
//    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//    
//    [self.view addSubview:activityIndicatorView];
//    [activityIndicatorView startAnimating];
    
    [self.view addSubview:myMapView];
    
//    if ([_locManager respondsToSelector:@selector(startUpdatingLocation:)]) {
//    }
    
    
    if(pinArray == nil) {
        //发送请求
        NSDictionary * dic = nil;
        NSString * lat = [NSString stringWithFormat:@"%f",myMapView.userLocation.location.coordinate.latitude];
        NSString * lng = [NSString stringWithFormat:@"%f",myMapView.userLocation.location.coordinate.longitude];
        distance = 0;
        myRange = 0;
        dic =
        [[NSDictionary alloc]initWithObjectsAndKeys:@"石家庄",@"CityName",lat,@"lat",lng,@"lng",@"0",@"range", nil];
        
        request = [[ASRequest alloc]initWithRequest:dic andURL:MapSearch];
        [dic release];
        [request setDelegate:self];
        [request startConnectInternet];
    }
    
    self.navigationItem.title = @"快洗";
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)insertBar
{
    Drop = [[DropDownList alloc]initWithFrame:CGRectMake(84, 8, 152, 32)];
    Drop.delegate = self;
    [myMapView addSubview:Drop];
    [Drop release];
    
    //搜索按钮
    search = [UIButton buttonWithType:UIButtonTypeCustom];
    search.frame = CGRectMake(32, 8, 52, 32);
    [search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * searchBg =
    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                      pathForResource:@"searchBack" ofType:@"png"]];
    [search setBackgroundImage:searchBg forState:UIControlStateNormal];
    
    [myMapView addSubview:search];
    
    //定位按钮
    locate = [UIButton buttonWithType:UIButtonTypeCustom];
    locate.frame = CGRectMake(236, 8, 52, 32);
    [locate addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * locateBg =
    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                      pathForResource:@"locateBack" ofType:@"png"]];
    [locate setBackgroundImage:locateBg forState:UIControlStateNormal];
    [myMapView addSubview:locate];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(26, 8, 268, 34)];
    mySearchBar.placeholder = @"请输入洗衣店名";
//    mySearchBar.layer.shadowOffset = CGSizeMake(0, 2);
//    mySearchBar.layer.shadowOpacity = 0.62;
//    mySearchBar.layer.shadowRadius = 8;
    mySearchBar.delegate = self;
    mySearchBar.showsCancelButton = YES;
    mySearchBar.delegate = self;
    
    for(UIButton * aView in [mySearchBar subviews]){
        if([aView isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)aView;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            
            break;
        }
    }
    
    [[mySearchBar.subviews objectAtIndex:0]removeFromSuperview];
    mySearchBar.backgroundColor = [UIColor clearColor];
    [myMapView addSubview:mySearchBar];
    [mySearchBar release];
    mySearchBar.hidden = YES;
}

- (IBAction)search:(id)sender
{
    //隐藏按钮
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.1;
    animation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    animation.type = kCATransitionFade;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
    Drop.hidden = YES;
    search.hidden = YES;
    locate.hidden = YES;
    
    mySearchBar.hidden = NO;
    [mySearchBar becomeFirstResponder];
    
    //清除大头针
    [myMapView removeAnnotations:pinArray];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.1;
    animation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.type = kCATransitionFade;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
    searchBar.hidden = YES;
    
    Drop.hidden = NO;
    search.hidden = NO;
    locate.hidden = NO;
    
    //取消搜索，移除大头针
    //重新插入大头针
    [self startRequestwithRange:myRange];
}

-(IBAction) backgroundTap:(id)sender{
    [mySearchBar resignFirstResponder];
    
    for (UIView *possibleButton in mySearchBar.subviews)
    {
        if ([possibleButton isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)possibleButton;
            cancelButton.enabled = YES;
            break;
        }
    }
    
    if (singleTap != nil) {
        if ([myMapView respondsToSelector:@selector(removeGestureRecognizer:)]) {
            [myMapView removeGestureRecognizer:singleTap];
        }
    }
}

//切换到列表视图
- (IBAction)showList:(id)sender
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.43];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
//    _locManager = nil;
//    self.view = nil;
//    self.point = nil;
//    [_locManager stopUpdatingLocation];
    if (Drop != nil) {
        [Drop removeFromSuperview];
//        Drop = nil;
        [Drop release];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)locate:(id)sender
{
    [_locManager startUpdatingLocation];
    
    //set center of mapView
    MKCoordinateRegion theRegion = { {0.0, 0.0}, {0.0, 0.0} };
    theRegion.center= myMapView.userLocation.location.coordinate;
    
    //缩放的精度。数值越小约精准
    theRegion.span.longitudeDelta = 0.005f;
    theRegion.span.latitudeDelta = 0.005f;
    //让MapView显示缩放后的地图。
    [myMapView setRegion:theRegion animated:YES];
    [_locManager stopUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //停止旋转
    if (activityView != nil) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
        activityView = nil;
    }
    
    //停止更新位置
    [_locManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation: _locManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         if (placemarks.count > 0 ) {
             //得到自己当前最近的地名
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
//             NSString *locatedAt =
//             [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             NSString * loc = placemark.thoroughfare;
             
             //locatedAt就是当前我所在的街道名称
             [myMapView.userLocation setTitle:loc];
             [myMapView.userLocation setSubtitle:@"我在这里"];
             
             //这里是设置地图的缩放，如果不设置缩放地图就非常的尴尬，
             //只能光秃秃的显示中国的大地图，但是我们需要更加精确到当前所在的街道，
             //那么就需要设置地图的缩放。
             MKCoordinateRegion theRegion = { {0.0, 0.0}, {0.0, 0.0} };
             theRegion.center= myMapView.userLocation.location.coordinate;
             
             //缩放的精度。数值越小约精准
             //x 纬度 lat
             theRegion.span.longitudeDelta = 0.005f;
             theRegion.span.latitudeDelta = 0.005f;
             //让MapView显示缩放后的地图。
             [myMapView setRegion:theRegion animated:YES];
             //最后让MapView整体显示， 因为截至到这里，我们已经拿到用户的经纬度，
             //并且已经换算出用户当前所在街道的名称。
             myMapView.hidden = false;
         }
         
     }];
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation: newlocation completionHandler:^(NSArray *array, NSError *error) {
//        if (array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
            //            NSString *country = placemark.ISOcountryCode;
            //返回城市名
//            NSString *city = placemark.locality;
    
            
//            NSLog(@"%@",city);
//        }
//    }];

//    if(pinArray == nil) {
        //发送请求
        NSDictionary * dic = nil;
        NSString * lat = [NSString stringWithFormat:@"%f",myMapView.userLocation.location.coordinate.latitude];
        NSString * lng = [NSString stringWithFormat:@"%f",myMapView.userLocation.location.coordinate.longitude];
        distance = 0;
        myRange = 0;
        dic =
            [[NSDictionary alloc]initWithObjectsAndKeys:@"石家庄",@"CityName",lat,@"lat",lng,@"lng",@"0",@"range", nil];
        
        request = [[ASRequest alloc]initWithRequest:dic andURL:MapSearch];
        [dic release];
        [request setDelegate:self];
        [request startConnectInternet];
        
//        pinArray
//    }
    [geocoder release];
    
    [self insertBar];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ( [error code] == kCLErrorDenied )
    {
        
        //第一次安装含有定位功能的软件时
        //程序将自定提示用户是否让当前App打开定位功能，
        //如果这里选择不打开定位功能，
        //再次调用定位的方法将会失败，并且进到这里。
        //除非用户在设置页面中重新对该软件打开定位服务，
        //否则程序将一直进到这里。
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务已经关闭"
                                                        message:@"请您在设置页面中打开本软件的定位服务"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        //        [manager stopUpdatingHeading];
        [manager stopUpdatingLocation];
    }
    else if ([error code] == kCLErrorHeadingFailure) {
        
    }
}

//在这里我们设置自定义图标来 标志当前我在地图的地方
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
{
    static NSString *identifier = @"spin";
    
    //显示用户位置的那个蓝点也是大头针，不希望改变它，这里要判断一下
    if(annotation != mapView.userLocation)
    {
        MKPinAnnotationView * pin =
        (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if ( !pin ) {
            pin = [[ [MKPinAnnotationView alloc ]
                    initWithAnnotation:annotation reuseIdentifier:identifier ]autorelease];
            pin.canShowCallout = YES;
//            pin.animatesDrop = YES;
//            pin.frame = CGRectMake(0, 0, 16, 24);
//            pin.image = [[[UIImage alloc]initWithContentsOfFile:
//                         [[NSBundle mainBundle]pathForResource:@"map-pins" ofType:@"png"]]autorelease];
            
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightBtn addTarget:self action:@selector(showStore:) forControlEvents:UIControlEventTouchUpInside];
            pin.rightCalloutAccessoryView = rightBtn;
//            pin.tag = [request.result objectAtIndex:]
//            pin.tag = [[[request.result objectAtIndex:1]objectForKey:@"ShopId"] integerValue];
        }
        else
            pin.annotation = annotation;
        return pin;
    }
    
    return nil;
}

- (IBAction)showStore:(UIButton *)sender
{
    pinArray = nil;
//    NSLog(@"%@", sender.superview.superview);
//    for (UILabel * aView in sender.superview) {
        if ([sender.superview isKindOfClass:[MKAnnotationView class]]) {
            NSLog(@"%@",sender.superview);
//            Info
        }
//    sender.superview.subviews
    ASStoreDetailInfo * detail = [[ASStoreDetailInfo alloc]init];
//    detail.shopId =  [[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"ShopId"];
//    detail.shopTelPhone = [[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"ShopTel"];
//    detail.ShopName = ;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    float version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    if (version>=6.0f  &&  !self.view.window)
    {
        [self setMySearchBar:nil];
        myMapView = nil;
        _locManager = nil;
        self.view = nil;
    }
}

- (void)viewDidUnload
{
//    self.view = nil;
//    _locManager = nil;
//    myMapView = nil;
//    [_locManager stopUpdatingLocation];
    [self setMySearchBar:nil];
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [_locManager stopUpdatingLocation];
//    _locManager = nil;
//    myMapView = nil;
    
    [super viewDidDisappear:animated];
}

#pragma mark -- search
#pragma mark Search Bar Delegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:singleTap];
    [singleTap release];
    
    [myMapView addGestureRecognizer:singleTap];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
    [mySearchBar resignFirstResponder];
    
    for (UIView *possibleButton in mySearchBar.subviews)
    {
        if ([possibleButton isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)possibleButton;
            cancelButton.enabled = YES;
            break;
        }
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm{
    if([searchTerm length]==0){
        [self resetSearch];
    }
}

#pragma mark -- search methods
- (void) resetSearch
{
    for (MKPointAnnotation * pin in pinArray) {
        
        //动画
        CATransition * animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.62;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animation setType:kCATransitionFade];
        [myMapView.layer addAnimation:animation forKey:@"animation"];
        
        [myMapView removeAnnotation:pin];

    }
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSDictionary * mapsearch =
    [[NSDictionary alloc]
     initWithObjectsAndKeys:searchTerm, @"search", @"3", @"type", @"石家庄",@"CityName",nil];
    
    request = [[ASRequest alloc]initWithRequest:mapsearch andURL:SearchList];
    [request setDelegate:self];
    [request startConnectInternet];
    
    [mapsearch release];
}


#pragma mark ASRequestDelegate

/*
 功能：当数据接收完以后调用
 */
-(void)requestDidFinishLoading
{
#pragma mark -- show info
//    NSLog(@"%@",request.result);
    
    pinArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i<[(NSArray *)request.result count]; i++) {
        //插入商家位置大头针
        MKPointAnnotation * pin = [[[MKPointAnnotation alloc]init]autorelease];
        pin.coordinate =
        CLLocationCoordinate2DMake([[[request.result objectAtIndex:i]objectForKey:@"ShopPosX"] floatValue],
                                   [[[request.result objectAtIndex:i]objectForKey:@"ShopPosY"] floatValue]);
        
        pin.title = [[request.result objectAtIndex:i]objectForKey:@"ShopName"];
        pin.subtitle =
        [NSString stringWithFormat:@"电话:%@",[[request.result objectAtIndex:i]objectForKey:@"ShopTel"]];
//        pin.storeId =
//        pin.storeName = pin.title;
//        pin.storeTel = pin.subtitle;
        
        [pinArray addObject:pin];
    }
    [myMapView addAnnotations:pinArray];
}
/*
 功能：当数据接收出错以后调用
 */
-(void)requestDidFailWithError
{
//    NSLog(@"error favorites");
}

- (void)userInteractionEnabled
{
    self.view.userInteractionEnabled = YES;
}
- (void)userInteractionAbled
{
    self.view.userInteractionEnabled = NO;
}

@end
