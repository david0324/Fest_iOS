//
//  FestDetailViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 07/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "FestDetailViewController.h"
#import "CommentViewController.h"
#import "InviteViewController.h"
#import "ChatViewController.h"
#import "AttendingViewController.h"
#import "FindFestViewController.h"
#import "MyFestViewController.h"
#import "SlideNavigationController.h"
#import "SlideViewController.h"
#import "CreateFestViewController.h"
#import "EventPostLsitVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "BackendManager.h"


@interface FestDetailViewController ()
{
    BOOL canEdit;
}
@end

@implementation FestDetailViewController
@synthesize view_header,lbl_header,lblFestAddress,lblFestDate,lblFestTitle,imgViewCover,scrollFest, txtViewFestDescrip,pageIndex,btnAccept,btnInvite,btnReject,btnShare,btnComment,btnChat,lblAttending,eventStatus,eventHost,eventType,arrDB,formatter,dateToday;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addressButton addTarget:self action:@selector(goto_FestLocation:) forControlEvents:UIControlEventTouchUpInside];
    [addressButton setTitle:@"BUTTON" forState:UIControlStateNormal];
    //addressButton.translatesAutoresizingMaskIntoConstraints = YES;
    [addressButton setFrame:lblFestAddress.frame];
    
    [self.view addSubview:addressButton];


}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    
    lbl_header.font = [UIFont fontWithName:LatoRegular size:18.0];
    lblFestTitle.font = [UIFont fontWithName:LatoBold size:20];
    [lbl_header setTextColor:COLOR_TEAL];



    imgViewCover.layer.cornerRadius = 96;
    
    formatter = [[NSDateFormatter alloc] init];
    
    if(self.isMyFest)
    {
        self.ivButtonBg.hidden = YES;
        self.btnAccept.hidden = YES;
        self.btnChat.hidden = NO;
        self.btnInvite.hidden = NO;
    }
    else
    {
        self.btnAccept.hidden = NO;
        self.btnChat.hidden = YES;
        self.btnInvite.hidden = YES;
    }
    
    
    [imgViewCover setClipsToBounds:YES];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftOnScreen:)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.scrollFest addGestureRecognizer:swipeLeft];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightOnScreen:)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.scrollFest addGestureRecognizer:swipeRight];
    
    self.userModel = [[GC arrUserDetails] firstObject];
    
    [GC setParentVC:self];
    
    [self.scrollFest setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [GC showLoader];
    
    if([GetValue_Key(@"Invite") isEqualToString:@"Invite"])
    {
        [[GC arrFest] removeAllObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getFestEventRequest];
        });
    }
    else
    {
        if([GetValue_Key(@"Nav") isEqualToString:@"MyFest"])
        {
            [[GC arrFest] removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self getFestEventRequest];
            });
        }
        else
        {
            [self getFestDetails];
        }
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self setupUI];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [GC setParentVC:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressUpdateNotify:) name:@"AddressUpdate" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddressUpdate" object:nil];
    
    if(flagExit == 1)
    {
        [GC setEventID:0];
        [GC setChatID:0];
        
        txtViewFestDescrip = nil;
        btnAccept = nil;
        btnShare = nil;
        btnReject = nil;
        btnInvite = nil;
        formatter = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MyMethods
-(void)setupUI{
    
    [NSLayoutConstraint deactivateConstraints:lbl_header.constraints];
    [lbl_header setFrame:CGRectMake(0, 0,  view_header.frame.size.width-120, view_header.frame.size.height)];
    [lbl_header setNumberOfLines:2];
    [lbl_header sizeToFit];
    [lbl_header setCenter:CGPointMake(view_header.frame.size.width/2.0, _btnEdit.center.y)];

    [self updateChtaButtonUI];
}
-(BOOL)amIWithinTheFestRadius{
    
    /*
     Users can post and view comments in a fest if they are within the fest radius.
     */
    
    
    NSDictionary *_dictFestDetails=[self.arrFestDetails firstObject];
    
    double festLat=[[_dictFestDetails objectForKey:@"Latitude"] doubleValue];
    double festLon=[[_dictFestDetails objectForKey:@"Longitude"] doubleValue];
    double festRadius=[[_dictFestDetails objectForKey:@"Miles"] doubleValue];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[APPDELEGATE delLatitude] longitude:[APPDELEGATE delLongitude]];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:festLat longitude:festLon];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    distance = distance/1609.34;
    
    if(distance<=festRadius)
    {
        return YES;
    }
    
    return NO;
}
-(void)updateChtaButtonUI{

    [btnChat setImage:nil forState:UIControlStateNormal];
    [btnChat.titleLabel setText:@""];
//    BOOL post=YES;
    if ([self amIWithinTheFestRadius]) {
        [btnChat.titleLabel setText:@"Post Something!"];
        [btnChat setTitle:@"Post Something!" forState:UIControlStateNormal];

    }
    else{
        [btnChat.titleLabel setText:@"View!"];
        [btnChat setTitle:@"View!!" forState:UIControlStateNormal];
    }
    [btnChat setTitleColor:COLOR_TEAL forState:UIControlStateNormal];
    [btnChat.titleLabel setFont:[UIFont fontWithName:LatoRegular size:17]];
    
//    [btnChat setBackgroundColor:RANDOM_COLOR];
    
}
-(void)showMyFests{
    DISPLAY_METHOD_NAME;
    MyFestViewController *MFV = [self.storyboard instantiateViewControllerWithIdentifier:MyFest_ViewController];
    //    [self.navigationController pushViewController:MFV animated:YES];
    //    ILLog(@"nav: %@", self.navigationController.viewControllers);
    
    self.navigationController.viewControllers=@[MFV];
    ILLog(@"nav2: %@", self.navigationController.viewControllers);
    
}
#pragma mark - Swipe On Screen
-(void)swipeLeftOnScreen:(UISwipeGestureRecognizer *)gest
{
    
    if(pageIndex == ([GC arrFest].count-1))
    {
        pageIndex = 0;
    }
    else
    {
        pageIndex++;
    }
    
    [GC setArrPreviews:[[NSMutableArray alloc] initWithArray:[[[GC arrFest] objectAtIndex:pageIndex] valueForKey:@"Medias"]]];
    [GC setEventID:[[[[GC arrFest] objectAtIndex:pageIndex] valueForKey:@"Id"] integerValue]];
    [GC setEventTitle:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:pageIndex] valueForKey:@"Title"]]];
    
    [GC showLoader];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self viewLayerAnimationRight];
        
        [self getFestEventRequest];
    });
    
}

