//
//  CommentViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 13/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "CommentViewController.h"
#import "ChatImageViewController.h"
#import "ProfileViewController.h"
#import "CellComment.h"
#import "ChatViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize view_header,lbl_header,imgViewCover,viewCenter,lblTitleComment,lblCommentValue,lblTitleLikes,lblLikesValue,arrComments,tableComments,txtComment,viewComment,btnPost,dic,btnPreview,isLike,btnLike,formatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    
    [self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    lbl_header.font=[UIFont fontWithName:ProximaNovaSemibold size:20.0];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestComments)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableComments addSubview:self.refreshControl];
    
    self.tableComments.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    self.tableComments.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableComments.separatorColor=[UIColor grayColor];
    self.tableComments.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    imgViewCover.contentMode = UIViewContentModeScaleAspectFill;
    imgViewCover.clipsToBounds = YES;
    
    [imgViewCover sd_setImageWithURL:URL(GetValue_Key(@"ImageChat")) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(!error)
        {
            imgViewCover.image = image;
        }
        
    }];
    
    dic = [NSMutableDictionary new];
    arrComments = [NSMutableArray new];
    formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:sss.zzz";
    refCount = 0;
    
    [self customView];
    
    self.userModel = [[GC arrUserDetails] firstObject];
    
    isLike = [GetValue_Key(@"LikeStatus") boolValue];
    lblLikesValue.text = [NSString stringWithFormat:@"%@",GetValue_Key(@"TotalLike")];
    lblCommentValue.text = @"0";
    
    if(isLike)
    {
        [btnLike setImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
    }
    else
    {
        [btnLike setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    }
    
    [GC setParentVC:self];
    
    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
    {
        if([GetValue_Key(@"Reload") isEqualToString:@"Reload"])
        {
            SetValue_Key(@"", @"Reload");
            
            self.arrComments = [NSMutableArray arrayWithArray:[GC arrComment]];
            
            NSMutableArray *arrTemp = [NSMutableArray new];
            arrTemp = [NSMutableArray arrayWithObjects:GetValue_Key(@"CommentData"), nil];
            
            for(long int i=0;i<arrTemp.count;i++)
            {
                NSMutableDictionary *dicTemp = [NSMutableDictionary new];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Message"]  forKey:@"Message"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FullName"]  forKey:@"Name"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FacebookId"]  forKey:@"FacebookId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.Id"]  forKey:@"LocalId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"] forKey:@"CommentId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"CreatedDate"]  forKey:@"CreatedDate"];
                
                [arrComments addObject:dicTemp];
            }
            
            refCount += arrTemp.count;
            
            self.lblCommentValue.text = [NSString stringWithFormat:@"%ld",(long)arrComments.count];
            
            arrTemp = nil;
            
            [tableComments reloadData];
            
            [GC setArrComment:[NSMutableArray arrayWithArray:self.arrComments]];
            
            if(arrComments.count>1)
                [self.tableComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrComments.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            [self performSelectorInBackground:@selector(likeStatusUpdateFromChat) withObject:nil];
        }
        else
        {
            [GC showLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self getAllComments:@"0"];
                
                [self performSelectorInBackground:@selector(likeStatusUpdateFromChat) withObject:nil];
            });
        }
    }
    else
    {
        [GC showLoader];
        if(isReach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self getAllComments:@"0"];
            });
            
        }
        else
        {
            [GC hideLoader];
            
            [self showAlert_Comment:@"" message:No_Internet];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    lbl_header.text = [[GC eventTitle] uppercaseString];
    
     SetValue_Key(@"Comment", @"Screen");
}

