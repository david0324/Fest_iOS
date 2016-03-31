//
//  MyFestViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 08/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "UserModel.h"
#import "NSData+Base64.h"

@class ASIFormDataRequest;

@interface MyFestViewController : FestParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    int flagExit;
    UISwipeGestureRecognizer *swipeLeft,*swipeRight;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UITableView *tableMyFest;
@property (nonatomic,strong) UILabel *lblNoData;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) NSDate *dateToday;
@property (nonatomic,strong) NSDateFormatter *formatter;

- (IBAction)menuFest:(id)sender;

@end
