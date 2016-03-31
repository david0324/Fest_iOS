//
//  FestParentViewController.m
//  Fest
//
//  Created by Denow Cleetus on 12/05/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "FestParentViewController.h"
#import "CreateFestViewController.h"

@interface FestParentViewController ()

@end

@implementation FestParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{

}

#pragma mark - TextViewAndTextFiled Delegates
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [ILLogic enableAutoCorrectionForTextFieldAndTextView:textView];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [ILLogic enableAutoCorrectionForTextFieldAndTextView:textField];
    return YES;
}

#pragma mark - MyMethods 
- (void)presentLeftMenuViewController:(id)sender
{
    NSLog(@"self: %@", self);
    
    NSArray *images = @[
                        [UIImage imageNamed:@"icon_menuMyProfile"],
                        [UIImage imageNamed:@"icon_menuFind"],
                        [UIImage imageNamed:@"icon_menuLoc"],
                        [UIImage imageNamed:@"icon_menuMyFest"],
                        [UIImage imageNamed:@"icon_menuAbout"],
                        [UIImage imageNamed:@"icon_menuhelp"],
                        [UIImage imageNamed:@"icon_menuSignout"],
                        ];
    NSArray *colors = @[
                        COLOR_TEAL,
                        COLOR_TEAL,
                        COLOR_TEAL,
                        COLOR_TEAL,
                        COLOR_TEAL,
                        COLOR_TEAL,
                        COLOR_TEAL,
                        ];
    
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndex:[APPDELEGATE selectedIndexMenu]];
    
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:set borderColors:colors];
    callout.delegate = self;
    [callout show];
}
-(UIViewController*)getCorrespondingController:(NSInteger)index{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    UIViewController *contr=[self.storyboard instantiateViewControllerWithIdentifier:FindFest_ViewController];
    switch (index) {
        case 0:{
            contr=[self.storyboard instantiateViewControllerWithIdentifier:Profile_ViewController];
        }
            
            break;
        case 1:{
            contr=[self.storyboard instantiateViewControllerWithIdentifier:FindFest_ViewController];
        }
            
            break;
        case 2:{
            contr=[self.storyboard instantiateViewControllerWithIdentifier:MyFest_ViewController];
        }
            
            break;
        case 3:{
            CreateFestViewController *CF = [self.storyboard instantiateViewControllerWithIdentifier:CreateFest_ViewController];
            CF.isEdit = NO;
            contr=CF;
        }
            
            break;
        case 4:{
            contr=[self.storyboard instantiateViewControllerWithIdentifier:About_ViewController];
        }
            
            break;
        case 5:
        {
            contr=[self.storyboard instantiateViewControllerWithIdentifier:Help_ViewController];
        }
            
            break;
        case 6:{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Do you want to quit the application?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alertView.tag=tagAlertSignout;
            [alertView show];
            
        }
            
            break;
            
        default:
            break;
    }
    return contr;
}
-(void)showAlertView_CF:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}
#pragma mark - RNFrostedSidebarDelegates
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index{
    DISPLAY_METHOD_NAME;
    ILLog(@"index: %zd", index);
    [sidebar dismissAnimated:YES completion:^(BOOL finished) {
        
        
        
    }];
    
    ILLog(@"self.nav: %@", self.navigationController);
    ILLog(@"self.nav.viewContr: %@", self.navigationController.viewControllers);
    
    
    if (index==6) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Do you want to quit the application?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alertView.tag=tagAlertSignout;
        [alertView show];
        
    }
    else{
        UIViewController *contr=[self getCorrespondingController:index];
        
        UINavigationController *existing=self.navigationController;
        [existing popToRootViewControllerAnimated:NO];
        existing.viewControllers=@[contr];
        [APPDELEGATE setSelectedIndexMenu:index];
    }
    
    
}


#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DISPLAY_METHOD_NAME;
    if(buttonIndex == 1 && alertView.tag==tagAlertSignout)
    {
        //[[FBSession activeSession] closeAndClearTokenInformation];
        [FBSession.activeSession closeAndClearTokenInformation];
        //[FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        
        [[[AppDelegate getDelegate] locationManager] stopUpdatingLocation];
        
        [GlobalClass DB_Delete];
        
        [GC remove_User_Data_From_Plist];
        
        UIViewController *homePage=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:Login_ViewController];
        UINavigationController *homeNav=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:Home_NavigationController];
        [homeNav setViewControllers:@[homePage]];
        [[AppDelegate getDelegate].window setRootViewController:homeNav];
        [[AppDelegate getDelegate].window makeKeyAndVisible];
        
        [APPDELEGATE setSelectedIndexMenu:1];
        
        [APPDELEGATE clearAllGeofences];
    }
}
-(BOOL)isExpiredDate:(NSString *)eventDate
{
    NSString * dateString = [NSString stringWithFormat: @"%@",eventDate];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate* endDate = [dateFormatter dateFromString:dateString];

    
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [endDate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}
-(NSDate *)toLocalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: [NSDate date]];
    return [NSDate dateWithTimeInterval: seconds sinceDate: [NSDate date]];
}
@end
