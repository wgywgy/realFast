//
//  ASStore.m
//  快洗
//
//  Created by D on 12-11-13.
//  Copyright (c) 2012年 Admin. All rights reserved.
//

#import "ASStore.h"

@implementation ASStore
@synthesize storeName = _storeName;
@synthesize storeTel = _storeTel;
@synthesize address = _address;
@synthesize collectNum = _collectNum;
@synthesize grade = _grade;
@synthesize distance = _distance;
@synthesize logo = _logo;

- (void) dealloc
{
    [_storeName release];
    [_storeTel release];
    [_collectNum release];
    [_address release];
    [_distance release];
    [_logo release];
    [_grade release];
    
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.storeName = [aDecoder decodeObjectForKey:@"storeName"];
        self.storeTel = [aDecoder decodeObjectForKey:@"storeTel"];
        self.collectNum = [aDecoder decodeObjectForKey:@"collectNum"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.distance = [aDecoder decodeObjectForKey:@"distance"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.logo = [aDecoder decodeObjectForKey:@"grade"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_storeName forKey:@"storeName"];
    [aCoder encodeObject:_storeTel forKey:@"storeTel"];
    [aCoder encodeObject:_collectNum forKey:@"collectNum"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_grade forKey:@"grade"];
    [aCoder encodeObject:_distance forKey:@"distance"];
    [aCoder encodeObject:_logo forKey:@"logo"];
}

@end
