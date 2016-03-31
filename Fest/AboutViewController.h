//
//  AboutViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 22/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;

@interface AboutViewController : FestParentViewController<UITextViewDelegate,UITextFieldDelegate>
{
    UITapGestureRecognizer *tap;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollAbout;
@property (weak, nonatomic) IBOutlet UILabel *lblAbout;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAbout;
@property (weak, nonatomic) IBOutlet UILabel *lblFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnInsta;
@property (weak, nonatomic) IBOutlet UILabel *lblContact;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextView *txtViewMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;


@end
