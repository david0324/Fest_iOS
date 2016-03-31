//
//  PictureFeedCell.h
//  Fest
//
//  Created by J.P.  on 2/25/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureFeedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfCell;
@property (strong, nonatomic) IBOutlet UIButton *buttonLike;
@property (strong, nonatomic) IBOutlet UILabel *labelPosterName;

@end
