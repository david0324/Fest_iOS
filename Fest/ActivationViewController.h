//
//  ActivationViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 08/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;

@interface ActivationViewController : FestParentViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITapGestureRecognizer *tap;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UILabel *lblActivation;
@property (weak, nonatomic) IBOutlet UIButton *btnEnter;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLink;
@property (nonatomic,strong) UITextField *txtActivation;
@property (nonatomic,strong) UITextField *txtMobile;
@property (nonatomic,strong) UITextField *myTxt;
@property (nonatomic,assign) NSInteger flagCode;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;

- (IBAction)click_to_Change:(id)sender;

@end
