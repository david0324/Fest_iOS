//
//  FestWebViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 22/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "FestWebViewController.h"

@interface FestWebViewController ()

@end

@implementation FestWebViewController

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
    
    [self.view_header setBackgroundColor:[UIColor whiteColor]];
    
    //[self.view_header bringSubviewToFront:self.btnBack];
    
    [GC setParentVC:self];
    
    [GC showLoader];
    
    if(isReach)
    {
        [self loadSocialMedia];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:No_Internet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)loadSocialMedia
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",GetValue_Key(@"FollowURL")]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.festWebView.scalesPageToFit=YES;
    [self.festWebView loadRequest:requestObj];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [GC hideLoader];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(error)
        NSLog(@"WebView Error-%@",error.localizedDescription);
}

#pragma mark - Go Back
- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
