//
//  ASUserEvalution.m
//  ASFastWashing
//
//  Created by Admin on 12-12-18.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASUserEvalution.h"
#import "ASEvalutionCell.h"
#import "ASRequest.h"
#import "URL.h"

@implementation ASUserEvalution
@synthesize myTableView = _myTableView;
@synthesize shopId = _shopId;
@synthesize evalutions = _evalutions;


-(void)dealloc
{
    [_myTableView release];
    [_shopId release];
    [_evalutions release];
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

-(void)viewWillAppear:(BOOL)animated
{
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"用户评价";
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"ShopId", nil];
    request = [[ASRequest alloc]initWithRequest:dic andURL:GetMyEvaluate];
    [request setDelegate:self];
    [request startConnectInternet];
    [dic release];
    
    _evalutions = [[NSArray alloc]init];
    
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 30)];
    [left setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goToBackView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [left release];
//    if (_evalutions.count == 0) {
//        UILabel * label = [[UILabel alloc] init];
//        label.frame = CGRectMake(50, 50, 220, 50);
//        label.backgroundColor = [UIColor clearColor];
//        label.text = @"该洗衣店还没有人评价！";
//        [self.view addSubview:label];
//    }
}

/*
 功能：返回上一个界面
 */
-(void)goToBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%d",[_evalutions count]);
    return [_evalutions count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSInteger row = 0;
    
    static NSString * SectionsTableIdentifier = @"tableCellIdentifier";
    ASEvalutionCell * cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    if (cell==nil) {
        NSArray* array = [[NSBundle mainBundle]loadNibNamed:@"ASEvalutionCell" owner:self options:nil];
        for (id object in array) {
            if ([object isKindOfClass:[ASEvalutionCell class]]) {
                cell = object;
            }
        }
        //不选中
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([_evalutions count]!=0) {
        NSLog(@"%@",_evalutions);
        cell.userName.text = [[_evalutions objectAtIndex:row]objectForKey:@"UserName"];
        cell.myEvalution.text = [[_evalutions objectAtIndex:row]objectForKey:@"Evaluate"];
        //cell.grade.text = [[_evalutions objectAtIndex:row]objectForKey:@"Grade"];
        cell.time.text = [[_evalutions objectAtIndex:row]objectForKey:@"GradeDate"];
        cell.time.textAlignment = NSTextAlignmentRight;
        
        //评价的小星星
        double ShopAveGrade = [[[_evalutions objectAtIndex:row] objectForKey:@"Grade"]doubleValue];
        
        if (ShopAveGrade!=0) {
            
            int aveGrade = (int)(ShopAveGrade!=0?ShopAveGrade:1);
            
            UIImageView*  starImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(189, 5, 17, 17)];
            UIImageView*  starImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(208, 5, 17, 17)];
            UIImageView*  starImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(227, 5, 17, 17)];
            UIImageView*  starImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(246, 5, 17, 17)];
            UIImageView*  starImageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(265, 5, 17, 17)];
            
            NSString* emptyImageUrl = [[NSBundle mainBundle] pathForResource:@"star" ofType:@"png"];
            NSString* fullImageUrl = [[NSBundle mainBundle]pathForResource:@"star_highlighted" ofType:@"png"];
            NSString* halfImageUrl = [[NSBundle mainBundle]pathForResource:@"star_half" ofType:@"png"];
            [starImageView1 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            [starImageView2 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            [starImageView3 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            [starImageView4 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            [starImageView5 setImage:[UIImage imageWithContentsOfFile:emptyImageUrl]];
            
            switch (aveGrade) {
                case 1:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    if (ShopAveGrade>1) {
                        [starImageView2 setImage:[UIImage imageWithContentsOfFile:halfImageUrl]];
                    }
                    break;
                case 2:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    [starImageView2 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    if (ShopAveGrade>2) {
                        [starImageView3 setImage:[UIImage imageWithContentsOfFile:halfImageUrl]];
                    }
                    break;
                    
                case 3:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView2 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView3 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    if (ShopAveGrade>3) {
                        [starImageView4 setImage:[UIImage imageWithContentsOfFile:halfImageUrl]];
                    }
                    break;
                    
                case 4:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView2 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView3 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView4 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    if (ShopAveGrade>4) {
                        [starImageView5 setImage:[UIImage imageWithContentsOfFile:halfImageUrl]];
                    }
                    break;
                    
                case 5:
                    [starImageView1 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView2 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView3 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView4 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    
                    [starImageView5 setImage:[UIImage imageWithContentsOfFile:fullImageUrl]];
                    break;
                    
                default:
                    break;
            }
            [cell.contentView addSubview:starImageView1];
            [starImageView1 release];
            [cell.contentView addSubview:starImageView2];
            [starImageView2 release];
            [cell.contentView addSubview:starImageView3];
            [starImageView3 release];
            [cell.contentView addSubview:starImageView4];
            [starImageView4 release];
            [cell.contentView addSubview:starImageView5];
            [starImageView5 release];
        }
        
    }
    if (row == [_evalutions count]-1) {
        row = 0;
    }else
    {
        row ++;
    }
    return cell;
}


#pragma mark ASRequest Delegate

-(void)requestDidFinishLoading
{
    NSLog(@"%@",[request.result class]);
    if ([request.result respondsToSelector:@selector(objectForKey:)]) {
        if([[request.result objectForKey:@"ERROR"]isEqualToString:@"NOTFIND"])
        return;
    }
    _evalutions = request.result;
    
    [self.myTableView reloadData];
}

-(void)requestDidFailWithError
{
    NSLog(@"ERROR");
    
    
}
@end
