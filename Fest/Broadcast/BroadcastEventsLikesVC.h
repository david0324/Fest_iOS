//
//  BroadcastEventsLikesVC.h
//  Fest
//
//  Created by Denow Cleetus on 19/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BroadcastEventsLikesVC : FestParentViewController<UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, retain)NSDictionary *dictPostDetails;
@property(nonatomic, retain)NSMutableArray *arrTableView;
@property(nonatomic, retain)IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewTopbar;

@end
