//
//  RouteMapViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 17/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "RouteMapViewController.h"

@interface RouteMapViewController ()

@end

@implementation RouteMapViewController
@synthesize view_header,lbl_header,mapView,locationManager,fromAddress,toAddress,fromLatitude,fromLongitude,toLatitude,toLongitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    
    [self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    lbl_header.font=[UIFont fontWithName:ProximaNovaSemibold size:20.0];
    
    if(isReach)
    {
        [GC showLoader:self withText:@"loading map..."];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getUserLocation];
        });
    }
    else
    {
        [GC hideLoader];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:No_Internet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get User Lcoation
-(void)getUserLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    fromLatitude=locationManager.location.coordinate.latitude;
    fromLongitude=locationManager.location.coordinate.longitude;
    
    [self reverseGeocode:fromLatitude And:fromLongitude];
    
}

#pragma mark - Conver Lat&Long into Address
- (void)reverseGeocode:(float)lat And:(float)longt
{
    if(isReach)
    {
        //[GC showLoader:self withText:@"loading..."];
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(lat, longt)
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            
                            if(!error)
                            {
                                NSMutableArray *ar = [[NSMutableArray alloc] initWithArray:placemarks];
                                NSString *strFullAddress = [NSString new];
                                
                                //NSLog(@"ar = %@",ar);
                                
                                
                                if([[ar objectAtIndex:0] valueForKey:@"formattedAddress"]!=nil)
                                {
                                    
                                    strFullAddress = [NSString stringWithFormat:@"%@",[[ar objectAtIndex:0] valueForKey:@"formattedAddress"]];
                                    
                                    fromAddress = strFullAddress;
                                    allocUserDefault;
                                    setUserDefault(strFullAddress, @"fAdd");
                                    setUserDefault(toAddress, @"tAdd");
                                    
                                    [self showRouteMap];
                                    
                                    [GC hideLoader];
                                }
                                else
                                {
                                    [GC hideLoader];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to fetch location details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [alertView show];
                                    });
                                }
                            }
                        }];
        
        
     }
    else
    {
        [GC hideLoader];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Network disconnected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - Show Route Map
-(void)showRouteMap
{
    mapView=[[MapView alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height-70))];
    
    Place* home = [[Place alloc] init];
    home.name = fromAddress;
    home.latitude = fromLatitude;
    home.longitude = fromLongitude;
    
    Place* office = [[Place alloc] init] ;
    office.name = toAddress;
    office.latitude = toLatitude;
    office.longitude = toLongitude;
    
    //NSLog(@"tolat & toLong=>%lf,%lf",toLatitude,toLongitude);
    
    [mapView showRouteFrom:home to:office];
    
    [self.view addSubview:mapView];
    
    [GC hideLoader];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Go Back
- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
