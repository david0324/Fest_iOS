//
//  FestParentViewController.h
//  Fest
//
//  Created by Denow Cleetus on 12/05/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "GAITrackedViewController.h"

@interface FestParentViewController : GAITrackedViewController<RNFrostedSidebarDelegate, UIAlertViewDelegate>

- (void)presentLeftMenuViewController:(id)sender; 
-(void)showAlertView_CF:(NSString *)title message:(NSString *)msg;

-(BOOL)isExpiredDate:(NSString *)eventDate ;


@end
