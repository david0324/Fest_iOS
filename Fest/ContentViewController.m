//
//  ContentViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "ContentViewController.h"
#import "PlayerViewController.h"
#import "PreviewViewController.h"
#import "ALMoviePlayerController.h"

@interface ContentViewController ()
{
    int selectedIndex;
}
@end

@implementation ContentViewController
@synthesize imgViewCover,movieController,btnPlay;

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
    
    
    
//    [[AppDelegate getDelegate] changeStatusbarColor];
    
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.view setAutoresizesSubviews:YES];
    
    imgViewCover = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.imgViewCover setAutoresizesSubviews:YES];
    self.imgViewCover.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.imgViewCover.contentMode=UIViewContentModeScaleAspectFit;
    [self.imgViewCover setClipsToBounds:YES];
    
    TEST_MODE;
    
    TASK_LISTED;
    /*
     Be able to select a picture and view it full screen. Remove Blank space
     
     so i implemented zoom feature, for that i need a scrollview
     */
    TASK_LISTED;
    
    UIScrollView *sc=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    sc.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    sc.scrollEnabled = NO;
    sc.minimumZoomScale = 1.0;
    sc.maximumZoomScale = 3.0;
    sc.delegate=self;
    [sc addSubview:imgViewCover];
    
    self.scroll=sc;
    [self.view addSubview:self.scroll];
    TEST_MODE;
    
    
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitPreview:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
 
    
    int mediaType = [[[[GC arrPreviews] objectAtIndex:selectedIndex] valueForKey:@"Type"] intValue];
    if(mediaType == 0)
    {
        
    }
    else
    {
        [self performSelector:@selector(goto_PlayerView) withObject:self afterDelay:0.1];
    }

}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return imgViewCover;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self.scroll setFrame:self.view.bounds];
    [imgViewCover setFrame:self.view.bounds];
} 
-(void)viewDidDisappear:(BOOL)animated
{
//    imgViewCover = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dummy


#pragma mark - Get Image
-(void)imageProcessing:(NSUInteger)index
{
    selectedIndex=index;
    
    int mediaType = [[[[GC arrPreviews] objectAtIndex:index] valueForKey:@"Type"] intValue];
    
    if(mediaType == 0)
    {
        [imgViewCover sd_setImageWithURL:URL([[[GC arrPreviews] objectAtIndex:index] valueForKey:@"Path"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
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
        
        [imgViewCover sd_setImageWithURL:URL([[[GC arrPreviews] objectAtIndex:index] valueForKey:@"ThumbPath"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound && (isReach))
            {
                [imgViewCover sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon-fest_ghost1"] options:SDWebImageRetryFailed];
            }
            else
            {
                imgViewCover.image = image;
                btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
                btnPlay.frame = CGRectMake(0, 0, 40, 40);
                btnPlay.layer.cornerRadius = 40/2;
                btnPlay.frame = ALIGHN_SUBVIEW_CENTER(btnPlay, self.view);
                btnPlay.autoresizesSubviews = YES;
                btnPlay.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
                
                [btnPlay setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
                [btnPlay addTarget:self action:@selector(goto_PlayerView) forControlEvents:UIControlEventTouchUpInside];
                [self.view insertSubview:btnPlay aboveSubview:imgViewCover];
               
            }
        }];
    }
}

#pragma mark - Go to Player View Controller
-(void)goto_PlayerView
{
    PlayerViewController *PVC = [self.storyboard instantiateViewControllerWithIdentifier:Player_ViewController];
    PVC.contentViewController=self;
    PVC.pageIndex=_pageIndex;
    [self.navigationController presentViewController:PVC animated:NO completion:nil];
}
-(void)gotoPage:(NSInteger)index{
    
    ILLog(@"pageIndex: %zd", _pageIndex);
    ILLog(@"index: %zd", index);

    
    UIPageViewControllerNavigationDirection direction=UIPageViewControllerNavigationDirectionForward;
    
    if (index>_pageIndex) {
        direction=UIPageViewControllerNavigationDirectionForward;
    }
    else{
        direction=UIPageViewControllerNavigationDirectionReverse;
    }
    
    if ([ILLogic checkTheEligibiltyOfShowingAnotherPageWithCurrentIndex:_pageIndex newIndex:index]) {
        [self.previewViewController goToPageWithIndex:index withDirection:direction];
    }
    else{
        ILLog(@"crieria faild !!!");
    }
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Exit View
-(void)exitPreview:(UITapGestureRecognizer *)gest
{
    if(gest.state == UIGestureRecognizerStateEnded)
    {
        imgViewCover = nil;
        btnPlay = nil;
        [self.delegate func_Exit];
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