-(void)swipeRightOnScreen:(UISwipeGestureRecognizer *)gest
{
    
    if(pageIndex == 0)
    {
        [self navigateToFest];
    }
    else
    {
        pageIndex--;
        
        [GC setArrPreviews:[[NSMutableArray alloc] initWithArray:[[[GC arrFest] objectAtIndex:pageIndex] valueForKey:@"Medias"]]];
        [GC setEventID:[[[[GC arrFest] objectAtIndex:pageIndex] valueForKey:@"Id"] integerValue]];
        [GC setEventTitle:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:pageIndex] valueForKey:@"Title"]]];
        
        [GC showLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self viewLayerAnimationLeft];
            
            [self getFestEventRequest];
        });
    }
}

#pragma mark - Get Fest Details
-(void)getFestDetails
{
    
    lblFestTitle.text =@"";//[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"Title"]];
    
    lbl_header.text = [NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"Title"]];
    
    [lbl_header sizeToFit];
    
    //[self.navigationController setTitle:[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"Title"]]];
    
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    
    NSDate *dateFestStart = [formatter dateFromString:[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"StartDate"]]];
    
   
    //Custom Date Format
    formatter.dateFormat = @"MMM dd, yyyy";
    NSString *strDate = [formatter stringFromDate:dateFestStart];
    lblFestDate.text = [NSString stringWithFormat:@"%@",strDate];
    
    //Custom Time Format
    formatter.timeStyle = NSTimeZoneNameStyleShortStandard;
    formatter.dateFormat = @"h:mm a";
    lblFestDate.text = lblFestDate.text;
    self.lbFestTime.text = [formatter stringFromDate:dateFestStart];
    
    self.lbDescription.text = [NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"Description"]];
    
    self.strAddress = [NSString stringWithFormat:@"%@,%@,%@,%@",
                       [[self.arrFestDetails firstObject] valueForKey:@"Street"],
                       [[self.arrFestDetails firstObject] valueForKey:@"City"],
                       [[self.arrFestDetails firstObject] valueForKey:@"State"],
                       [[self.arrFestDetails firstObject] valueForKey:@"Zip"]];
    
    self.strAddress = [self.strAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    lblFestAddress.text = [NSString stringWithFormat:@"%@\n%@\n%@ %@",
                           [[self.arrFestDetails firstObject] valueForKey:@"Street"],
                           [[self.arrFestDetails firstObject] valueForKey:@"City"],
                           [[self.arrFestDetails firstObject] valueForKey:@"State"],
                           [[self.arrFestDetails firstObject] valueForKey:@"Zip"]];
    
    [lblFestAddress sizeToFit];
    
        
    if([GC arrPreviews].count>0)
    {
        int mediaType = [[[[GC arrPreviews] firstObject] valueForKey:@"Type"] intValue];
        NSString *strImgPath;
        if(mediaType == 0)
        {
            strImgPath = [NSString stringWithFormat:@"%@",[[[GC arrPreviews] firstObject] valueForKey:@"Path"]];
            self.playButn.hidden=TRUE;
        }
        else
        {
            strImgPath = [NSString stringWithFormat:@"%@",[[[GC arrPreviews] firstObject] valueForKey:@"ThumbPath"]];
            self.playButn.hidden=FALSE;
        }
        
        
        //@"icon_fest_ghost1"
        [imgViewCover sd_setImageWithURL:URL(strImgPath) placeholderImage:[UIImage imageNamed:@"default_fest_icon"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                imgViewCover.image = image;
            }
            else{
                imgViewCover.image = [UIImage imageNamed:@"default_fest_icon"];
            }
        }];
    }
    else
    {
        self.playButn.hidden=TRUE;
        imgViewCover.image = [UIImage imageNamed:@"default_fest_icon"];
    }
    
    lblAttending.text = [NSString stringWithFormat:@"%@ going",[[self.arrFestDetails firstObject] valueForKey:@"TotalAttending"]];
    
    
    if(self.isMyFest)
    {
        
        canEdit=YES;
        
        eventType = [[[self.arrFestDetails firstObject] valueForKey:@"Type"] intValue];
        eventHost = [[[self.arrFestDetails firstObject] valueForKey:@"IsHost"] intValue];
        
        self.refUserID = [NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKeyPath:@"User.Id"]];
        
        if([self.userModel.localID isEqualToString:self.refUserID])//Admin
        {
            btnInvite.hidden = NO;
            btnChat.hidden = NO;
            canEdit=YES;
            
            SetValue_Key(@"Admin", @"Role");
        }
        else
        {
            
           canEdit=NO;
            
            arrDB = [GlobalClass DB_Load_ByID:@"MyFest" withColName:@"festEventId" andParam:[NSString stringWithFormat:@"%ld",(long)[GC eventID]]];
            
            MyFest *myFest;
            if(arrDB.count>0)
                myFest = [arrDB firstObject];
            
            if(eventType == 1) // Public Event
            {
                btnInvite.hidden = NO;
                
                if(eventHost == 1){
                    canEdit=YES;
                    btnChat.hidden = NO;
                }
            }
            else // Private Event
            {
                if(eventHost == 1)
                {
                    canEdit=YES;
                    btnInvite.hidden = NO;
                    btnChat.hidden = NO;
                    SetValue_Key(@"Host", @"Role");
                }
                else
                {
                    btnInvite.hidden = YES;
                    SetValue_Key(@"", @"Role");
                }
            }
            
            if(myFest!=nil)
            {
                int valStatus = [myFest.festEventStatus intValue];
                
                if(valStatus == 1)
                    btnChat.hidden = NO;
                else
                {
                    
                    if([myFest.festDate timeIntervalSinceDate:[[AppDelegate getDelegate] localTime]]<=0)
                    {
                        
                        CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[AppDelegate getDelegate] delLatitude] longitude:[[AppDelegate getDelegate] delLongitude]];
                        
                        CLLocation *locB = [[CLLocation alloc] initWithLatitude:[myFest.latitude doubleValue] longitude:[myFest.longitude doubleValue]];
                        
                        CLLocationDistance distance = [locA distanceFromLocation:locB];
                        
                        distance = distance/1609.34;
                        
                        if(distance<=[myFest.festRadius floatValue])
                        {
                            myFest.festEventStatus = [NSNumber numberWithInteger:1];
                            
                            // Save everything
                            NSError *error = nil;
                            if ([myFest.managedObjectContext updatedObjects]) {
                                NSLog(@"FD-Update was successful!");
                            } else {
                                NSLog(@"FD-Update wasn't successful: %@", [error userInfo]);
                            }
                            
                            btnChat.hidden = NO;
                        }
                    }
                }
            }
            else
            {
                btnChat.hidden = NO;
            }
        }
    }
    else
    {
        canEdit=NO;
    }
    
    [GC hideLoader];
    
    //Check fest is started or not
    NSString *festDate=[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"StartDate"]];
    if(![self isExpiredDate:festDate])
    {
        btnChat.hidden = YES;
    }
   
}

