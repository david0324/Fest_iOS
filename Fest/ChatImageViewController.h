//
//  ChatImageViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 17/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>


@interface ChatImageViewController : FestParentViewController<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *tap;
}

@property (nonatomic,strong)  UIImageView *imgViewCover;
@property (nonatomic,strong) MPMoviePlayerViewController *movieController;

@end
