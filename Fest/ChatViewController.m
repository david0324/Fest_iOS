//
//  ChatViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 28/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "ChatViewController.h"
#import "CommentViewController.h"
#import "ProfileViewController.h"
#import "ChatImageViewController.h"
#import "FestDetailViewController.h"
#import "CellChatEven.h"
#import "CellChatOdd.h"

#define KeyH(val) [NSString stringWithFormat:@"H-%ld",(long)val]
#define KeyW(val) [NSString stringWithFormat:@"W-%ld",(long)val]
#define KeyImageFrame(val) [NSString stringWithFormat:@"Image-%ld",(long)val]

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize view_header,lbl_header,imgViewCover,lblUserName,arrChat,arrImages,index,isVideo,isCamera,viewBottom,btnCamera,dicFrame,strMediaURL,strCoverURL,strChatType,strMediaType,arrChatId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define TBLY 230 + 24

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    
    //[self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    lbl_header.font = [UIFont fontWithName:LatoRegular size:18.0];
    //lblUserName.font = [UIFont fontWithName:ProximaNovaSemibold size:15.0];
    
    refCount = 0;
    dicFrame = [NSMutableDictionary new];
    isVideo = NO;
    strMediaType = [NSString new];
    strChatType = [NSString new];
    
    strMediaType = @"0";
    strChatType = @"0";
    
    flagExit = 0;
    
    arrChat = [NSMutableArray new];
    arrChatId = [NSMutableArray new];
    strMediaURL = [NSString new];
    strCoverURL = [NSString new];
    arrImages = [NSMutableArray new];
    self.userModel = [[GC arrUserDetails] firstObject];
    
    //self.tableChat=[[UITableView alloc]initWithFrame:CGRectMake(0, TBLY, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - TBLY)];
    //self.tableChat.delegate=self;
    //self.tableChat.dataSource=self;
    //self.tableChat.backgroundColor=[UIColor whiteColor];
    
    
    /*self.tableChat.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableChat.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableChat.separatorColor=[UIColor clearColor];
    self.tableChat.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableChat.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableChat.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableChat.estimatedRowHeight = 100;
    self.tableChat.rowHeight = UITableViewAutomaticDimension;*/
    
    
    //[self.view addSubview:self.tableChat];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestChat)
                  forControlEvents:UIControlEventValueChanged];
    //[self.tableChat addSubview:self.refreshControl];
    
    viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-40), ([UIScreen mainScreen].bounds.size.width), 40)];
    viewBottom.backgroundColor = COLOR_TOOLBARCOLOR;
    
    btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCamera.frame = CGRectMake(10, 5, 30, 30);
    [btnCamera setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(captureImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewBottom addSubview:btnCamera];
    
    /*btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChat.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40), 5, 30, 30);
    [btnChat setImage:[UIImage imageNamed:@"icon_sendChat"] forState:UIControlStateNormal];
    [btnChat addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];*/
    
    //[viewBottom addSubview:btnChat];
    
    /*txtViewChat = [[UITextView alloc] initWithFrame:CGRectMake(50, 5, ([UIScreen mainScreen].bounds.size.width-100), 30)];
    txtViewChat.delegate = self;
    txtViewChat.textAlignment = NSTextAlignmentLeft;
    txtViewChat.textColor = COLOR_MAINTINTCOLOR;
    txtViewChat.autocorrectionType = UITextAutocorrectionTypeNo;
    txtViewChat.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtViewChat.font = [UIFont fontWithName:LatoRegular size:15.0];
    txtViewChat.layer.cornerRadius = 2.0;
    txtViewChat.layer.borderColor = [UIColor blackColor].CGColor;
    txtViewChat.layer.borderWidth = 0.5;
    txtViewChat.text = @"Type your message...";*/
    
    //[viewBottom addSubview:txtViewChat];
    
    //[self.view insertSubview:viewBottom aboveSubview:tableChat];
    
    self.lbl_header.text = [GC eventTitle];//[[GC eventTitle] uppercaseString];
    
    /*self.viewTrans.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.75];
    self.viewTrans.hidden = YES;
    btnLeft.hidden = YES;
    btnRight.hidden = YES;*/
    
    self.lblUserName.font = [UIFont fontWithName:LatoLight size:13.0];
    
    
    //imgViewCover.clipsToBounds = YES;
    //imgViewCover.contentMode = UIViewContentModeScaleAspectFill;
    //imgViewCover.layer.cornerRadius = 87;
    //imgViewUserProfile.clipsToBounds = YES;
    //imgViewUserProfile.contentMode = UIViewContentModeScaleAspectFill;
    
    //imgViewUserProfile.layer.cornerRadius = 30/2;
    //imgViewUserProfile.layer.masksToBounds = YES;
    //imgViewUserProfile.layer.borderWidth = 0;
    
    [GC setParentVC:self];
    
    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
    {
        self.lbl_header.text = [GC eventTitle];
        
        if([GetValue_Key(@"Reload") isEqualToString:@"Reload"])
        {
            SetValue_Key(@"", @"Reload");
            
            self.arrChat = [NSMutableArray arrayWithArray:[GC arrChat]];
            
            self.arrChatId = [NSMutableArray arrayWithArray:[GC arrChatId]];
            
            self.arrImages = [NSMutableArray arrayWithArray:[GC arrChatImages]];
            
            NSMutableArray *arrTemp = [NSMutableArray new];
            arrTemp = [NSMutableArray arrayWithObjects:GetValue_Key(@"ChatData"), nil];
            
            int valType = 0;
            
            for(long int i=0;i<arrTemp.count;i++)
            {
                NSMutableDictionary *dicTemp = [NSMutableDictionary new];
                
                valType = [[[arrTemp objectAtIndex:i] valueForKey:@"Type"] intValue];
                
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FullName"]  forKey:@"Name"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FacebookId"]  forKey:@"FacebookId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.Id"]  forKey:@"LocalId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Type"] forKey:@"Type"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"] forKey:@"ChatId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"LikeStatus"] forKey:@"LikeStatus"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"TotalLike"] forKey:@"TotalLike"];
                
                NSString *strTest = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                
                if(valType == 0 && (![strTest isEqualToString:@"<null>"]))
                {
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Message"]  forKey:@"Message"];
                    [arrChat addObject:dicTemp];
                }
                
                strMediaURL = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                
                if(valType == 1)
                {
                    [dicTemp setObject:strMediaURL forKey:@"Path"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"] forKey:@"MediaType"];
                    
                    if([[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"]intValue]==1)
                    {
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"ThumbPath"] forKey:@"ThumbPath"];
                    }
                    
                    [arrImages addObject:dicTemp];
                    
                }
                
                [arrChatId addObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"]];
            }
            
            refCount += arrTemp.count;
            
            arrTemp = nil;
            
            [self.tableViewFeed reloadData];
            
            [[GC arrChat] removeAllObjects];
            [[GC arrChatId] removeAllObjects];
            [[GC arrChatImages] removeAllObjects];
            
            [GC setArrChat:[NSMutableArray arrayWithArray:self.arrChat]];
            
            [GC setArrChatId:[NSMutableArray arrayWithArray:self.arrChatId]];
            
            [GC setArrChatImages:[NSMutableArray arrayWithArray:self.arrImages]];
            
            /*if(arrChat.count>1)
                [self.tableViewFeed scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrChat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            if(arrImages.count>0)
                [self showChatCoverImage:(arrImages.count-1)];*/
            
        }
        else
        {
            [GC showLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self getAllChat:@"0"];
                
            });
        }
    }
    else
    {
        [self loadChatData];
    }
    
    [GC showLoader];
    
    [self getAllChat:@"0"];
        
    self.imageArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < arrImages.count; i++) {
        UIImageView *iv = [[UIImageView alloc] init];
        [iv sd_setImageWithURL:URL([[arrImages objectAtIndex:i] valueForKey:@"Path"])];
        [self.imageArray addObject:iv];
        /*[iv sd_setImageWithURL:URL([[arrImages objectAtIndex:i] valueForKey:@"Path"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            int x = 0;
            if(!error)
            {
                iv.image = image;
                [self.imageArray addObject:iv];
            }
        }];*/
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    SetValue_Key(@"Chat", @"Screen");
    
    if([GetValue_Key(@"HitLike") isEqualToString:@"HitLike"])
    {
        SetValue_Key(@"", @"ChatId");
        SetValue_Key(@"", @"LikeStatus");
        SetValue_Key(@"", @"TotalLike");
        SetValue_Key(@"", @"ImageChat");
        
        [GC showLoader];
        
        refCount = 0;
        
        [arrImages removeAllObjects];
        
        [arrChat removeAllObjects];
        
        [self getAllChat:@"0"];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(flagExit == 1)
    {
        //txtViewChat = nil;
        btnCamera = nil;
        //btnChat = nil;
        viewBottom = nil;
        self.dataImage = nil;
        self.dataRequest = nil;
        arrChat = nil;
        arrImages = nil;
        arrChatId = nil;
        
        SetValue_Key(@"", @"Screen");
        
        [GC setChatID:0];
        [[GC arrChat] removeAllObjects];
        [[GC arrChatId] removeAllObjects];
        [[GC arrChatImages] removeAllObjects];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Func to Call Request
-(void)loadChatData
{
    if(isReach)
    {
        [GC showLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getAllChat:@"0"];
            
        });
    }
    else
    {
        [self showAlert_Chat:@"" message:No_Internet];
    }
}

#pragma mark - Show Chat Cover Images
/*-(void)showChatCoverImage:(NSInteger)tag
{
    if(arrImages.count>0)
    {
        index = tag;
        
        [GC setChatID:[[[arrImages objectAtIndex:index] valueForKey:@"ChatId"] integerValue]];
        
        SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"LikeStatus"], @"LikeStatus");
        SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"TotalLike"], @"TotalLike");
        
        lblUserName.text = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"Name"]];
        
        int mediaType = [[[arrImages objectAtIndex:index] valueForKey:@"MediaType"] intValue];
        
        if(mediaType == 0)
        {
            strCoverURL = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"Path"]];
            SetValue_Key(@"0", @"MediaType");
        }
        else
        {
            strCoverURL = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"ThumbPath"]];
            SetValue_Key(@"1", @"MediaType");
            SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"Path"], @"ChatVideo");
        }
        
        
        [imgViewCover sd_setImageWithURL:URL([[arrImages objectAtIndex:index] valueForKey:@"Path"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                imgViewCover.image = image;
                //self.viewTrans.hidden = NO;
            }
            
        }];
        
        [imgViewUserProfile sd_setImageWithURL:FBURL([[arrImages objectAtIndex:index] valueForKey:@"FacebookId"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                imgViewUserProfile.image = image;
            }
            
        }];
        
        if(arrImages.count>1)
        {
            btnLeft.hidden = NO;
            btnRight.hidden = NO;
        }
    }
    else
    {
        imgViewCover.image = [UIImage imageNamed:@"icon_fest_ghost1"];
        //btnLeft.hidden = YES;
        //btnRight.hidden = YES;
        //self.viewTrans.hidden = YES;
    }
}*/


#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //[self getAllChat:@"0"];
    int count  = arrImages.count;
    return [GC arrChatImages].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self getAllChat:@"0"];
    NSString *cellIdentifier = @"pictureFeedCell";
    
    PictureFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PictureFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.imageViewOfCell.clipsToBounds = YES;
    cell.imageViewOfCell.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *iv = [self.imageArray objectAtIndex:indexPath.row];
    
    cell.imageViewOfCell.image = iv.image;
    
    //cell.imageViewOfCell.image = [self.imageArray objectAtIndex:indexPath.row];

    //uiimage *iv = [self.imageArray objectAtIndex:indexPath.row]
    
    //cell.imageViewOfCell.image = iv.image;
    
    /*if(arrImages.count>0)
    {
        index = indexPath.row;
        
        //[GC setChatID:[[[arrImages objectAtIndex:index] valueForKey:@"ChatId"] integerValue]];
        
        //SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"LikeStatus"], @"LikeStatus");
        //SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"TotalLike"], @"TotalLike");
        
        lblUserName.text = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"Name"]];
        
        int mediaType = [[[arrImages objectAtIndex:index] valueForKey:@"MediaType"] intValue];
        
        if(mediaType == 0)
        {
            strCoverURL = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"Path"]];
            //SetValue_Key(@"0", @"MediaType");
        }
        else
        {
            strCoverURL = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"ThumbPath"]];
            //SetValue_Key(@"1", @"MediaType");
            //SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"Path"], @"ChatVideo");
        }
        
        
        [cell.imageViewOfCell sd_setImageWithURL:URL([[arrImages objectAtIndex:index] valueForKey:@"Path"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                cell.imageViewOfCell.image = image;
                //self.viewTrans.hidden = NO;
            }
            
        }];
    }*/
    
        /*[imgViewUserProfile sd_setImageWithURL:FBURL([[arrImages objectAtIndex:index] valueForKey:@"FacebookId"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                imgViewUserProfile.image = image;
            }
            
        }];*/
        
        /*if(arrImages.count>1)
        {
            btnLeft.hidden = NO;
            btnRight.hidden = NO;
        }*/
    //}
    /*else
    {
        cell.imageViewOfCell.image = [UIImage imageNamed:@"icon_fest_ghost1"];
        //btnLeft.hidden = YES;
        //btnRight.hidden = YES;
        //self.viewTrans.hidden = YES;
    }*/
    
    return cell;
}


    
    
    
    /*CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    NSString *strMessage = [NSString new];
    NSDictionary *_dicChat = [arrChat objectAtIndex:indexPath.row];
    NSString *type = [NSString stringWithFormat:@"%@",_dicChat[@"Type"]];
    
    if([type isEqualToString:@"1"])
    {
        
    }
    else
    {
        strMessage = [NSString stringWithFormat:@"%@",_dicChat[@"Message"]];
        
        width = [[dicFrame objectForKey:KeyW(indexPath.row)] floatValue];
        height= [[dicFrame objectForKey:KeyH(indexPath.row)] floatValue];
        
    }

    NSString *strUserId = [NSString stringWithFormat:@"%@",[[self.arrChat objectAtIndex:indexPath.row] valueForKey:@"LocalId"]];
    
    if(![strUserId isEqualToString:self.userModel.localID])
    {
        UIImageView *imgViewProfile;
        CellChatOdd *cellOdd = [tableView dequeueReusableCellWithIdentifier:CellChatOdd_ID];
        cellOdd.lbContent.text = strMessage;
        cellOdd.lbUserName.text = _dicChat[@"Name"];
        imgViewProfile = cellOdd.ivUserPorfile;
        imgViewProfile.image = [UIImage imageNamed:@"icon_chatUserPH"];
        imgViewProfile.layer.cornerRadius = 21;
        [imgViewProfile sd_setImageWithURL:FBURL([[arrChat objectAtIndex:indexPath.row] valueForKey:@"FacebookId"]) placeholderImage:[UIImage imageNamed:@"icon_chatUserPH"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
            {
                [self.tableChat reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else{
                
                imgViewProfile.image = image;
            }
        }];
        
        cellOdd.btnProfile.tag = indexPath.row;
        [cellOdd.btnProfile addTarget:self action:@selector(goto_Profile_Chat:) forControlEvents:UIControlEventTouchUpInside];*/
    
        /*UIView* viewbase = (UIView *)[cellOdd viewWithTag:10];
        [viewbase removeFromSuperview];
        
        UIView *viewContent = [[UIView alloc] init];
        viewContent.frame = CGRectMake(0, 0, cellOdd.bounds.size.width, cellOdd.bounds.size.height);
        viewContent.tag = 10;
        
        UIView *viewComment = [[UIView alloc] init];
        viewComment.frame = CGRectMake(60, 5, (width+10), height+10);
        viewComment.backgroundColor = setColor(58, 212, 196);
        viewComment.layer.cornerRadius = 3.0;
        
        if(strMessage.length>0)
        {
            UILabel *lblContent = [[UILabel alloc] init];
            lblContent.frame = CGRectMake(5, 5, width, height);
            lblContent.font = [UIFont fontWithName:ProximaNovaRegular size:13.0];
            lblContent.textColor = [UIColor whiteColor];
            lblContent.textAlignment = NSTextAlignmentRight;
            lblContent.numberOfLines = 0;
            lblContent.lineBreakMode = NSLineBreakByWordWrapping;
            lblContent.text = strMessage;
            [lblContent sizeToFit];
            [viewComment addSubview:lblContent];
            
            CGRect framelbl = lblContent.frame;
            framelbl.origin.y = (viewComment.frame.size.height - lblContent.frame.size.height)/2;
            
            lblContent.frame = framelbl;
        }
        
        imgViewProfile.frame = CGRectMake(10, 5, 40, 40);
        
        UIImageView *imgCurve = [[UIImageView alloc] initWithFrame:CGRectMake(55, 5, 8, 8)];
        imgCurve.image = [UIImage imageNamed:@"icon_curve_green"];
        
        UIButton *btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        btnProfile.frame = CGRectMake(0, 5, 60, 60);
        btnProfile.backgroundColor = [UIColor clearColor];
        btnProfile.clipsToBounds = YES;
        btnProfile.layer.cornerRadius = 40/2;
        btnProfile.layer.masksToBounds = YES;
        btnProfile.layer.borderWidth = 0;

        
        [viewContent addSubview:imgViewProfile];
        [viewContent addSubview:btnProfile];
        [viewContent addSubview:viewComment];
        [viewContent addSubview:imgCurve];
        
        [cellOdd.contentView addSubview:viewContent];*/
        
        //return cellOdd;
    //}
    /*else
    {
        CellChatEven *cellEven = [tableView dequeueReusableCellWithIdentifier:CellChatEven_ID];
        cellEven.lbContent.text = strMessage;*/
    
        /*UIView* viewbase = (UIView *)[cellEven viewWithTag:10];
        [viewbase removeFromSuperview];
        
        UIView *viewContent = [[UIView alloc] init];
        viewContent.frame = CGRectMake(0, 0, cellEven.bounds.size.width, cellEven.bounds.size.height);
        viewContent.tag = 10;
        
        UIView *viewComment = [[UIView alloc] init];
        viewComment.frame = CGRectMake((cellEven.bounds.size.width-(60+width+10)), 5, (width+10), height+10);
        viewComment.backgroundColor = setColor(228, 228, 228);
        viewComment.layer.cornerRadius = 3.0;
        
        imgViewProfile.frame = CGRectMake((cellEven.bounds.size.width-50), 5, 40, 40);
        
        UIImageView *imgCurve = [[UIImageView alloc] initWithFrame:CGRectMake((imgViewProfile.frame.origin.x-13), 5, 8, 8)];
        imgCurve.image = [UIImage imageNamed:@"icon_curve_grey"];
        
        UIButton *btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        btnProfile.frame = CGRectMake((cellEven.bounds.size.width-50), 5, 60, 60);
        btnProfile.backgroundColor = [UIColor clearColor];
        btnProfile.clipsToBounds = YES;
        btnProfile.layer.cornerRadius = 40/2;
        btnProfile.layer.masksToBounds = YES;
        btnProfile.layer.borderWidth = 0;
        btnProfile.tag = indexPath.row;
        [btnProfile addTarget:self action:@selector(goto_Profile_Chat:) forControlEvents:UIControlEventTouchUpInside];
        
        if(strMessage.length>0)
        {
            UILabel *lblContent = [[UILabel alloc] init];
            lblContent.frame = CGRectMake(5, 5, width, height);
            lblContent.font = [UIFont fontWithName:ProximaNovaRegular size:13.0];
            lblContent.textColor = [UIColor blackColor];
            lblContent.textAlignment = NSTextAlignmentLeft;
            lblContent.numberOfLines = 0;
            lblContent.lineBreakMode = NSLineBreakByWordWrapping;
            lblContent.text = strMessage;
            [lblContent sizeToFit];
            [viewComment addSubview:lblContent];
            
            CGRect framelbl = lblContent.frame;
            framelbl.origin.y = (viewComment.frame.size.height - lblContent.frame.size.height)/2;
            
            lblContent.frame = framelbl;
        }
        
        [viewContent addSubview:imgViewProfile];
        [viewContent addSubview:btnProfile];
        [viewContent addSubview:viewComment];
        [viewContent addSubview:imgCurve];
        
        [cellEven.contentView addSubview:viewContent];*/
        
        //return cellEven;
    //}
    
    //return nil;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - TextView Delegates
