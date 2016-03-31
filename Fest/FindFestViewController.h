//
//  FindFestViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "UserModel.h"
#import "NSData+Base64.h"
#import <CoreLocation/CoreLocation.h>
#import "GAITrackedViewController.h"

@class ASIFormDataRequest;

@interface FindFestViewController : FestParentViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate>
{
    UISwipeGestureRecognizer *swipeLeft,*swipeRight;
    double latitude,longitude,refLatitude,refLongitude;
    NSInteger miles,refmiles;
    int flagExit;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UISlider *sliderMiles;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UITableView *tableFest;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic1;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic2;
@property (weak, nonatomic) IBOutlet UILabel *lblStatic3;

@property (nonatomic,strong) UILabel *lblNoData;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;

- (IBAction)menuFest:(id)sender;

@end