-(void)viewDidDisappear:(BOOL)animated
{
    SetValue_Key(@"", @"Screen");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Text Field
-(void)customView
{
    
    viewComment = [[UIView alloc] init];
    
    viewComment.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-216-40), [UIScreen mainScreen].bounds.size.width, 40);
    viewComment.backgroundColor=[UIColor lightGrayColor];

    txtComment = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, ([UIScreen mainScreen].bounds.size.width-70), 30)];
    txtComment.delegate = self;
    txtComment.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.85];
    txtComment.textColor = [UIColor blackColor];
    txtComment.font = [UIFont fontWithName:ProximaNovaLight size:14.0];
    txtComment.textAlignment = NSTextAlignmentLeft;
    txtComment.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    txtComment.autocorrectionType = UITextAutocorrectionTypeNo;
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:txtComment];

    txtComment.borderStyle = UITextBorderStyleLine;
    txtComment.layer.borderColor = [UIColor grayColor].CGColor;
    txtComment.layer.borderWidth = 0.5;
    txtComment.layer.cornerRadius = 5.0;
    
    UIView *viewLeft = [UIView new];
    viewLeft.frame = CGRectMake(0, 0, 5, 30);
    [txtComment setLeftViewMode:UITextFieldViewModeAlways];
    txtComment.leftView = viewLeft;
    
    [viewComment addSubview:txtComment];
    
    btnPost = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPost.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40), 5, 30, 30);
    [btnPost addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    [btnPost setImage:[UIImage imageNamed:@"icon_post"] forState:UIControlStateNormal];
    [viewComment addSubview:btnPost];
    
    viewComment.hidden = YES;
    [self.view insertSubview:viewComment aboveSubview:self.tableComments];
}

#pragma mark - Text Field Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtComment = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self resetView];
    
    [UIView commitAnimations];
    
    return YES;
}

#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrComments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellComment *cell = [tableView dequeueReusableCellWithIdentifier:CellComment_ID];
    
    if(cell == nil)
    {
        cell = [[CellComment alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellComment_ID];
    }
    
    
    UIView* viewbase = (UIView *)[cell viewWithTag:10];
    [viewbase removeFromSuperview];
    
    UIView *viewContent = [[UIView alloc] init];
    UILabel *lblContent = [[UILabel alloc] init];
    
    if(cell.bounds.size.height<=54)
    {
        viewContent.frame = CGRectMake(0, 0, cell.bounds.size.width, 54);
        lblContent.frame = CGRectMake(60, 27, (cell.bounds.size.width-60-10), 18);
    }
    else
    {
        viewContent.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
        lblContent.frame = CGRectMake(60, 27, (cell.bounds.size.width-60-10), (cell.bounds.size.height-36));
    }
    
    UIButton *btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    btnProfile.frame = CGRectMake(10, 10, 40, 40);
    btnProfile.backgroundColor = [UIColor clearColor];
    btnProfile.clipsToBounds = YES;
    btnProfile.layer.cornerRadius = 40/2;
    btnProfile.layer.masksToBounds = YES;
    btnProfile.layer.borderWidth = 0;
    btnProfile.tag = indexPath.row;
    [btnProfile addTarget:self action:@selector(goto_Profile_Comments:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgViewProfile = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    imgViewProfile.contentMode = UIViewContentModeScaleAspectFill;
    imgViewProfile.clipsToBounds = YES;
    imgViewProfile.layer.cornerRadius = 40/2;
    imgViewProfile.layer.masksToBounds = YES;
    imgViewProfile.layer.borderWidth = 0;
    
    [imgViewProfile sd_setImageWithURL:FBURL([[arrComments objectAtIndex:indexPath.row] valueForKey:@"FacebookId"]) placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
        {
            [self.tableComments reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            
            imgViewProfile.image = image;
        }
    }];

    [viewContent addSubview:imgViewProfile];
    [viewContent addSubview:btnProfile];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake((cell.bounds.size.width-65), 7, 65, 20)];
    lblTime.font = [UIFont fontWithName:ProximaNovaRegular size:10.0];
    lblTime.textColor = [UIColor lightGrayColor];
    lblTime.textAlignment = NSTextAlignmentCenter;
    lblTime.numberOfLines = 1;
    lblTime.lineBreakMode = NSLineBreakByTruncatingTail;
    
    /*NSDate *dateFest = [formatter dateFromString:[NSString stringWithFormat:@"%@",[[arrComments objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"]]];
    lblTime.text = [self getTimeDifference:dateFest];*/
    lblTime.text = @"";
    [viewContent addSubview:lblTime];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, (cell.bounds.size.width-10-40-10-15-65-10), 20)];
    lblName.font = [UIFont fontWithName:ProximaNovaSemibold size:16.0];
    lblName.textColor = [UIColor blackColor];
    lblName.textAlignment = NSTextAlignmentLeft;
    lblName.numberOfLines = 1;
    lblName.lineBreakMode = NSLineBreakByTruncatingTail;
    lblName.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"Name"];
    [viewContent addSubview:lblName];

    lblContent.font = [UIFont fontWithName:ProximaNovaRegular size:14.0];
    lblContent.textColor = [UIColor lightGrayColor];
    lblContent.textAlignment = NSTextAlignmentLeft;
    lblContent.numberOfLines = 0;
    lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    lblContent.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"Message"];
    [viewContent addSubview:lblContent];
    
    UIImageView* imgLine = (UIImageView *)[cell viewWithTag:11];
    [imgLine removeFromSuperview];
    
    if(indexPath.row == (self.arrComments.count-1))
    {
        UIImageView *imgDivider = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, cell.bounds.size.width, 0.5)];
        imgDivider.image = [UIImage imageNamed:@"icon_divider"];
        imgDivider.tag = 11;
        [viewContent addSubview:imgDivider];
    }
    
    [viewContent addSubview:imgViewProfile];
    [viewContent addSubview:lblName];
    [viewContent addSubview:lblContent];
    [viewContent addSubview:lblTime];
    
    viewContent.tag = 10;
    [cell.contentView addSubview:viewContent];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight=0.0;
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(60, 27, ([UIScreen mainScreen].bounds.size.width-60-10), 18);
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.font=[UIFont fontWithName:ProximaNovaRegular size:14.0];
    label.text = [[self.arrComments objectAtIndex:indexPath.row] valueForKey:@"Message"];
    
    CGSize max_lblSize=CGSizeMake(([UIScreen mainScreen].bounds.size.width-60-10), FLT_MAX);
    
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineBreakMode = label.lineBreakMode;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:ProximaNovaRegular size:14.0],NSParagraphStyleAttributeName:para};
    
    CGSize curr_lblSize=[label.text boundingRectWithSize:max_lblSize
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    
    
    CGRect new_lblFrame=label.frame;
    new_lblFrame.size.height=curr_lblSize.height;
    label.frame=new_lblFrame;
    
    if(new_lblFrame.size.height<=18)
    {
        cellHeight=54;
    }
    else
    {
        cellHeight=new_lblFrame.size.height + 36;
    }
    
    return cellHeight;
}

