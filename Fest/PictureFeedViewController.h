//
//  PictureFeedViewController.h
//  Fest
//
//  Created by J.P.  on 2/25/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "UserModel.h"
#import "NSData+Base64.h"
#import "PictureFeedCell.h"
#import "FestDetailViewController.h"

@class ASIFormDataRequest;

@interface PictureFeedViewController : FestParentViewController <UITableViewDataSource, UITableViewDelegate>

{
    NSInteger refCount;
}

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *labelHeader;
@property (strong, nonatomic) IBOutlet UIButton *buttonMenu;
@property (strong, nonatomic) IBOutlet UITableView *feedTableView;


@property (nonatomic,strong) NSString *strMediaURL,*strCoverURL,*strMediaType,*strChatType;
@property (nonatomic,strong) NSMutableArray *arrChat ,*arrChatId;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) ASIHTTPRequest *dataRequest;
@property (nonatomic,strong) UserModel *userModel;

- (IBAction)goBack:(id)sender;

@end
