//
//  MapViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 25/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "MapViewController.h"
#import "BasicMapAnnotation.h"

#define Span 50.0f;

#define Street_number @"street_number"
#define Route @"route"
#define Neighborhood @"neighborhood"
#define Sublocality_level_2 @"sublocality_level_2"
#define Sublocality_level_1 @"sublocality_level_1"
#define Locality @"locality"
#define Administrative_area_level_2 @"administrative_area_level_2"
#define Administrative_area_level_1 @"administrative_area_level_1"
#define Country @"country"
#define Postal_code @"postal_code"

float minZoom = 6.0;
float maxZoom = 22.0;

@interface MapViewController ()
{
    //MKCircle *circleOverlay;
    //MKCircle *circleOverlay;
    GMSMapView *mapView;
    GMSMarker *marker;
    GMSCircle *geoFenceCircleOnMap;
}

@property (nonatomic,strong) BasicMapAnnotation *basicAnnotation;

@end

@implementation MapViewController
@synthesize view_header,lbl_header,btnBack,viewAddress,lblAddressTitle,lblAddress,viewBottom,sliderRadius,imgViewPin,locationManager,latitude,longitude,strAddress,viewPulse,customView,lblDescrip,imagePopUp,miles,circleRadius,btnDrop,mapPin,basicAnnotation, googleMapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    lbl_header.font = [UIFont fontWithName:LatoRegular size:18.0];
    
    //[self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    //lbl_header.font = [UIFont fontWithName:ProximaNovaSemibold size:20.0];
    lblAddress.font = [UIFont fontWithName:LatoRegular size:12.0];
    lblAddressTitle.font = [UIFont fontWithName:LatoRegular size:13.0];
    
    self.dicAddress = [[NSMutableDictionary alloc] init];
    
    //[self userLocation];
    
    //[self.view sendSubviewToBack:googleMapsSubView];
    /*[self.view bringSubviewToFront:self.sliderRadius];
     [self.view bringSubviewToFront:self.lblRadius ];
     [self.view bringSubviewToFront:self.viewBottom];
     [self.view bringSubviewToFront:self.lblRadius_title];
     [self.view bringSubviewToFront:self.lbl50Miles_title];
     [self.view bringSubviewToFront:self.lbl50Yards_title];
     [self.view bringSubviewToFront:self.lblMiles_title ];
     [self.view bringSubviewToFront:self.view_header];
     [self.view bringSubviewToFront:self.lbl_header];
     [self.view bringSubviewToFront:self.lblAddress];
     [self.view bringSubviewToFront:self.btnBack];
     [self.view bringSubviewToFront:self.viewAddress];*/
    
    //self.view = mapView;
    
    
    
    [self.lblRadius_title setFont:[UIFont fontWithName:ProximaNovaSemibold size:18.0]];
    [self.lblRadius setFont:[UIFont fontWithName:ProximaNovaSemibold size:18.0]];
    [self.lbl50Yards_title setFont:[UIFont fontWithName:ProximaNovaLight size:11.0]];
    [self.lbl50Yards_title setFont:[UIFont fontWithName:ProximaNovaLight size:11.0]];
    [self.lblMiles_title setFont:[UIFont fontWithName:ProximaNovaLight size:13.0]];
    
    //[self.sliderRadius addTarget:self action:@selector(sliderRadiusValue:withEvent:) forControlEvents:UIControlEventValueChanged];
    flagExit = 0;
    flagLabel = 0;
    refLat = 0.0;
    refLong = 0.0;
    flagDone = 0;
    self.lblRadius.text = @"50";
    self.lblMiles_title.text = @"Yards";
    
    
    mapView = [[GMSMapView alloc] init];
    mapView.delegate=self;
    mapView.frame = googleMapView.frame;
    geoFenceCircleOnMap = [[GMSCircle alloc] init];
    geoFenceCircleOnMap.fillColor = [UIColor colorWithRed:58.0/256.0 green:212.0/256.0 blue:196.0/256.0 alpha:0.4]; //58, 212, 196
    geoFenceCircleOnMap.strokeColor=[UIColor clearColor];
    [mapView setMinZoom:minZoom maxZoom:maxZoom];
    [mapView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
    

    
    [self.view addSubview:mapView];
    
    [self.view bringSubviewToFront:self.sliderRadius];
    [self.view bringSubviewToFront:self.lblRadius ];
    [self.view bringSubviewToFront:self.viewBottom];
    [self.view bringSubviewToFront:self.lblRadius_title];
    [self.view bringSubviewToFront:self.lbl50Miles_title];
    [self.view bringSubviewToFront:self.lbl50Yards_title];
    [self.view bringSubviewToFront:self.lblMiles_title ];
    [self.view bringSubviewToFront:self.view_header];
    [self.view bringSubviewToFront:self.lbl_header];
    [self.view bringSubviewToFront:self.lblAddress];
    [self.view bringSubviewToFront:self.btnBack];
    [self.view bringSubviewToFront:self.viewAddress];
    
    
    [GC setParentVC:self];
    
    
    imgViewPin = [[UIImageView alloc] init];
    imgViewPin.frame = CGRectMake(0, 0, 50, 50);
    imgViewPin.image = [UIImage imageNamed:@"icon_pin_red"];
    
    TEST_MODE;
    imgViewPin.image = [UIImage imageNamed:@"icon_loction_fest"];
    TEST_MODE;
    
    [imgViewPin setHidden:YES];
    [mapView addSubview:imgViewPin];
    
    [self initialSetupDidLoad];
    
    /*
    // Do any additional setup after loading the view.
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    
    [self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    lbl_header.font = [UIFont fontWithName:ProximaNovaSemibold size:20.0];
    lblAddress.font = [UIFont fontWithName:ProximaNovaRegular size:12.0];
    lblAddressTitle.font = [UIFont fontWithName:ProximaNovaSemibold size:13.0];
    
    mkMapView.delegate=self;
    mkMapView.mapType=MKMapTypeStandard;
    [mkMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    mkMapView.showsUserLocation = NO;
    
    self.dicAddress = [NSMutableDictionary new];
    self.strFullAddress = [NSString new];
    self.strFullAddress = @"";
    
    self.pulseScaleFactor = 5.3;
    self.pulseAnimationDuration = 1.5;
    self.outerPulseAnimationDuration = 3;
    self.delayBetweenPulseCycles = 0;
    
    [self.lblRadius_title setFont:[UIFont fontWithName:ProximaNovaSemibold size:18.0]];
    [self.lblRadius setFont:[UIFont fontWithName:ProximaNovaSemibold size:18.0]];
    [self.lbl50Yards_title setFont:[UIFont fontWithName:ProximaNovaLight size:11.0]];
    [self.lbl50Yards_title setFont:[UIFont fontWithName:ProximaNovaLight size:11.0]];
    [self.lblMiles_title setFont:[UIFont fontWithName:ProximaNovaLight size:13.0]];
    
    [self.sliderRadius addTarget:self action:@selector(sliderRadiusValue:withEvent:) forControlEvents:UIControlEventValueChanged];
    
    flagExit = 0;
    flagLabel = 0;
    refLat = 0.0;
    refLong = 0.0;
    flagDone = 0;
    self.lblRadius.text = @"50";
    self.lblMiles_title.text = @"Yards";
    
    imgViewPin = [[UIImageView alloc] init];
    imgViewPin.frame = CGRectMake(0, 0, 22, 30);
    imgViewPin.frame = ALIGHN_SUBVIEW_CENTER(imgViewPin, self.mkMapView);
    self.imgViewPin.hidden = NO;
    
    if([UIScreen mainScreen].bounds.size.height>480)
    {
        CGRect frame = imgViewPin.frame;
        frame.origin.x += 5;
        frame.origin.y += 57;
        
        imgViewPin.frame = frame;
    }
    else
    {
        CGRect frame = imgViewPin.frame;
        frame.origin.x += 5;
        frame.origin.y += 12;
        
        imgViewPin.frame = frame;
    }
    
    imgViewPin.image = [UIImage imageNamed:@"icon_pin"];
    //[self.view insertSubview:imgViewPin aboveSubview:mkMapView];
    
    btnDrop = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDrop.frame = imgViewPin.frame;
    btnDrop.backgroundColor = [UIColor clearColor];
    [btnDrop addTarget:self action:@selector(dropPin) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:btnDrop aboveSubview:self.mkMapView];
    
    [GC setParentVC:self];*/
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*[UIView animateWithDuration:0.5 animations:^{
     
     [self.sliderRadius setValue:miles animated:YES];
     
     [self computeRadius];
     }];*/
     //dispatch_async(dispatch_get_main_queue(), ^{
         [self userLocation];
     //});
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:maxZoom];
    
    
    
    //mapView = [GMSMapView mapWithFrame:self.googleMapsSubView.frame camera:camera];
    
    mapView.camera = camera;

    TEST_MODE;