/*-(void)textViewDidBeginEditing:(UITextView *)textView
{
    txtViewChat = textView;
    if([txtViewChat.text isEqualToString:@"Type your message..."])
    {
        txtViewChat.text = @"";
    }
    
    [btnChat setImage:[UIImage imageNamed:@"icon_reject"] forState:UIControlStateNormal];
    
    [self moveViewsToTop:30];
}

-(void)textViewDidChange:(UITextView *)textView
{
    strChatType = @"0";
    NSInteger contentHeight = textView.contentSize.height;
    
    if([textView.text isEqualToString:@""])
    {
        [btnChat setImage:[UIImage imageNamed:@"icon_reject"] forState:UIControlStateNormal];
        
        contentHeight = 30;
        viewCenter.hidden = YES;
        tableChat.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-70-216-(contentHeight+10)));
        viewBottom.frame = CGRectMake(0, (self.view.frame.size.height-216-(contentHeight+10)), [UIScreen mainScreen].bounds.size.width, contentHeight+10);
        txtViewChat.frame = CGRectMake(50, 5, ([UIScreen mainScreen].bounds.size.width-100), 30);
        
        
        [txtViewChat sizeThatFits:CGSizeMake(220, contentHeight)];
        [txtViewChat layoutIfNeeded];
        [txtViewChat setNeedsUpdateConstraints];
        
    }
    else
    {
        [btnChat setImage:[UIImage imageNamed:@"icon_sendChat"] forState:UIControlStateNormal];
        
        CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
        
        CGFloat overflow = line.origin.y + line.size.height
        - ( textView.contentOffset.y + textView.bounds.size.height
           - textView.contentInset.bottom - textView.contentInset.top );
        
        
        if ( overflow > 0 ) {
            // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
            
            contentHeight = textView.contentSize.height;
            
            switch (contentHeight) {
                case 30:
                {
                    contentHeight = 30;
                }
                    
                    break;
                case 44:
                {
                    contentHeight = 60;
                }
                    break;
                case 58:
                {
                    contentHeight = 90;
                }
                    break;
                    
                default:
                    break;
            }
            
            [txtViewChat sizeThatFits:CGSizeMake(([UIScreen mainScreen].bounds.size.width-100), contentHeight)];
            [txtViewChat layoutIfNeeded];
            [txtViewChat setNeedsUpdateConstraints];
            
            if(txtViewChat.contentSize.height<=58)
            {
                viewCenter.hidden = YES;
                
                CGRect frame = txtViewChat.frame;
                frame.size.height += 16;
                txtViewChat.frame = frame;
                
                tableChat.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-70-216-(frame.size.height+10)));
                viewBottom.frame = CGRectMake(0, (self.view.frame.size.height-216-(frame.size.height+10)), [UIScreen mainScreen].bounds.size.width, (frame.size.height+10));
                
            }
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //Return Key Event
    if ([textView.text isEqualToString:@""] && [text isEqualToString:@""])
    {
        viewCenter.hidden = YES;
        
        if(txtViewChat.text.length>0)
        {
            
            [txtViewChat sizeThatFits:CGSizeMake(([UIScreen mainScreen].bounds.size.width-100), txtViewChat.contentSize.height)];
            [txtViewChat layoutIfNeeded];
            [txtViewChat setNeedsUpdateConstraints];
            
            CGRect frame = txtViewChat.frame;
            frame.size.height += 16;
            txtViewChat.frame = frame;
            
            tableChat.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-70-216-(frame.size.height+10)));
            viewBottom.frame = CGRectMake(0, (self.view.frame.size.height-216-(frame.size.height+10)), [UIScreen mainScreen].bounds.size.width, (frame.size.height+10));
        }else{
            
            [txtViewChat sizeThatFits:CGSizeMake(([UIScreen mainScreen].bounds.size.width-100), 30)];
            [txtViewChat layoutIfNeeded];
            [txtViewChat setNeedsUpdateConstraints];
            
            tableChat.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-70-216-(txtViewChat.frame.size.height+10)));
            viewBottom.frame = CGRectMake(0, (self.view.frame.size.height-216-(txtViewChat.frame.size.height+10)), [UIScreen mainScreen].bounds.size.width, (txtViewChat.frame.size.height+10));
            
        }
    }
    
    return YES;
}*/

