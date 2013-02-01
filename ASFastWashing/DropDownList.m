//
//  DropDownList.m
//  DropList
//
//  Created by apple on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DropDownList.h"
#import <QuartzCore/QuartzCore.h>
//#import "ASRequest.h"
//#import "URL.h"

@implementation DropDownList
@synthesize list,listView,lineColor,listBgColor,borderStyle,myButton,delegate;
- (id)initWithFrame:(CGRect)frame {
    
    if(self=[super initWithFrame:frame]){
        //默认的下拉列表中的数据
        list=[[NSArray alloc]initWithObjects:@"不限范围", @"三公里内",@"一公里内",nil];
        
        borderStyle=UITextBorderStyleRoundedRect;
        
        showList=NO; //默认不显示下拉框
        oldFrame=frame; //未下拉时控件初始大小
        //当下拉框显示时，计算出控件的大小。
        newFrame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height*4);
        
        //列表边框线颜色
        lineColor = [UIColor clearColor];
        listBgColor = [UIColor clearColor];
        lineWidth = 1;     //默认列表边框粗细为1
        
        //把背景色设置为透明色，否则会有一个黑色的边
        self.backgroundColor=[UIColor clearColor];
        [self drawView];//调用方法，绘制控件
        
    }
    return self;
}
-(void)drawView{
    
    myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, oldFrame.size.width, oldFrame.size.height);
    [myButton addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventTouchUpInside];
    //按钮字体
    myButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    //颜色
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //按钮背景
//    [myButton setBackgroundImage:[UIImage imageNamed:@"button.png" ] forState:UIControlStateNormal];
    UIImage * myButtonBg = 
    [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                      pathForResource:@"mapButtonCenter" ofType:@"png"]]
     stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
    [myButton setBackgroundImage:myButtonBg forState:UIControlStateNormal];

    [self addSubview:myButton];
    
    [myButton setTitle:@"不限范围" forState:UIControlStateNormal];
    
    //下拉列表
    listView=[[UITableView alloc]initWithFrame:
              CGRectMake(0, 0,
                         oldFrame.size.width,
                         oldFrame.size.height*3 - 1)];
    listView.dataSource=self;
    listView.delegate=self;
    listView.backgroundColor=listBgColor;
    listView.separatorColor=lineColor;
    //一开始listView是隐藏的，此后根据showList的值显示或隐藏
    listView.hidden=!showList;
    listView.bounces = NO;
    
    //列表背景
    UIImage *listBackground = [[UIImage imageNamed:@"listBg.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 8, 10)];
    UIImageView * listBgView = [[UIImageView alloc]initWithImage:listBackground];
    listBgView.frame = CGRectMake(0, 0, 210, 95);
    listBgView.contentMode = UIViewContentModeScaleToFill;
    
    listView.backgroundView = listBgView;
    [listBgView release];
    
    [self addSubview:listView];
    [listView release];
}

-(void)dropdown{
    if(showList) {//如果下拉框已显示，什么都不做
//        [self setShowList:NO];
        return;
    } else {//如果下拉框尚未显示，则进行显示
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        
        [self.superview bringSubviewToFront:self];
        [self setShowList:YES];//显示下拉框
    }
}

#pragma mark listViewdataSource method and delegate method
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"listviewid";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil){
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellid]autorelease];
    }

    cell.textLabel.text=(NSString*)[list objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //字体大小
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return oldFrame.size.height;
}

//当选择下拉列表中的一行时，设置文本框中的值，隐藏下拉列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [myButton setTitle:(NSString*)[list objectAtIndex:indexPath.row]
              forState:UIControlStateNormal];
    //切换排序
    //不限距离
    if (indexPath.row == 0) {
        [self.delegate startRequestwithRange:0];
//        list = ns
//        list=[[NSArray alloc]initWithObjects:@"一公里内",@"三公里内",nil];
//        [listView reloadData];
    }
    //三公里内
    if (indexPath.row == 1) {
        [self.delegate startRequestwithRange:3];
//        list=[[NSArray alloc]initWithObjects:@"一公里内",@"不限范围",nil];
//        [listView reloadData];
    }
    //一公里内
    if (indexPath.row == 2) {
        [self.delegate startRequestwithRange:1];
//        list=[[NSArray alloc]initWithObjects:@"三公里内",@"不限范围",nil];
//        [listView reloadData];
    }
    
    [self setShowList:NO];
}

//setShowList:No为隐藏，setShowList:Yes为显示
-(BOOL)showList{
    return showList;
}

-(void)setShowList:(BOOL)b{
    showList=b;
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.2;
    animation.type = kCATransitionFade;
    
    if(showList){
        animation.timingFunction =
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        self.frame=newFrame;
        
        //设置阴影
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.62;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:
                                 CGRectMake(0, 0,
                                            newFrame.size.width, newFrame.size.height-oldFrame.size.height)]
                                .CGPath;
        self.layer.shadowRadius = 8.0f;
    } else {
        animation.timingFunction =
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        //取消阴影
        self.layer.shadowOpacity = 0;
        self.frame=oldFrame;
    }
    
    [[self.listView layer] addAnimation:animation forKey:@"animation"];

    listView.hidden=!b;
}

- (void)dealloc {
    [super dealloc];
}

@end