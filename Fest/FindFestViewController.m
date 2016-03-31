//
//  FindFestViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "FindFestViewController.h"
#import "FestDetailViewController.h"
#import "CreateFestViewController.h"
#import "MyFestViewController.h"
//#import "RESideMenu.h"
#import "CellFindFest.h"
#import "EventPostLsitVC.h"

@interface FindFestViewController ()

@end

@implementation FindFestViewController
@synthesize view_header,lbl_header,sliderMiles,lblDistance,tableFest,btnMenu,locationManager,dataRequest,userModel,lblNoData;

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
    
    //[self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"icon_plain_bg", @"icon_plain_bg")]]];
    
    [self.tableFest setBackgroundColor:[UIColor clearColor]];
    
    self.tableFest.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableFest.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    lbl_header.font=[UIFont fontWithName:LatoRegular size:18.0];
    //self.lblDistance.font=[UIFont fontWithName:ProximaNovaSemibold size:18.0];
    
    [self.sliderMiles addTarget:self action:@selector(sliderValue:withEvent:) forControlEvents:UIControlEventValueChanged];
    
   
    flagExit = 0;
    
    [self.btnMenu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.lblStatic1 setFont:[UIFont fontWithName:ProximaNovaLight size:11.0]];
    //[self.lblStatic2 setFont:[UIFont fontWithName:ProximaNovaLight size:11.0]];
    //[self.lblStatic3 setFont:[UIFont fontWithName:ProximaNovaLight size:13.0]];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft_FF:)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    /*swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight_FF:)];
     swipeRight.numberOfTouchesRequired = 1;
     swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
     [self.view addGestureRecognizer:swipeRight];*/
    
    [self showNoResult];
    
    [[GC arrFest] removeAllObjects];
    
    [GC setParentVC:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.sliderMiles setValue:25 animated:YES];
        [self computeSliderValue];
    }];
    
    [GC showLoader];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        miles = 25;
        [self getGeneralFest];
    });
    
    /*FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends?fields=name,email,picture,birthday,location"];
     [ friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
     NSArray *data = [result objectForKey:@"data"];
     NSLog(@"result=>%@",result);
     for (FBGraphObject<FBGraphUser> *friend in data) {
     NSLog(@"%@:%@", [friend username],[friend birthday]);
     }
     }];*/
    
    
    /*UserModel *userModel = [[GC arrUserDetails] firstObject];
     NSLog(@"User ID=>%@",userModel.localID);*/
    
    /*NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"id,name,picture",@"fields",nil];
     
     [FBRequestConnection startWithGraphPath:@"me/friends"
     parameters:params
     HTTPMethod:@"GET"
     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
     if(error == nil) {
     FBGraphObject *response = (FBGraphObject*)result;
     NSLog(@"Friends: %@",[response objectForKey:@"data"]);
     }
     else{
     
     NSLog(@"result=>%@",result);
     }
     }];*/
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Find Fest";
}

-(void)viewDidAppear:(BOOL)animated
{
    if([GetValue_Key(@"EventUpdated") isEqualToString:@"EventUpdated"])
    {
        [GC showLoader];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            miles = 25;
            [self getGeneralFest];
        });
        
        SetValue_Key(@"", @"EventUpdated");
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(flagExit == 1)
    {
        self.userModel = nil;
        self.dataRequest = nil;
        self.locationManager = nil;
        self.lblNoData = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get User Location
-(void)getUserLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    latitude=locationManager.location.coordinate.latitude;
    longitude=locationManager.location.coordinate.longitude;
}

#pragma mark - Location manager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    latitude = manager.location.coordinate.latitude;
    longitude = manager.location.coordinate.longitude;
}

#pragma mark - Swipe Gesture
-(void)swipeLeft_FF:(UISwipeGestureRecognizer *)gest
{
    MyFestViewController *MV = [self.storyboard instantiateViewControllerWithIdentifier:MyFest_ViewController];
    [self.navigationController pushViewController:MV animated:YES];
}

-(void)swipeRight_FF:(UISwipeGestureRecognizer *)gest
{
    
    flagExit = 1;
    
    MyFestViewController *MV = [self.storyboard instantiateViewControllerWithIdentifier:MyFest_ViewController];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:MV animated:NO];
    
}