#pragma mark - Go to Preview Page
/*-(void)goto_Preview_Chat
{
    ChatImageViewController *CIV = [self.storyboard instantiateViewControllerWithIdentifier:ChatImage_ViewController];
    SetValue_Key(strMediaURL, @"ImageChat");
    [self.navigationController pushViewController:CIV animated:YES];
}*/

#pragma mark - Move Views To Top
/*-(void)moveViewsToTop:(NSInteger)height
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.2];
    
    viewCenter.hidden = YES;
    tableChat.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-70-216-(height+10)));
    txtViewChat.frame = CGRectMake(50, 5, ([UIScreen mainScreen].bounds.size.width-100), 30);
    viewBottom.frame = CGRectMake(0, (self.view.frame.size.height-216-(height+10)), [UIScreen mainScreen].bounds.size.width, height+10);
    
    if(arrChat.count>1 && height == 30)
        [self.tableChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrChat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    [UIView commitAnimations];
}*/

#pragma mark - Reset Views To Original Position
/*-(void)resetView
{
    [txtViewChat resignFirstResponder];
    [btnChat setImage:[UIImage imageNamed:@"icon_sendChat"] forState:UIControlStateNormal];
    
    viewCenter.hidden = NO;
    tableChat.frame = CGRectMake(0, (TBLY), [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-TBLY));
    txtViewChat.frame = CGRectMake(50, 5, ([UIScreen mainScreen].bounds.size.width-100), 30);
    viewBottom.frame = CGRectMake(0, (self.view.frame.size.height-40), [UIScreen mainScreen].bounds.size.width, 40);
    //[tableChat reloadData];
}*/

