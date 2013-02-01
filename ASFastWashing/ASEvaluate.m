//
//  ASEvaluate.m
//  ASFastWashing
//
//  Created by yuyang-pc on 12-12-10.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASEvaluate.h"

@implementation ASEvaluate

@synthesize evaluate;
@synthesize grade;
@synthesize gradeDate;
@synthesize orderId;
@synthesize myImage;
@synthesize shopId;

-(void)dealloc
{
    [evaluate release];
    [grade release];
    [gradeDate release];
    [orderId release];
    [shopId release];
    [myImage release];
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.evaluate = [aDecoder decodeObjectForKey:@"evaluate"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.gradeDate = [aDecoder decodeObjectForKey:@"gradeDate"];
        self.orderId = [aDecoder decodeObjectForKey:@"orderId"];
        self.shopId = [aDecoder decodeObjectForKey:@"shopId"];
        self.myImage = [aDecoder decodeObjectForKey:@"myImage"];
    }
      return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:evaluate forKey:@"evaluate"];
    [aCoder encodeObject:grade forKey:@"grade"];
    [aCoder encodeObject:gradeDate forKey:@"gradeDate"];
    [aCoder encodeObject:orderId forKey:@"orderId"];
    [aCoder encodeObject:shopId forKey:@"shopId"];
    [aCoder encodeObject:myImage forKey:@"myImage"];
}
@end
