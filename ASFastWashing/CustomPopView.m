//
//  CustomPopView.m
//  myMap
//
//  Created by D on 12-11-21.
//  Copyright (c) 2012年 AlphaStudio. All rights reserved.
//

#import "CustomPopView.h"
#import "Annotation.h"

@implementation CustomPopView
@synthesize callView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
        callView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star.jpeg" ]];
        
        [callView setFrame:CGRectMake(-46, -146, 0, 0)];
        [callView sizeToFit];
        
        [self animateCalloutAppearance];
        [self addSubview:callView];
    } else {
        //Remove your custom view...
        [callView removeFromSuperview];
    }

}

- (void)didAddSubview:(UIView *)subview
{
        for (UIView *subsubView in subview.subviews) {
            if ([subsubView class] == [UIImageView class]) {
                UIImageView *imageView = ((UIImageView *)subsubView);
                [imageView removeFromSuperview];
            }
            if ([subsubView class] == [UILabel class]) {
                UILabel *labelView = ((UILabel *)subsubView);
                [labelView removeFromSuperview];
            }
        }

}

- (void)animateCalloutAppearance
{
    CGFloat scale = 0.001f;
    callView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -50);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        CGFloat scale = 1.1f;
        callView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGFloat scale = 0.95;
            callView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                CGFloat scale = 1.0;
                callView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
            } completion:nil];
        }];
    }];
    
}

@end