#pragma mark - Go to Profile View
/*-(void)goto_Profile_Chat:(UIButton *)sender
{
    [self resetView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ProfileViewController *PV = [self.storyboard instantiateViewControllerWithIdentifier:Profile_ViewController];
        PV.localID = [NSString stringWithFormat:@"%@",[[self.arrChat objectAtIndex:sender.tag] valueForKey:@"LocalId"]];
        [self.navigationController pushViewController:PV animated:YES];
        
    });
    
}*/

#pragma mark - Go Back
- (IBAction)goBack:(id)sender
{
    flagExit = 1;
    
    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
    {
        FestDetailViewController *FD = [self.storyboard instantiateViewControllerWithIdentifier:FestDetail_ViewController];
        FD.isMyFest = YES;
        FD.pageIndex = 0;
        [self.navigationController pushViewController:FD animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Show Next Cover Image
/*- (IBAction)leftImageView:(id)sender
{
    //[GC showLoader];
    
    if(arrImages.count>1)
    {
        if(index == 0)
        {
            index = [arrImages count]-1;
        }
        else
        {
            index--;
        }
        
        [GC setChatID:[[[arrImages objectAtIndex:index] valueForKey:@"ChatId"] integerValue]];
        
        SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"LikeStatus"], @"LikeStatus");
        SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"TotalLike"], @"TotalLike");
        
        lblUserName.text = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"Name"]];
        
        int mediaType = [[[arrImages objectAtIndex:index] valueForKey:@"MediaType"] intValue];
        
        if(mediaType == 0)
        {
            strCoverURL = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"Path"]];
            SetValue_Key(@"0", @"MediaType");
        }
        else
        {
            strCoverURL = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"ThumbPath"]];
            SetValue_Key(@"1", @"MediaType");
            SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"Path"], @"ChatVideo");
        }
        
        
        [imgViewCover sd_setImageWithURL:URL(strCoverURL) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                imgViewCover.image = image;
            }
            
        }];
        
        [imgViewUserProfile sd_setImageWithURL:FBURL([[arrImages objectAtIndex:index] valueForKey:@"FacebookId"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                imgViewUserProfile.image = image;
            }
            
        }];
    }
}*/

/*- (IBAction)rightImageView:(id)sender
{
    
    if(arrImages.count>1)
    {
        if(index == arrImages.count-1)
        {
            index = 0;
        }
        else
        {
            index++;
        }
        
        [GC setChatID:[[[arrImages objectAtIndex:index] valueForKey:@"ChatId"] integerValue]];
        
        SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"LikeStatus"], @"LikeStatus");
        SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"TotalLike"], @"TotalLike");
        
        lblUserName.text = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"Name"]];
        int mediaType = [[[arrImages objectAtIndex:index] valueForKey:@"MediaType"] intValue];
        
        if(mediaType == 0)
        {
            strCoverURL = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"Path"]];
            SetValue_Key(@"0", @"MediaType");
        }
        else
        {
            strCoverURL = [NSString stringWithFormat:@"%@",[[arrImages objectAtIndex:index] valueForKey:@"ThumbPath"]];
            SetValue_Key(@"1", @"MediaType");
            SetValue_Key([[arrImages objectAtIndex:index] valueForKey:@"Path"], @"ChatVideo");
        }
        
        [imgViewCover sd_setImageWithURL:URL(strCoverURL) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                imgViewCover.image = image;
            }
            
        }];
        
        [imgViewUserProfile sd_setImageWithURL:FBURL([[arrImages objectAtIndex:index] valueForKey:@"FacebookId"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(!error)
            {
                imgViewUserProfile.image = image;
            }
            
        }];
    }
}*/

#pragma mark - Get Local Time & Date
-(NSDate *)localTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: [NSDate date]];
    return [NSDate dateWithTimeInterval: seconds sinceDate: [NSDate date]];
}

#pragma mark - Show Alert View
-(void)showAlert_Chat:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - Open Camera
-(void)openCamera_Chat
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *takePhoto=[[UIImagePickerController alloc] init];
        takePhoto.delegate=(id)self;
        takePhoto.allowsEditing=NO;
        takePhoto.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self addChildViewController:takePhoto];
        [takePhoto didMoveToParentViewController:self];
        [self.view addSubview:takePhoto.view];
    }
    else
    {
        [self showAlert_Chat:@"" message:No_Camera];
    }
    
}

