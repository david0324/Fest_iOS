//
//  CellInvite.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 24/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "CellInvite.h"

@implementation CellInvite

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
