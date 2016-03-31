//
//  ChatImageViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 17/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "ChatImageViewController.h"
#import "ALMoviePlayerController.h"

@interface ChatImageViewController ()<ALMoviePlayerControllerDelegate>

@property (nonatomic,strong) ALMoviePlayerController *alMoviePlayer;
@property (nonatomic) CGRect defaultFrame;

@end

@implementation ChatImageViewController
@synthesize imgViewCover,movieController,alMoviePlayer,defaultFrame;

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
    
    [self.view setAutoresizesSubviews:YES];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitImagePreview:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    self.imgViewCover = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imgViewCover.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.imgViewCover setAutoresizesSubviews:YES];
    self.imgViewCover.contentMode=UIViewContentModeScaleAspectFit;
    [self.imgViewCover setClipsToBounds:YES];
    
    [self.view addSubview:imgViewCover];
    
    int mediaType = [GetValue_Key(@"MediaType") intValue];
    
    if(mediaType == 0)
    {
        [imgViewCover sd_setImageWithURL:URL(GetValue_Key(@"ImageChat")) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound && (isReach))
            {
                [imgViewCover sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon-fest_ghost1"] options:SDWebImageRetryFailed];
            }
            else
            {
                imgViewCover.image = image;
            }
        }];
    }
    else
    {
        
        //Custom Movie Player
        self.alMoviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.alMoviePlayer setContentURL:URL(GetValue_Key(@"ChatVideo"))];
        self.alMoviePlayer.view.alpha = 1.0f;
        self.alMoviePlayer.view.autoresizesSubviews = YES;
        self.alMoviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.alMoviePlayer.delegate = self;
        [self.alMoviePlayer setFullscreen:YES];
        
        //Create the controls
        ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.alMoviePlayer style:ALMoviePlayerControlsStyleDefault];
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
}

-(void)moviePlaybackDidFinish:(NSNotification *)notify
{
    NSLog(@"Video Finished");
    [movieController.moviePlayer prepareToPlay];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientation_ChatPreview) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
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

#pragma mark  - Movie Player Delegates
-(void)exitPlayer
{
    [self tiltWindow_Chat];
    
    [self.alMoviePlayer.view removeFromSuperview];
    self.alMoviePlayer = nil;
    imgViewCover = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

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

#pragma mark - Gesture Delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Detect Orientation
-(void)orientation_ChatPreview
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

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Tilt Window
-(void)tiltWindow_Chat
{
    UIWindow *_window = [[[UIApplication sharedApplication] delegate] window];
    [_window setTransform:CGAffineTransformMakeRotation (0)];
    [_window setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - Exit Preview
-(void)exitImagePreview:(UITapGestureRecognizer *)gest
{
    if(gest.state == UIGestureRecognizerStateEnded)
    {
        [self tiltWindow_Chat];
        
        imgViewCover = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
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