//    no need to show my location, I will show with another pin **
//    mapView.myLocationEnabled = YES;
    TEST_MODE;
    
    
    TEST_MODE;
    // no need to show marker, make it simple ****
    // Creates a marker in the center of the map.
//    marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
//    marker.title = @"My Location";
//    marker.snippet = @"Australia";
//    marker.map = mapView;
    TEST_MODE;

    [self computeRadius];
    ILLog(@"radius: %f", circleRadius);
    CLLocationCoordinate2D centre=CLLocationCoordinate2DMake(latitude, longitude);
    [self setMapZoomAndPositionBasedOnRadiusInMtrs:circleRadius andCentrePoint:centre];
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        CLLocationCoordinate2D location;
        location.longitude = self.longitude;
        location.latitude = self.latitude;
            
        geoFenceCircleOnMap.position = location;
        geoFenceCircleOnMap.radius = circleRadius;
    
    TEST_MODE;
//        geoFenceCircleOnMap.map = mapView;
    TEST_MODE;
        [self getAddressFromLocation:location];
    //});
    
    //geoFenceCircleOnMap = [GMSCircle circleWithPosition:location radius:circleRadius];
    
    
}

/*-(void)viewDidAppear:(BOOL)animated
{    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.sliderRadius setValue:miles animated:YES];
        
        [self computeRadius];
    }];
    
    if(latitude!=0.0 && longitude!=0.0)
    {
        [GC showLoader:self withText:@"loading map..."];
        
        self.lblAddress.text = [NSString stringWithFormat:@"%@",GetValue_Key(@"Street")];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CLLocationCoordinate2D location2D;
            location2D.latitude = latitude;
            location2D.longitude = longitude;
            
            [self getAddressFromLocation:location2D];
            
            [self showMapView];
            
            [GC hideLoader];
        });
        
    }
    else if (![strAddress isEqualToString:@""] && strAddress!=nil)
    {
        self.lblAddress.text = [NSString stringWithFormat:@"%@",GetValue_Key(@"Street")];
        
        [GC showLoader:self withText:@"loading map..."];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getLocationFromAddressString_fromAdd:strAddress];
        });
        
    }
    else
    {
        [GC showLoader:self withText:@"loading map..."];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self userLocation];
            
            [self showMapView];
        });
    }
}*/

