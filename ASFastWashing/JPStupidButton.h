//
//  JPStupidButton.h
//  AnimationPlay
//
//  Created by James Pozdena on 5/9/11.
//  Copyright 2011 James Pozdena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface JPStupidButton : UIButton {
    int              buttonMode;
    int              state;
    CALayer         *baseLayer;
    CAGradientLayer *gradient;
    CGRect           orig_bounds;
}

- (void)setupLayers;

@end
