//
//  Weather.h
//  快洗
//
//  Created by Admin on 12-11-10.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectCityViewController;
@class DDCalendarView;
typedef void (^RevealBlock2)();

@interface Weather : UIViewController<UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{ 
    UIPageControl * myPageControl;               //Page Control
    DDCalendarView * calendarView;               //日历视图
@private
	RevealBlock2 _revealBlock;
}
- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock2)revealBlock;
@property(nonatomic,retain)IBOutlet UITextField * selectCityField;//选择城市的第一响应者

@property(nonatomic,retain)IBOutlet UILabel * city;   //城市
@property(nonatomic,retain)IBOutlet UILabel * temp1;  //温度1
@property(nonatomic,retain)IBOutlet UILabel * weather; //天气
@property(nonatomic,retain)IBOutlet UILabel * time;   //更新时间
@property(nonatomic,retain)IBOutlet UILabel * date_y; //日期-年月日
@property(nonatomic,retain)IBOutlet UILabel * week;   //日期-周
@property(nonatomic,retain)IBOutlet UIImageView * img1; //天气图片1
@property(nonatomic,retain)IBOutlet UIImageView * img2; //天气图片2
@property(nonatomic,retain)IBOutlet UILabel * index_cl; //晨练
@property(nonatomic,retain)IBOutlet UILabel * index_uv; //紫外线
@property(nonatomic,retain)IBOutlet UILabel * index_d;  //穿衣指数

@property(nonatomic,retain)IBOutlet UIPageControl * myPageControl;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator3;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator4;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator5;

@property(nonatomic,retain)UIPickerView * selectCityPicker;  //选择城市用的picker
//未来三天天气用到的接口
@property(nonatomic,retain)IBOutlet UILabel * temp3;
@property(nonatomic,retain)IBOutlet UILabel * temp4;
@property(nonatomic,retain)IBOutlet UILabel * temp5;
@property(nonatomic,retain)IBOutlet UIImageView * img3;
@property(nonatomic,retain)IBOutlet UIImageView * img4;
@property(nonatomic,retain)IBOutlet UIImageView * img5;
@property(nonatomic,retain)IBOutlet UIImageView * img6;
@property(nonatomic,retain)IBOutlet UIImageView * img7;
@property(nonatomic,retain)IBOutlet UIImageView * img8;
@property(nonatomic,retain)IBOutlet UILabel * weather3;
@property(nonatomic,retain)IBOutlet UILabel * weather4;
@property(nonatomic,retain)IBOutlet UILabel * weather5;
@property(nonatomic,retain)IBOutlet UILabel * wind3;
@property(nonatomic,retain)IBOutlet UILabel * wind4;
@property(nonatomic,retain)IBOutlet UILabel * wind5;
@property(nonatomic,retain)IBOutlet UILabel * date_y3;
@property(nonatomic,retain)IBOutlet UILabel * date_y4;
@property(nonatomic,retain)IBOutlet UILabel * date_y5;

@property(nonatomic,retain)NSArray * currentCity;   //当前的城市
@property(nonatomic,retain)NSDictionary * weatherInfo;  //城市天气情况
@property(nonatomic,retain)NSMutableData * weatherInfoData;//Data数据
//以下为pickerview的数据源
@property (nonatomic,retain) NSMutableArray *data;   //省份名称数组
@property (nonatomic,retain) NSMutableDictionary * dictionary;//省份、城市数据字典
@property (nonatomic,retain) NSString * cityName;    //城市名称
@property (nonatomic,retain) NSDictionary * cityList;//所有城市名称和对应的id

-(IBAction)press:(id)sender;

@end
