//
//  ASAgreementController.h
//  ASFastWashing
//
//  Created by Hao on 1/16/13.
//  Copyright (c) 2013 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASAgreementController : UIViewController

@property(nonatomic,retain) UITextView *textView;
@property(nonatomic,retain)IBOutlet UIButton *agree;
@property(nonatomic,retain)IBOutlet UIButton *cancel;

-(IBAction)agree:(id)sender;
-(IBAction)disAgree:(id)sender;

@end
