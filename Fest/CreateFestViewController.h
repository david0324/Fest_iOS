//
//  CreateFestViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 24/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ASIFormDataRequest.h"
#import "NSData+Base64.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class ASIFormDataRequest;
#import "JCDatePicker.h"
@interface CreateFestViewController : FestParentViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,JCDatePickerDelegate>
{
    UISwipeGestureRecognizer *swipeLeft,*swipeRight;
    UIToolbar *toolbar1,*toolbar2,*toolbar3,*toolbar4;
    UIDatePicker *datePicker,*timePicker;
    JCDatePicker *endDatePicker;
    NSDateFormatter *formatter;
    CGRect keyboardFrame;
    CGPoint svos,svosTxtView;
    int festType,flagAlert,flagExit,flagAppear,flagEdit,id1,id2,id3;
    double cLatitude,cLongitude;
    BOOL isTxt,isTxtView;
    UITapGestureRecognizer *tapScroll;
    NSString *strMsg;
}
@property (strong, nonatomic) IBOutlet UIButton *openMapViewButton;
- (IBAction)openMapViewButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover1;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover2;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover3;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload1;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload2;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtEndDate;
@property (weak, nonatomic) IBOutlet UITextField *txtTime;
@property (weak, nonatomic) IBOutlet UITextField *txtStreet;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZipcode;
@property (weak, nonatomic) IBOutlet UITextView *txtViewDescrip;
@property (weak, nonatomic) IBOutlet UITextView *txtViewNotification;
@property (weak, nonatomic) IBOutlet UIView *view_bottom;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollFest;
@property (weak, nonatomic) IBOutlet UISlider *sliderDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnPrivate;
@property (weak, nonatomic) IBOutlet UIButton *btnPublic;
@property (strong, nonatomic) IBOutlet UISwitch *switchPrivate;
@property (strong, nonatomic) UILabel *lblPrivatePublic;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblImages;
@property (weak, nonatomic) IBOutlet UILabel *lblMax3;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivate;
@property (weak, nonatomic) IBOutlet UILabel *lblPublic;
@property (weak, nonatomic) IBOutlet UILabel *lblRadius_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl50Yards;
@property (weak, nonatomic) IBOutlet UILabel *lbl50Miles;
@property (weak, nonatomic) IBOutlet UILabel *lblMile;
@property (weak, nonatomic) IBOutlet UILabel *lblDescrip;
@property (weak, nonatomic) IBOutlet UILabel *lblNotification;
@property (weak, nonatomic) IBOutlet UIButton *btnHost;


@property (nonatomic,strong) NSMutableDictionary *dicAddress;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) UITextField *mytxtfield;
@property (nonatomic,strong) UITextView *mytxtView;
@property (nonatomic,assign) NSInteger flag_btn;
@property (nonatomic,assign) BOOL isVideo,isEdit,isCamera;
@property (nonatomic,strong) NSData *data1;
@property (nonatomic,strong) NSData *data2;
@property (nonatomic,strong) NSData *data3;
@property (nonatomic,strong) NSData *dataVideo;
@property (nonatomic,strong) NSString *strAddress;
@property (nonatomic,strong) NSString *type1,*type2,*type3;
@property (nonatomic,assign) NSInteger miles;

- (IBAction)menuFest:(id)sender;
- (IBAction)upload1:(id)sender;
- (IBAction)upload2:(id)sender;
- (IBAction)upload3:(id)sender;
- (IBAction)invitePeople:(id)sender;
- (IBAction)saveFest:(id)sender;
- (IBAction)addHost:(id)sender;
- (IBAction)openLocation:(id)sender;
- (IBAction)sliderDistanceChange:(id)sender;

@end
