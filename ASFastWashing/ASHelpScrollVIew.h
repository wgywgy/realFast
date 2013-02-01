//
//  ASHelpScrollVIew.h
//  ASFastWashing
//
//  Created by yuyang-pc on 12-12-12.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myScrollViewDatasource;

@interface ASHelpScrollVIew : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    id<myScrollViewDatasource> _datasource;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<myScrollViewDatasource> datasource;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end


@protocol myScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;


@end