#pragma mark - Animation For Layer
-(void)viewLayerAnimationRight
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[self.scrollFest layer] addAnimation:animation forKey:@"ShowNextDetails_Right"];
}

-(void)viewLayerAnimationLeft
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[self.scrollFest layer] addAnimation:animation forKey:@"ShowNextDetails_Left"];
}

#pragma mark - FB Sharing
-(void)FBSharing
{
    // Check if the Facebook app is installed and we can present the share dialog
    
    NSURL *picURL;
    
    if([GC arrPreviews].count>0)
    {
        picURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[[GC arrPreviews]firstObject] valueForKey:@"Path"]]];
    }
    else
    {
        picURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,@"no_name.png"]];
    }
    
    
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://www.apple.com/itunes/"];
    params.name = lblFestTitle.text;
    params.caption = lblFestAddress.text;
    params.picture = picURL;
    params.linkDescription = [NSString stringWithFormat:@" %@",txtViewFestDescrip.text];
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.linkDescription
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"%@",[NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                              
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       lblFestTitle.text, @"name",
                                       lblFestAddress.text, @"caption",
                                       [NSString stringWithFormat:@" %@",txtViewFestDescrip.text], @"description",
                                       @"https://www.apple.com/itunes/", @"link",
                                       [NSString stringWithFormat:@"%@",picURL], @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error)
                                                      {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"%@",[NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                      } else
                                                      {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                                  
                                                              }
                                                          }
                                                      }
                                                  }];
        
    }
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