-(void)viewDidDisappear:(BOOL)animated
{
    if(flagExit == 1)
    {
        strAddress = nil;
        self.strFullAddress = nil;
        viewPulse = nil;
        self.pulseAnimationGroup = nil;
        self.locationManager = nil;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MyMethods
-(void)initialSetupDidLoad{
    [self setupUI];
}

-(void)setupUI{
    
    float size=SCREEN_WIDTH-100;
    _viewCircle=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size, size)];
    [_viewCircle.layer setCornerRadius:size/2.0];
    [_viewCircle setClipsToBounds:YES];
    _viewCircle.center=mapView.center;
    [_viewCircle setBackgroundColor:[UIColor colorWithRed:58.0/256.0 green:212.0/256.0 blue:196.0/256.0 alpha:0.4]]; //58, 212, 196
    [_viewCircle setUserInteractionEnabled:NO];
//    [_viewCircle setHidden:YES];
    
    [mapView addSubview:_viewCircle];

    [sliderRadius setTintColor:COLOR_TEAL];
    [lblAddressTitle setTextColor:COLOR_TEAL];
    
}


-(CLLocationCoordinate2D)calculateCoordinateForDistanceInKm:(double)distanceKM bearing:(double)bearing initialCoordinate:(CLLocationCoordinate2D)coordinate
{
    if(!CLLocationCoordinate2DIsValid(coordinate) || !isValidDouble(distanceKM) || !isValidDouble(bearing))
        assert("The Inputs are not Valid");
    
    double angularDistance  = tan(distanceKM / 6371.0f);
    double bearingRad       = degreeToRad(bearing);
    double currentLat       = degreeToRad(coordinate.latitude);
    double currentLong      = degreeToRad(coordinate.longitude);
    
    double newLatitude      = asin((sin(currentLat) * cos(angularDistance))
                                   + (cos(currentLat) * sin(angularDistance) * cos(bearingRad)));
    double newLongitude     = currentLong + atan2(sin(bearingRad)
                                                  * sin(angularDistance) * cos(currentLat), cos(angularDistance) - (sin(currentLat) * sin(newLatitude)));
    // newLongitude should be in the range -180 to +180
    newLongitude           = fmod((newLongitude + 3*M_PI), (2*M_PI)) - M_PI;
    
    return CLLocationCoordinate2DMake(RadToDegree(newLatitude), RadToDegree(newLongitude));
}