#pragma mark - Button Action to Post Comment
-(void)postComment
{
    if(txtComment.text.length>0)
    {
        if(isReach)
        {
            [self resetView];
            
            [GC showLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self postCommentRequest];
            });
        }
        else
        {
            [self showAlert_Comment:@"" message:No_Internet];
        }
    }
}

#pragma mark - Go to Profile Page
-(void)goto_Profile_Comments:(UIButton *)sender
{
    ProfileViewController *PV = [self.storyboard instantiateViewControllerWithIdentifier:Profile_ViewController];
    PV.localID = [NSString stringWithFormat:@"%@",[[self.arrComments objectAtIndex:sender.tag] valueForKey:@"LocalId"]];
    [self.navigationController pushViewController:PV animated:YES];
}

#pragma mark - Move Views To Top
-(void)moveViewsToTop
{
    imgViewCover.frame = CGRectMake(0, (70-160-30), [UIScreen mainScreen].bounds.size.width, 160);
    btnPreview.frame = CGRectMake(0, (70-160-30), [UIScreen mainScreen].bounds.size.width, 160);
    viewCenter.frame = CGRectMake(0, (imgViewCover.frame.origin.y+imgViewCover.frame.size.height), [UIScreen mainScreen].bounds.size.width, 30);
    tableComments.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-70-216-40));
    
    if(arrComments.count>1)
        [self.tableComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrComments.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

#pragma mark - Reset Views To Original Position
-(void)resetView
{
    imgViewCover.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, 160);
    btnPreview.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, 160);
    viewCenter.frame = CGRectMake(0, (imgViewCover.frame.origin.y+imgViewCover.frame.size.height), [UIScreen mainScreen].bounds.size.width, 30);
    tableComments.frame = CGRectMake(0, (viewCenter.frame.origin.y+viewCenter.frame.size.height), [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-70-160-30));
    viewComment.hidden = YES;
    [txtComment resignFirstResponder];
}

#pragma mark - Get My Date & Time
-(NSDate *)myLocalTime
{
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"UTC"];
    NSInteger seconds = [tz secondsFromGMTForDate: [NSDate date]];
    return [NSDate dateWithTimeInterval: seconds sinceDate: [NSDate date]];
}

