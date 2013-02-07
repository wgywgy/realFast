//
//  FirstViewController.m
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "StoreList.h"
#import "URL.h"
#import "ASStoreDetailInfo.h"
#import "ASMyCell.h"
#import "UIImageView+WebCache.h"
#import "ASStore.h"

@interface StoreList ()
- (void)revealSidebar;
@end

@implementation StoreList
@synthesize
            index = _index,
            test = _test,
            storeName = _storeName,
            allStore = _allStore,
            distance = _distance,
            grade = _grade,
            mySearchBar = _mySearchBar,
            myView = _myView,
            myTableView = _myTableView,
            storeCollect = _storeCollect,
            storeDistance = _storeDistance,
            storeGrade = _storeGrade,
            searchHistory = _searchHistory;

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock4)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
		_revealBlock = [revealBlock copy];
        UIBarButtonItem * leftButton = 
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                      target:self
                                                      action:@selector(revealSidebar)];

		self.navigationItem.leftBarButtonItem = leftButton;
        [leftButton release];
	}
	return self;
}

- (void)revealSidebar {
	_revealBlock();
}

- (void)setMynavigationBarHide:(BOOL)hide
{
    [UIView beginAnimations:@"navHide"context:left];
    [UIView setAnimationDelegate:self];
    if (hide) {
//        self.navigationController.navigationBar.frame = CGRectMake(0, -44, 320, 44);
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    [UIView commitAnimations];
}

- (void)dealloc
{
    [_index release];
    [_storeName release];
    [_allStore release];
    [_distance release];
    [_grade release];
    [_mySearchBar release];
    [_myTableView release];
    [_myView release];
    _refreshHeaderView = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    if (listType == 0) {
        distanceListCount ++;
    }
    if (listType == 1) {
        gradeListCount ++;
    }
    if (listType == 2) {
        collectListCount ++;
    }
    [self startRequestwithType:listType];
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];

    [_refreshHeaderView removeFromSuperview];
    _refreshHeaderView = nil;
    rect_screen = [[UIScreen mainScreen]bounds];
    if (_refreshHeaderView == nil) {
        EGORefreshTableFooterView *view = nil;
		if (rect_screen.size.height <= 480) {
            NSLog(@"%f",self.myTableView.contentSize.height);
            view = [[EGORefreshTableFooterView alloc]
                    initWithFrame:CGRectMake(0, self.myTableView.contentSize.height,320, 480)];
        } else {
            view = [[EGORefreshTableFooterView alloc]
                    initWithFrame:CGRectMake(0, self.myTableView.contentSize.height,320, 480)];
        }
        view.delegate = self;
        [self.myTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
	}
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

//	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];

//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    //显示被隐藏的搜索栏
    if (isSearchView) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:2.618f];
        [self.mySearchBar setAlpha:1.0f];
        [UIView commitAnimations];
        [self.myTableView setFrame:CGRectMake(0, 0, 320, rect_screen.size.height -20)];
//        [self.myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if ((_storeCollect.count >= 5 || _storeGrade.count >= 5 || _storeDistance.count >= 5)) {
        //        && scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 388) {
        //            if (scrollView.contentOffset.y > tmpY)
        if (-currentOffset >= 4)
        {
            navIsHidden = YES;
            //搜索
            if (isSearchView == YES) {
                [self.mySearchBar resignFirstResponder];
                
                for (UIView *possibleButton in self.mySearchBar.subviews)
                {
                    if ([possibleButton isKindOfClass:[UIButton class]])
                    {
                        UIButton *cancelButton = (UIButton*)possibleButton;
                        cancelButton.enabled = YES;
                        break;
                    }
                }
                
                left.hidden = YES;
                mid.hidden = YES;
                right.hidden = YES;
                mySearchBtn.hidden = YES;
                
//                [self.myTableView setFrame:CGRectMake(0, 0, 320, rect_screen.size.height - 20)];
                
            } else {
                //隐藏导航栏
                self.wantsFullScreenLayout = YES;
//                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self setMynavigationBarHide:YES];
                
                left.transform = CGAffineTransformIdentity;
                [UIView beginAnimations:@"leftHide"context:left];
                [UIView setAnimationDelegate:self];
                left.frame = CGRectMake(0, -44, 68, 36);
                [UIView commitAnimations];
                
                mid.transform = CGAffineTransformIdentity;
                [UIView beginAnimations:@"midHide"context:left];
                [UIView setAnimationDelegate:self];
                mid.frame = CGRectMake(68, -44, 68, 36);
                [UIView commitAnimations];
                
                right.transform = CGAffineTransformIdentity;
                [UIView beginAnimations:@"rightHide"context:left];
                [UIView setAnimationDelegate:self];
                right.frame = CGRectMake(136, -44, 68, 36);
                [UIView commitAnimations];
                
                mySearchBar.transform = CGAffineTransformIdentity;
                [UIView beginAnimations:@"rightHide"context:left];
                [UIView setAnimationDelegate:self];
                mySearchBtn.frame = CGRectMake(204, -44, 116, 36);
                [UIView commitAnimations];
                
                //                   left.hidden = YES;
                //                    mid.hidden = YES;
                //                    right.hidden = YES;
                //                    mySearchBtn.hidden = YES;
                
                [self.myTableView setFrame:CGRectMake(0, 0, 320, rect_screen.size.height)];
            }
            //                toTop.hidden = NO;
        } else {
            navIsHidden = NO;
            
            if (isSearchView == YES) {
                //搜索
                //                [self.mySearchBar resignFirstResponder];
                
                //                self.mySearchBar.hidden = YES;
                
                self.wantsFullScreenLayout = YES;
                left.hidden = YES;
                mid.hidden = YES;
                right.hidden = YES;
                mySearchBtn.hidden = YES;
                
//                [self.myTableView setFrame:CGRectMake(0, 44, 320, rect_screen.size.height - 44 - 20)];
                
            } else {
//                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [self setMynavigationBarHide:NO];
                
                left.transform = CGAffineTransformIdentity;
                [UIView beginAnimations:@"leftShow"context:left];
                [UIView setAnimationDelegate:self];
                left.frame = CGRectMake(0, 0, 68, 36);
                [UIView commitAnimations];
                
                mid.transform = CGAffineTransformIdentity;
                [UIView beginAnimations:@"midShow"context:left];
                [UIView setAnimationDelegate:self];
                mid.frame = CGRectMake(68, 0, 68, 36);
                [UIView commitAnimations];
                
                left.transform = CGAffineTransformIdentity;
                [UIView beginAnimations:@"rightShow"context:left];
                [UIView setAnimationDelegate:self];
                right.frame = CGRectMake(136, 0, 68, 36);
                [UIView commitAnimations];
                
                mySearchBar.transform = CGAffineTransformIdentity;
                [UIView beginAnimations:@"rightHide"context:left];
                [UIView setAnimationDelegate:self];
                mySearchBtn.frame = CGRectMake(204, 0, 116, 36);
                [UIView commitAnimations];
                
                
                left.hidden = NO;
                mid.hidden = NO;
                right.hidden = NO;
                mySearchBtn.hidden = NO;
                
                [self.myTableView setFrame:CGRectMake(0, 36, 320, rect_screen.size.height - 36 - 44)];
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isSearchView) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:2.6918f];
        [self.mySearchBar setAlpha:1.0f];
        [UIView commitAnimations];
//        [self.myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.myTableView setFrame:CGRectMake(0, 0, 320, rect_screen.size.height -20)];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableFooterView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.6];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableFooterView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableFooterView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"count:%u", [_stores count]);
    //显示搜索历史
//    if (isSearchView == YES && mySearchTerm == @"") {
//        return [_searchHistory count];
//    }
    //显示洗衣店
    if (listType == 0 ) {
        return [_storeDistance count];
    } else if (listType == 1) {
        return [_storeGrade count];
    } else if (listType == 2) {
        return [_storeCollect count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
//    static NSString * historycellId = @"historycellId";
    
    //搜索历史记录cell
//    if (isSearchView == YES && mySearchTerm == @"")
//    {
//        UITableViewCell * historycell = [tableView dequeueReusableCellWithIdentifier:historycellId];
//        if (historycell == nil) {
//            historycell =
//            [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId]
//             autorelease];
//            //显示历史记录
//            _searchHistory =
//            [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];
//    //        NSLog(@"%@",_searchHistory);
//            historycell.textLabel.text = [_searchHistory objectAtIndex:indexPath.row];
//        }
//        return historycell;
//    } else {
        ASMyCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell =
            [[[ASMyCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId]
             autorelease];
        }
        NSString * info = nil;
        //按距离排序
        if (listType == 0) {
            //判断距离为公里还是米
            if ( [[NSString stringWithFormat:
                   @"%@",[[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"distance"]] length]
                < 4) {
                info =
                [NSString stringWithFormat:@"%@米",[[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"distance"] ];
            } else {
                info =
                [NSString stringWithFormat:@"%.1f公里",
                 [[[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"distance"] floatValue] / 1000];
            }
            imageName = [[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"ShopLogo"];
            NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@",Ip,imageName]];
            [cell.imageView setImageWithURL:url placeholderImage:noLogo];
            [url release];
            cell.textLabel.text = [[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"ShopName"];
            
            addr =
            [NSString stringWithFormat:@"%@",[[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"ShopAddr"] ];

        }
        if (listType == 1) {
            info =
            [NSString stringWithFormat:@"%@分",[[_storeGrade objectAtIndex:indexPath.row]objectForKey:@"ShopAveGrade"] ];
            
            imageName = [[_storeGrade objectAtIndex:indexPath.row]objectForKey:@"ShopLogo"];
            NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@",Ip,imageName]];
            [cell.imageView setImageWithURL:url placeholderImage:noLogo];
            [url release];
            cell.textLabel.text = [[_storeGrade objectAtIndex:indexPath.row]objectForKey:@"ShopName"];
            
            addr =
            [NSString stringWithFormat:@"%@",[[_storeGrade objectAtIndex:indexPath.row]objectForKey:@"ShopAddr"] ];

        }
        if (listType == 2) {
            //判断距离为公里还是米
            if ( [[NSString stringWithFormat:
                   @"%@",[[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"CollectNum"]] length]
                < 5) {
                info =
                [NSString stringWithFormat:@"%@人",[[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"CollectNum"] ];
            } else {
                info =
                [NSString stringWithFormat:@"%.1f万人",
                 [[[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"CollectNum"] floatValue] / 10000];
            }

            imageName = [[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"ShopLogo"];
            NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/%@",Ip,imageName]];
            [cell.imageView setImageWithURL:url placeholderImage:noLogo];
            [url release];
            cell.textLabel.text = [[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"ShopName"];
            
            addr =
            [NSString stringWithFormat:@"%@",[[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"ShopAddr"] ];

        }
        
        cell.detailTextLabel.text = info;
    
        cell.address.text = addr;

        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //cell background
        NSString *bgImgPath = nil;
        if (indexPath.row % 2 == 0) {
            bgImgPath = [[NSBundle mainBundle] pathForResource:@"lightbg" ofType:@"png"];
        } else {
            bgImgPath = [[NSBundle mainBundle] pathForResource:@"darkbg" ofType:@"png"];
        }
        
        UIImage *bgImg =
        [[UIImage imageWithContentsOfFile:bgImgPath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        
        cell.backgroundView = [[[UIImageView alloc] initWithImage:bgImg] autorelease];
        cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cell.backgroundView.frame = cell.bounds;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (isSearchView == YES && mySearchTerm == @"")
//        return (rect_screen.size.height - 100) / 8;
//    else
        return (rect_screen.size.height - 100) / 5;
}

//距离排序
- (IBAction)distanceSort:(UIButton *)sender
{
    distanceListCount = self.myTableView.contentSize.height;
//	if (rect_screen.size.height <= 480) {
//        _refreshHeaderView.frame = CGRectMake(0, self.myTableView.contentSize.height,320, 480);
//    } else {
//        _refreshHeaderView.frame = CGRectMake(0, self.myTableView.contentSize.height,320, 480);
//    }
    listType = 0;
    [self startRequestwithType:0];
    [self.myTableView reloadData];
    
    [sender addSubview:select];
}

//评价分数排序
- (IBAction)agreeSort:(UIButton *)sender
{
    gradeListHeight = self.myTableView.contentSize.height;
    listType = 1;
    [self startRequestwithType:1];
    [self.myTableView reloadData];

    [sender addSubview:select];
}

//收藏人数排序
- (IBAction)favoriteSort:(UIButton *)sender
{
    collectListHeight = self.myTableView.contentSize.height;
    listType = 2;
    [self startRequestwithType:2];
    [self.myTableView reloadData];

    [sender addSubview:select];
}

//搜索按钮展开
- (IBAction)SearchBtn:(id)sender
{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setMynavigationBarHide:YES];

    left.hidden = YES;
    mid.hidden = YES;
    right.hidden = YES;
    mySearchBtn.hidden = YES;
    self.mySearchBar.hidden = NO;
    
    self.mySearchBar.text = @"";
    
    //改变背景
//    UIImage *syncBgImg = [UIImage imageNamed:@""];
//    UIColor *color = [[UIColor alloc] initWithPatternImage:syncBgImg];
    [self.myTableView setBackgroundColor:
            [UIColor colorWithRed:(38.0f/255.0f) green:(44.0f/255.0f) blue:(58.0f/255.0f) alpha:1.0f]];
    
    isSearchView = YES;
    
    //清空数据
    [_storeDistance removeAllObjects];
    [_storeGrade removeAllObjects];
    [_storeCollect removeAllObjects];
    
    [self.myTableView reloadData];
    [self.mySearchBar becomeFirstResponder];
//    [self.myTableView setFrame:CGRectMake(0, 44, 320, rect_screen.size.height - 64)];
    [self.myTableView setFrame:CGRectMake(0, 44, 320, rect_screen.size.height - 20)];
//    [self.myTableView setContentOffset:CGPointMake(0, 44) animated:NO];
}

#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //read
//    _searchHistory =
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];
    //保存历史记录
//    if (mySearchTerm != @"") {
//        [_searchHistory addObject:searchBar.text];
////        [_searchHistory insertObject:searchBar.text atIndex:0];
//        NSLog(@"%@", [_searchHistory class]);
//        NSLog(@"%@",searchBar.text);
//        NSLog(@"search:%d",_searchHistory.count);
//        NSLog(@"searchArray:%@",_searchHistory);
//        [[NSUserDefaults standardUserDefaults] setObject:_searchHistory forKey:@"searchHistory"];
//    
//        //同样的文字搜索不再请求
//        if ([mySearchTerm isEqualToString:searchBar.text] == NO) {
//            mySearchTerm = searchBar.text;
//            [self handleSearchForTerm:mySearchTerm];
//        }
//    }
    
    [self.mySearchBar resignFirstResponder];
    
    //保持取消按钮
    for (UIView *possibleButton in self.mySearchBar.subviews)
    {
        if ([possibleButton isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)possibleButton;
            cancelButton.enabled = YES;
            break;
        }
    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setMynavigationBarHide:NO];
    
//    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
//    animation.timingFunction =
//    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    
//    animation.type = kCATransitionFade;
//    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
    isSearchView = NO;
    //显示选项卡
    left.hidden = NO;
    mid.hidden = NO;
    right.hidden = NO;
    mySearchBtn.hidden = NO;
    
    self.mySearchBar.hidden = YES;
    [self.mySearchBar resignFirstResponder];
    [self resetSearch];
    
    [self.myTableView setBackgroundColor:[UIColor whiteColor]];
    [self.myTableView setContentOffset:CGPointMake(0, -8) animated:NO];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm{
    if([searchTerm length]==0){
        //清理数据
//        [_stores removeAllObjects];
        mySearchTerm = @"";
        if (listType == 0) {
            [_storeDistance removeAllObjects];
        }
        if (listType == 1) {
            [_storeGrade removeAllObjects];
        }
        if (listType == 2) {
            [_storeCollect removeAllObjects];
        }
//        NSLog(@"%d",isSearchView);
//        NSLog(@"mysearchTerm:%@",mySearchTerm);
        [self.myTableView reloadData];
    } else {
        mySearchTerm = searchTerm;
        [self handleSearchForTerm:searchTerm];
    }
}

#pragma mark -- search methods
- (void) resetSearch
{
//    [_stores removeAllObjects];
    [self startRequestwithType:listType];
    [self.myTableView reloadData];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSDictionary * search = nil;
    if (listType == 0) {
        search =
        [[NSDictionary alloc]initWithObjectsAndKeys:searchTerm, @"search", @"0", @"type",
         @"37.997849", @"X", @"114.521973", @"Y",
         @"石家庄",@"CityName", nil];
    } else {
//        NSLog(@"%d",listType);
        search =
        [[NSDictionary alloc]
         initWithObjectsAndKeys:searchTerm, @"search", [NSString stringWithFormat:@"%d",listType], @"type",
         @"石家庄",@"CityName",nil];
    }

    request = [[ASRequest alloc]initWithRequest:search andURL:SearchList];
    [request setDelegate:self];
    [request startConnectInternet];

    [search release];
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

    rect_screen = [[UIScreen mainScreen]bounds];
    if (_refreshHeaderView == nil) {
        EGORefreshTableFooterView *view = nil;
//        NSLog(@"height:%f",self.myTableView.bounds.size.height);
//        NSLog(@"rect:%f",rect_screen.size.height);
		if (rect_screen.size.height <= 480) {
            view = [[EGORefreshTableFooterView alloc]
                    initWithFrame:CGRectMake(0, 533,320, 480)];
        } else {
            view = [[EGORefreshTableFooterView alloc]
                    initWithFrame:CGRectMake(0, 654,320, 560)];
        }
        view.delegate = self;
        [self.myTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
	}
    
    self.navigationController.navigationBarHidden = NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    [leftButton release];
    [leftBarButton release];
    
    second = NO;
    isSearchView = NO;
    navIsHidden = NO;
    
    _storeDistance = [[NSMutableArray alloc]initWithCapacity:0];
    _storeGrade = [[NSMutableArray alloc]initWithCapacity:0];
    _storeCollect = [[NSMutableArray alloc]initWithCapacity:0];
    
    localList = [[NSMutableArray alloc]initWithCapacity:0];
    
    //位置管理器
//    _locManager = [[CLLocationManager alloc]init];
//    [_locManager setDelegate:self];
//    [_locManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
//    //每10M更新位置
//    _locManager.distanceFilter = 10.0f;
//    [_locManager startUpdatingLocation];
    
//    _searchHistory = [[NSMutableArray alloc]initWithCapacity:0];
    //第一行添加按钮分类排序
    //选中距离排序
    listType = 0;
    
    unSelectImage = [[[[UIImage alloc]initWithContentsOfFile:
                       [[NSBundle mainBundle]pathForResource:@"darkbg" ofType:@"png"]] autorelease]
                     stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
    
    SelectImage = [[[UIImage alloc]initWithContentsOfFile:
                    [[NSBundle mainBundle]pathForResource:@"selectBg" ofType:@"png"]] autorelease];
    select = [[[UIImageView alloc]initWithImage:SelectImage]autorelease];
    select.frame = CGRectMake(9, 32, 50, 4);
    
    noLogo = [[UIImage alloc]initWithContentsOfFile:
               [[NSBundle mainBundle]pathForResource: @"star" ofType:@"jpeg"]];
    
    //放大镜图片
    glass = [[[UIImage alloc]initWithContentsOfFile:
               [[NSBundle mainBundle]pathForResource:@"glass" ofType: @"png"]] autorelease];
    glassView = [[[UIImageView alloc]initWithImage:glass] autorelease];
    glassView.frame = CGRectMake(18, 10, 16, 16);
    
    searchBg = [[[[UIImage alloc]initWithContentsOfFile:
                 [[NSBundle mainBundle]pathForResource:@"search" ofType:@"png"]] autorelease]
                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 1)];
    searchBgView = [[[UIImageView alloc]initWithImage:searchBg] autorelease];
    searchBgView.frame = CGRectMake(8, 4, 108, 27);
    
    [self insertSortBar];
    
    //show ads
//    NSString * imgUrl = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
//    UIImageView * join = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
//    join.image = [UIImage imageWithContentsOfFile:imgUrl];
    UIButton * join = [[UIButton alloc]initWithFrame:
                       CGRectMake(0, 0, 320, 36)];
    UIImage * joinImg = [UIImage imageNamed:@"test.jpg"];
    [join setBackgroundImage:joinImg forState:UIControlStateNormal];
    
    join.layer.shadowPath = [UIBezierPath bezierPathWithRect:join.bounds].CGPath;

    join.layer.shadowOffset = CGSizeMake(0, 2);
    join.layer.shadowOpacity = 0.62;
    join.layer.shadowRadius = 4;

    join.tag = 3;
    
    //ads goto view
    [join addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.myView addSubview:join];
    [join release];
    
    //after a while hide ads
    [NSTimer scheduledTimerWithTimeInterval: 3.4 target: self selector: @selector(timerMethod) userInfo: nil repeats: NO];
    
    [self startRequestwithType:0];
    
    self.navigationItem.title = @"快洗";
    
    //提高Tableview的高度
    [self.myTableView setFrame:CGRectMake(0, 36, 320, rect_screen.size.height- 100)];
//    [self.myTableView setBounces:NO];

    //自定义navigationItem
     
    UIImage  * mapIcon   = [UIImage imageNamed:@"地图按钮1.png"];
    UIButton * mapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    
    UIImage  * mapIconPress   = [UIImage imageNamed:@"地图按钮.png"];
    [mapButton setBackgroundImage:mapIconPress forState:UIControlStateHighlighted];

    [mapButton setBackgroundImage:mapIcon forState:UIControlStateNormal];

    [mapButton addTarget:self action:@selector(showMap:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * mapBtnItem = [[UIBarButtonItem alloc]initWithCustomView:mapButton];
    self.navigationItem.rightBarButtonItem = mapBtnItem;
    [mapButton release];
    [mapBtnItem release];
    
    self.mySearchBar = [[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
    self.mySearchBar.placeholder = @"请输入洗衣店名";
    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.mySearchBar.barStyle = UIBarStyleBlack;
    [self.view addSubview:self.mySearchBar];
    self.mySearchBar.hidden = YES;
    [self.mySearchBar setShowsCancelButton:YES animated:NO];
    
    //修改搜索框背景
    //去掉搜索框背景
    [[self.mySearchBar.subviews objectAtIndex:0]removeFromSuperview];
    
    //自定义背景
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索栏.png"]];
    [self.mySearchBar insertSubview:imageView atIndex:0];
    
    [imageView release];
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation: newlocation completionHandler:^(NSArray *array, NSError *error) {
//        if (array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
////            NSString *country = placemark.ISOcountryCode;
//            //返回城市名
//            NSString *city = placemark.locality;
//            
//            NSLog(@"%@",city);
//        }
//    }];
//
//    [geocoder release];
    
    for(UIButton * cc in [self.mySearchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
//            cc.frame = CGRectMake(0, 0, 36, 30);
//            [cc setImage:[[UIImage alloc]initWithContentsOfFile:
//                           [[NSBundle mainBundle]pathForResource:@"搜索取消" ofType:@"png"]]
//                forState:UIControlStateNormal];
            [cc setBackgroundImage:[UIImage imageNamed:@"搜索取消.png"] forState:UIControlStateNormal];
//            [cc insertSubview:[[UIImageView alloc]initWithImage:
//                                [[UIImage alloc]initWithContentsOfFile:
//                               [[NSBundle mainBundle]pathForResource:@"搜索取消" ofType:@"png"]]]
//                       atIndex:0];
        }
    }
    
    //增加搜索栏阴影
    self.mySearchBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:
                                         CGRectMake(self.mySearchBar.bounds.origin.x - 4, self.mySearchBar.bounds.origin.y,
                                                    self.mySearchBar.bounds.size.width + 8, self.mySearchBar.bounds.size.height)].CGPath;
//                                         self.mySearchBar.bounds].CGPath;


    self.mySearchBar.layer.shadowOffset = CGSizeMake(0, 2);
    self.mySearchBar.layer.shadowOpacity = 0.62;
    self.mySearchBar.layer.shadowRadius = 4;
    
    self.mySearchBar.showsCancelButton = YES;
    // replace cancel
    for(UIButton * aView in [self.mySearchBar subviews]){
        if([aView isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)aView;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
            
            break;
        }
    }
    
    self.mySearchBar.delegate = self;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardShowing)
                                                 name: @"SearchViewKeyboardShowingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardMissing)
                                                 name: @"SearchViewKeyboardMissingNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionEnabled)
                                                 name: @"userInteractionEnabledNotice"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(userInteractionAbled)
                                                 name: @"userInteractionAbledNotice"
                                               object: nil];
}

- (void) insertSortBar
{
    left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:unSelectImage forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 68, 36);
    left.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [left setTitle:@"距离" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(distanceSort:) forControlEvents:UIControlEventTouchUpInside];
    [left addSubview:select];
    [self.view addSubview:left];
    
    mid= [UIButton buttonWithType:UIButtonTypeCustom];
    [mid setBackgroundImage:unSelectImage forState:UIControlStateNormal];
    mid.frame = CGRectMake(68, 0, 68, 36);
    [mid setTitle:@"评分" forState:UIControlStateNormal];
    mid.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [mid setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mid addTarget:self action:@selector(agreeSort:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mid];
    
    right= [UIButton buttonWithType:UIButtonTypeCustom];
    [right setBackgroundImage:unSelectImage forState:UIControlStateNormal];
    right.frame = CGRectMake(136, 0, 68, 36);
    right.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [right setTitle:@"收藏数" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(favoriteSort:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    // 增加搜索按钮
//    UIImage * searchImg =[[[[UIImage alloc]initWithContentsOfFile:
//                            [[NSBundle mainBundle]pathForResource:@"" ofType:@"png"]]autorelease]
//                          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    
    mySearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mySearchBtn setBackgroundImage:unSelectImage forState:UIControlStateNormal];
    mySearchBtn.frame = CGRectMake(204, 0, 116, 36);
    [mySearchBtn addSubview:searchBgView];

    [mySearchBtn setTitle:@"共30个商家" forState:UIControlStateNormal];
    mySearchBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [mySearchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [mySearchBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 20, 0, 0)];
    [mySearchBtn addTarget:self action:@selector(SearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //放大镜图片
    [mySearchBtn addSubview:glassView];
//    [glass release];
    [self.view addSubview:mySearchBtn];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    //停止更新位置
    [_locManager stopUpdatingLocation];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation: _locManager.location completionHandler:
//     ^(NSArray *placemarks, NSError *error) {
//         //得到自己当前最近的地名
//         CLPlacemark *placemark = [placemarks objectAtIndex:0];
//         
//         locatedAt =
//         [[placemark.addressDictionary valueForKey:@"locality"] componentsJoinedByString:@", "];
//         NSLog(@"locatedAt%@",locatedAt);
//         
//     }];
//    
//    [geocoder release];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_locManager stopUpdatingLocation];
//    _locManager = nil;
//    [self setMySearchBar:nil];
    
    [super viewDidDisappear:animated];
}

- (void) startRequestwithType:(int)type
{
    listType = type;
    NSDictionary * dic = nil;

    if (type == 0) {
        dic =
        [[NSDictionary alloc]initWithObjectsAndKeys:@"石家庄",@"CityName",@"1",@"type",@"37.997849",@"X",@"114.521973",@"Y"
                                                    ,[NSNumber numberWithInteger:distanceListCount],@"row",nil];
    }
    if (type == 1) {
        dic =
        [[NSDictionary alloc]initWithObjectsAndKeys:@"石家庄",@"CityName",@"2",@"type",[NSNumber numberWithInteger:gradeListCount],@"row", nil];
    }
    if (type == 2) {
        dic =
        [[NSDictionary alloc]initWithObjectsAndKeys:@"石家庄",@"CityName",@"3",@"type",[NSNumber numberWithInteger:collectListCount],@"row", nil];
    }
    
//    operateType = 1;
    request = [[ASRequest alloc]initWithRequest:dic andURL:AllShopInfo];
    [dic release];
    [request setDelegate:self];
    [request startConnectInternet];
}

//点击加入我们
- (void)joinClick
{
    
}

//点击地图按钮，切换到地图视图
- (IBAction)showMap:(id)sender
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.43];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    mapViewCtrl = [[[ASMyMapViewController alloc]init]autorelease];
    [self.navigationController pushViewController:mapViewCtrl animated:NO];
}

//- (void)toTopPress
//{
//    if (isSearchView) {
//        [self.myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    } else {
//        [self.myTableView setContentOffset:CGPointMake(0, 0) animated:NO];
//    }
//}

- (void)timerMethod
{
    for (UIButton *aView in self.myView.subviews)
    {
        if ([aView isKindOfClass:[UIButton class]] && aView.tag == 3) {
            //动画
            CATransition * animation = [CATransition animation];
            animation.delegate = self;
            animation.duration = 1.12;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [animation setType:kCATransitionFade];
            animation.subtype = kCATransitionFromTop;
            [aView.superview.layer addAnimation:animation forKey:@"animation"];
            [aView removeFromSuperview];
            
            break;
        }
    }
    
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.62;
//    self.navigationController.navigationBar.layer.shadowRadius = 4;

}

//when click tableview hide keyboard
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mySearchBar resignFirstResponder];
    return indexPath;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}

//搜索取消按钮
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    searchBar.showsScopeBar = YES;
//    [searchBar sizeToFit];
//    [searchBar setShowsCancelButton:YES animated:YES];
//    
//    self.mySearchBar.layer.shadowOpacity = 0;
//    [self.view addGestureRecognizer:singleTap];
    //
    return YES;
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    searchBar.showsScopeBar = NO;
//    [searchBar sizeToFit];
//    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self resetSearch];
//    [self.myTableView reloadData];
    if (isSearchView) {
//        left.hidden = NO;
//        mid.hidden = NO;
//        right.hidden = NO;
//        mySearchBtn.hidden = NO;
//        isSearchView = NO;
        self.mySearchBar.hidden = NO;
        for (UIView *possibleButton in self.mySearchBar.subviews)
        {
            if ([possibleButton isKindOfClass:[UIButton class]])
            {
                UIButton *cancelButton = (UIButton*)possibleButton;
                cancelButton.enabled = YES;
                break;
            }
        }
        [self.myTableView setFrame:CGRectMake(0, 44, 320, rect_screen.size.height - 64)];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
//        if (navIsHidden == YES) {
//            toTop.hidden = NO;
//        }
    } else {
        //去掉搜索栏
//        left.hidden = YES;
//        mid.hidden = YES;
//        right.hidden = YES;
//        mySearchBtn.hidden = YES;
//        isSearchView = NO;
//        self.mySearchBar.hidden = YES;
        
//        [self.myTableView setFrame:CGRectMake(0, 0, 320, rect_screen.size.height - 20)];
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (navIsHidden == YES) {
//            toTop.hidden = NO;
            [self.navigationController setNavigationBarHidden:YES];
        } else {
            [self.navigationController setNavigationBarHidden:NO];
//            toTop.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setMySearchBar:nil];
    [self setMyTableView:nil];
    [self setMyView:nil];
    [super viewDidUnload];
}

//进入商店详细信息view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSLog(@"mysearchTerm%@",mySearchTerm);
//    NSLog(@"%d",isSearchView);
//    if (isSearchView == YES && mySearchTerm == @"") {
//        self.mySearchBar.text = 
//        [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"]
//                                               objectAtIndex:indexPath.row];
//        
//        [self handleSearchForTerm:self.mySearchBar.text];
//    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        ASStoreDetailInfo * detail = [[ASStoreDetailInfo alloc]init];

        //传shopId
        if (listType == 0) {
            if ([_storeDistance respondsToSelector:@selector(objectAtIndex:)]) {
                detail.shopId = [[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"ShopId"];
                detail.shopTelPhone = [[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"ShopTel"];
                detail.ShopName = [[_storeDistance objectAtIndex:indexPath.row]objectForKey:@"ShopName"];
            }
        }
        if (listType == 1) {
            if ([_storeGrade respondsToSelector:@selector(objectAtIndex:)]) {
                detail.shopId = [[_storeGrade objectAtIndex:indexPath.row]objectForKey:@"ShopId"];
                detail.shopTelPhone = [[_storeGrade objectAtIndex:indexPath.row]objectForKey:@"ShopTel"];
                detail.ShopName = [[_storeGrade objectAtIndex:indexPath.row]objectForKey:@"ShopName"];
            }
        }
        if (listType == 2) {
            if ([_storeCollect respondsToSelector:@selector(objectAtIndex:)]) {
                detail.shopId = [[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"ShopId"];
                detail.shopTelPhone = [[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"ShopTel"];
                detail.ShopName = [[_storeCollect objectAtIndex:indexPath.row]objectForKey:@"ShopName"];
            }
        }
        if (isSearchView) {
            self.mySearchBar.hidden = YES;
            left.hidden = YES;
            mid.hidden = YES;
            right.hidden = YES;
            mySearchBtn.hidden = YES;
            
            [self.myTableView setFrame:CGRectMake(0, 0, 320, rect_screen.size.height - 20)];
        }
//        toTop.hidden = YES;
    
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
//    }
}

#pragma mark ASRequestDelegate

/*
 功能：当数据接收完以后调用
 */
-(void)requestDidFinishLoading
{
#pragma mark -- show info
    
    //生成cell
        if (listType == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:request.result forKey:@"storeDistance"];
            
            //read
            NSArray * dic  =
            [[NSUserDefaults standardUserDefaults] objectForKey:@"storeDistance"];

            [_storeDistance removeAllObjects];
            for (int i = 0; i < [dic count]; i++) {
                [_storeDistance insertObject:[dic objectAtIndex:i] atIndex:i];
            }
        }
        if (listType == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:request.result forKey:@"storeGrade"];
            
            //read
            NSArray * dic  =
            [[NSUserDefaults standardUserDefaults] objectForKey:@"storeGrade"];

            [_storeGrade removeAllObjects];
            for (int i = 0; i < [dic count]; i++) {
                [_storeGrade insertObject:[dic objectAtIndex:i] atIndex:i];
            }
        }
        if (listType == 2) {
            [[NSUserDefaults standardUserDefaults] setObject:request.result forKey:@"storeCollect"];
            
            //read
            NSArray * dic  =
            [[NSUserDefaults standardUserDefaults] objectForKey:@"storeCollect"];

            [_storeCollect removeAllObjects];
            for (int i = 0; i < [dic count]; i++) {
                [_storeCollect insertObject:[dic objectAtIndex:i] atIndex:i];
            }
        }

        [self.myTableView reloadData];
    
        //设置列表背景颜色
        [self.myTableView setBackgroundColor:
                          [UIColor colorWithRed:(38.0f/255.0f) green:(44.0f/255.0f) blue:(58.0f/255.0f)
                                          alpha:1.0f]];
}

/*
 功能：当数据接收出错以后调用
 */
-(void)requestDidFailWithError
{
    if (listType == 0) {
        //read
        NSArray * dic  =
        [[NSUserDefaults standardUserDefaults] objectForKey:@"storeDistance"];
        
        [_storeDistance removeAllObjects];
        for (int i = 0; i < [dic count]; i++) {
            [_storeDistance insertObject:[dic objectAtIndex:i] atIndex:i];
        }
    }
    if (listType == 1) {
        //read
        NSArray * dic  =
        [[NSUserDefaults standardUserDefaults] objectForKey:@"storeGrade"];
        
        [_storeGrade removeAllObjects];
        for (int i = 0; i < [dic count]; i++) {
            [_storeGrade insertObject:[dic objectAtIndex:i] atIndex:i];
        }
    }
    if (listType == 2) {
        //read
        NSArray * dic  =
        [[NSUserDefaults standardUserDefaults] objectForKey:@"storeCollect"];
        
        [_storeCollect removeAllObjects];
        for (int i = 0; i < [dic count]; i++) {
            [_storeCollect insertObject:[dic objectAtIndex:i] atIndex:i];
        }
    }
    
    [self.myTableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    beginOffset = scrollView.contentOffset;
}

//滑动检测
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    CGFloat dy = beginOffset.y - scrollView.contentOffset.y;
 
    currentOffset = dy;
    NSLog(@"current:%f",currentOffset);
    if (isSearchView && currentOffset >= 44) {
        //        NSLog(@"bin");
        //        NSLog(@"hei:%f",scrollView.contentOffset.y);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.618f];
        [self.mySearchBar setAlpha:0.0f];
        [UIView commitAnimations];
        [self.myTableView setFrame:CGRectMake(0, 0, 320, rect_screen.size.height -20)];
//        [self.myTableView setContentOffset:CGPointMake(0, 44) animated:NO];
    }
    if (scrollView.contentOffset.y > 0) {
    if (isSearchView == NO && (_storeCollect.count >= 5 || _storeGrade.count >= 5 || _storeDistance.count >= 5) ) {
        //        && scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 388) {
        //            if (scrollView.contentOffset.y > tmpY)
//            navIsHidden = YES;
            //搜索
            //隐藏导航栏
//            self.wantsFullScreenLayout = YES;
//        left.transform = CGAffineTransformIdentity;
            [UIView beginAnimations:@"leftHide"context:left];
            [UIView setAnimationDelegate:self];
            self.navigationController.navigationBar.frame = CGRectMake(0, currentOffset +20, 320, 44);
            [UIView commitAnimations];
            
            left.transform = CGAffineTransformIdentity;
            [UIView beginAnimations:@"leftHide"context:left];
            [UIView setAnimationDelegate:self];
            left.frame = CGRectMake(0, currentOffset, 68, 36);
            [UIView commitAnimations];
            
            mid.transform = CGAffineTransformIdentity;
            [UIView beginAnimations:@"midHide"context:left];
            [UIView setAnimationDelegate:self];
            mid.frame = CGRectMake(68, currentOffset, 68, 36);
            [UIView commitAnimations];
            
            right.transform = CGAffineTransformIdentity;
            [UIView beginAnimations:@"rightHide"context:left];
            [UIView setAnimationDelegate:self];
            right.frame = CGRectMake(136, currentOffset, 68, 36);
            [UIView commitAnimations];
            
            mySearchBar.transform = CGAffineTransformIdentity;
            [UIView beginAnimations:@"rightHide"context:left];
            [UIView setAnimationDelegate:self];
            mySearchBtn.frame = CGRectMake(204, currentOffset, 116, 36);
            [UIView commitAnimations];
            
            [self.myTableView setFrame:CGRectMake(0, currentOffset, 320, rect_screen.size.height)];
//             left.hidden = NO;
//            mid.hidden = NO;
//            right.hidden = NO;
//            mySearchBtn.hidden = NO;
//            
//            [self.myTableView setFrame:CGRectMake(0, 36, 320, rect_screen.size.height - 36 - 44)];
    }
    }
}

- (void)userInteractionEnabled
{
    self.view.userInteractionEnabled = YES;
}
- (void)userInteractionAbled
{
    self.view.userInteractionEnabled = NO;
}

#pragma mark keyboardHide
- (void)keyboardShowing
{
    if (isSearchView) {
        if (  [_storeCollect count] != 0
            ||[_storeDistance count] != 0
            ||[_storeGrade count] != 0)
        {
            //当有搜索结果时 继续隐藏
        } else {
            [self.mySearchBar becomeFirstResponder];
        }
    }
}
- (void)keyboardMissing
{
    if (isSearchView) {
        [self.mySearchBar resignFirstResponder];
    }
}

@end
