//
//  PreviewViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
#import "ContentViewController.h"

@interface PreviewViewController : FestParentViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,PreviewDelegate>

@property (nonatomic,strong) PageViewController *pageViewController;
@property (nonatomic,strong) ContentViewController *contentViewController;

- (void)goToPageWithIndex:(NSInteger)index withDirection:(UIPageViewControllerNavigationDirection)direction;

@end
