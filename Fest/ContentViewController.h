//
//  ContentViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSData+Base64.h"

@class PreviewViewController;
@class ALMoviePlayerController;

@protocol PreviewDelegate <NSObject>

-(void)func_Exit;

@end

@interface ContentViewController : FestParentViewController<UIScrollViewDelegate>
{
    UITapGestureRecognizer *tap;
    
}

@property BOOL flagVideo;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewCover;
@property (nonatomic,strong) MPMoviePlayerViewController *movieController;
@property (nonatomic,strong) UIButton *btnPlay;
@property (nonatomic,strong) id<PreviewDelegate>delegate;
@property (nonatomic, retain)UIScrollView *scroll;
@property (nonatomic, weak) PreviewViewController *previewViewController;
@property (nonatomic,strong) ALMoviePlayerController *alMoviePlayer;

@property NSUInteger pageIndex;

-(void)imageProcessing:(NSUInteger)index;
-(void)goto_PlayerView;
-(void)gotoPage:(NSInteger)index;


@end
