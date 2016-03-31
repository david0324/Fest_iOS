//
//  SlideViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 17/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RESideMenu.h"

@interface SlideViewController : FestParentViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableSlide;
@property (nonatomic,strong) NSMutableArray *arrMenu;
@property (nonatomic,strong) NSMutableArray *arrIcons;

@end
