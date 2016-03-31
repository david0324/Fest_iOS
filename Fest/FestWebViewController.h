//
//  FestWebViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 22/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FestWebViewController : FestParentViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIWebView *festWebView;

- (IBAction)goBack:(id)sender;

@end