bool isValidDouble(double number)
{
    if(isnan(number) || isinf(number))
        return NO;
    return YES;
}

double degreeToRad(double degree)
{
    double radians  = (degree *  M_PI)/ 180.0f;
    return radians;
}

double RadToDegree(double rad)
{
    double degree   = (rad *  180.0f)/ M_PI;
    return degree;
}
#pragma mark - Drop Pin
/*-(void)dropPin
{
    if(!btnDrop.selected && !imgViewPin.hidden)
    {
        self.imgViewPin.hidden = YES;
        
        for (BasicMapAnnotation *mapAnn in self.mkMapView.annotations) {
            
            [self.mkMapView removeAnnotation:mapAnn];
        }
        
        self.basicAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:self.mkMapView.region.center.latitude   andLongitude:self.mkMapView.region.center.longitude];
        //[mkMapView addAnnotation:self.basicAnnotation];
        
        [btnDrop setSelected:YES];
        
    }
}*/

#pragma mark - Pulse Animation
/*-(void)pulseAndFadeAnimation
{
    viewPulse = [[UIView alloc] initWithFrame:CGRectMake((self.mkMapView.bounds.size.width-100)/2, (self.mkMapView.bounds.size.height/2)+30, 100, 100)];
    viewPulse.backgroundColor = [UIColor blueColor];
    viewPulse.layer.cornerRadius = 50;
    
    [self.view insertSubview:viewPulse aboveSubview:self.mkMapView];
    
    [self.viewPulse.layer addAnimation:self.pulseAnimationGroup forKey:@"pulse"];
    
}*/

/*- (CAAnimationGroup*)pulseAnimationGroup {
    if(!_pulseAnimationGroup) {
        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        _pulseAnimationGroup = [CAAnimationGroup animation];
        _pulseAnimationGroup.duration = self.outerPulseAnimationDuration + self.delayBetweenPulseCycles;
        _pulseAnimationGroup.repeatCount = INFINITY;
        _pulseAnimationGroup.removedOnCompletion = NO;
        _pulseAnimationGroup.timingFunction = defaultCurve;
        
        NSMutableArray *animations = [NSMutableArray new];
        
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
        pulseAnimation.fromValue = @0.0;
        pulseAnimation.toValue = @1.0;
        pulseAnimation.duration = self.outerPulseAnimationDuration;
        [animations addObject:pulseAnimation];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        animation.duration = self.outerPulseAnimationDuration;
        animation.values = @[@0.45, @0.45, @0];
        animation.keyTimes = @[@0, @0.2, @1];
        animation.removedOnCompletion = NO;
        [animations addObject:animation];
        
        _pulseAnimationGroup.animations = animations;
    }
    
    return _pulseAnimationGroup;
}*/


#pragma mark - Show Map View
/*-(void)showMapView
{
    self.mkMapView.showsUserLocation = YES;
    
    MKCoordinateRegion myRegion;
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    
    //Spaning zoom location
    MKCoordinateSpan mySpan;
    mySpan.latitudeDelta = Span;
    mySpan.longitudeDelta = Span;
    
    //Setting regions position
    myRegion.center = center;
    myRegion.span = mySpan;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, 500, 500);
    //MKCoordinateRegion adjustedRegion = [mkMapView regionThatFits:viewRegion];
    //[mkMapView setRegion:adjustedRegion animated:YES];
    
}*/