#pragma mark - Animation Delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GC arrFest].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFindFest *cell = [tableView dequeueReusableCellWithIdentifier:CellFindFest_ID];
    
    if(cell == nil)
    {
        cell = (CellFindFest *) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellFindFest_ID];
    }
    
    //cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_cover_bg"]];
    
    /*UIView *viewBase = (UIView *)[cell viewWithTag:6];
    [viewBase removeFromSuperview];
    
    UIView *viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-90, cell.bounds.size.width, 80)];
    viewContent.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.75];
    viewContent.tag = 6;
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, cell.bounds.size.width-20, 25)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.numberOfLines = 1;
    lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    lblTitle.font = [UIFont fontWithName:ProximaNovaSemibold size:15.0];
    lblTitle.text = [[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Title"]] uppercaseString];
    [viewContent addSubview:lblTitle];*/
    cell.lblTitle.text = [[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Title"]] uppercaseString];
    
    NSString *refDescrip = [NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Description"]];
    
    if(refDescrip.length>0 && ![refDescrip isEqualToString:@"<null>"]){
        
        /*NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrahStyle setLineSpacing:5];
        
        UILabel *lblDescrip = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, cell.bounds.size.width-20, 40)];
        lblDescrip.backgroundColor = [UIColor clearColor];
        lblDescrip.textColor = [UIColor darkGrayColor];
        lblDescrip.textAlignment = NSTextAlignmentLeft;
        lblDescrip.numberOfLines = 3;
        lblDescrip.lineBreakMode = NSLineBreakByTruncatingTail;
        lblDescrip.attributedText = [[NSAttributedString alloc] initWithString:refDescrip attributes:@{NSParagraphStyleAttributeName : paragrahStyle , NSFontAttributeName : [UIFont fontWithName:ProximaNovaRegular size:16.0]}];
        [viewContent addSubview:lblDescrip];
        
        [lblDescrip sizeToFit];
        
        viewContent.frame = CGRectMake(0, cell.bounds.size.height-(30 + lblDescrip.frame.size.height + 5 + 10), cell.bounds.size.width, (30 + lblDescrip.frame.size.height + 5));*/
        cell.lblDescrip.text = refDescrip;
        
    }
    else
    {
        cell.lblDescrip.text = @"";
        //viewContent.frame = CGRectMake(0, cell.bounds.size.height-40, cell.bounds.size.width, 30);
    }
    
    NSMutableArray *arrMedia = [[NSMutableArray alloc] initWithArray:[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Medias"]];
    cell.imgViewCover.layer.cornerRadius = 49;
    
    if(arrMedia.count>0)
    {
        cell.imgViewCover.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgViewCover.clipsToBounds = YES;
        int mediaType = [[[arrMedia firstObject] valueForKey:@"Type"] intValue];
        NSString *strImgPath;
        if(mediaType == 0)
            strImgPath = [NSString stringWithFormat:@"%@",[[arrMedia firstObject] valueForKey:@"Path"]];
        else
            strImgPath = [NSString stringWithFormat:@"%@",[[arrMedia firstObject] valueForKey:@"ThumbPath"]];
        
        //@"icon_fest_ghost1"
        
        [cell.imgViewCover sd_setImageWithURL:URL(strImgPath) placeholderImage:[UIImage imageNamed:@"default_fest_icon"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
            {
                [self.tableFest reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else{
                
                cell.imgViewCover.image = image;
            }
        }];
    }
    else
    {
        cell.imgViewCover.image = [UIImage imageNamed:@"default_fest_icon"];
    }
    
    //[cell.contentView addSubview:viewContent];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *festDate=[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"StartDate"]];
    if([self isExpiredDate:festDate])
    {
        EventPostLsitVC *eventPostList = [[ILLogic storyboardNoAutolayout] instantiateViewControllerWithIdentifier:EventPostsList_VC];
        eventPostList.strTitle=lbl_header.text;
        eventPostList.dictFestDetails=[[GC arrFest] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:eventPostList animated:YES];
    }
    else
    {
        flagExit = 0;
        
        //Maintain Media Contents Globally
        [GC setArrPreviews:[[NSMutableArray alloc] initWithArray:[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Medias"]]];
        
        //Maintain Event ID, Event Title & Event Likes Globally
        [GC setEventID:[[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue]];
        [GC setEventTitle:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Title"]]];
        
        FestDetailViewController *FDV = [self.storyboard instantiateViewControllerWithIdentifier:FestDetail_ViewController];
        FDV.isMyFest = NO;
        FDV.pageIndex=indexPath.row;
        FDV.arrFestDetails=[[NSMutableArray alloc] initWithObjects:[[GC arrFest] objectAtIndex:indexPath.row], nil];
        [self.navigationController pushViewController:FDV animated:YES];
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 121.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

#pragma mark - Show No Result Label
-(void)showNoResult
{
    lblNoData = [[UILabel alloc] init];
    lblNoData.frame = CGRectMake(20, self.tableFest.frame.origin.y+20, [UIScreen mainScreen].bounds.size.width-40, 30);
    lblNoData.text = @"No records found.";
    lblNoData.textColor = [UIColor whiteColor];
    lblNoData.textAlignment = NSTextAlignmentCenter;
    lblNoData.hidden = YES;
    lblNoData.font = [UIFont fontWithName:ProximaNovaSemibold size:16.0];
    [self.view insertSubview:lblNoData aboveSubview:self.tableFest];
}

#pragma mark  - List of General Fests
-(void)getGeneralFest
{
    if(isReach)
    {
        [self festRequest];
    }
    else
    {
        [GC hideLoader];
        
        [self showAlertView_FF:@"" message:No_Internet];
    }
}

#pragma mark - Request For Fest
-(void)festRequest
{
    [self getUserLocation];
    
    self.userModel = [[GC arrUserDetails] firstObject];
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    NSMutableDictionary *dicSearch = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicSearch setObject:[NSString stringWithFormat:@"%lf",latitude] forKey:@"Latitude"];
    [dicSearch setObject:[NSString stringWithFormat:@"%lf",longitude] forKey:@"Longitude"];
    [dicSearch setObject:[NSString stringWithFormat:@"%ld",(long)miles] forKey:@"Miles"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicSearch forKey:@"SearchCriteria"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *strJson = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *dataMyJson =[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,FindFest];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:dataMyJson]];
    
    [self.dataRequest startSynchronous];
    
    lblNoData.hidden = YES;
    
    if(self.dataRequest)
    {
        self.lblDistance.text = @"";
        if([self.dataRequest error])
        {
            [GC hideLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    [self showAlertView_FF:@"" message:No_Internet];
                else
                    [self showAlertView_FF:@"" message:self.dataRequest.error.localizedDescription];
                
            });
            
        }
        else if ([self.dataRequest responseString])
        {
            
            NSData *data= [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result == 1)
            {
                
                //Maintain Fest Lists Globally
                [GC setArrFest:[[NSMutableArray alloc] initWithArray:[json valueForKeyPath:@"Data"]]];
                
                //NSLog(@"GC.arrFest.count=>%ld",(long)[GC arrFest].count);
                
                [GC hideLoader];
                
                if([GC arrFest].count>0){
                    
                    lblNoData.hidden = YES;
                    [self.tableFest reloadData];
                    
                    NSMutableAttributedString *_attrStrCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)[GC arrFest].count] attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor],NSFontAttributeName:[UIFont fontWithName:LatoBold size:15.0]}];
                    NSMutableAttributedString *_attrStrWithin = [[NSMutableAttributedString alloc] initWithString:@" within " attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:[UIFont fontWithName:LatoRegular size:15.0]}];
                    NSMutableAttributedString *_attrStrMile = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)miles] attributes:@{NSForegroundColorAttributeName: COLOR_MAINCOLOR,NSFontAttributeName:[UIFont fontWithName:LatoBold size:15.0]}];
                    NSMutableAttributedString *_attrStrMi = [[NSMutableAttributedString alloc] initWithString:@" mi" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor],NSFontAttributeName:[UIFont fontWithName:LatoBold size:15.0]}];
                    [_attrStrCount appendAttributedString:_attrStrWithin];
                    [_attrStrCount appendAttributedString:_attrStrMile];
                    [_attrStrCount appendAttributedString:_attrStrMi];
                    self.lblDistance.attributedText = _attrStrCount;
                }
                else{
                    
                    lblNoData.hidden = NO;
                    
                    [self.tableFest reloadData];
                    
                }
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        if([strFailure rangeOfString:@"Record Not found"].length!=0)
                        {
                            if([GC arrFest].count>0)
                            {
                                [[GC arrFest] removeAllObjects];
                            }
                            
                            [tableFest reloadData];
                            
                            lblNoData.hidden = NO;
                            
                        }
                        else
                            [self showAlertView_FF:@"" message:strFailure];
                    }
                    else
                    {
                        [[AppDelegate getDelegate] sessionExpired];
                    }
                    
                });
            }
        }
    }
    else
    {
        [GC hideLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlertView_FF:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Alert View Common
-(void)showAlertView_FF:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - Compute Yards & Miles
-(void)computeSliderValue
{
    miles = (NSInteger) roundf(self.sliderMiles.value);
    self.lblDistance.text = [NSString stringWithFormat:@"1 - %ld",(long)miles];
}

#pragma mark - Fest menu
- (IBAction)menuFest:(id)sender
{
    flagExit = 1;
}

#pragma mark - Distance Changer
- (IBAction)sliderValue:(UISlider *)slider withEvent:(UIEvent*)e;
{
    [self computeSliderValue];
    
    UITouch * touch = [e.allTouches anyObject];
    
    if( touch.phase != UITouchPhaseMoved && touch.phase != UITouchPhaseBegan)
    {
        //The user has ended drag.
        if(refmiles!=miles)
            [self getGeneralFest];
    }
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

@end
