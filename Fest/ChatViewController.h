//
//  ChatViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 28/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+Base64.h"
#import "ASIFormDataRequest.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "PictureFeedCell.h"

@class ASIFormDataRequest;

@interface ChatViewController : FestParentViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    CGFloat refHeight;
    int flagMedia,flagExit;
    NSInteger refCount;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover;
//@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
//@property (weak, nonatomic) IBOutlet UIView *viewCenter;
//@property (weak, nonatomic) IBOutlet UIButton *btnRight;
//@property (weak, nonatomic) IBOutlet UIView *viewTrans;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
//@property (weak, nonatomic) IBOutlet UIImageView *imgViewUserProfile;
//@property (nonatomic,weak) IBOutlet UITableView *tableChat;
@property (nonatomic,strong) UIView *viewBottom;
//@property (nonatomic,strong) UITextView *txtViewChat;
@property (nonatomic,strong) UIButton *btnCamera;
//@property (nonatomic,strong) UIButton *btnChat;
@property (strong, nonatomic) IBOutlet UITableView *tableViewFeed;

@property (nonatomic,assign) BOOL isVideo,isCamera;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSMutableArray *arrChat,*arrImages,*arrChatId, *imageArray;
@property (nonatomic,strong) NSMutableDictionary *dicFrame;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSString *strMediaURL,*strCoverURL,*strMediaType,*strChatType;
@property (nonatomic,strong) NSData *dataImage,*dataVideo;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;



- (IBAction)goBack:(id)sender;
- (IBAction)leftImageView:(id)sender;
- (IBAction)rightImageView:(id)sender;
- (IBAction)goto_Comments:(id)sender;

@end
