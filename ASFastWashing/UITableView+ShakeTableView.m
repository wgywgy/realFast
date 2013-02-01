//
//  UITableView+ShakeTableView.m
//  快洗
//
//  Created by SSD on 12-11-22.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "UITableView+ShakeTableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITableView (ShakeTableView)
- (void) shake {
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.382f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-3.82, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+3.82, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-3.82, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+3.82, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-3.82, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+3.82, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn setValues:array];
    [array release];
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    [times release];
    [self.layer addAnimation:keyAn forKey:@"TextAnim"];
}

@end