#pragma mark - Open Gallery
-(void)openImageGallery_Chat
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self addChildViewController:picker];
        [picker didMoveToParentViewController:self];
        [self.view addSubview:picker.view];
    }
}

#pragma mark - Capture Video
-(void)captureVideo_Chat
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        isVideo = YES;
        isCamera = YES;
        UIImagePickerController *pickerVideo=[[UIImagePickerController alloc] init];
        pickerVideo.delegate=(id)self;
        pickerVideo.allowsEditing=YES;
        pickerVideo.sourceType=UIImagePickerControllerSourceTypeCamera;
        pickerVideo.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        pickerVideo.videoMaximumDuration = 60.0;
        pickerVideo.mediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
        [self addChildViewController:pickerVideo];
        [pickerVideo didMoveToParentViewController:self];
        [self.view addSubview:pickerVideo.view];
        
    }
    else
    {
        [self showAlert_Chat:@"" message:No_Internet];
    }
}

#pragma mark - Get Video From Gallery
-(void)getVideoFromGallery_Chat
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        isVideo = YES;
        isCamera = NO;
        UIImagePickerController *takeVideo=[[UIImagePickerController alloc] init];
        takeVideo.delegate=(id)self;
        takeVideo.allowsEditing=YES;
        takeVideo.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        takeVideo.mediaTypes=[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        [self addChildViewController:takeVideo];
        [takeVideo didMoveToParentViewController:self];
        [self.view addSubview:takeVideo.view];
        
    }
}

