//
//  ResetViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 20/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;
@interface ResetViewController : FestParentViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITapGestureRecognizer *tap;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollReset;

@property (nonatomic,strong) UITextField *txtOld;
@property (nonatomic,strong) UITextField *txtNew;
@property (nonatomic,strong) UILabel *lblOld,*lblNew;
@property (nonatomic,strong) UIButton *btnReset;
@property (nonatomic,strong) UITextField *myTxt;
@property (nonatomic,strong) NSString *strOldNumber;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;

- (IBAction)goBack:(id)sender;

@end
