//
//  ASRenrenViewController.m
//  WYYShareTest
//
//  Created by Parker on 12-11-23.
//  Copyright (c) 2012年 河北师范大学软件学院. All rights reserved.
//

#import "ASRenrenViewController.h"

#define DEBUG 1
@implementation ASRenrenViewController
@synthesize renren = _renren;

-(void)dealloc
{
    [_renren release];
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self renrenBtnPressed:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)renrenBtnPressed:(id)sender
{    
//此方法授权会提示有误
    self.renren = [Renren sharedRenren]; 
    if (![self.renren isSessionValid]) {
        //[self shareRenForSongs];
        [self.renren authorizationWithPermisson:nil andDelegate:self];
    }
    else
    {
        //[self.renren logout:self];
        [self shareRenForSongs];
    }
//    NSArray * permissions = [NSArray arrayWithObjects:@"photo_upload",@"publish_feed", nil];
//    [self.renren authorizationWithPermisson:permissions andDelegate:self];
    
   //[self shareRenForSongs];
}
-(void)shareRenForSongs
{
    
    //self.renren = [Renren sharedRenren];
    NSString* text = [NSString stringWithFormat:@"大家好！祝大家今天体侧顺利过关！正在研究评论分享中……，嘿嘿，你懂得……"];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"http://share.renren.com/share/361395694/14744176443?from=web_matter",@"url",
                                 @"xxx洗衣店",@"name",
//                                 @"访问我吧",@"action_name",
                                 @"http://share.renren.com/share/361395694/14744176443?from=web_matter",@"action_link",
                                 text,@"description",
                                 @"小时候的照片！",@"caption",
//                                 @"http://fmn.rrimg.com/fmn060/20121112/1035/original_H63V_05f30000b5ae118d.jpg",@"image",
                                 nil];
    [self.renren dialog:@"feed" andParams:params andDelegate:self];
//    UIImage* image = [UIImage imageNamed:@"1.png"]; 
//    NSString *caption = @"这是一张测试图片";
//    [self.renren publishPhotoSimplyWithImage:image caption:caption];
    
}
#pragma mark - Renren Delegate
/**
 * 授权登录成功时被调用,第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的 Renren 类型对象。 */
- (void)renrenDidLogin:(Renren *)renren
{
//    [self shareRenForSongs];
#ifdef DEBUG
    NSLog(@"renren = <#%@#>",renren);
#endif
    
}
/**
 ￼6
 ￼人人网开放平台
 ￼* 授权登录失败时被调用,第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的 Renren 类型对象。 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{    
#ifdef DEBUG
    NSLog(@"error = <#%@#>",error);
#endif
}

/**
 * 接口请求成功,第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的 Renren 类型对象。 * @param response 传回接口请求的响应。
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    NSLog(@"response = %@",response);
    //[renren logout:self];
}
/**
 * 用户登出成功后被调用 第三方开发者实现这个方法
 * @param renren 传回代理登出接口请求的 Renren 类型对象。 */
- (void)renrenDidLogout:(Renren *)renren
{
#ifdef DEBUG
    NSLog(@"logout renren = %@",renren);
#endif
}

@end
