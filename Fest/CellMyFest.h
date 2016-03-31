//
//  CellMyFest.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 15/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMyFest : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *imgViewCover;
@property (nonatomic,weak) IBOutlet UILabel *lblDescrip;
@property (nonatomic,weak) IBOutlet UILabel *lblTitle;

@end
