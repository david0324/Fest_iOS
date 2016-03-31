//
//  InviteViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 24/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;
@interface InviteViewController : FestParentViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,ContactsDelegate>

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectAll;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (nonatomic,strong) UITableView *tableInvite;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) Contact *selectedContact;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) NSArray *arrayContacts;
@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic,strong) NSMutableAttributedString *strAttribute;
@property (nonatomic,strong) UILabel *lblNoresult;
@property (nonatomic,assign) BOOL isSearch,isAdditionalInvite;
@property (nonatomic,strong) NSString *festTitle;
@property (nonatomic,strong) NSString *festLocation;

- (IBAction)select_All_Contacts:(id)sender;
- (IBAction)invite:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)clearField_Invite:(id)sender;

@end
