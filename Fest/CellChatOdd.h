//
//  CellChatOdd.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 28/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellChatOdd : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivUserPorfile;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;

@end
