//
//  ASLogCell.m
//  ASFastWashing
//
//  Created by D on 12-12-12.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASLogCell.h"

@implementation ASLogCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    [self.imageView setFrame:
     CGRectMake(8, 8, bounds.size.height -16, bounds.size.height - 16)];
    //image边框
    [self.textLabel setFrame:
     CGRectMake(bounds.size.height, 4,
                200, (bounds.size.height - 4) / 2)];
    [self.detailTextLabel setFrame:
     CGRectMake(bounds.size.height, bounds.size.height / 2,
                200, (bounds.size.height- 4) / 2)];
    
	self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.imageView.layer.borderWidth = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
