//
//  CommentViewController.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 13/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "NSData+Base64.h"
#import "UserModel.h"

@class ASIFormDataRequest;

@interface CommentViewController : FestParentViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSInteger refCount;
}

@property (weak, nonatomic) IBOutlet UIView *view_header;
@property (weak, nonatomic) IBOutlet UILabel *lbl_header;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover;
@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleComment;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleLikes;
@property (weak, nonatomic) IBOutlet UILabel *lblLikesValue;
@property (weak, nonatomic) IBOutlet UITableView *tableComments;
@property (weak, nonatomic) IBOutlet UIButton *btnPreview;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;

@property (nonatomic,assign) BOOL isLike;
@property (nonatomic,strong) UITextField *txtComment;
@property (nonatomic,strong) UIView *viewComment;
@property (nonatomic,strong) UIButton *btnPost;
@property (nonatomic,strong) NSMutableArray *arrComments;
@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;

- (IBAction)goBack:(id)sender;
- (IBAction)addComment:(id)sender;
- (IBAction)hitLike:(id)sender;
- (IBAction)previewImage:(id)sender;

@end
