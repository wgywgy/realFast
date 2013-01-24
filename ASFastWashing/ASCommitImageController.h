//
//  ASCommitImageController.h
//  ASFastWashing
//
//  Created by Hao on 12/19/12.
//  Copyright (c) 2012 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCommitImageController : UIViewController<UIWebViewDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,retain) NSDictionary *dicThree;
@property(nonatomic,retain)IBOutlet UIWebView *myWebView;
@property(nonatomic,retain)UIActivityIndicatorView *activityIndicatorView;

@end
