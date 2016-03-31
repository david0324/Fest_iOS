//
//  AppDelegate.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 11/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;
@property (nonatomic,retain) CLLocationManager*locationManager;
@property (nonatomic) double delLatitude,delLongitude;
@property (nonatomic,strong) NSString *strCurrentAddress;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) NSDate *dateToday;
@property NSInteger selectedIndexMenu;

+(AppDelegate *)getDelegate;
-(void)changeStatusbarColor;
- (void)openSession;
-(void)sessionExpired;
-(void)getCurrentLocation;
-(void)getAddressFromLocation:(double)lat longitude:(double)lng;
-(NSDate *)localTime;

#pragma mark - 
-(void)geoFenceEntryDetected:(CLRegion*)region;
-(void)geoFenceExitDetected:(CLRegion*)region;
-(void)clearAllGeofences;


@end
