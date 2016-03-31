//
//  PlayerViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 02/12/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALMoviePlayerController.h"
@class ContentViewController;
@interface PlayerViewController : FestParentViewController<ALMoviePlayerControllerDelegate>

@property (nonatomic, weak) ContentViewController *contentViewController;
@property (nonatomic,strong) ALMoviePlayerController *alMoviePlayer;
@property (nonatomic) CGRect defaultFrame;
@property NSInteger pageIndex;

@end
