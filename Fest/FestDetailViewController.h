//
//  FestDetailViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 07/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+Base64.h"
#import "PreviewViewController.h"
#import "CommentViewController.h"
#import "RouteMapViewController.h"
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;

@interface FestDetailViewController : FestParentViewController<UIAlertViewDelegate, UIActionSheetDelegate>
{
    UISwipeGestureRecognizer *swipeLeft,*swipeRight;
    int flagExit;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover;
@property (weak, nonatomic) IBOutlet UILabel *lblFestTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbFestTime;
@property (weak, nonatomic) IBOutlet UILabel *lblFestDate;
@property (weak, nonatomic) IBOutlet UILabel *lblFestAddress;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollFest;
@property (weak, nonatomic) IBOutlet UILabel *lblAttending;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UILabel *lbDescription;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;

@property (nonatomic,strong) IBOutlet UIButton *btnAccept;
@property (nonatomic,strong) IBOutlet UIButton *btnInvite;
@property (nonatomic,strong) UIButton *btnReject;
@property (nonatomic,strong) UIButton *btnShare;
@property (nonatomic,strong) IBOutlet UIButton *btnChat;
@property (nonatomic,strong) UIButton *btnComment;
@property (nonatomic,strong) UITextView *txtViewFestDescrip;
@property (nonatomic,assign) NSInteger pageIndex,eventStatus,eventType,eventHost;
@property (nonatomic,strong) NSString *refUserID,*strAddress;
@property (nonatomic,strong) NSMutableArray *arrFestDetails;
@property (nonatomic,strong) NSArray *arrDB;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,assign) BOOL isMyFest;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) NSDate *dateToday;
@property (weak, nonatomic) IBOutlet UIImageView *ivButtonBg;

@property(weak, nonatomic) IBOutlet UIButton *playButn;

- (IBAction)goto_FestLocation:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goto_attendingList:(id)sender;
- (IBAction)goto_Preview:(id)sender;
- (IBAction)btnEditClicked:(id)sender;
- (IBAction)invite_People:(id)sender;
- (IBAction)share_Fest:(id)sender;
- (IBAction)acceptEvent:(id)sender;
- (IBAction)goto_Comment:(id)sender;
- (IBAction)goto_Chat:(id)sender;


@end
