//
//  Annotation.m
//  myMap
//
//  Created by D on 12-11-21.
//  Copyright (c) 2012年 AlphaStudio. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize locationType;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

@end
