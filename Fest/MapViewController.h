//
//  MapViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 25/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SVGeocoder.h"
#import "AFHTTPRequestOperationManager.h"

#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : FestParentViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate, GMSMapViewDelegate>
{
    int flagExit,flagLabel,flagDone,flagUser;
    double refLat,refLong;
    CGPoint point;
}

@property (strong, nonatomic) IBOutlet UIView *googleMapView;
@property (nonatomic, retain) UIView *viewCircle;

- (IBAction)geoFenceSliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
//@property (weak, nonatomic) IBOutlet MKMapView *mkMapView;
@property (weak, nonatomic) IBOutlet UIView *viewAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressTitle;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UISlider *sliderRadius;
@property (weak, nonatomic) IBOutlet UILabel *lblRadius_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl50Yards_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl50Miles_title;
@property (weak, nonatomic) IBOutlet UILabel *lblMiles_title;
@property (weak, nonatomic) IBOutlet UILabel *lblRadius;

@property (nonatomic,strong) UIButton *btnDrop;
@property (nonatomic,strong) MKPinAnnotationView *mapPin;
@property (nonatomic,strong)  UIImageView *imgViewPin;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString *strAddress,*strFullAddress;
@property (nonatomic,assign) double latitude,longitude;
@property (nonatomic,assign) CLLocationCoordinate2D *coordinate;
@property (nonatomic,strong) NSMutableDictionary *dicAddress;
@property (nonatomic,strong) UIView *viewPulse;
@property (nonatomic, strong) CAAnimationGroup *pulseAnimationGroup;
@property (nonatomic, readwrite) float pulseScaleFactor; // default is 5.3
@property (nonatomic, readwrite) NSTimeInterval pulseAnimationDuration; // default is 1s
@property (nonatomic, readwrite) NSTimeInterval outerPulseAnimationDuration; // default is 3s
@property (nonatomic, readwrite) NSTimeInterval delayBetweenPulseCycles; // default is 1s
@property (nonatomic,strong) UIView *customView;
@property (nonatomic,strong) UILabel *lblDescrip;
@property (nonatomic,strong) UIImageView *imagePopUp;
@property (nonatomic,assign) NSInteger miles;
@property (nonatomic,assign) double circleRadius;

- (IBAction)goto_back:(id)sender;
- (IBAction)saveAddress:(id)sender;

@end
