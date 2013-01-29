//
//  Favorites.m
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "Favorites.h"
#import "ASCustomCell.h"
#import "NSDictionary+DeepCopy.h"
#import "ASRequest.h"
#import "URL.h"
#import "ASStore.h"
#import "ASStoreDetailInfo.h"
#import "UIImageView+WebCache.h"

@interface Favorites ()
- (void)revealSidebar;
@end


@implementation Favorites

@synthesize mySearchBar = _mySearchBar;
@synthesize myTableView = _myTableView;
@synthesize stores =_stores;
@synthesize request = _request;

-(void)dealloc
{
    [_request release];
    [_myTableView release];
    [_mySearchBar release];
    [_stores release];
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock3)revealBlock {
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    //dejavu: tableview无分割线
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //隐藏搜索栏
    CGRect bounds = [self.myTableView bounds];
    bounds.origin.y += self.mySearchBar.bounds.size.height;
    [self.myTableView setBounds:bounds];
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    _mySearchBar.showsScopeBar = NO;
    //星星背景图片
    NSString * path = [[NSBundle mainBundle]pathForResource:@"五角星" ofType:@"png"];
    UIView * view = [[UIView alloc]initWithFrame:self.view.frame];
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:path]];
    imageView.frame = CGRectMake( 60 , ((rect_screen.size.height - 64) / 2 ) - 130, 200, 200);
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(90,((rect_screen.size.height - 64) / 2 ) + 100 , 200 , 40)];
    lable.text = @"您收藏夹为空";
    [lable setFont:[UIFont systemFontOfSize:22]];
    [lable setTextColor:[UIColor grayColor]];
    lable.backgroundColor = [UIColor clearColor];
    
    
    [view addSubview:lable];
    [view addSubview:imageView];
    [lable release];
    
    [self.view insertSubview:view atIndex:0];
    [imageView release];
    [view release];
    
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(searchBarResignFirstResponder) name:@"EvaluateViewKeyboardMissingNotice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionEnabled)
                                                 name: @"userInteractionEnabledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionAbled)
                                                 name: @"userInteractionAbledNotice"
                                               object: nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：接受通知后，userInteractionEnabled做出反应
 ****************************************/
