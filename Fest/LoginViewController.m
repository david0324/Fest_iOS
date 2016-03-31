//
//  LoginViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "LoginViewController.h"
#import "FindFestViewController.h"
#import "RESideMenu.h"
#import "BaseViewController.h"
#import "SlideNavigationController.h"
#import "FindFestViewController.h"
#import "SlideViewController.h"
#import "ActivationViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LoginViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property(nonatomic,strong) MPMoviePlayerController *moviePlayerCtrl;

@end

@implementation LoginViewController

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
    
    // ask to get user's location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    

    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    //kch - [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"splashscreen", @"splashscreen")]]];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[GC user_Data_Plist_RetrievedData_Settings:@"UserModel"]];
    
    if([dic allKeys].count>1)
    {
        [GC requestAddressBookAccess];
        
        UserModel *userModel = [UserModel new];
        
        userModel.firstName = [dic objectForKey:@"firstName"];
        userModel.lastName = [dic objectForKey:@"lastName"];
        userModel.localID = [dic objectForKey:@"localID"];
        userModel.authToken = [dic objectForKey:@"authToken"];
        userModel.facebookID = [dic objectForKey:@"facebookID"];
        userModel.profileURL = [dic objectForKey:@"profileURL"];
        userModel.email = [dic objectForKey:@"email"];
        userModel.birthday = [dic objectForKey:@"birthday"];
        userModel.schooling = [dic objectForKey:@"schooling"];
        userModel.activation = [dic objectForKey:@"activation"];
        [[GC arrUserDetails] addObject:userModel];
        
        self.isActivated = [[dic objectForKey:@"activation"] integerValue];
                
        [self performSelectorOnMainThread:@selector(move_to_Fest) withObject:nil waitUntilDone:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [GC setParentVC:self];
    
    [self initMediaPlayer];
    [self.moviePlayerCtrl play];
}

-(void)viewWillAppear:(BOOL)animated
{
    [GC setParentVC:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookStateChanged) name:@"FacebookStateChange" object:nil];
    [self initMediaPlayer];
    [self.moviePlayerCtrl play];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FacebookStateChange" object:nil];
    [self.moviePlayerCtrl stop];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Init Media Player
- (void)initMediaPlayer{
    if(!self.moviePlayerCtrl){
        NSString *_strFilePath = [[NSBundle mainBundle] pathForResource:@"fest-vid" ofType:@"m4v"];
        self.moviePlayerCtrl = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:_strFilePath]];
        self.moviePlayerCtrl.controlStyle = MPMovieControlStyleNone;
        self.moviePlayerCtrl.repeatMode = MPMovieRepeatModeOne;
        CGSize _szView = self.view.frame.size;
        self.moviePlayerCtrl.view.frame = CGRectMake(0, 0, _szView.width,_szView.height);
        [self.moviePlayerCtrl setScalingMode:MPMovieScalingModeAspectFill];
        [self.moviePlayerCtrl setFullscreen:NO];
        self.moviePlayerCtrl.view.userInteractionEnabled = NO;
        [self.view addSubview:self.moviePlayerCtrl.view];
        [self.view sendSubviewToBack:self.moviePlayerCtrl.view];
        //[self.moviePlayerCtrl play];
    }
}

#pragma mark - Notification for Facebook state change
-(void)facebookStateChanged
{
    if (FBSession.activeSession.isOpen)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [GC showLoader:self withText:@"fetching data..."];
            
            [self fetchUserDataFromFB];
            
        });
    }
}

#pragma mark - Fetch User Info From Facebook
-(void)fetchUserDataFromFB
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error){
         if(!error)
         {
             
//             NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[user valueForKey:@"id"]];
             NSString *userImageURL =[FBURL([user valueForKey:@"id"]) absoluteString];
             
             self.userModel = [[UserModel alloc] init];
             
             self.userModel.facebookID = [NSString stringWithFormat:@"%@",[user valueForKey:@"id"]];
             self.userModel.firstName = [NSString stringWithFormat:@"%@",[user valueForKey:@"first_name"]];
             self.userModel.lastName = [NSString stringWithFormat:@"%@",[user valueForKey:@"last_name"]];
             self.userModel.email = [NSString stringWithFormat:@"%@",[user valueForKey:@"email"]];
             self.userModel.birthday = [NSString stringWithFormat:@"%@",[user valueForKey:@"birthday"]];
             self.userModel.schooling = [NSString stringWithFormat:@"%@",[[user valueForKeyPath:@"education.school.name"] firstObject]];
             [self.userModel.schooling componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             self.userModel.profileURL = userImageURL;
             
             [[GC arrUserDetails] addObject:self.userModel];
             
             [[AppDelegate getDelegate] getCurrentLocation];
             
             [self performSelector:@selector(loginRequest) withObject:nil];
             
         }
         else
         {
             [GC hideLoader];
             
             UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             
             [alert show];

         }
     }];
}

