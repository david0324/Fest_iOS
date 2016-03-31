//
//  EventLikesCell.m
//  Fest
//
//  Created by Denow Cleetus on 19/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "EventLikesCell.h"

@implementation EventLikesCell

- (void)awakeFromNib {
    
    [self initialSetup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initialSetup{
    [self.imgVUserPic.layer setCornerRadius:CGRectGetWidth(self.imgVUserPic.frame)/2];
    [self.imgVUserPic setClipsToBounds:YES];
    [self.lblName setFont:[UIFont fontWithName:LatoRegular size:14]];
    [self.lblName setTextColor:COLOR_TEAL];

}

@end