#pragma mark - Updated Fest Event Status Request
-(void)getFestEventRequest
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,GetFest];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:myJSONData]];
    
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        
        if([self.dataRequest error])
        {
            [GC hideLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    [self showAlertView_FD:@"" message:No_Internet];
                else
                    [self showAlertView_FD:@"" message:self.dataRequest.error.localizedDescription];
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *data= [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result == 1)
            {
                [GC hideLoader];
                
                self.arrFestDetails = [NSMutableArray arrayWithObjects:[json valueForKey:@"Data"], nil];
                
                if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
                {
                    [GC setArrFest:[NSMutableArray arrayWithObjects:[self.arrFestDetails firstObject], nil]];
                    [GC setArrPreviews:[[NSMutableArray alloc] initWithArray:[[[GC arrFest] firstObject] valueForKey:@"Medias"]]];
                    [GC setEventTitle:[NSString stringWithFormat:@"%@",[[[GC arrFest] firstObject] valueForKey:@"Title"]]];
                }
                
                if(self.isMyFest  && !([GetValue_Key(@"Nav") isEqualToString:@"MyFest"]))
                    [[GC arrFest] replaceObjectAtIndex:pageIndex withObject:[self.arrFestDetails firstObject]];
                
                [self getFestDetails];
                
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlertView_FD:@"" message:strFailure];
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
            
            [self showAlertView_FD:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Update Accept or Reject Event Status Request
-(void)updateEventStatus
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)self.eventStatus] forKey:@"Status"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,UpdateEventStatus];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:myJSONData]];
    
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        
        if([self.dataRequest error])
        {
            [GC hideLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    [self showAlertView_FD:@"" message:No_Internet];
                else
                    [self showAlertView_FD:@"" message:self.dataRequest.error.localizedDescription];
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *data= [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result == 1)
            {
                [GC hideLoader];
                
                SetValue_Key(@"EventUpdated", @"EventUpdated");
                
                switch (self.eventStatus)
                {
                    case 1:// Accept
                    {
                        
                        [self performSelectorOnMainThread:@selector(saveLocal_FestDetails) withObject:nil waitUntilDone:YES];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fest Accepted" message:@"This fest has been moved to My Fest." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            
                            [alertView show];
                        });
                    }
                        
                        break;
                        
                    case 2:// Reject
                    {
                        if([GC arrFest].count == 1)
                        {
                            [self navigateToFest];
                        }
                        else
                        {
                            [[GC arrFest] removeObjectAtIndex:pageIndex];
                            
                            pageIndex = pageIndex - 1;
                            
                            [self swipeLeftOnScreen:swipeLeft];
                            
                        }
                        
                    }
                        
                        break;
                        
                    default:
                        break;
                }
                
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlertView_FD:@"" message:strFailure];
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
            
            [self showAlertView_FD:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Navigate View After Update
-(void)navigateToFest
{
    flagExit = 1;
    
    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
    {
        SetValue_Key(@"", @"Notification");
        SetValue_Key(@"", @"Invite");
        
//        SlideViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:Slide_ViewController];
//        SlideNavigationController *SlideNav;
        
        
        
        ILLog(@"self.nav.viewCo: %@", self.navigationController.viewControllers);
        
        if([GetValue_Key(@"Nav") isEqualToString:@"FindFest"])
        {
            FindFestViewController *FVC = [self.storyboard instantiateViewControllerWithIdentifier:FindFest_ViewController];
            
//            SlideNav = [[SlideNavigationController alloc] initWithRootViewController:FVC];

            
            UINavigationController *nav=self.navigationController;
            [nav popToRootViewControllerAnimated:NO];
            nav.viewControllers=@[FVC];
        }
        else
        {
            MyFestViewController *MF = [self.storyboard instantiateViewControllerWithIdentifier:MyFest_ViewController];
            
//            SlideNav = [[SlideNavigationController alloc] initWithRootViewController:MF];
            
            UINavigationController *nav=self.navigationController;
            [nav popToRootViewControllerAnimated:NO];
            nav.viewControllers=@[MF];
        }
        
        SetValue_Key(@"", @"Nav");
        
        
        
        
        
//        RESideMenu *BV = [[RESideMenu alloc] initWithContentViewController:SlideNav leftMenuViewController:SVC rightMenuViewController:nil];
//        
//        [self presentViewController:BV animated:NO completion:nil];
        
        
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Show Alert View
-(void)showAlertView_FD:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==tagAlertDelete) {
        if (buttonIndex==1) {
            [self performSelector:@selector(deleteThisFest) withObject:nil afterDelay:0.2];
        }
    }
    else if (alertView.tag==tagAlertDeleteSuccess) {
        if (buttonIndex==1) {
            [self performSelector:@selector(festDeleted:) withObject:nil afterDelay:0.2];
        }
    }
    else{
        if(buttonIndex == [alertView cancelButtonIndex])
        {
            if(!self.isMyFest)
            {
                if([GC arrFest].count == 1)
                {
                    [self navigateToFest];
                }
                else
                {
                    [[GC arrFest] removeObjectAtIndex:pageIndex];
                    
                    pageIndex = pageIndex - 1;
                    
                    [self swipeLeftOnScreen:swipeLeft];
                    
                }
            }
        }
    }
    

}

#pragma mark - NSNotification For Address Update
-(void)addressUpdateNotify:(NSNotification *)notify
{
    
    NSString *strURL = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&saddr=%@",self.strAddress,[AppDelegate getDelegate].strCurrentAddress];
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
    } else {
        NSLog(@"Can't open URL ");
    }
}

