//
//  HelpViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 28/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : FestParentViewController<UITableViewDataSource, UITableViewDelegate>
{
    CGRect frameRadius,framePush;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

@property (nonatomic,strong) UIButton *btnRadius;
@property (nonatomic,strong) UIButton *btnPush;
@property (nonatomic,strong) UIView *viewRadius;
@property (nonatomic,strong) UIView *viewPush;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property NSInteger selectedSection;

@property (nonatomic, retain) NSMutableArray *arrTableView;

- (IBAction)goto_Menu:(id)sender;

@end
