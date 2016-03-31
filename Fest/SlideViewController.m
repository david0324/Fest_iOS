//
//  SlideViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 17/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "SlideViewController.h"
#import "FindFestViewController.h"
#import "ProfileViewController.h"
#import "CreateFestViewController.h"
#import "MyFestViewController.h"
#import "LoginViewController.h"
#import "HomeNavigationController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "CellSlide.h"
//#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"

@interface SlideViewController ()

@end

@implementation SlideViewController
@synthesize tableSlide,arrMenu,arrIcons;

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
    
    self.tableSlide.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"icon_slider_bg", @"icon_slider_bg")]]];
    
    arrMenu=[NSMutableArray arrayWithObjects:@"Find a Fest",@"My Fests",@"Create a Fest",@"My Profile",@"About",@"Help",@"Sign Out", nil];
    
    arrIcons=[NSMutableArray arrayWithObjects:@"icon_menuFind",@"icon_menuMyFest",@"icon_menuLoc",@"icon_menuMyProfile",@"icon_menuAbout",@"icon_menuhelp",@"icon_menuSignout", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Status Bar Color Change
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMenu.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellSlide *cellSlide = [tableView dequeueReusableCellWithIdentifier:CellSlide_ID];
    
    cellSlide.lblMenuTitle.font=[UIFont fontWithName:LatoBold size:18];
    cellSlide.lblMenuTitle.text=[arrMenu objectAtIndex:indexPath.row];
    
    cellSlide.imgViewMenu.image=[UIImage imageNamed:[arrIcons objectAtIndex:indexPath.row]];
    
    return cellSlide;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:FindFest_ViewController]] animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
                
            });
            
        }
            
            break;
        case 1:{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:MyFest_ViewController]] animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
                
            });
        }
            
            break;
        case 2:{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CreateFestViewController *CF = [self.storyboard instantiateViewControllerWithIdentifier:CreateFest_ViewController];
                CF.isEdit = NO;
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:CF] animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
                
            });
        }
            
            break;
        case 3:{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:Profile_ViewController]] animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
            });
            
        }
            
            break;
        case 4:{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:About_ViewController]] animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
            });
        }
            
            break;
        case 5:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:Help_ViewController]] animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
                
            });

        }
            
            break;
        case 6:{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Do you want to quit the application?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertView show];
            
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        //[[FBSession activeSession] closeAndClearTokenInformation];
        [FBSession.activeSession closeAndClearTokenInformation];
        //[FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        
        [[[AppDelegate getDelegate] locationManager] stopUpdatingLocation];
        
        [GlobalClass DB_Delete];
        
        [GC remove_User_Data_From_Plist];
        
        LoginViewController *homePage=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:Login_ViewController];
        HomeNavigationController *homeNav=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:Home_NavigationController];
        [homeNav setViewControllers:@[homePage]];
        [[AppDelegate getDelegate].window setRootViewController:homeNav];
        [[AppDelegate getDelegate].window makeKeyAndVisible];
        
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
