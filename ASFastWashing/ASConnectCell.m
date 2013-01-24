//
//  ASConnectCell.m
//  ASFastWashing
//
//  Created by yuyang-pc on 12-12-20.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASConnectCell.h"

@implementation ASConnectCell
@synthesize logo,timeLable,shopLable;
-(void)dealloc
{
    [shopLable release];
    [logo release];
    [timeLable release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.logo = [[[UIImageView alloc] init] autorelease];
        self.logo.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.logo];
        
        self.shopLable = [[[UILabel alloc] init] autorelease];
        [self.shopLable setFont:[UIFont systemFontOfSize:15]];
        [self.shopLable setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.shopLable];

        self.timeLable = [[[UILabel alloc] init] autorelease];
        [self.timeLable setFont:[UIFont systemFontOfSize:10]];
        [self.timeLable setTextColor:[UIColor grayColor]];
        [self.timeLable setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.timeLable];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect myBounds = self.bounds;
    
    [self.logo setFrame:CGRectMake(8, 8, (myBounds.size.height - 16) * 1.21, myBounds.size.height - 16)];
    self.logo.layer.masksToBounds = YES;
	self.logo.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.logo.layer.borderWidth = 1.2f;
    self.logo.layer.cornerRadius = 7;
    
    [self.shopLable setFrame:
     CGRectMake(myBounds.size.height * 1.2 - 6 , 8,
                200, (myBounds.size.height - 1) / 3)];
    
    [self.timeLable setFrame:CGRectMake(myBounds.size.height * 1.2 - 6, myBounds.size.height / 3 + 3, 200, myBounds.size.height / 3)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