#pragma mark - Login Service Request
-(void)loginRequest
{
   
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:self.userModel.facebookID forKey:LoginFacebookId];
    [dic setObject:self.userModel.firstName forKey:LoginFirstName];
    [dic setObject:self.userModel.lastName forKey:LoginLastName];
    [dic setObject:self.userModel.birthday forKey:LoginDateOfBirth];
    
    NSMutableArray *arrDevice = [NSMutableArray new];
    NSMutableDictionary *dicDevices = [NSMutableDictionary new];

    if([[NSUserDefaults standardUserDefaults] stringForKey:deviceTokenKey].length>6)
        [dicDevices setObject:[[NSUserDefaults standardUserDefaults] stringForKey:deviceTokenKey] forKey:@"Udid"];
    else
        [dicDevices setObject:@"" forKey:@"Udid"];
    
    [dicDevices setObject:@"0" forKey:@"Type"];
    [arrDevice addObject:dicDevices];
    
    NSMutableArray *arrMedia = [NSMutableArray new];
    NSMutableDictionary *dicMedia = [NSMutableDictionary new];
    
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userModel.profileURL]]];
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    
    [dicMedia setObject:[data base64EncodedString] forKey:@"Path"];
    [dicMedia setObject:@"0" forKey:@"Tag"];
    [dicMedia setObject:@"0" forKey:@"Type"];
    [arrMedia addObject:dicMedia];
    
    [dic setObject:arrDevice forKey:LoginDevices];
    [dic setObject:arrMedia forKey:LoginMedias];

    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
                         
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *loginUrl=[NSString stringWithFormat:@"%@%@",IP2,LoginURL];
    NSURL *url=[NSURL URLWithString:loginUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate=self;
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"content-type" value:@"application/json"];
    [request setPostBody:[NSMutableData dataWithData:myJSONData]];
    
    [request startSynchronous];
    
    if(request)
    {
        [GC hideLoader];
        
        if([request error])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *strError = [NSString new];
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    strError =  No_Internet;
                else
                    strError = self.dataRequest.error.localizedDescription;
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:strError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            });

        }
        else if ([request responseString])
        {
            NSData *dat = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1)
            {
                
                self.userModel.authToken = [NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.AuthToken"]];
                self.userModel.localID = [NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.Id"]];
                
                self.isActivated = [[json valueForKeyPath:@"Data.Status"] integerValue];
                
                
//                DELETE_HARD_CODED;
//                TEST_MODE;
//                self.isActivated = 2;  // bypassing phone number verification [self.isActivated = 2] *******
//            
//                TEST_MODE;
//                DELETE_HARD_CODED;
                
                self.userModel.activation = [NSString stringWithFormat:@"%ld",(long)self.isActivated];
                
                [[GC arrUserDetails] replaceObjectAtIndex:0 withObject:self.userModel];
                
                [GC user_Data_Plist_SaveData_Settings];
                
                [self performSelectorOnMainThread:@selector(move_to_Fest) withObject:nil waitUntilDone:YES];
            }
            else
            {
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:strFailure delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                });
            }
        }
    }
    else
    {
        [GC hideLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:ServerError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        });
    }
}

#pragma mark - Get Activation (or) Move to Fest Home Screen
-(void)move_to_Fest
{
    //self.isActivated = 0;
    
    switch (self.isActivated) {
        case 0:
        {
            ActivationViewController *AV = [self.storyboard instantiateViewControllerWithIdentifier:Activation_ViewController];
            AV.flagCode = 0;
            [self.navigationController pushViewController:AV animated:YES];

        }
            
            break;
        case 1:
        {
            ActivationViewController *AV = [self.storyboard instantiateViewControllerWithIdentifier:Activation_ViewController];
            AV.flagCode = 1;
            [self.navigationController pushViewController:AV animated:YES];

        }
            
            break;
        case 2:
        {
            
//            
            
            
//            SlideViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:Slide_ViewController];
            FindFestViewController *FVC = [self.storyboard instantiateViewControllerWithIdentifier:FindFest_ViewController];
//            SlideNavigationController *SlideNav = [[SlideNavigationController alloc] initWithRootViewController:FVC];
            
//            RESideMenu *BV = [[RESideMenu alloc] initWithContentViewController:SlideNav leftMenuViewController:SVC rightMenuViewController:nil];
            
            TEST_MODE;
//            [self.navigationController pushViewController:BV animated:YES];
            [self.navigationController pushViewController:FVC animated:YES];
            
            TEST_MODE;

        }
            
            break;
        default:
            break;
    }
    
}

#pragma mark - Login Using Facebook
- (IBAction)facebook_login:(id)sender
{
    [GC showLoader];
    
    if(isReach)
    {
        [GC hideLoader];
        
        TEST_MODE;
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        TEST_MODE;
        
        [[AppDelegate getDelegate] openSession];
    }
    else
    {
        [GC hideLoader];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Network disconnected. Unable to login." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
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