#pragma mark - Show Image & video Upload Options
-(void)uploadOptions_Chat
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Pictures Gallery",@"Take a picture",@"Take a Video",@"Video Gallery", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    isVideo = NO;
    
    switch (buttonIndex) {
        case 0:{
            
            [self openImageGallery_Chat];
        }
            
            break;
        case 1:{
            
            [self openCamera_Chat];
        }
            
            break;
            
        case 2:{
            
            [self captureVideo_Chat];
        }
            break;
            
        case 3:{
            
            [self getVideoFromGallery_Chat];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Image Picker Delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker.view removeFromSuperview];
    [picker removeFromParentViewController];
    
    __block UIImage *image = [UIImage new];
    
    strChatType = @"1";
    
    [GC showLoader];
    
    if(isReach)
    {
        if(isVideo)
        {
            NSURL *urlVideo = [info objectForKey:UIImagePickerControllerMediaURL];
            
            if(isCamera)
                UISaveVideoAtPathToSavedPhotosAlbum([urlVideo path], nil, nil, nil);
            
            AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:urlVideo options:nil];
            CMTime duration = asset1.duration;
            float videoLenght = CMTimeGetSeconds(duration);
            
            if(videoLenght>61.0)
            {
                [GC hideLoader];
                [self showAlert_Chat:@"" message:@"Video playback time should be one minute."];
            }
            else
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.dataVideo = [NSData dataWithContentsOfURL:urlVideo];
                    
                    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
                    generate1.appliesPreferredTrackTransform = YES;
                    NSError *err = NULL;
                    CMTime time = CMTimeMake(1, 2);
                    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
                    image = [[UIImage alloc] initWithCGImage:oneRef];
                    self.dataImage = UIImageJPEGRepresentation(image, 0.8);
                    
                    strMediaType = @"1";
                    
                    [self postChatRequest];
                    
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                image = [info valueForKey:UIImagePickerControllerEditedImage];
                
                if(!image){
                    image = [UIImage new];
                    image = [info valueForKey:UIImagePickerControllerOriginalImage];
                }
                
                self.dataImage = UIImageJPEGRepresentation(image,0.8);
                
                strMediaType = @"0";
                
                [self postChatRequest];
                
            });
        }
    }
    else
    {
        [GC hideLoader];
        [self showAlert_Chat:@"" message:No_Internet];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [picker.view removeFromSuperview];
        [picker removeFromParentViewController];
        
        isVideo = NO;
        
        isCamera = NO;
        
    });
}

