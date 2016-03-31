//
//  NavPushController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 01/12/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "NavPushController.h"
#import "ChatViewController.h"
#import "FestDetailViewController.h"
#import "CommentViewController.h"

@interface NavPushController ()

@end

@implementation NavPushController

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
    
    if([GetValue_Key(@"Nav") isEqualToString:@"MyFest"])
    {
        if([GetValue_Key(@"isChat") isEqualToString:@"1"]){
            ChatViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:Chat_ViewController];
            [self pushViewController:CV animated:YES];
            
            SetValue_Key(@"0", @"isChat");
        }
        
        if([GetValue_Key(@"isComment") isEqualToString:@"1"])
        {
            CommentViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:Comment_ViewController];
            [self pushViewController:CV animated:YES];
            
            SetValue_Key(@"0", @"isComment");
        }
    }
    else if ([GetValue_Key(@"Nav") isEqualToString:@"FindFest"])
    {
        FestDetailViewController *FD = [self.storyboard instantiateViewControllerWithIdentifier:FestDetail_ViewController];
        if([GetValue_Key(@"GeoFence") isEqualToString:@"GeoFence"])
            FD.isMyFest = YES;
        else
            FD.isMyFest = NO;
        
        SetValue_Key(@"", @"GeoFence");
        
        [self pushViewController:FD animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
