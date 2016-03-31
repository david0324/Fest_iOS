//
//  PreviewViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController
@synthesize pageViewController,contentViewController;

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
    // Do any additional setup after loading the view..
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.view setAutoresizesSubviews:YES];
    self.view.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:Page_ViewController];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate=self;
    self.pageViewController.view.backgroundColor=[UIColor clearColor];
    self.pageViewController.view.frame = self.view.bounds;
    [self.pageViewController.view setAutoresizesSubviews:YES];
    self.pageViewController.view.center = self.view.center;
    self.pageViewController.view.clipsToBounds = YES;
    self.pageViewController.view.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:Content_ViewController];
    contentViewController.view.frame=self.pageViewController.view.bounds;
    contentViewController.view.center=self.pageViewController.view.center;
    contentViewController.delegate=self;
    contentViewController.pageIndex = 0;
    [contentViewController imageProcessing:0];
    
    TEST_MODE;
    contentViewController.previewViewController=self; // here only we are setting initial controller for pageviewcontroller, so need to set here also ****
    TEST_MODE;
    
    [self setVideoFlag:contentViewController andIndex:0];
    NSArray *arrViewControllers = @[contentViewController];
    [self.pageViewController setViewControllers:arrViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationRP) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    
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
#pragma mark - MyMethods
- (void)goToPageWithIndex:(NSInteger)index withDirection:(UIPageViewControllerNavigationDirection)direction{
   
    DISPLAY_METHOD_NAME;
    // Instead get the view controller of the first page
    id page = [self viewControllerAtIndex:index];
    NSArray *initialViewControllers = [NSArray arrayWithObject:page];
    
    // Do the setViewControllers: again but this time use direction animation:
    [self.pageViewController setViewControllers:initialViewControllers direction:direction animated:YES completion:nil];
}

#pragma mark - PageViewDelegates
-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    UIViewController *VC=[self viewControllerAtIndex:index];
    
    return VC;
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((ContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [[GC arrPreviews] count]) {
        return nil;
    }
    
    UIViewController *VC=[self viewControllerAtIndex:index];
    
    return VC;
    
}

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    if (([[GC arrPreviews] count] == 0) || (index >= [[GC arrPreviews] count])) {
        return nil;
    }
    
    


    
    
    
    
    // Create a new view controller and pass suitable data.
    ContentViewController *ContentView = [self.storyboard instantiateViewControllerWithIdentifier:Content_ViewController];
    ContentView.view.center=self.pageViewController.view.center;
    ContentView.pageIndex = index;
    ContentView.delegate=self;
    ContentView.previewViewController=self;
    [ContentView imageProcessing:index];
    
    [self setVideoFlag:ContentView andIndex:index];
    return ContentView;
    
}
-(void)setVideoFlag:(ContentViewController*)cont andIndex:(NSInteger)index{
    cont.flagVideo=NO;
    NSDictionary *d=[[GC arrPreviews] objectAtIndex:index];
    if ([[d objectForKey:@"Type"] integerValue]==1) {
        cont.flagVideo=YES;
    }
    
}
- (void)pageViewController:(UIPageViewController *)pageViewControll didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        TASK_LISTED;
        /*
         On the main fest page, we would like the videos to automatically play. Autoplay a video
         while scrolling
         */
        ContentViewController *cont=[pageViewControll.viewControllers lastObject];
        if (cont.flagVideo) {
            [cont goto_PlayerView];
        }
        TASK_LISTED;
    }
}

#pragma mark - Detect Orientation
-(void)orientationRP
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
-(void)tiltWindow
{
    UIWindow *_window = [[[UIApplication sharedApplication] delegate] window];
    [_window setTransform:CGAffineTransformMakeRotation (0)];
    [_window setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - Go Back
-(void)func_Exit
{
    [self tiltWindow];
    
    [self.pageViewController removeFromParentViewController];
    [self.pageViewController.view removeFromSuperview];
    
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