#pragma mark - Save Data to Local DB
-(void)saveLocal_FestDetails
{
    NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
    
    // Grab the Label entity
    MyFest *myFest = [NSEntityDescription insertNewObjectForEntityForName:@"MyFest" inManagedObjectContext:context];
    
    [myFest setUserId:[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKeyPath:@"User.Id"]]];
    [myFest setFestTitle:lblFestTitle.text];
    [myFest setFestLocation:[NSString stringWithFormat:@"%@,%@,%@,%@",
                             [[self.arrFestDetails firstObject] valueForKey:@"Street"],
                             [[self.arrFestDetails firstObject] valueForKey:@"City"],
                             [[self.arrFestDetails firstObject] valueForKey:@"State"],
                             [[self.arrFestDetails firstObject] valueForKey:@"Zip"]]];
    
    [myFest setLatitude:[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"Latitude"]]];
    [myFest setLongitude:[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"Longitude"]]];
    [myFest setFestEventId:[NSString stringWithFormat:@"%ld",(long)[GC eventID]]];
    [myFest setFestEventStatus:[NSNumber numberWithInteger:0]];
    [myFest setFestRadius:[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"Miles"]]];
    [myFest setPushNotification:[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"Notification"]]];
    
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *festDate = [formatter dateFromString:[NSString stringWithFormat:@"%@",[[self.arrFestDetails firstObject] valueForKey:@"StartDate"]]];
    [myFest setFestDate:festDate];
    
    // Save everything
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"Fest Accept - Saved to local data ");
    } else {
        NSLog(@"Fest Accept - Not saved to local data: %@", [error userInfo]);
    }
}

