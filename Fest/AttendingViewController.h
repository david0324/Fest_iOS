//
//  AttendingViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 09/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;

@interface AttendingViewController : FestParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    int flagExit;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UILabel *lblFestTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFestDate;
@property (weak, nonatomic) IBOutlet UILabel *lblFestAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblFestCount;
//@property (weak, nonatomic) IBOutlet UITableView *tableAttending;
@property (nonatomic,strong) NSMutableArray *arrAttending;
@property (nonatomic,strong) NSMutableArray *arrDetails;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;
@property (weak, nonatomic) IBOutlet UILabel *lbFestTime;
@property (weak, nonatomic) IBOutlet UICollectionView *colvAttending;

- (IBAction)goBack:(id)sender;

@end
