//
//  ProfileViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 22/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "ASIFormDataRequest.h"
#import "NSData+Base64.h"

@class ASIFormDataRequest;

@interface ProfileViewController : FestParentViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIButton *btnMe;
}

@property (weak, nonatomic) IBOutlet UITableView *tableProfile;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile1;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile2;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile3;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile4;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile5;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile6;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile1;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile2;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile3;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile4;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile5;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile6;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UIView *viewToolBar;

//@property (nonatomic,strong) UIButton *btnReset;
@property (nonatomic,strong) NSMutableArray *arrTitles;
@property (nonatomic,strong) NSMutableArray *arrContents;
@property (nonatomic,assign) BOOL isCamera;
@property (nonatomic,assign) NSInteger flag_btn;
@property (nonatomic,strong) NSString *localID;
@property (nonatomic,strong) UIButton *btnBack;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) NSData *data1;
@property (nonatomic,strong) NSData *data2;
@property (nonatomic,strong) NSData *data3;
@property (nonatomic,strong) NSData *data4;
@property (nonatomic,strong) NSData *data5;
@property (nonatomic,strong) NSData *data6;

- (IBAction)menuFest:(id)sender;
- (IBAction)upload_image1:(id)sender;
- (IBAction)upload_image2:(id)sender;
- (IBAction)upload_image3:(id)sender;
- (IBAction)upload_image4:(id)sender;
- (IBAction)upload_image5:(id)sender;
- (IBAction)upload_image6:(id)sender;
- (IBAction)edit_profile:(id)sender;

@end