#pragma mark - Get Latest Chat
-(void)getLatestChat
{
    [self.refreshControl endRefreshing];
    
    //[self resetView];
    
    [GC showLoader];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(arrChat.count>0)
            [self getAllChat:[NSString stringWithFormat:@"%@",[arrChatId lastObject]]];
        else
        {
            [arrChat removeAllObjects];
            
            [arrImages removeAllObjects];
            
            [self getAllChat:@"0"];
        }
    });
}

#pragma mark - Get All Chat
-(void)getAllChat:(NSString *)tag
{
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    [dicMain setObject:tag forKey:@"LastReceivedChatId"];
    
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    NSData *dataMyJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,AllChats];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest new];
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:dataMyJson]];
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        [GC hideLoader];
        
        if([self.dataRequest error])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showAlert_Chat:@"" message:self.dataRequest.error.localizedDescription];
                
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                NSMutableArray *arrTemp = [NSMutableArray new];
                arrTemp = [NSMutableArray arrayWithArray:[json valueForKeyPath:@"Data.Chats"]];
                
                SetValue_Key(@"", @"HitLike");
                
                if(refCount == arrTemp.count)
                {
                    if(arrChat.count>1)
                        //[self.tableChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrChat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                    return;
                }
                else
                {
                    int valType = 0;
                    
                    for(long int i=0;i<arrTemp.count;i++)
                    {
                        NSMutableDictionary *dicTemp = [NSMutableDictionary new];
                        
                        valType = [[[arrTemp objectAtIndex:i] valueForKey:@"Type"] intValue];
                        
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FullName"]  forKey:@"Name"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FacebookId"]  forKey:@"FacebookId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.Id"]  forKey:@"LocalId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Type"] forKey:@"Type"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"] forKey:@"ChatId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"LikeStatus"] forKey:@"LikeStatus"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"TotalLike"] forKey:@"TotalLike"];
                        
                        NSString *strTest = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                        
                        if(valType == 0 && (![strTest isEqualToString:@"<null>"]))
                        {
                            [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Message"]  forKey:@"Message"];
                            [arrChat addObject:dicTemp];
                        }
                        
                        strTest = nil;
                        
                        strMediaURL = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                        
                        if(valType == 1)
                        {
                            [dicTemp setObject:strMediaURL forKey:@"Path"];
                            [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"] forKey:@"MediaType"];
                            
                            if([[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"]intValue]==1)
                            {
                                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"ThumbPath"] forKey:@"ThumbPath"];
                            }
                            
                            [arrImages addObject:dicTemp];
                        }
                        
                        [arrChatId addObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"]];
                        
                    }
                    
                    refCount = arrTemp.count;
                    
                    arrTemp = nil;
                    
                    [GC setArrChat:[NSMutableArray arrayWithArray:self.arrChat]];
                    
                    [GC setArrChatId:[NSMutableArray arrayWithArray:self.arrChatId]];
                    
                    [GC setArrChatImages:[NSMutableArray arrayWithArray:self.arrImages]];
                    
                    [self.tableViewFeed reloadData];
                    
                    /*if(arrChat.count>1)
                        //[self.tableChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrChat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
                    {
                        if(arrImages.count > 0)
                            //[self showChatCoverImage:arrImages.count-1];
                        else
                            //[self showChatCoverImage:0];
                    }
                    else
                        //[self showChatCoverImage:0];*/
                    
                }
                
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        if([strFailure isEqualToString:@"Record Not found"])
                        {
                            if(arrImages.count == 0)
                            {
                                //btnLeft.hidden = YES;
                                //btnRight.hidden= YES;
                                
                            }
                        }
                    }
                    else
                    {
                        [[AppDelegate getDelegate] sessionExpired];
                    }
                    
                });
            }
        }
    }
    else
    {
        [GC hideLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlert_Chat:@"" message:ServerError];
        });
    }
}

