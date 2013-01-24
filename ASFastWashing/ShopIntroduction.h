//
//  ShopIntroduction.h
//  ASFastWashing
//
//  Created by Hao on 12/16/12.
//  Copyright (c) 2012 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopIntroduction : UIViewController
{
    UITextView *textView;
    
    CGRect rect_screen;
    
    NSString *introduction;
    NSString *shopName;
}
@property(nonatomic,retain)IBOutlet UITextView *textView;
@property(nonatomic,retain)NSString *introduction;
@property(nonatomic,retain)NSString *shopName;

@end
