//
//  MyFestViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 08/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "MyFestViewController.h"
#import "CreateFestViewController.h"
#import "FindFestViewController.h"
//#import "RESideMenu.h"
#import "CellMyFest.h"
#import "FestDetailViewController.h"
#import "EventPostLsitVC.h"

@interface MyFestViewController ()

@end

@implementation MyFestViewController
@synthesize view_header,btnMenu,lbl_header,tableMyFest,lblNoData,dateToday,formatter;

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
    
    //[self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"icon_plain_bg", @"icon_plain_bg")]]];
    
    [self.tableMyFest setBackgroundColor:[UIColor clearColor]];
    
    self.tableMyFest.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableMyFest.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableMyFest.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    lbl_header.font=[UIFont fontWithName:LatoRegular size:18.0];
    
    [self.btnMenu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    SetValue_Key(@"", @"EventUpdated");
    
    [GC setParentVC:self];
    
    [self showNoResult];
    
    [[GC arrFest] removeAllObjects];
    
    formatter = [[NSDateFormatter alloc] init];
    
    [GC showLoader:self withText:@"loading data..."];
    if(isReach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getAllMyFest];
        });
    }
    else
    {
        [GC hideLoader];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Network disconnected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    SetValue_Key(@"", @"HitLike");
    
    if([GetValue_Key(@"EventUpdated") isEqualToString:@"EventUpdated"])
    {
        [GC showLoader];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getAllMyFest];
        });
        
        SetValue_Key(@"", @"EventUpdated");
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(flagExit == 1)
    {
        self.userModel = nil;
        self.dataRequest = nil;
        self.lblNoData = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Show No Result Label
-(void)showNoResult
{
    lblNoData = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width-40, 30)];
    lblNoData.text = @"No records found.";
    lblNoData.textColor = [UIColor whiteColor];
    lblNoData.textAlignment = NSTextAlignmentCenter;
    lblNoData.font = [UIFont fontWithName:ProximaNovaSemibold size:16.0];
    lblNoData.hidden = YES;
    [self.view insertSubview:lblNoData aboveSubview:self.tableMyFest];
}

#pragma mark - Swipe Gesture
-(void)swipeLeft:(UISwipeGestureRecognizer *)gest
{
    flagExit = 1;
    
    CreateFestViewController *CV = [self.storyboard instantiateViewControllerWithIdentifier:CreateFest_ViewController];
    CV.isEdit = NO;
    [self.navigationController pushViewController:CV animated:YES];
}

-(void)swipeRight:(UISwipeGestureRecognizer *)gest
{
    
    flagExit = 1;
    
    FindFestViewController *FV = [self.storyboard instantiateViewControllerWithIdentifier:FindFest_ViewController];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:FV animated:NO];
    
}

