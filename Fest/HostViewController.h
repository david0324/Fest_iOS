//
//  HostViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 06/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;

@interface HostViewController : FestParentViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,ContactsDelegate>

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIView *viewHost;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnAddHost;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectAll;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (nonatomic,strong) UITableView *tableHost;
@property (nonatomic,strong) NSArray *arrayContacts;
@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic,strong) UILabel *lblNoresult;
@property (nonatomic,strong) NSMutableAttributedString *strAttribute;
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) Contact *selectedContact;

- (IBAction)select_All_Contacts:(id)sender;
- (IBAction)addHost:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)clearField_Host:(id)sender;

@end
