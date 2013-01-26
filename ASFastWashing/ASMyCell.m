//
//  ASMyCell.m
//  ASFastWashing
//
//  Created by D on 12-12-12.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASMyCell.h"

@implementation ASMyCell
@synthesize address;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        address = [[[UILabel alloc] init] autorelease];
        [self.contentView addSubview:address];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    rect_screen = [[UIScreen mainScreen]bounds];
    CGRect bounds = self.bounds;
    [self.imageView setFrame:
     CGRectMake(8, 8, (bounds.size.height - 16) * 1.21, bounds.size.height -16)];
//    568 480
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    
    if (rect_screen.size.height == 480) {
        [self.textLabel setFrame:
         CGRectMake(bounds.size.height * 1.2 - 5, 4,
                    268, bounds.size.height / 2)];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        [self.detailTextLabel setFrame:
         CGRectMake(266, bounds.size.height / 2 - 12,
                    44, 24)];
        [address setFrame:CGRectMake(bounds.size.height * 1.2 - 5, bounds.size.height / 2 ,
                                     272, 32)];
    } else {
        [self.textLabel setFrame:
         CGRectMake(bounds.size.height * 1.2 - 5, 6,
                    268, bounds.size.height / 2)];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        [self.detailTextLabel setFrame:
         CGRectMake(266, bounds.size.height / 2 - 12,
                    44, 24)];
        [address setFrame:CGRectMake(bounds.size.height * 1.2 - 5, bounds.size.height / 2 + 4,
                                     272, 32)];
    }
    
    address.textColor = [UIColor darkGrayColor];
    address.backgroundColor = [UIColor clearColor];
    address.font = [UIFont systemFontOfSize:12];
    
    self.detailTextLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel.layer.masksToBounds = YES;
	self.detailTextLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.detailTextLabel.layer.borderWidth = 1.2f;
    self.detailTextLabel.layer.cornerRadius = 5;
    self.detailTextLabel.backgroundColor = [UIColor lightGrayColor];
    self.detailTextLabel.alpha = 0.8;
    
    //image边框
    self.imageView.layer.masksToBounds = YES;
	self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.imageView.layer.borderWidth = 1.2f;
    self.imageView.layer.cornerRadius = 7;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