#pragma mark - Animation Delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GC arrFest].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellMyFest *cell = [tableView dequeueReusableCellWithIdentifier:CellMyFest_ID];
    
    if(cell == nil)
    {
        cell = (CellMyFest *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellMyFest_ID];
    }
    
    /*cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_cover_bg"]];
    
    UIView *viewBase = (UIView *)[cell viewWithTag:6];
    [viewBase removeFromSuperview];
    
    UIView *viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-90, cell.bounds.size.width, 80)];
    viewContent.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.75];
    viewContent.tag = 6;
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, cell.bounds.size.width-20, 25)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.numberOfLines = 1;
    lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    lblTitle.font = [UIFont fontWithName:ProximaNovaSemibold size:15.0];
    lblTitle.text = [[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Title"]] uppercaseString];
    [viewContent addSubview:lblTitle];*/
    cell.lblTitle.text = [[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Title"]] uppercaseString];
    
    NSString *refDescrip = [NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Description"]];
    
    if(refDescrip.length>0 && ![refDescrip isEqualToString:@"<null>"]){
        /*
        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrahStyle setLineSpacing:5];
        
        UILabel *lblDescrip = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, cell.bounds.size.width-20, 40)];
        lblDescrip.backgroundColor = [UIColor clearColor];
        lblDescrip.textColor = [UIColor darkGrayColor];
        lblDescrip.textAlignment = NSTextAlignmentLeft;
        lblDescrip.numberOfLines = 3;
        lblDescrip.lineBreakMode = NSLineBreakByTruncatingTail;
        lblDescrip.attributedText = [[NSAttributedString alloc] initWithString:refDescrip attributes:@{NSParagraphStyleAttributeName : paragrahStyle, NSFontAttributeName : [UIFont fontWithName:ProximaNovaRegular size:16.0]}];
        [viewContent addSubview:lblDescrip];
        
        [lblDescrip sizeToFit];
        
        viewContent.frame = CGRectMake(0, cell.bounds.size.height-(30 + lblDescrip.frame.size.height + 5 + 10), cell.bounds.size.width, (30 + lblDescrip.frame.size.height + 5));
        */
        cell.lblDescrip.text = refDescrip;
        
    }
    else
    {
        cell.lblDescrip.text = @"";
        //viewContent.frame = CGRectMake(0, cell.bounds.size.height-40, cell.bounds.size.width, 30);
    }

    
    NSMutableArray *arrMedia = [[NSMutableArray alloc] initWithArray:[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Medias"]];
    cell.imgViewCover.layer.cornerRadius = 49;
    if(arrMedia.count>0)
    {
        cell.imgViewCover.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgViewCover.clipsToBounds = YES;
        int mediaType = [[[arrMedia firstObject] valueForKey:@"Type"] intValue];
        NSString *strImgPath;
        if(mediaType == 0)
            strImgPath = [NSString stringWithFormat:@"%@",[[arrMedia firstObject] valueForKey:@"Path"]];
        else
            strImgPath = [NSString stringWithFormat:@"%@",[[arrMedia firstObject] valueForKey:@"ThumbPath"]];
        
        [cell.imgViewCover sd_setImageWithURL:URL(strImgPath) placeholderImage:[UIImage imageNamed:@"default_fest_icon"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
            {
                [self.tableMyFest reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else{
                
                cell.imgViewCover.image = image;
            }
        }];
    }
    else
    {
        cell.imgViewCover.image = [UIImage imageNamed:@"default_fest_icon"];
    }
    
    //[cell.contentView addSubview:viewContent];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *festDate=[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"StartDate"]];
        if([self isExpiredDate:festDate])
        {
            EventPostLsitVC *eventPostList = [[ILLogic storyboardNoAutolayout] instantiateViewControllerWithIdentifier:EventPostsList_VC];
            eventPostList.strTitle=lbl_header.text;
            eventPostList.dictFestDetails=[[GC arrFest] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:eventPostList animated:YES];
        }
        else
        {
            flagExit = 0;
            
            //Maintain Media Contents Globally
            [GC setArrPreviews:[[NSMutableArray alloc] initWithArray:[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Medias"]]];
            
            //Maintain Event ID, Event Title & Event Likes Globally
            [GC setEventID:[[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Id"] integerValue]];
            [GC setEventTitle:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Title"]]];
            
            NSLog(@"EventID=>%ld",(long)[GC eventID]);
            
            FestDetailViewController *FDV = [self.storyboard instantiateViewControllerWithIdentifier:FestDetail_ViewController];
            FDV.isMyFest = YES;
            FDV.pageIndex=indexPath.row;
            FDV.arrFestDetails=[[NSMutableArray alloc] initWithObjects:[[GC arrFest] objectAtIndex:indexPath.row], nil];
            [self.navigationController pushViewController:FDV animated:YES];
        }
        
        
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 121.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

#pragma mark - Retrieve My Fest Data from Server
-(void)getAllMyFest
{
    self.userModel = [[GC arrUserDetails] firstObject];
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:self.userModel.localID forKey:@"UserId"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,AllMyFest];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:myJSONData]];
    
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        if([self.dataRequest error])
        {
            [GC hideLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *strError = [NSString new];
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    strError =  No_Internet;
                else
                    strError = self.dataRequest.error.localizedDescription;
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:strError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            });
            
        }
        else if ([self.dataRequest responseString])
        {
            NSData *data= [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result == 1)
            {
                
                //Maintain Fest Lists Globally
                [GC setArrFest:[[NSMutableArray alloc] initWithArray:[json valueForKeyPath:@"Data.Events"]]];
                
                if([GC arrFest].count>0){
                    
                    lblNoData.hidden = YES;
                    
                    [GC hideLoader];
                    
                    [tableMyFest performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        {
                            if([GlobalClass DB_Load_AllData:@"MyFest"].count>0)
                                [GlobalClass DB_Delete];
                            
                            if([GlobalClass DB_Load_AllData:@"MyFest"].count == 0)
                            {
                                [self saveAllDataLocal];
                            }
                        }
                    });
                }
                else{
                    
                    [GC hideLoader];
                    
                    lblNoData.hidden = NO;
                }
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        if([strFailure rangeOfString:@"Record Not found"].length!=0)
                        {
                            lblNoData.hidden = NO;
                        }
                        else
                        {
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:strFailure delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            
                            [alert show];
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
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:ServerError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        });
    }
}

#pragma mark - Save ALL Data Local DB
-(void)saveAllDataLocal
{
    
    NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
    
    for(long int i=0;i<[GC arrFest].count;i++)
    {
        
        NSString *refUserId = [NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKeyPath:@"User.Id"]];
        
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        NSDate *festDate = [formatter dateFromString:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKey:@"StartDate"]]];
        
        if([festDate compare:[[AppDelegate getDelegate] localTime]] == NSOrderedDescending)
        {
            if(![refUserId isEqualToString:self.userModel.localID])
            {
                
                // Grab the Label entity
                MyFest *myFest = [NSEntityDescription insertNewObjectForEntityForName:@"MyFest" inManagedObjectContext:context];
                
                [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
                
                [myFest setUserId:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKeyPath:@"User.Id"]]];
                [myFest setFestTitle:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKey:@"Title"]]];
                
                [myFest setFestLocation:[NSString stringWithFormat:@"%@,%@,%@,%@",
                                         [[[GC arrFest] objectAtIndex:i] valueForKey:@"Street"],
                                         [[[GC arrFest] objectAtIndex:i] valueForKey:@"City"],
                                         [[[GC arrFest] objectAtIndex:i] valueForKey:@"State"],
                                         [[[GC arrFest] objectAtIndex:i] valueForKey:@"Zip"]]];
                
                [myFest setLatitude:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKey:@"Latitude"]]];
                [myFest setLongitude:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKey:@"Longitude"]]];
                [myFest setFestEventId:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKey:@"Id"]]];
                [myFest setFestEventStatus:[NSNumber numberWithInteger:0]];
                [myFest setFestRadius:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKey:@"Miles"]]];
                [myFest setPushNotification:[NSString stringWithFormat:@"%@",[[[GC arrFest] objectAtIndex:i] valueForKey:@"Notification"]]];
                [myFest setFestDate:festDate];
                
                
                TEST_MODE;
                // Save everything
                NSError *error = nil;
                if ([context save:&error]) {
                    NSLog(@"My Fest - Saved to local data ");
//                    UIAlertView *al=[[UIAlertView alloc]initWithTitle:nil message:@"Myfest - locally cache to coredata success" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//                    [al show];
                } else {
                    NSLog(@"My Fest - Not saved to local data: %@", [error userInfo]);
//                    UIAlertView *al=[[UIAlertView alloc]initWithTitle:nil message:@"Myfest - locally cache to coredata failed" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//                    [al show];
                }
                TEST_MODE;

            }
        }
    }
}

#pragma mark - Fest Menu
- (IBAction)menuFest:(id)sender
{
    flagExit = 1;
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