#pragma mark - Get Time Difference
-(NSString *)getTimeDifference:(NSDate *)dateComment
{
    
    if([dateComment compare:[self myLocalTime]] == NSOrderedDescending)
    {
        dateComment = [self myLocalTime];
    }
    
    long double diff = [[self myLocalTime] timeIntervalSinceDate:dateComment];
    
    if(diff<0)
        diff = diff*-1;
    
    NSString *strTime = [NSString new];
    
    if(diff!=0 && diff<60)
    {
        strTime = [NSString stringWithFormat:@"%ld sec ago",(long)roundl(diff)];
    }
    else if(diff>=60 && diff<3600)
    {
        strTime = [NSString stringWithFormat:@"%ld min ago",(long)(roundl(diff)/60)];
    }
    else if(diff>=3600 && diff<86400)
    {
        strTime = [NSString stringWithFormat:@"%ld hours ago",(long)(roundl(diff)/3600)];
    }
    else if (diff>=86400)
    {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:[[AppDelegate getDelegate]localTime]
                                                              toDate:dateComment
                                                             options:0];
        
        
        NSInteger days = ([components day]*-1);
        
        strTime = [NSString stringWithFormat:@"%ld day ago",(long)days];
        
        if(days>7)
        {
            if(days>7 && days<14)
            {
                strTime = [NSString stringWithFormat:@"week ago"];
            }
            else if(days>14 && days<21)
            {
                strTime = [NSString stringWithFormat:@"2 weeks ago"];
            }
            else if(days>21 && days<30)
            {
                strTime = [NSString stringWithFormat:@"3 weeks ago"];
            }
        }
        else
        {
            NSInteger month = days/30;
            
            if(month<12)
                strTime = [NSString stringWithFormat:@"%ld month ago",(long)month];
            else
            {
                month = month/12;
                strTime = [NSString stringWithFormat:@"%ld year ago",(long)month];
            }
        }
    }
    
    return strTime;
}

#pragma mark - Get Latest Comments
-(void)getLatestComments
{
    [self.refreshControl endRefreshing];
    
    [self resetView];
    
    [GC showLoader];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(arrComments.count>0)
            [self getAllComments:[NSString stringWithFormat:@"%@",[[arrComments lastObject] valueForKey:@"CommentId"]]];
        else
        {
            [arrComments removeAllObjects];
            
            [self getAllComments:@"0"];
        }
    });
}

