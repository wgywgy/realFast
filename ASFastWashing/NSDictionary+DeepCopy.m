//
//  NSDictionary+DeepCopy.m
//  快洗
//
//  Created by D on 12-11-13.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "NSDictionary+DeepCopy.h"

@implementation NSDictionary (DeepCopy)
- (NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *ret = [[[NSMutableDictionary alloc]
                                initWithCapacity:[self count]]autorelease];
    NSArray *keys = [self allKeys];
    for (id key in keys) {
        id oneValue = [self valueForKey:key];
        id oneCopy = nil;
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        }
        else if ([oneValue respondsToSelector:@selector(mutableCopy)]) {
            oneCopy = [oneValue mutableCopy];
        }
        if (oneCopy == nil) {
            oneCopy = [oneValue copy];
        }
        [ret setValue:oneCopy forKey:key];
    }
    return ret;
}
@end