#pragma mark - Accept Event
- (IBAction)acceptEvent:(id)sender
{
    eventStatus = 1;
    
    [GC showLoader];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateEventStatus];
    });
    [self.btnInvite setTitle:@"" forState:UIControlStateNormal];
    [self.btnInvite setImage:[UIImage imageNamed:@"icon_whiteCheck"] forState:UIControlStateNormal];
    
#if 0 //reject?
    eventStatus = 2;
    
    [GC showLoader];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateEventStatus];
    });
#endif
    
}

#pragma mark - Invite to Fest
- (IBAction)invite_People:(id)sender
{
    InviteViewController *IV = [self.storyboard instantiateViewControllerWithIdentifier:Invite_ViewController];
    IV.isAdditionalInvite = YES;
    [self.navigationController pushViewController:IV animated:YES];
}

#pragma mark - Share Fest
#pragma Share Fest
- (IBAction)share_Fest:(id)sender
{
    if(isReach)
    {
        [self FBSharing];
    }
    else
    {
        [GC hideLoader];
        
        [self showAlertView_FD:@"" message:No_Internet];
    }
}

#pragma mark - Go to Fest Location
- (IBAction)goto_FestLocation:(id)sender
{
    [GC showLoader];
    
    if(isReach)
    {
        
        [[AppDelegate getDelegate] getCurrentLocation];
        [[AppDelegate getDelegate] getAddressFromLocation:[AppDelegate getDelegate].delLatitude longitude:[AppDelegate getDelegate].delLongitude];
        
    }
    else
    {
        [self showAlertView_FD:@"" message:No_Internet];
    }
}

#pragma mark - Go back
- (IBAction)goBack:(id)sender
{
    [self navigateToFest];
}

#pragma mark - Attending List
- (IBAction)goto_attendingList:(id)sender
{
    if(self.arrFestDetails.count!=0)
    {
        AttendingViewController *AL = [self.storyboard instantiateViewControllerWithIdentifier:Attending_ViewController];
        [AL setArrDetails:[NSMutableArray arrayWithObjects:self.lblFestTitle.text,self.lblFestDate.text,self.lblFestAddress.text,self.lblAttending.text,self.lbFestTime.text, nil]];
        [self.navigationController pushViewController:AL animated:YES];
        
    }
}