#pragma mark - Get All Comments
-(void)getAllComments:(NSString *)tag
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC chatID]] forKey:@"EventChatId"];
    [dicMain setObject:tag forKey:@"LastReceivedCommentId"];
    
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    NSData *dataMyJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,AllComments];
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
                
                [self showAlert_Comment:@"" message:self.dataRequest.error.localizedDescription];
                
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
               
                NSMutableArray *arrTemp = [NSMutableArray new];
                
                arrTemp = [NSMutableArray arrayWithArray:[json valueForKeyPath:@"Data.Comments"]];
                
                if(refCount == arrTemp.count)
                {
                    if(arrComments.count>1)
                        [self.tableComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrComments.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                    return;
                }
                else
                {
                    
                    for(long int i=0;i<arrTemp.count;i++)
                    {
                        NSMutableDictionary *dicTemp = [NSMutableDictionary new];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Message"]  forKey:@"Message"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FullName"]  forKey:@"Name"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FacebookId"]  forKey:@"FacebookId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.Id"]  forKey:@"LocalId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"] forKey:@"CommentId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"CreatedDate"]  forKey:@"CreatedDate"];
                        
                        [arrComments addObject:dicTemp];
                    }
                    
                    refCount = arrComments.count;
                    self.lblCommentValue.text = [NSString stringWithFormat:@"%ld",(long)arrComments.count];
                    
                    arrTemp = nil;
                    
                    [self.tableComments reloadData];
                    
                    [GC setArrComment:[NSMutableArray arrayWithArray:self.arrComments]];
                    
                    if(arrComments.count>1)
                        [self.tableComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrComments.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                }
                
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {

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
            
            [self showAlert_Comment:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Post Comment Request
-(void)postCommentRequest
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    NSMutableDictionary *dicComment = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicComment setObject:txtComment.text forKey:@"Message"];
    [dicComment setObject:@{@"Id" : self.userModel.localID} forKey:@"User"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicComment forKey:@"Comment"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC chatID]] forKey:@"EventChatId"];
    
    if(arrComments.count>0)
        [dicMain setObject:[NSString stringWithFormat:@"%@",[[arrComments lastObject]valueForKey:@"CommentId"]] forKey:@"LastReceivedCommentId"];
    else
        [dicMain setObject:@"0" forKey:@"LastReceivedCommentId"];
    
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    NSData *dataMyJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,PostComment];
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
                
                [self showAlert_Comment:@"" message:self.dataRequest.error.localizedDescription];
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                //Clear Text Field
                txtComment.text = @"";
                
                NSMutableArray *arrTemp = [NSMutableArray new];
                arrTemp = [NSMutableArray arrayWithArray:[json valueForKeyPath:@"Data.Chat.Comments"]];
                
                for(long int i=0;i<arrTemp.count;i++)
                {
                    NSMutableDictionary *dicTemp = [NSMutableDictionary new];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Message"]  forKey:@"Message"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FullName"]  forKey:@"Name"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FacebookId"]  forKey:@"FacebookId"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.Id"]  forKey:@"LocalId"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"] forKey:@"CommentId"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"CreatedDate"] forKey:@"CreatedDate"];
                    
                    [arrComments addObject:dicTemp];
                }
                
                refCount = arrComments.count;
                
                self.lblCommentValue.text = [NSString stringWithFormat:@"%ld",(long)arrComments.count];
                self.lblLikesValue.text = [NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.Chat.TotalLike"]];
                
                arrTemp = nil;
                
                [tableComments reloadData];
                
                [GC setArrComment:[NSMutableArray arrayWithArray:self.arrComments]];
                
                if(arrComments.count>1)
                    [self.tableComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrComments.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlert_Comment:@"" message:strFailure];
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
            
            [self showAlert_Comment:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Give Like Request
-(void)giveLikeRequest
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    NSMutableDictionary *dicLike = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicLike setObject:@{@"Id" : self.userModel.localID} forKey:@"User"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicLike forKey:@"Like"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC chatID]] forKey:@"EventChatId"];
    
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    NSData *dataMyJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,LikeEvent];
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
                
                [self showAlert_Comment:@"" message:self.dataRequest.error.localizedDescription];
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                NSInteger x = [lblLikesValue.text integerValue];
                
                if(isLike)
                {
                    isLike = NO;
                    [btnLike setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
                    if(x>0)
                        x -= 1;
                }
                else
                {
                    isLike = YES;
                    [btnLike setImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
                    
                    x = x+1;
                }
                
                lblLikesValue.text = [NSString stringWithFormat:@"%ld",(long)x];
                
                SetValue_Key(@"HitLike", @"HitLike");
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlert_Comment:@"" message:strFailure];
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
            
            [self showAlert_Comment:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Get Like Status Update while Notification
-(void)likeStatusUpdateFromChat
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    [dicMain setObject:@"0" forKey:@"LastReceivedChatId"];
    
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

        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1)
            {
                
                NSMutableArray *arrTemp = [NSMutableArray new];
                arrTemp = [NSMutableArray arrayWithArray:[json valueForKeyPath:@"Data.Chats"]];
                
                for(long int i=0;i<arrTemp.count;i++)
                {
                    NSInteger refChatId = [[[arrTemp objectAtIndex:i] valueForKey:@"Id"] integerValue];
                    
                    if(refChatId == [GC chatID])
                    {
                        isLike = [[[arrTemp objectAtIndex:i] valueForKey:@"LikeStatus"] boolValue];
                        
                        if(isLike)
                        {
                            [btnLike setImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [btnLike setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
                        }

                        return;
                    }
                }
                
                [GC hideLoader];
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        
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
            
            [self showAlert_Comment:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Show Alert View
-(void)showAlert_Comment:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - Go Back
- (IBAction)goBack:(id)sender
{
    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
    {
        ChatViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:Chat_ViewController];
        [self.navigationController pushViewController:CV animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Add Comment
- (IBAction)addComment:(id)sender
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];

    [self moveViewsToTop];
    
    viewComment.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-216-40), ([UIScreen mainScreen].bounds.size.width), 40);
    viewComment.hidden = NO;
    [txtComment becomeFirstResponder];
    
    [UIView commitAnimations];
    
}

#pragma mark - Give Like
- (IBAction)hitLike:(id)sender
{
    [GC showLoader];
    
    if(isReach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self giveLikeRequest];
        });
    }
    else
    {
        [GC hideLoader];
        [self showAlert_Comment:@"" message:No_Internet];
    }
}

#pragma mark - Go to Preview Page
- (IBAction)previewImage:(id)sender
{
 
    ChatImageViewController *CIV = [self.storyboard instantiateViewControllerWithIdentifier:ChatImage_ViewController];
    [self.navigationController pushViewController:CIV animated:YES];
 
}

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