#pragma mark - User Location
-(void)userLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    latitude=locationManager.location.coordinate.latitude;
    longitude=locationManager.location.coordinate.longitude;
    
    CLLocationCoordinate2D location2D;
    location2D.latitude = latitude;
    location2D.longitude = longitude;
    
    [self getAddressFromLocation:location2D];
}


#pragma mark - Convert address to latitude & longitude
/*-(void)getLocationFromAddressString_fromAdd:(NSString*) addressStr
{
    
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false", esc_addr];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    NSData *data1 = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data1!=nil)
    {
        NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
        
        if([[json valueForKey:@"status"] isEqualToString:@"OK"])
        {
            NSMutableArray *arrlat = [[NSMutableArray alloc] initWithObjects:[[[[json valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"], nil];
            
            latitude=[[[arrlat objectAtIndex:0] objectAtIndex:0] doubleValue];
            
            NSMutableArray *arrlong = [[NSMutableArray alloc] initWithObjects:[[[[json valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"], nil];
            
            longitude=[[[arrlong objectAtIndex:0] objectAtIndex:0] doubleValue];
            
            CLLocationCoordinate2D location2D;
            location2D.latitude = latitude;
            location2D.longitude = longitude;
            
            [self getAddressFromLocation:location2D];
            
            [self showMapView];
            
            [GC hideLoader];
        }
        else
        {
            latitude=0.0;
            longitude=0.0;
            
            [GC hideLoader];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter correct address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else
    {
        latitude=0.0;
        longitude=0.0;
        
        [GC hideLoader];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Network issue, unable to fetch data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
}*/

#pragma mark - Googlemap Delegates
//- (void)mapView:(GMSMapView *)mapViewp willMove:(BOOL)gesture{
//    if (gesture) {
//        
//        TEST_MODE;
//        float currZomm=mapViewp.camera.zoom;
//        [mapView setMinZoom:currZomm maxZoom:currZomm];  // to disable gesture zoom ****
//        TEST_MODE;
//    }
//    
//    DISPLAY_METHOD_NAME;
//    
//}
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    DISPLAY_METHOD_NAME;
}
- (void)mapView:(GMSMapView *)mapViewParam idleAtCameraPosition:(GMSCameraPosition *)position{
    DISPLAY_METHOD_NAME;
    CGPoint poi = mapViewParam.center;
    CLLocationCoordinate2D mapCenterPoi = [mapViewParam.projection coordinateForPoint:poi];
    ILLog(@"posPoint: %@", position);
    ILLog(@"mapCenterPoi lat: %f Lon: %f", mapCenterPoi.latitude, mapCenterPoi.longitude);


    self.latitude=mapCenterPoi.latitude;
    self.longitude=mapCenterPoi.longitude;
    
    CLLocationCoordinate2D location2D;
    location2D.latitude = self.latitude;
    location2D.longitude = self.longitude;
    
    [imgViewPin setCenter:CGPointMake(poi.x, poi.y-17)]; // so need to adjust the image ****
    [imgViewPin setHidden:NO];
    
    [self getAddressFromLocation:location2D];
    
    
    ILLog(@"frame1: %@", NSStringFromCGRect(mapViewParam.frame));
    ILLog(@"frame2: %@", NSStringFromCGRect(mapView.frame));
    ILLog(@"frame3: %@", NSStringFromCGRect(self.view.frame));
    
    
    TEST_MODE;
    geoFenceCircleOnMap.position=location2D;
    TEST_MODE;
    
    
    
    ILLog(@"zoom: %f", mapView.camera.zoom);
}
#pragma mark - Map View Delegates
/*- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(btnDrop.selected)
    {
        if([annotation isKindOfClass:[MKUserLocation class]])
        {
            return nil;
        }
        
        mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        mapPin.image = [UIImage imageNamed:@"icon_pin"];
        mapPin.canShowCallout = NO;
        
        return mapPin;
    }
    else
    {
        mapPin = nil;
        
        return nil;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        [btnDrop setSelected:NO];
        
        for (BasicMapAnnotation *mapAnn in self.mkMapView.annotations) {
            
            [self.mkMapView removeAnnotation:mapAnn];
        }
        
        self.imgViewPin.hidden = NO;
        
        [self.mkMapView removeOverlay:circleOverlay];
        
        CLLocationCoordinate2D location2d = [self coordinateOfLocation];
        
        latitude = location2d.latitude;
        longitude = location2d.longitude;
        
        [self getAddressFromLocation:location2d];
	}
    
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    if(![self.strFullAddress isEqualToString:@""])
    {
        
        if(!btnDrop.selected)
        {
            for (BasicMapAnnotation *myAnn in self.mkMapView.annotations) {
                
                [self.mkMapView removeAnnotation:myAnn];
            }
            
            [self.mkMapView removeOverlay:circleOverlay];
            
            CLLocationCoordinate2D location2d;
            
            location2d = [self coordinateOfLocation];
            
            latitude = location2d.latitude;
            longitude = location2d.longitude;
            
            [self getAddressFromLocation:location2d];
        }
        
    }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    
    if([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircle *circle = (MKCircle*) overlay;
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:circle];
        circleView.fillColor = [setColor(58, 212, 196) colorWithAlphaComponent:0.4];
        return circleView;
    }
    
    return nil;
}

#pragma mark - Convert Map Pin to Map Center Point
-(CLLocationCoordinate2D)coordinateOfLocation{
    
    if([UIScreen mainScreen].bounds.size.height>480)
        return [self.mkMapView convertPoint:CGPointMake(imgViewPin.frame.origin.x+11, imgViewPin.frame.origin.y-7) toCoordinateFromView:self.mkMapView];
    else
        return [self.mkMapView convertPoint:CGPointMake(imgViewPin.frame.origin.x+11, imgViewPin.frame.origin.y-12) toCoordinateFromView:self.mkMapView];
}*/

