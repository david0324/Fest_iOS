//
//  RouteMapViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 17/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SVGeocoder.h"
#import "Place.h"
#import "MapView.h"

@interface RouteMapViewController : FestParentViewController

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (nonatomic,strong) NSString *fromAddress, *toAddress;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign) double fromLatitude,fromLongitude,toLatitude,toLongitude;
@property (nonatomic,strong) MapView *mapView;

- (IBAction)goBack:(id)sender;

@end
