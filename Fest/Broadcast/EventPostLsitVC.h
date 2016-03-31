//
//  EventPostLsitVC.h
//  Fest
//
//  Created by Denow Cleetus on 17/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventPostLsitVC : FestParentViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>


@property (nonatomic, retain) NSString *strTitle;

@property(nonatomic, retain) NSMutableArray *arrTableview;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *viewTopbar;

@property(nonatomic, retain) NSDictionary *dictFestDetails;

@property(nonatomic, retain) NSMutableArray *arryCells;

@property BOOL enablePost;

@property BOOL reload;

@property (strong, nonatomic) IBOutlet UIButton *btnUpload;

@property (strong, nonatomic) IBOutlet UIView *viewUploadBg;



@property TagUpload tagUploading;
@property (nonatomic, retain)NSData *dataUpload;
@property (nonatomic, retain)NSData *dataThumb;
@property (nonatomic, retain)NSString *videoExtension;
@property (nonatomic, retain)NSString *resolutionImgOrVid;




-(void)getFestEventPosts;

- (IBAction)btnUploadClicked:(id)sender;


@end
