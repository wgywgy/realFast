//
//  ASEvaluteViewController.h
//  快洗
//
//  Created by yuyang-pc on 12-11-27.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
#import "ASRequestDelegate.h"
#import "JHStatusTextView.h"

@class ASRequest;

@interface ASEvaluteViewController : UIViewController<DLStarRatingDelegate,
                                                           ASRequestDelegate,
                                                             JHStatusTextViewDelegate,
                                                                UIAlertViewDelegate>
{
    ASRequest * request;
    NSInteger gradeRate;
    NSString* shopId;
    NSInteger myRow;
}

@property(nonatomic,assign)NSInteger gradeRate;
//@property(nonatomic,retain) UIImage* photo;
//@property(nonatomic,retain) IBOutlet UIButton *photoButton;
@property(nonatomic,retain) IBOutlet JHStatusTextView* evaluateText;
@property(nonatomic,retain)IBOutlet UILabel* evaLable;
@property(nonatomic,retain)ASRequest* request;
@property(nonatomic,retain)NSString* shopId;
@property(nonatomic,assign)NSInteger myRow;

//- (IBAction)choosePhoto:(id)sender;
- (IBAction)wrongPressed;
- (IBAction)okPressed:(id)sender;
@end