#pragma mark - Post Chat Request
-(void)postChatRequest
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    NSMutableDictionary *dicChat = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    if([strChatType isEqualToString:@"0"])
    {
        //[dicChat setObject:txtViewChat.text forKey:@"Message"];
    }
    else
    {
        if([strMediaType isEqualToString:@"0"])
        {
            [dicChat setObject:[self.dataImage base64EncodedString] forKey:@"Message"];
        }
        else
        {
            [dicChat setObject:[self.dataVideo base64EncodedStringWithOptions:0] forKey:@"Message"];
            [dicChat setObject:[self.dataImage base64EncodedString] forKey:@"ThumbPath"];
        }
    }
    
    [dicChat setObject:strChatType forKey:@"Type"];
    [dicChat setObject:strMediaType forKey:@"MediaType"];
    [dicChat setObject:@{@"Id" : self.userModel.localID} forKey:@"User"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    [dicMain setObject:dicChat forKey:@"Chat"];
    
    if(arrChat.count>0)
        [dicMain setObject:[NSString stringWithFormat:@"%@",[[arrChat lastObject] valueForKey:@"ChatId"]] forKey:@"LastReceivedChatId"];
    else
        [dicMain setObject:@"0" forKey:@"LastReceivedChatId"];
    
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    NSData *dataMyJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,PostChat];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest new];
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:dataMyJson]];
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        [GC hideLoader];
        
        if([self.dataRequest error])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showAlert_Chat:@"" message:self.dataRequest.error.localizedDescription];
                
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                //txtViewChat.text = @"Type your message...";
                self.dataImage = nil;
                
                NSMutableArray *arrTemp = [NSMutableArray new];
                arrTemp = [NSMutableArray arrayWithArray:[json valueForKeyPath:@"Data.Chats"]];
                
                int valType = 0;
                
                for(long int i=0;i<arrTemp.count;i++)
                {
                    NSMutableDictionary *dicTemp = [NSMutableDictionary new];
                    
                    valType = [[[arrTemp objectAtIndex:i] valueForKey:@"Type"] intValue];
                    
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FullName"]  forKey:@"Name"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FacebookId"]  forKey:@"FacebookId"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.Id"]  forKey:@"LocalId"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Type"] forKey:@"Type"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"] forKey:@"ChatId"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"LikeStatus"] forKey:@"LikeStatus"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"TotalLike"] forKey:@"TotalLike"];
                    
                    NSString *strTest = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                    
                    if(valType == 0 && (![strTest isEqualToString:@"<null>"]))
                    {
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Message"]  forKey:@"Message"];
                        [arrChat addObject:dicTemp];
                    }
                    
                    strTest = nil;
                    
                    strMediaURL = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                    
                    if(valType == 1)
                    {
                        [dicTemp setObject:strMediaURL forKey:@"Path"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"] forKey:@"MediaType"];
                        
                        if([[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"]intValue]==1)
                        {
                            [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"ThumbPath"] forKey:@"ThumbPath"];
                        }
                        
                        [arrImages addObject:dicTemp];
                        
                    }
                    
                    [arrChatId addObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"]];
                }
                
                refCount = arrTemp.count;
                
                arrTemp = nil;
                
                [GC setArrChat:[NSMutableArray arrayWithArray:self.arrChat]];
                
                [GC setArrChatId:[NSMutableArray arrayWithArray:self.arrChatId]];
                
                [GC setArrChatImages:[NSMutableArray arrayWithArray:self.arrImages]];
                
                [self.tableViewFeed reloadData];
                
                /*if(arrChat.count>1)
                    [self.tableChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrChat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                if(arrImages.count>0)
                    [self showChatCoverImage:(arrImages.count-1)];*/
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlert_Chat:@"" message:strFailure];
                    }
                    else
                    {
                        [[AppDelegate getDelegate] sessionExpired];
                    }
                    
                });
            }
        }
    }
    else
    {
        [GC hideLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlert_Chat:@"" message:ServerError];
        });
    }
}

#pragma mark - Begin Chat
/*- (IBAction)startChat:(id)sender
{
    if([txtViewChat.text isEqualToString:@""])
    {
        [self resetView];
        txtViewChat.text = @"Type your message...";
        [btnChat setImage:[UIImage imageNamed:@"icon_sendChat"] forState:UIControlStateNormal];
    }
    else
    {
        if(isReach)
        {
            [self resetView];
            
            [GC showLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self postChatRequest];
            });
            
        }
        else
        {
            [self showAlert_Chat:@"" message:No_Internet];
        }
    }
}*/

#pragma mark - Use Image For Chat
- (IBAction)captureImage:(id)sender
{
    //txtViewChat.text = @"";
    //[self resetView];
    
    [self performSelector:@selector(uploadOptions_Chat) withObject:nil afterDelay:0.2];
    
}

#pragma mark - Go to Comments
/*- (IBAction)goto_Comments:(id)sender
{
    if(arrImages.count>0)
    {
        [self resetView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CommentViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:Comment_ViewController];
            SetValue_Key(strCoverURL, @"ImageChat");
            [self.navigationController pushViewController:CV animated:YES];
            
        });
    }
}*/

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