#pragma mark - Get Address
-(void)getAddressFromLocation:(CLLocationCoordinate2D) location2d
{
    /*if(!btnDrop.selected)
        circleOverlay = [MKCircle circleWithCenterCoordinate:self.mkMapView.region.center radius:circleRadius];
    else
        circleOverlay = [MKCircle circleWithCenterCoordinate:self.basicAnnotation.coordinate radius:circleRadius];
    
    [self.mkMapView addOverlay:circleOverlay];*/
    
    
    if (isReach) {
        GMSGeocoder *geocoder = [[GMSGeocoder alloc] init];
        
        [geocoder reverseGeocodeCoordinate:location2d completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            
            GMSAddress* address = [response firstResult];
            
            ILLog(@"addLines: %@", address.lines);
            

            TASK_LISTED;     // Application closes when map is opened on the create a fest page **********
            NSString *street=address.thoroughfare?address.thoroughfare:@"";
            NSString *postalCode=address.postalCode?address.postalCode:@"";
            NSString *adminArea=address.administrativeArea?address.administrativeArea:@"";
            TASK_LISTED;
            
            NSString *thoroughfare = address.thoroughfare?address.thoroughfare:@"";
            NSString *locality = address.locality?address.locality:@"";
            
            
            
            
            NSString* fullAddress = [NSString stringWithFormat:@"%@ %@ %@",thoroughfare, locality, adminArea];
            
            NSString *line1=[address.lines firstObject];
            if (line1 && line1.length) {
                fullAddress=[NSString stringWithFormat:@"%@", line1];
            }
            

            self.strFullAddress = [[NSString alloc] initWithString:fullAddress];
            
   
            
            
            [self.dicAddress setObject:street forKey:@"Street"];
            [self.dicAddress setObject:locality forKey:@"City"];
            [self.dicAddress setObject:postalCode forKey:@"Zipcode"];
            [self.dicAddress setObject:adminArea forKey:@"State"];
            
            [self.dicAddress setObject:self.strFullAddress forKey:@"FullAddress"];
            
            
            [GC hideLoader];
            
            
            ILLog(@"fullAddr: %@", fullAddress);
            
            TASK_LISTED;     // Fest location and address banner UI. Slider bar UI **********
            [lblAddress setNumberOfLines:2];
            TASK_LISTED;

            
            lblAddress.text = fullAddress;
    

            SetValue_Key(@"MapAddress", @"MapAddress");
            
            
        }];
        
    }

    /*if (isReach) {
        
        NSString *strURL=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",location2d.latitude,location2d.longitude];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"OK"]) {
                
                NSMutableArray *ar = [[NSMutableArray alloc] initWithObjects:[[responseObject valueForKey:@"results"] objectAtIndex:0], nil];
                
                self.strFullAddress = [NSString new];
                self.strFullAddress = [NSString stringWithFormat:@"%@",[[[responseObject valueForKey:@"results"] objectAtIndex:0] valueForKey:@"formatted_address"]];
                
                [self.dicAddress setObject:self.strFullAddress forKey:@"FullAddress"];
                
                NSMutableArray *arrAddr = [[NSMutableArray alloc] initWithArray:[[ar valueForKey:@"address_components"]firstObject]];
                
                // Separate Address Components
                NSString *strStreet = [NSString new];
                
                for(int i=0;i<arrAddr.count;i++)
                {
                    NSMutableDictionary *dicAddr = [[NSMutableDictionary alloc] initWithDictionary:[arrAddr objectAtIndex:i]];
                    
                    NSMutableArray *arrKey = [NSMutableArray arrayWithArray:[dicAddr objectForKey:@"types"]];
                    NSString *strKey = [NSString stringWithFormat:@"%@",[arrKey firstObject]];
                    
                    if([strKey isEqualToString:Street_number] || [strKey isEqualToString:Route] || [strKey isEqualToString:Neighborhood] || [strKey isEqualToString:Sublocality_level_1] || [strKey isEqualToString:Sublocality_level_2])
                    {
                        if(i==0)
                            strStreet = [NSString stringWithFormat:@"%@",[dicAddr objectForKey:@"long_name"]];
                        else
                            strStreet = [NSString stringWithFormat:@"%@,%@",strStreet,[dicAddr objectForKey:@"long_name"]];
                    }
                    else
                    {
                        if([strKey isEqualToString:Locality])
                            [self.dicAddress setObject:[dicAddr objectForKey:@"long_name"] forKey:@"City"];
                        else if ([strKey isEqualToString:Administrative_area_level_1])
                            [self.dicAddress setObject:[dicAddr objectForKey:@"short_name"] forKey:@"State"];
                        else if ([strKey isEqualToString:Country])
                            [self.dicAddress setObject:[dicAddr objectForKey:@"long_name"] forKey:@"Country"];
                        else if ([strKey isEqualToString:Postal_code])
                            [self.dicAddress setObject:[dicAddr objectForKey:@"long_name"] forKey:@"Zipcode"];
                    }
                }
                
                if(strStreet.length>0){
                    
                    [self.dicAddress setObject:strStreet forKey:@"Street"];
                    
                    if(![GetValue_Key(@"Street") isEqualToString:@""])
                    {
                        SetValue_Key(@"", @"Street");
                    }
                    else
                    {
                        self.lblAddress.text = strStreet.copy;
                        self.lblAddress.text = [self.lblAddress.text stringByReplacingOccurrencesOfString:@"," withString:@" "];
                    }
                }
                
                [GC hideLoader];
                
                SetValue_Key(@"MapAddress", @"MapAddress");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             [GC hideLoader];
         }];
    }*/
    else
    {
        [GC hideLoader];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network disconnected." message:@"Unable to fetch location details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - Compute Current Slider Value
-(void)computeRadius
{
    
    float val= self.sliderRadius.value;
    ILLog(@"sliderVal: %f", val);
    
    
    miles = (NSInteger) roundf(self.sliderRadius.value);
    
    if(miles<63360)
    {
        miles = (NSInteger) roundf(miles/1760) * 100 ;
        
        if(miles<=50)
            miles = 50;
        
        if(miles>50)
            miles = miles/2;
        
        circleRadius = miles * 0.9144;
        
        self.lblRadius.text = [NSString stringWithFormat:@"%ld",(long)miles];
        self.lblMiles_title.text = @"Yards";
    }
    else
    {
        miles = (NSInteger ) roundf(self.sliderRadius.value/1760);
        miles -= 36;
        
        if(miles == 0 || miles == 1)
            miles = 2;
        
        circleRadius = miles * 1609.34;
        
        self.lblRadius.text = [NSString stringWithFormat:@"%ld",(long)miles];
        self.lblMiles_title.text = @"Mile(s)";
    }
}

#pragma mark - Go Back
- (IBAction)goto_back:(id)sender
{
    SetValue_Key(@"", @"MapAddress");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Save Address and Go back
- (IBAction)saveAddress:(id)sender
{
    flagExit = 1;
    [self.dicAddress setObject:[NSString stringWithFormat:@"%ld",(long)roundf(self.sliderRadius.value)] forKey:@"Radius"];
    [self.dicAddress setObject:[NSString stringWithFormat:@"%lf",latitude] forKey:@"Latitude"];
    [self.dicAddress setObject:[NSString stringWithFormat:@"%lf",longitude] forKey:@"Longitude"];
    [[GC collections] setObject:self.dicAddress forKey:@"Location"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Distance Changer
/*- (IBAction)sliderRadiusValue:(UISlider *)slider withEvent:(UIEvent*)e;
{
    [self computeRadius];
    
    UITouch * touch = [e.allTouches anyObject];
    
    if( touch.phase != UITouchPhaseMoved && touch.phase != UITouchPhaseBegan)
    {
        //The user has ended drag.
        
        [self.mkMapView removeOverlay:circleOverlay];
        
        if(!btnDrop.selected)
            circleOverlay = [MKCircle circleWithCenterCoordinate:self.mkMapView.region.center radius:circleRadius];
        else
            circleOverlay = [MKCircle circleWithCenterCoordinate:self.basicAnnotation.coordinate radius:circleRadius];
        
        [self.mkMapView addOverlay:circleOverlay];
        
    }
}*/

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)geoFenceSliderChanged:(id)sender
{
    
    [self computeRadius];
    geoFenceCircleOnMap.radius = circleRadius;
    geoFenceCircleOnMap.fillColor = [UIColor blackColor]; //58, 212, 196


    float percent = self.sliderRadius.value/self.sliderRadius.maximumValue;

    float mapMax=mapView.maxZoom;
    
    float rangeSet=maxZoom-minZoom;
    
    float zoomInverse=rangeSet*percent;
    float zoomNeeded=maxZoom-zoomInverse;
    
    ILLog(@"perecnt: %f", percent);
    ILLog(@"perecntmapMax: %f", mapMax);
    ILLog(@"zoomInverse: %f", zoomInverse);
    ILLog(@"zoomNeeded: %f", zoomNeeded);
    
    ILLog(@"circleRadius: %f", circleRadius);

    
    
    
    CLLocationCoordinate2D centre=CLLocationCoordinate2DMake(self.latitude, self.longitude);
    [self setMapZoomAndPositionBasedOnRadiusInMtrs:circleRadius andCentrePoint:centre];
    

}
-(void)setMapZoomAndPositionBasedOnRadiusInMtrs:(float)radiusMtrs andCentrePoint:(CLLocationCoordinate2D)centre{
    
    
    //    50 yards = 45.72 metres **************
    [mapView setMinZoom:minZoom maxZoom:maxZoom];  // can set zoom within tha limits ****
    
    double kms=radiusMtrs/1000.0;
    double kmsBasedOnDiamter=(radiusMtrs/2.0)/1000.0;
    
    CLLocationCoordinate2D loc1=[self calculateCoordinateForDistanceInKm:kmsBasedOnDiamter bearing:0 initialCoordinate:centre];
    CLLocationCoordinate2D loc2=[self calculateCoordinateForDistanceInKm:kmsBasedOnDiamter bearing:180 initialCoordinate:centre];
    
    float padding= (mapView.frame.size.height- _viewCircle.frame.size.height)/2.0; // since we are showing a circle, we need to enclose our distance range within that circle
    
    ILLog(@"padding: %f", padding);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:loc1 coordinate:loc2];
    
    TEST_MODE;
    //    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:padding];
    
    float padTop=CGRectGetMinY(_viewCircle.frame) - CGRectGetMinY(mapView.frame);
    float padLeft=CGRectGetMinX(_viewCircle.frame) - CGRectGetMinX(mapView.frame);
    float padBottom=CGRectGetMaxY(mapView.frame) - CGRectGetMaxY(_viewCircle.frame);
    float padRight=CGRectGetMaxX(mapView.frame) - CGRectGetMaxX(_viewCircle.frame);
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(padTop, padLeft, padBottom, padRight)];
    TEST_MODE;
    
    [mapView moveCamera:update];
    
    [mapView animateToLocation:centre];
    
    ILLog(@"zoom: %f", mapView.camera.zoom);
    
    TEST_MODE;
    
    float currZomm=mapView.camera.zoom;
    [mapView setMinZoom:currZomm maxZoom:currZomm];  // to disable gesture zoom ****
    
}
@end
