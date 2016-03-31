//
//  AttendingViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 09/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "AttendingViewController.h"
#import "ProfileViewController.h"
#import "ColvCellAttending.h"

@interface AttendingViewController ()

@end

@implementation AttendingViewController

@synthesize view_header,lbl_header,lblFestAddress,lblFestCount,lblFestDate,lblFestTitle,arrAttending;

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
    
    lbl_header.font=[UIFont fontWithName:LatoRegular size:18];
    lblFestTitle.font = [UIFont fontWithName:LatoBold size:20];
    
    //self.tableAttending.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.tableAttending.separatorColor=[UIColor grayColor];
    
    lblFestTitle.text = [self.arrDetails objectAtIndex:0];
    lblFestDate.text = [self.arrDetails objectAtIndex:1];
    lblFestAddress.text = [self.arrDetails objectAtIndex:2];
    lblFestCount.text = [self.arrDetails objectAtIndex:3];
    self.lbFestTime.text = [self.arrDetails objectAtIndex:4];
    
    arrAttending = [NSMutableArray new];
    
    [GC setParentVC:self];
    
    if(isReach)
    {
        [GC showLoader];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getAllAttendingList];
        });
    }
    else
    {
        [self showAlertView_Attending:@"" message:No_Internet];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(flagExit == 1)
    {
        self.arrAttending = nil;
        self.userModel = nil;
        self.dataRequest = nil;
        self.arrDetails = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAttending.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellAttending *cell = [tableView dequeueReusableCellWithIdentifier:CellAttending_ID];
    
    if(cell == nil)
    {
        cell = [[CellAttending alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellAttending_ID];
    }
    
    UIView* viewbase = (UIView *)[cell viewWithTag:10];
    [viewbase removeFromSuperview];
    
    UIView *viewContent = [[UIView alloc] init];
    viewContent.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
    
    UIImageView *imgViewProfile = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    imgViewProfile.contentMode = UIViewContentModeScaleAspectFill;
    imgViewProfile.clipsToBounds = YES;
    imgViewProfile.layer.cornerRadius = 40/2;
    imgViewProfile.layer.masksToBounds = YES;
    imgViewProfile.layer.borderWidth = 0;
    imgViewProfile.image = [UIImage imageNamed:@"icon_ghost2"];
    
    [imgViewProfile sd_setImageWithURL:FBURL([[arrAttending objectAtIndex:indexPath.row] valueForKey:@"FacebookId"]) placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
        {
            [self.tableAttending reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            
            imgViewProfile.image = image;
        }
    }];
    
    [viewContent addSubview:imgViewProfile];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, (cell.bounds.size.width-10-40-10-10), 24)];
    lblName.font = [UIFont fontWithName:ProximaNovaSemibold size:16.0];
    lblName.textColor = [UIColor blackColor];
    lblName.textAlignment = NSTextAlignmentLeft;
    lblName.numberOfLines = 1;
    lblName.lineBreakMode = NSLineBreakByTruncatingTail;
    lblName.text = [[arrAttending objectAtIndex:indexPath.row] valueForKey:@"FullName"];
    [viewContent addSubview:lblName];
    
    UIImageView* imgLine = (UIImageView *)[cell viewWithTag:11];
    [imgLine removeFromSuperview];
    
    if(indexPath.row == (arrAttending.count-1))
    {
        UIImageView *imgDivider = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, cell.bounds.size.width, 0.5)];
        imgDivider.image = [UIImage imageNamed:@"icon_divider"];
        imgDivider.tag = 11;
        [viewContent addSubview:imgDivider];
    }
    
    viewContent.tag = 10;
    [cell.contentView addSubview:viewContent];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    flagExit = 0;
    ProfileViewController *PV = [self.storyboard instantiateViewControllerWithIdentifier:Profile_ViewController];
    PV.localID = [NSString stringWithFormat:@"%@",[[arrAttending objectAtIndex:indexPath.row]valueForKey:@"Id"]];
    [self.navigationController pushViewController:PV animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
*/

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrAttending.count;
}

// The cell that is returned m\ust be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (ColvCellAttending *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ColvCellAttending *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColvCellAttending" forIndexPath:indexPath];
    NSMutableDictionary *_dicItem = arrAttending[indexPath.row];
    UIImageView *imgViewProfile = cell.ivPhoto;
    imgViewProfile.image = [UIImage imageNamed:@"icon_chatUserPH"];
    
    [imgViewProfile sd_setImageWithURL:FBURL(_dicItem[@"FacebookId"]) placeholderImage:[UIImage imageNamed:@"icon_chatUserPH"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
        {
            [self.colvAttending reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
        }
        else{
            
            imgViewProfile.image = image;
        }
    }];
    cell.ivPhoto.layer.cornerRadius = 32;
    return cell;
}


- (void)hightLightCell:(UICollectionViewCell*)cell Highlight:(BOOL)aHigh{
    if (aHigh) {
        cell.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.1 animations:^{
            cell.transform = CGAffineTransformMakeScale(1.05,1.05);
        }];
    }
    else{
        [UIView animateWithDuration:0.1 animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self hightLightCell:cell Highlight:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self hightLightCell:cell Highlight:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableDictionary *_dicAttendMan = arrAttending[indexPath.row];
    ProfileViewController *PV = [self.storyboard instantiateViewControllerWithIdentifier:Profile_ViewController];
    PV.localID = [NSString stringWithFormat:@"%@",_dicAttendMan[@"Id"]];
    [self.navigationController pushViewController:PV animated:YES];
}

#pragma mark - Go to Profile Page
-(void)goto_Profile_Attending:(UIButton *)sender
{
    flagExit = 0;
    ProfileViewController *PV = [self.storyboard instantiateViewControllerWithIdentifier:Profile_ViewController];
    PV.localID = [NSString stringWithFormat:@"%@",[[arrAttending objectAtIndex:sender.tag]valueForKey:@"Id"]];
    [self.navigationController pushViewController:PV animated:YES];
}

#pragma mark - Request To Get All Attending List
-(void)getAllAttendingList
{
    self.userModel = [[GC arrUserDetails] firstObject];
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    NSData *dataMyJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,Attending];
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
                
                [self showAlertView_Attending:@"" message:self.dataRequest.error.localizedDescription];
                
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                arrAttending = [NSMutableArray arrayWithArray:[json valueForKeyPath:@"Data.Users"]];
                
                [self.colvAttending reloadData];
                
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlertView_Attending:@"" message:strFailure];
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
            
            [self showAlertView_Attending:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Alert View Common
-(void)showAlertView_Attending:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - Go Back
- (IBAction)goBack:(id)sender
{
    flagExit = 1;
    [self.navigationController popViewControllerAnimated:YES];
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