#pragma mark - Go to Comment
- (IBAction)goto_Comment:(id)sender
{
    CommentViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:Comment_ViewController];
    [self.navigationController pushViewController:CV animated:YES];
}

#pragma mark - Go to Chat
- (IBAction)goto_Chat:(id)sender
{
//    ChatViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:Chat_ViewController];
//    //ChatViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureFeedViewController"];
//    [self.navigationController pushViewController:CV animated:YES];
//    TEST_MODE;
//    return;
//    TEST_MODE;
    
    /*
     Users can post and view comments in a fest if they are within the fest radius.
     Users can view the posts if they are outside the fest radius, but within 50miles [no posting]
     Users wont see or be able to post in the fest if they are outside 50miles.
     */
    
    EventPostLsitVC *eventPostList = [[ILLogic storyboardNoAutolayout] instantiateViewControllerWithIdentifier:EventPostsList_VC];
    eventPostList.strTitle=lbl_header.text;
    [self.navigationController pushViewController:eventPostList animated:YES];

    
}

#pragma mark - Edit Fest
- (IBAction)btnEditClicked:(id)sender
{
    [self showEditActionSheet];
}
-(void)showEditActionSheet{
    
    if(self.isMyFest)
    {
        UIActionSheet *act=[[UIActionSheet alloc]initWithTitle:@"Do you want to" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit", @"Delete", nil];
        act.tag=tagActionEditDelete;
        [act showInView:self.view];
    }
    else
    {
        UIActionSheet *act=[[UIActionSheet alloc]initWithTitle:@"Do you want to" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
        act.tag=tagActionEditDelete;
        [act showInView:self.view];
    }
    
}
-(void)gotoEditPage{
    CreateFestViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:CreateFest_ViewController];
    CV.isEdit = YES;
    [self.navigationController pushViewController:CV animated:YES];
}

#pragma mark - Delete Fest
-(void)showDeleteAlert{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to delete this fest" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=tagAlertDelete;
    [alert show];
}
-(void)deleteThisFest
{
    DISPLAY_METHOD_NAME;
    
    ILLog(@"nav: %@", self.navigationController.viewControllers);
    

  

    NSDictionary *festDetails=[self.arrFestDetails firstObject];
    NSString *eventId=[festDetails objectForKey:@"Id"];
    NSMutableDictionary *d=[NSMutableDictionary new];
    [d setObject:eventId forKey:@"EventID"];

    dispatch_async(dispatch_get_main_queue(), ^{
        [GC showLoader:self withText:@"Processing..."];
        [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagDeleteFest andDictionary:d andDelegate:self];
    });
    

}
-(void)festDeleted:(id)st{
    DISPLAY_METHOD_NAME;
    [self showMyFests];
 
}
#pragma mark - Go to Preview
- (IBAction)goto_Preview:(id)sender
{
    if([GC arrPreviews].count == 0)
    {
        [self showAlertView_FD:@"" message:@"There are no images for this fest."];
    }
    else
    {
        PreviewViewController *PV = [self.storyboard instantiateViewControllerWithIdentifier:Preview_ViewController];
        [self.navigationController pushViewController:PV animated:YES];
    }
}
#pragma mark - Actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==tagActionEditDelete) {
        
        NSString *butnTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
        
        ILLog(@"buttonIndex: %zd", buttonIndex);
        if ([butnTitle isEqualToString:@"Edit"]) {
            ILLog(@"edit");
            [self performSelector:@selector(gotoEditPage) withObject:nil afterDelay:.2];
        }
        else if ([butnTitle isEqualToString:@"Delete"]){
            ILLog(@"delete");
            [self performSelector:@selector(showDeleteAlert) withObject:nil afterDelay:.2];
        }
        else{
            ILLog(@"cancel");
        }
        
    }
}
#pragma mark - BackendManger Delegate
-(void)backendConnectionSuccess:(BOOL)flagSuccess withResponse:(NSDictionary*)dictResponse andConnectionTag:(ConnectionTags)connectionTag{
    DISPLAY_METHOD_NAME;
    if (flagSuccess) {
        NSLog(@"delete success");
        [self festDeleted:nil];
    }
    else{
        NSLog(@"delete failed");
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
