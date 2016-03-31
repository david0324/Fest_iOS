//
//  AddEventPostVC.h
//  Fest
//
//  Created by Denow Cleetus on 18/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventPostLsitVC;

@interface AddEventPostVC : FestParentViewController<UITextViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewTopbar;
@property (nonatomic, retain) NSDictionary *dictFestDetails;
@property (strong, nonatomic) IBOutlet UITextView *txtViewStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnPost;
@property (strong, nonatomic) IBOutlet UIButton *btnUpload;
@property (strong, nonatomic) IBOutlet UIImageView *imgVThumb;
@property (strong, nonatomic) IBOutlet UIImageView *imgVVidId;
@property (strong, nonatomic) IBOutlet UILabel *lblUpload;

@property TagUpload tagUploading;

@property (nonatomic, retain)NSData *dataUpload;
@property (nonatomic, retain)NSData *dataThumb;
@property (nonatomic, retain)NSString *videoExtension;
@property (nonatomic, retain)NSString *resolutionImgOrVid;
@property (nonatomic, weak) EventPostLsitVC *obEventList;

@end
