//
//  LoginViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "UserModel.h"
#import "NSData+Base64.h"
//#import "GAITrackedViewController.h"

@class ASIFormDataRequest;

@interface LoginViewController : FestParentViewController

@property (nonatomic,strong) ASIFormDataRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,assign) NSInteger isActivated;

- (IBAction)facebook_login:(id)sender;

@end
