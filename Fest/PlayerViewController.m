//
//  PlayerViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 02/12/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "PlayerViewController.h"
#import "ContentViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController
@synthesize alMoviePlayer,defaultFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    DISPLAY_METHOD_NAME;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.view setAutoresizesSubviews:YES];

    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationPlayer) name:@"UIDeviceOrientationDidChangeNotification" object:nil];

    TASK_EXTRA;
    TEST_MODE;
    NSLog(@"[GC arrPreviews]: %@", [GC arrPreviews]);
    NSURL *url=nil;
    for(NSDictionary *d in [GC arrPreviews]){
        if ([[d objectForKey:@"Type"] integerValue]==1) {
            url=URL([d valueForKey:@"Path"]);
        }
    }
    TEST_MODE;
    TASK_EXTRA;
    
    //Custom Movie Player
    self.alMoviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    TEST_MODE;
//    [self.alMoviePlayer setContentURL:URL([[[GC arrPreviews] firstObject] valueForKey:@"Path"])];
    if (url) {
        [self.alMoviePlayer setContentURL:url];
    }

    TEST_MODE;
    
    self.alMoviePlayer.view.alpha = 1.0f;
    self.alMoviePlayer.view.autoresizesSubviews = YES;
    self.alMoviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.alMoviePlayer.delegate = self;
    [self.alMoviePlayer setFullscreen:YES];
    
    //Create the controls
    
    
    TEST_MODE;
//    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.alMoviePlayer style:ALMoviePlayerControlsStyleDefault];
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.alMoviePlayer style:ALMoviePlayerControlsStyleEmbedded];
    TEST_MODE;
    movieControls.autoresizesSubviews = YES;
    movieControls.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [movieControls setBarColor:[UIColor colorWithRed:46/255.0 green:188/255.0 blue:194/255.0 alpha:0.5]];
    [movieControls setTimeRemainingDecrements:YES];
    
    //assign controls
    [self.alMoviePlayer setControls:movieControls];
    [self.view addSubview:self.alMoviePlayer.view];
    
    [self.alMoviePlayer play];
    
    self.defaultFrame = self.view.bounds;

}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Detect Orientation
-(void)orientationPlayer
{
    
    NSInteger orientation = [[UIDevice currentDevice] orientation];
    UIWindow *_window = [[[UIApplication sharedApplication] delegate] window];
    
    switch (orientation) {
        case 1:{
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [_window setTransform:CGAffineTransformMakeRotation (0)];
            [_window setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [UIView commitAnimations];
            //NSLog(@"Portrait");
        }
            break;
        case 2:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [_window setTransform:CGAffineTransformMakeRotation (M_PI)];
            [_window setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [UIView commitAnimations];
            //NSLog(@"PortraitUpsideDown");
        }
            
            break;
        case 3:{
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [_window setTransform:CGAffineTransformMakeRotation (M_PI / 2)];
            [_window setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            [UIView commitAnimations];
            //NSLog(@"LR");
        }
            
            break;
        case 4:{
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [_window setTransform:CGAffineTransformMakeRotation (- M_PI / 2)];
            [_window setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            [UIView commitAnimations];
            //NSLog(@"LF");
            
        }
            
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark  - Movie Player Delegates
- (void)configureViewForOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat videoWidth = 0;
    CGFloat videoHeight = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        videoWidth = 700.f;
        videoHeight = 535.f;
    } else {
        videoWidth = self.view.frame.size.width;
        videoHeight = 220.f;
    }
    
    //calulate the frame on every rotation, so when we're returning from fullscreen mode we'll know where to position the movie plauyer
    self.defaultFrame = CGRectMake(self.view.frame.size.width/2 - videoWidth/2, self.view.frame.size.height/2 - videoHeight/2, videoWidth, videoHeight);
    
    //only manage the movie player frame when it's not in fullscreen. when in fullscreen, the frame is automatically managed
    if (self.alMoviePlayer.isFullscreen)
        return;
    
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    [self.alMoviePlayer setFrame:self.defaultFrame];
}

//IMPORTANT!
- (void)moviePlayerWillMoveFromWindow {
    //movie player must be readded to this view upon exiting fullscreen mode.
    if (![self.view.subviews containsObject:self.alMoviePlayer.view])
        [self.view addSubview:self.alMoviePlayer.view];
    
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    [self.alMoviePlayer setFrame:self.defaultFrame];
}

- (void)movieTimedOut {
    NSLog(@"MOVIE TIMED OUT");
}

#pragma mark - NSNotification to exit view
-(void)exitPlayer
{
    [self removeMoviePlayer];
    
    
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
-(void)exitPlayeSwipeLeft{
    DISPLAY_METHOD_NAME;
    
    NSInteger new=self.pageIndex+1;

//    if(![ILLogic checkTheEligibiltyOfShowingAnotherPageWithCurrentIndex:self.pageIndex newIndex:new])
//    {
//        if (self.pageIndex==0) {
//            //            1st one is video, so remove the player and go back,,, tap won't work on videoplayer *****
//        }
//        else{
//            ILLog(@"not eligible for a swipe");
//            return;
//        }
//    }
    
    [self removeMoviePlayer];
    
    id content =  self.contentViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [content gotoPage:new];
    }];
}
-(void)exitPlayeSwipeRight{
    DISPLAY_METHOD_NAME;
    
    NSInteger new=self.pageIndex-1;
//    if(![ILLogic checkTheEligibiltyOfShowingAnotherPageWithCurrentIndex:self.pageIndex newIndex:new])
//    {
//        if (self.pageIndex==0) {
////            1st one is video, so remove the player and go back,,, tap won't work on videoplayer *****
//        }
//        else{
//            ILLog(@"not eligible for a swipe");
//            return;
//        }
//    }
    
    
    [self removeMoviePlayer];
    
    id content =  self.contentViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [content gotoPage:new];
    }];
}
#pragma mark - MyMethods
-(void)removeMoviePlayer{
    
    [self.alMoviePlayer stop];

    if (self.alMoviePlayer.view.superview) {
        [self.alMoviePlayer.view removeFromSuperview];
    }
    self.alMoviePlayer.controls = nil;
    self.alMoviePlayer = nil;

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