- (void)userInteractionEnabled
{
    self.view.userInteractionEnabled = YES;
}
- (void)userInteractionAbled
{
    self.view.userInteractionEnabled = NO;
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：
 ****************************************/
 - (void)searchBarResignFirstResponder
{
    [_mySearchBar resignFirstResponder];
}

/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：编辑收藏夹
 ****************************************/
-(IBAction)toggleEdit:(id)sender
{
    
    [self.myTableView setEditing:!self.myTableView.editing animated:YES];
    if (self.myTableView.editing) {
        
        UIButton * right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
        [right setTitle:@"完成" forState:UIControlStateNormal];
        right.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [right setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
        [right addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
        [right release];
        
        
        UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 30)];
        [left setTitle:@"删除全部" forState:UIControlStateNormal];
        left.titleLabel.font = [UIFont systemFontOfSize: 11.0];
        [left setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
        [left addTarget:self action:@selector(removeAllShop:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
        self.navigationItem.leftBarButtonItem = leftButton;
        [leftButton release];
        [left release];
        
    }
    else{
        UIButton * right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
        UIImage * backImage = [UIImage imageNamed:@"垃圾桶.png"];
        UIImageView * image = [[UIImageView alloc]initWithImage:backImage];
        image.frame = CGRectMake(9, 5, 18, 20);
        [right addSubview:image];
        [image release];
        [right setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
        [right addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
        [right release];
    
        UIImage * tmp = [UIImage imageNamed:@"导航按钮.png"];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
        [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:tmp forState:UIControlStateNormal];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        [leftBarButton release];
        [leftButton release];
    }
    
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：清除所有收藏的商店
 ****************************************/
-(IBAction)removeAllShop:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"删除所有收藏" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    [sheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        int num = [_myTableView numberOfRowsInSection:0];
        for (int i = 0; i<num; i++) {
            [self CancelTheCollection:0];
        }
        [_myTableView reloadData];
        [_myTableView setAlpha:0];
        //隐藏搜索栏
        CGRect bounds = [self.myTableView bounds];
        bounds.origin.y += self.mySearchBar.bounds.size.height;
        [self.myTableView setBounds:bounds];
        
        //变换按钮
        self.navigationItem.rightBarButtonItem = nil;
        
        UIImage * tmp = [UIImage imageNamed:@"导航按钮.png"];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
        [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:tmp forState:UIControlStateNormal];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        [leftBarButton release];
        [leftButton release];
    }
}
//删除cell
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    [self CancelTheCollection:row];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    if ([_stores count]==0) {
        [_myTableView setAlpha:0];
        self.navigationItem.rightBarButtonItem = nil;
        
        UIImage * tmp = [UIImage imageNamed:@"导航按钮.png"];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
        [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:tmp forState:UIControlStateNormal];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        [leftBarButton release];
        [leftButton release];
        
    }
    //隐藏搜索栏
    CGRect bounds = [self.myTableView bounds];
    bounds.origin.y += self.mySearchBar.bounds.size.height;
    [self.myTableView setBounds:bounds];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.myTableView setEditing:NO animated:NO];
    
    _stores = [[NSMutableArray alloc]initWithArray:[self GetShopInfoFromLocal]];
    if ([_stores count]!=0) {
        UIButton * right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
        [right setBackgroundImage:[[UIImage imageNamed:@"button背景.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(9,9,18,9)]  forState:UIControlStateNormal];
        UIImage * backImage = [UIImage imageNamed:@"垃圾桶.png"];
        UIImageView * image = [[UIImageView alloc]initWithImage:backImage];
        image.frame = CGRectMake(9, 5, 18, 20);
        [right addSubview:image];
        [image release];
        [right addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
        [right release];
    }
    [_myTableView reloadData];
}

/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：获取本地收藏的商店
 ****************************************/
- (NSArray*)GetShopInfoFromLocal
{
    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
    
    NSArray * ShopData = [preferences objectForKey:@"LocalShop"];
    if ([ShopData count]!=0) {
        [_myTableView setAlpha:1];
        return ShopData;
    }
    else
    {
        [_myTableView setAlpha:0];
        return nil;
    }
}


#pragma mark ASRequestDelegate

/*
 功能：当数据接收完以后调用
 */
-(void)requestDidFinishLoading
{

}
/*
 功能：当数据接收出错以后调用
 */
-(void)requestDidFailWithError
{
    NSLog(@"error favorites");
}


#pragma mark table代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //显示7个cell
    return ([[UIScreen mainScreen]bounds].size.height - 64) / 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_stores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    
    static NSString * SectionsTableIdentifier = @"SectionsTableIdentifier";
    ASCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    if (cell==nil) {
        NSArray* array = [[NSBundle mainBundle]loadNibNamed:@"ASCustomCell" owner:self options:nil];
        for (id object in array) {
            if ([object isKindOfClass:[ASCustomCell class]]) {
                cell = object;
            }
        }
    }
    if ([_stores count]!=0) {
        cell.data= [_stores objectAtIndex:row];

        cell.storeName.text = [cell.data objectForKey:@"ShopName"];
        
        NSString * imageName = [cell.data objectForKey:@"ShopLogo"];
        
        NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@",Ip,imageName]];
        
        NSString * placeholderImage = [[NSBundle mainBundle] pathForResource:@"star" ofType:@"jpeg"];
        
        [cell.logo setImageWithURL:url placeholderImage:[UIImage imageWithContentsOfFile:placeholderImage]];
        cell.ShopAddress.text = [cell.data objectForKey:@"ShopAddr"];
        
        [url release];

    }

    //cell background
    NSString *bgImgPath = nil;
    if (indexPath.row % 2 == 0) {
        bgImgPath = [[NSBundle mainBundle] pathForResource:@"lightbg" ofType:@"png"];
    } else {
        bgImgPath = [[NSBundle mainBundle] pathForResource:@"darkbg" ofType:@"png"];
    }
    
    UIImage *bgImg = [[UIImage imageWithContentsOfFile:bgImgPath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
    
    cell.backgroundView = [[[UIImageView alloc] initWithImage:bgImg] autorelease];
    cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.backgroundView.frame = cell.bounds;
    cell.index = indexPath.row;
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASStoreDetailInfo * detail = [[ASStoreDetailInfo alloc]init];
    
    //传shopId
    if ([_stores respondsToSelector:@selector(objectAtIndex:)]) {
        detail.shopId = [[_stores objectAtIndex:[indexPath row]]objectForKey:@"ShopId"];
        detail.shopTelPhone = [[_stores objectAtIndex:[indexPath row]]objectForKey:@"ShopTel"];
        detail.ShopName =  [[_stores objectAtIndex:[indexPath row]]objectForKey:@"ShopName"];
    }
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
    
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    ASStoreDetailInfo * detail = [[ASStoreDetailInfo alloc]init];
    
    //传shopId
    if ([_stores respondsToSelector:@selector(objectAtIndex:)]) {
        detail.shopId = [[_stores objectAtIndex:indexPath.row]objectForKey:@"ShopId"];
    }
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_mySearchBar resignFirstResponder];
    return indexPath;
}

#pragma mark scrollview delegate



//滑动检测
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (_stores.count >= 5 ) {
        if (scrollView.contentOffset.y > 55)
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [_myTableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        } else if(scrollView.contentOffset.y <- 55){
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [_myTableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        }
    }
}
#pragma mark searchBar delegate

//搜索-----取消按钮
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
 
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    // replace cancel
    for(id aView in [self.mySearchBar subviews]){
        if([aView isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)aView;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            
            break;
        }
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGRect bounds = [self.myTableView bounds];
    bounds.origin.y += self.mySearchBar.bounds.size.height;
    [self.myTableView setBounds:bounds];
    
    [UIView commitAnimations];
    
    searchBar.text = @"";
    [self resetSearch];
    [_myTableView reloadData];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0) {
        [self resetSearch];
        [_myTableView reloadData];
        return;
    }
    [self handleSearchForTerm:searchTerm];
}

- (void)resetSearch {
    _stores = [[NSMutableArray alloc]initWithArray:[self GetShopInfoFromLocal]];
}
//实现搜索功能
- (void)handleSearchForTerm:(NSString *)searchTerm {
    NSMutableArray * objectsToRemove =[[NSMutableArray alloc] init];
    for (NSDictionary * key in self.stores) {
        if ([[key objectForKey:@"ShopName"] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location ==NSNotFound) {
            [objectsToRemove addObject:key];
        }
    }
    [self.stores removeObjectsInArray:objectsToRemove];
    [objectsToRemove release];
    [_myTableView reloadData];
}

//- (void)switchContrller
//{
//    ASBaseShareViewController * share = [[ASBaseShareViewController alloc]init];
//    [self.navigationController pushViewController:share animated:NO];
//    [share release];
//}

- (void)CancelTheCollection:(NSInteger)row
{
    NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [[_stores objectAtIndex:row] objectForKey:@"ShopId"],@"ShopId",@"-1",@"method",nil];
    _request = [[ASRequest alloc]initWithRequest:dic andURL:CollectionShop];
    [_request startConnectInternet];
    [dic release];
    
    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
    
    NSArray * ShopData = [preferences objectForKey:@"LocalShop"];
    if (ShopData) {
        NSMutableArray * shop = [NSMutableArray arrayWithArray:ShopData];
        [shop removeObjectAtIndex:row];
        [_stores removeObjectAtIndex:row];
        [preferences setObject:shop forKey:@"LocalShop"];
    }
    [preferences synchronize];

//    [_myTableView reloadData];
}

//#pragma mark ASUserDefault
//
////图片保存到本地 key为图片id
//- (void)SaveImageToLocal:(UIImage *)image Keys:(NSString *)key
//{
//    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
//    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
//    
//    [preferences synchronize];
//    
//}
//
////判断本地是否有id为key的图片
//- (BOOL)LocalHaveImage:(NSString *)key
//{
//    if (key == nil) {
//        return NO;
//    }
//    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
//    NSData * imgData = [preferences objectForKey:key];
//    if (imgData) {
//        return YES;
//    }
//    else
//        return NO;
//}
//
////获得本地id为key的图片
//- (UIImage *)GetImageFromLocal:(NSString *)key
//{
//    NSUserDefaults * preferences = [NSUserDefaults standardUserDefaults];
//    NSData * imgData = [preferences objectForKey:key];
//    if (imgData) {
//        UIImage * image = [UIImage imageWithData:imgData];
//        return image;
//    } else {
//        NSLog(@"no local picture!");
//        return nil;
//    }
//}

@end
