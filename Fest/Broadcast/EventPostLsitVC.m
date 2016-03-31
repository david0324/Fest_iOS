//
//  EventPostLsitVC.m
//  Fest
//
//  Created by Denow Cleetus on 17/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "EventPostLsitVC.h"
#import "FestDetailViewController.h"
#import "AddEventPostVC.h"
#import "BackendManager.h"
#import "EventPostCell.h"
#import "BroadcastEventsLikesVC.h"
#import <AVFoundation/AVFoundation.h>

float minVisbileHeightForVideoPlayback = 100;


@interface EventPostLsitVC ()
{
    EventPostCell *cellEventDummy;
    UIImageView *noPostImage;
}
@end

static NSString *CellIdentifier = @"EventPostCell";


@implementation EventPostLsitVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _arrTableview=[[NSMutableArray alloc]init];
    _arryCells=[[NSMutableArray alloc]init];

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    cellEventDummy = (EventPostCell *)[nib objectAtIndex:0];
    
    
    
    [self initialSetupDidLoad];
    
    noPostImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splashscreen"]];
    noPostImage.frame=CGRectMake(0, _tableView.frame.origin.y, noPostImage.frame.size.width, noPostImage.frame.size.height-100);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (_reload) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [GC showLoader:self withText:@""];
        });
        [self getFestEventPosts];
    }


}
-(void)viewDidDisappear:(BOOL)animated{
    [self stopCurrentVideoPlaybackForAllCellsExcept:nil];

    [super viewDidDisappear:animated];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)dealloc{

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MyMethods
-(void)initialSetupDidLoad{
 
    
    UIButton *btnBack = (id)[_viewTopbar viewWithTag:100];
    UILabel *lblTop = (id)[_viewTopbar viewWithTag:101];
    
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    lblTop.font = [UIFont fontWithName:LatoRegular size:18.0];
    [lblTop setTextColor:COLOR_TEAL];
    [lblTop setText:_strTitle];

    UIButton *btnAdd=(id)[_viewTopbar viewWithTag:102];
    [btnAdd setTitleColor:COLOR_TEAL forState:UIControlStateNormal];
    [btnAdd setHidden:YES];
    
    
    [_btnUpload setBackgroundColor:[UIColor whiteColor]];
    [_btnUpload.layer setCornerRadius:CGRectGetWidth(_btnUpload.frame)/2];
    [_btnUpload.layer setBorderWidth:2];
    [_btnUpload.layer setBorderColor:COLOR_TEAL.CGColor];
    [_btnUpload setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
    [_btnUpload addTarget:self action:@selector(gotoAddPost) forControlEvents:UIControlEventTouchUpInside];
    
    FestDetailViewController *festDet=nil;

    for(UIViewController *cnt in self.navigationController.viewControllers){
        if ([cnt isKindOfClass:[FestDetailViewController class]])
        {
            festDet=(id)cnt;
            self.dictFestDetails=festDet.arrFestDetails.firstObject;
            break;
        }
    }
    
    _reload=YES;
    
    
    
    [_tableView setHidden:YES];
    [self updateUIForAddPost];
    
    
    NSLog(@"dictDetails: %@", _dictFestDetails);
    
}
-(void)updateUIForAddPost{

    /*
     Users can post and view comments in a fest if they are within the fest radius.
     Users can view the posts if they are outside the fest radius, but within 50miles [no posting]
     Users wont see or be able to post in the fest if they are outside 50miles.
     */
    
//    UIButton *btnAdd=(id)[_viewTopbar viewWithTag:102];
    
    _enablePost=NO;

    if ([self amIWithinTheFestRadius]){
        _enablePost=YES;
    }

//    [btnAdd setHidden:!_enablePost];
    
    if (_enablePost) {
        [_btnUpload setHidden:NO];
        [_viewUploadBg setHidden:NO];
        
    }
    else{
        
        [_btnUpload setHidden:YES];
        [_viewUploadBg setHidden:YES];

        
        CGRect rec=_tableView.frame;
        rec.size.height+=_btnUpload.frame.size.height;
        [_tableView setFrame:rec];
    }
    
}

-(BOOL)amIWithinTheFestRadius{
    
    /*
    Users can post and view comments in a fest if they are within the fest radius.
     */
    
    
    double festLat=[[_dictFestDetails objectForKey:@"Latitude"] doubleValue];
    double festLon=[[_dictFestDetails objectForKey:@"Longitude"] doubleValue];
    double festRadius=[[_dictFestDetails objectForKey:@"Miles"] doubleValue];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[APPDELEGATE delLatitude] longitude:[APPDELEGATE delLongitude]];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:festLat longitude:festLon];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    distance = distance/1609.34;
    
    if(distance<=festRadius)
    {
        return YES;
    }
    
    return NO;
}
-(IBAction)gotoAddPost{
    DISPLAY_METHOD_NAME;
    
//    AddEventPostVC *addPost=[[ILLogic storyboardNoAutolayout] instantiateViewControllerWithIdentifier:@"AddEventPost"];
//    addPost.dictFestDetails=self.dictFestDetails;
//    addPost.obEventList=self;
//    [self.navigationController pushViewController:addPost animated:NO];
    
    [self stopCurrentVideoPlaybackForAllCellsExcept:nil];
   /* DISPLAY_METHOD_NAME;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery",@"Capture",nil];
    [actionSheet showInView:self.view];
    */
    [self openCamera];
    
}
-(void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateTableView:(NSArray*)arr{
    
    [self stopCurrentVideoPlaybackForAllCellsExcept:nil];
    [_arrTableview removeAllObjects];
    [_arrTableview addObjectsFromArray:arr];
    [_tableView reloadData];
    
    if(!arr.count){
        
        [self.view addSubview:noPostImage];
       // [self showAlertView_CF:@"" message:@"No posts found"];
    }
    else
    {
        [noPostImage removeFromSuperview];
        [_tableView setHidden:NO];
    }
}
-(void)getFestEventPosts{
    
//    TEST_MODE;
//    NSArray *arr=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"festPostsList.txt" ofType:nil]];
//    [self updateTableView:arr];
//    return;
//    TEST_MODE;
    
    _reload=NO;

//    dispatch_async(dispatch_get_main_queue(), ^{
//        [GC showLoader:self withText:@""];
//    });
    

    
    NSString *festId=[self.dictFestDetails objectForKey:@"Id"];

    NSMutableDictionary *d=[NSMutableDictionary new];
    
    [d setObject:festId forKey:@"EventId"];
    [d setObject:@"" forKey:@"LastReceivedChatId"];
    [d setObject:@"50" forKey:@"NoOfRows"];
    [d setObject:@"2" forKey:@"NoOfComments"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagGetAllEventPosts andDictionary:d andDelegate:self];
    });
}

- (IBAction)btnUploadClicked:(id)sender {
    DISPLAY_METHOD_NAME;
    
    [self openCamera];
}
-(void)stopCurrentVideoPlaybackForAllCellsExcept:(EventPostCell*)cellParam{
    for(EventPostCell *cell in _arryCells){
        
        if ([cellParam isEqual:cell]) {
            NSLog(@"same cell");
        }
        
        if ([cell respondsToSelector:@selector(removeMoviePlayer)] && ![cellParam isEqual:cell]) {
            [cell removeMoviePlayer];
        }
    }
    
}
-(void)imageUpload{
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    NSString *festId=[self.dictFestDetails objectForKey:@"Id"];
    
    NSData *datIm=self.dataUpload;
    NSData *datImThUmb=self.dataThumb;
    
    NSString *lat=[NSString stringWithFormat:@"%f", [APPDELEGATE delLatitude]];
    NSString *lon=[NSString stringWithFormat:@"%f", [APPDELEGATE delLongitude]];
    NSString *title=@"";

    
    [d setObject:festId forKey:@"EventId"];
    [d setObject:datIm forKey:@"Message"];
    [d setObject:@"1" forKey:@"Type"];
    [d setObject:lat forKey:@"Latitude"];
    [d setObject:lon forKey:@"Longitude"];
    [d setObject:title forKey:@"Title"];
    [d setObject:@"0" forKey:@"MediaType"];  // image
    [d setObject:datImThUmb forKey:@"ThumbPath"];
    [d setObject:@".png" forKey:@"MediaExtension"];
    [d setObject:@".jpg" forKey:@"ThumbExtension"];
    [d setObject:_resolutionImgOrVid forKey:@"Resolution"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GC showLoader:self withText:@""];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagCreateEventPost andDictionary:d andDelegate:self];
    });
    
    
    
    
    
}
-(void)videoUpload{
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    
    NSString *festId=[self.dictFestDetails objectForKey:@"Id"];
    
    NSData *datVid=self.dataUpload;
    NSData *datImThUmb=self.dataThumb;
    
    NSString *lat=[NSString stringWithFormat:@"%f", [APPDELEGATE delLatitude]];
    NSString *lon=[NSString stringWithFormat:@"%f", [APPDELEGATE delLongitude]];
    NSString *title=@"";
    
    
    NSString *extension=[NSString stringWithFormat:@".%@", _videoExtension];
    
    
    [d setObject:festId forKey:@"EventId"];
    [d setObject:datVid forKey:@"Message"];
    [d setObject:@"1" forKey:@"Type"];
    [d setObject:lat forKey:@"Latitude"];
    [d setObject:lon forKey:@"Longitude"];
    [d setObject:title forKey:@"Title"];
    [d setObject:@"1" forKey:@"MediaType"]; //video
    [d setObject:datImThUmb forKey:@"ThumbPath"];
    [d setObject:@".jpg" forKey:@"ThumbExtension"];
    [d setObject:extension forKey:@"MediaExtension"];
    [d setObject:_resolutionImgOrVid forKey:@"Resolution"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GC showLoader:self withText:@""];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagCreateEventPost andDictionary:d andDelegate:self];
    });
    
}
-(void)initiateAutoplay{
    //    NSArray *arrVisible=[_tableView visibleCells];
    NSArray *arrVisibleIndx=[_tableView indexPathsForVisibleRows];
    
    
    //    for(EventPostCell *cell in _arryCells){
    //
    //        if([arrVisible containsObject:cell])
    //        {
    //            CGRect cellRect = [_tableView rectForRowAtIndexPath:indexPath];
    //            BOOL completelyVisible = CGRectContainsRect(_tableView.bounds, cellRect);
    //        }
    //
    //    }
    
    NSIndexPath *selected=[arrVisibleIndx firstObject];
    
    float hgtIntersection=0;
    
    for(NSIndexPath *indx in arrVisibleIndx){
        
        NSDictionary *dictPost=[_arrTableview objectAtIndex:indx.row];
        NSInteger type = [[dictPost objectForKey:@"Type"] integerValue];
        NSInteger mediaType=[[dictPost objectForKey:@"MediaType"] integerValue];
        
        
        CGRect cellRect = [_tableView rectForRowAtIndexPath:indx];
        CGRect recIntersect = CGRectIntersection(cellRect, _tableView.bounds);
        
        if (recIntersect.size.height>hgtIntersection && type==1 && mediaType==1) {
            hgtIntersection=recIntersect.size.height;
            selected=indx;
        }
        
        NSLog(@"frame: %@", NSStringFromCGRect(recIntersect));
        NSLog(@"indx: %@", indx);
    }
    
    
    if (hgtIntersection>minVisbileHeightForVideoPlayback) 
    {
        @try {
            EventPostCell *cell=(id)[_tableView cellForRowAtIndexPath:selected];
            if (cell.alMoviePlayer.playbackState!=MPMoviePlaybackStatePlaying) {
                [cell playVideo];
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception.description);
        }
        @finally {
            
        }
    }
    else{
        
        
        NSLog(@"indxHgtLow: %@", selected);
        NSLog(@"hgtIntersection: %f", hgtIntersection);
    }
    
    

}
#pragma mark - Open Camera
-(void)openCamera
{
   /* if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing=NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: picker.sourceType];
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        picker.videoMaximumDuration = 60.0;
        [self presentViewController:picker animated:NO completion:nil];
        
    }
    */
    [self openCamera_CF];
}
-(void)openCamera_CF
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _tagUploading = tagUploadImageCamera;
        
        UIImagePickerController *takePhoto=[[UIImagePickerController alloc] init];
        takePhoto.delegate=(id)self;
        takePhoto.allowsEditing=NO;
        takePhoto.sourceType=UIImagePickerControllerSourceTypeCamera;
        takePhoto.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: takePhoto.sourceType];
        
        [self presentViewController:takePhoto animated:NO completion:nil];
    }
    else
    {
        [self showAlertView_CF:@"" message:No_Camera];
    }
}

#pragma mark - Open Gallery

-(void)openImageGallery_CF
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _tagUploading = tagUploadImageGalley;
        
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing=NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: picker.sourceType];
        [self presentViewController:picker animated:NO completion:nil];
        
    }
}

#pragma mark - Capture Video
/*-(void)captureVideo_CF
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _tagUploading = tagUploadVideoCamera;
        
        UIImagePickerController *pickerVideo=[[UIImagePickerController alloc] init];
        pickerVideo.delegate=(id)self;
        pickerVideo.allowsEditing=YES;
        pickerVideo.sourceType=UIImagePickerControllerSourceTypeCamera;
        pickerVideo.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        pickerVideo.videoQuality = UIImagePickerControllerQualityTypeMedium;
        pickerVideo.videoMaximumDuration = 60.0;
        pickerVideo.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: picker.sourceType];
        
        [self.navigationController presentViewController:pickerVideo animated:NO completion:nil];
        
    }
    else
    {
        [self showAlertView_CF:@"" message:No_Camera];
    }
}

#pragma mark - Get Video From Gallery
-(void)getVideoFromGallery_CF
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        _tagUploading = tagUploadVideoGalley;
        
        UIImagePickerController *takeVideo=[[UIImagePickerController alloc] init];
        takeVideo.delegate=(id)self;
        takeVideo.allowsEditing=YES;
        takeVideo.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        takeVideo.mediaTypes=[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        
        [self presentViewController:takeVideo animated:NO completion:nil];
    }
}
*/

#pragma mark - Tableview Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *d=[_arrTableview objectAtIndex:indexPath.row];
    return [cellEventDummy heightForTheCellWithPostData:d];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrTableview.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    EventPostCell *cell = (EventPostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (EventPostCell *)[nib objectAtIndex:0];
        [_arryCells addObject:cell];
    }
    
    cell.indexPath=indexPath;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *d=[_arrTableview objectAtIndex:indexPath.row];
    [cell updateUIBasedOnPostData:d withDelegate:self];
    
    NSInteger type=[[d objectForKey:@"Type"] integerValue];
    NSString *title=@"";
    if (type==0) {
        title=[d objectForKey:@"Message"];
    }
    else{
        title=[d objectForKey:@"Title"];
        [cell.imgVPost setContentMode:UIViewContentModeScaleAspectFit];
        [cell.imgVPost setBackgroundColor:COLOR_TEAL];
        
        NSURL *url=[NSURL URLWithString:[d objectForKey:@"Message"]];
        if ([[d objectForKey:@"MediaType"] integerValue]==0) {
//            image

            [cell.imgVPost sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_icon_transparent"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
                {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
                else if(image){
                    cell.imgVPost.image = image;
                    [cell.imgVPost setContentMode:UIViewContentModeScaleAspectFill];
                }
            }];
            
            
        }
        else{
//            video
            NSURL *urlThumb=[NSURL URLWithString:[d objectForKey:@"ThumbPath"]];
//            [cell.imgVPost setImageWithURL:urlThumb placeholderImage:[UIImage imageNamed:@"icon_fb"]];
            [cell.imgVPost sd_setImageWithURL:urlThumb placeholderImage:[UIImage imageNamed:@"default_icon_transparent"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
                {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
                else if(image){
                    cell.imgVPost.image = image;
                    [cell.imgVPost setContentMode:UIViewContentModeScaleAspectFill];
                }
            }];
            
        }
    }
    
    
//    [cell.imgUserPic setImageWithURL:[NSURL URLWithString:[d objectForKey:@"UserImage"]]];
    NSURL *urluserPic=[NSURL URLWithString:[d objectForKey:@"UserImage"]];
    [cell.imgUserPic setContentMode:UIViewContentModeScaleAspectFit];
    [cell.imgUserPic sd_setImageWithURL:urluserPic placeholderImage:[UIImage imageNamed:@"default_icon_transparent"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
        {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if(image){
            cell.imgUserPic.image = image;
        }
    }];
    
    cell.lblPostTitle.text=title;
    
    NSString *fName=([d objectForKey:@"FirstName"])?[d objectForKey:@"FirstName"]:@"";
    NSString *lName=([d objectForKey:@"LasttName"])?[d objectForKey:@"LasttName"]:@"";
    
    [cell.lblUserName setText:[NSString stringWithFormat:@"%@ %@", fName, lName]];
    
    TEST_MODE;
//    [cell performSelector:@selector(playVideo) withObject:nil afterDelay:0.5]; 
    TEST_MODE;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - BackendMangaer Delegate
-(void)backendConnectionSuccess:(BOOL)flagSuccess withResponse:(NSDictionary*)dictResponse andConnectionTag:(ConnectionTags)connectionTag{

  
    if(flagSuccess){
        
        if (connectionTag==connectionTagGetAllEventPosts) {
            
            NSArray *arr=[dictResponse objectForKey:@"Data"];
            [self updateTableView:arr];
            [GC hideLoader];

        }
        else if (connectionTag==connectionTagLikeDisLikeEventPost){
            
            [self getFestEventPosts];
            
        }
        else if (connectionTag==connectionTagCreateEventPost){
            
            _reload=YES;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [GC showLoader:self withText:@""];
//            });
            [self getFestEventPosts];
        }
        else{
            [GC hideLoader];
        }
    }
    else{
        [GC hideLoader];
    }
}

#pragma mark - Event Cell delegate
-(void)btnLikeClicked:(NSDictionary*)dict{
    DISPLAY_METHOD_NAME;
    
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    UserModel *userModel = [[GC arrUserDetails] firstObject];
    
    [d setObject:[[dict objectForKey:@"PostID"] stringVal] forKey:@"EventChatId"];
    [d setObject:userModel.localID forKey:@"UserId"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GC showLoader:self withText:@""];
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagLikeDisLikeEventPost andDictionary:d andDelegate:self];
    });
    
}
-(void)btnLikeCountClicked:(NSDictionary*)dict{
    DISPLAY_METHOD_NAME;
    
    
    /*
     Get Event Likes List
     URL: http://54.69.37.46/festapp.api.com/api/EventPosts/
     GetLikersList
     Type:POST
     Request:{"UserToken":{"AuthToken":"1136917495","Id":7},"EventChatId":154}
     
     */
    
    BroadcastEventsLikesVC *likes=[[ILLogic storyboardNoAutolayout] instantiateViewControllerWithIdentifier:@"BroadcastEventsLikes"];
    likes.dictPostDetails=dict;
    [self.navigationController pushViewController:likes animated:YES];
    
}
-(void)videoPlayBackStarting:(EventPostCell *)cell
{
    [self stopCurrentVideoPlaybackForAllCellsExcept:cell];
}

#pragma mark - ScrollviewDelegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *arrVisible=[_tableView visibleCells];

    
    for(EventPostCell *cell in _arryCells){
        
        
        if([arrVisible containsObject:cell])
        {
            
        }
        else{
            if ([cell respondsToSelector:@selector(removeMoviePlayer)]) {
                [cell removeMoviePlayer];
            }
        }
    }
    
    for(EventPostCell *cellVisible in arrVisible){
        [cellVisible scrollViewDidScroll:scrollView andTableView:_tableView];
        
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"decelerate: %zd", decelerate);
    if (!decelerate) {
        [self initiateAutoplay];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self initiateAutoplay];
}
#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //NSLog(@"buttonIndex=>%ld",(long)buttonIndex);
    
    
    
    switch (buttonIndex) {
        case 0:{
            [self performSelectorOnMainThread:@selector(openImageGallery_CF) withObject:nil waitUntilDone:YES];
        }
            
            break;
        case 1:{
            [self performSelectorOnMainThread:@selector(openCamera_CF) withObject:nil waitUntilDone:YES];
        }
            
            break;
            
            
        default:
            break;
    }
}
#pragma mark - Image Picker Controller Delegates
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:^{
        [GC showLoader];
        float widThumb=320.0;
        
        BOOL isImage =FALSE;
        
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage] )
        {
            isImage=TRUE;
        }
        else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie] )
        {
            isImage=FALSE;
        }
        
        if (isImage==TRUE)
        {
            
            float phoneResolWidth=SCREEN_WIDTH*[[UIScreen mainScreen] scale];
            
            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
            
            if (image.size.width>phoneResolWidth) {
                UIImage *resizedBig=[ILLogic resizeImageWithImage:image scaledToWidth:phoneResolWidth];
                self.dataUpload = UIImagePNGRepresentation(resizedBig);
            }
            else{
                self.dataUpload = UIImagePNGRepresentation(image);
            }
            
            UIImage *imgD=[UIImage imageWithData:self.dataUpload];
            _resolutionImgOrVid=[NSString stringWithFormat:@"%.0f,%.0f", imgD.size.width, imgD.size.height];
            
            
            if (image.size.width>widThumb) {
                UIImage *resizedSmall=[ILLogic resizeImageWithImage:image scaledToWidth:widThumb];
                self.dataThumb=UIImageJPEGRepresentation(resizedSmall, 1);
            }
            else{
                self.dataThumb=UIImageJPEGRepresentation(image, 1);
            }
            
            [self imageUpload];
        }
        else if (isImage==FALSE){
            NSURL *urlVideo = [info objectForKey:UIImagePickerControllerMediaURL];
            if(_tagUploading==tagUploadVideoCamera){
                UISaveVideoAtPathToSavedPhotosAlbum([urlVideo path], nil, nil, nil);
            }
            
            self.videoExtension=[urlVideo pathExtension];
            
            AVAssetTrack *videoTrack = nil;
            AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:urlVideo options:nil];
            
            
            NSArray *videoTracks = [asset1 tracksWithMediaType:AVMediaTypeVideo];
            CMFormatDescriptionRef formatDescription = NULL;
            NSArray *formatDescriptions = [videoTrack formatDescriptions];
            if ([formatDescriptions count] > 0)
                formatDescription = (__bridge CMFormatDescriptionRef)[formatDescriptions objectAtIndex:0];
            
            if ([videoTracks count] > 0)
                videoTrack = [videoTracks objectAtIndex:0];
            
            CGSize trackDimensions = {
                .width = 0.0,
                .height = 0.0,
            };
            trackDimensions = [videoTrack naturalSize];
            //        NSInteger width = trackDimensions.width;
            //        NSInteger height = trackDimensions.height;
            
            
            self.dataUpload = [NSData dataWithContentsOfURL:urlVideo];
            
            AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
            generate1.appliesPreferredTrackTransform = YES;
            NSError *err = NULL;
            CMTime time = CMTimeMake(1, 2);
            CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
            UIImage *thumb = [[UIImage alloc] initWithCGImage:oneRef];
            NSLog(@"sizeImg: %@", NSStringFromCGSize(thumb.size));
            NSLog(@"sizeVid: %@", NSStringFromCGSize(trackDimensions));
            
            TEST_MODE;
            //        if (thumb.size.height>thumb.size.width) {
            //            _resolutionImgOrVid=[NSString stringWithFormat:@"%zd,%zd", height, width]; // because width and height are getting interchanged *****
            //        }
            //        else{
            //            _resolutionImgOrVid=[NSString stringWithFormat:@"%zd,%zd", width, height];
            //        }
            
            _resolutionImgOrVid=[NSString stringWithFormat:@"%.0f,%.0f", thumb.size.width, thumb.size.height]; // // because width and height are getting interchanged, if we take video resolution in portrait *****
            NSLog(@"_resolutionImgOrVid: %@", _resolutionImgOrVid);
            
            TEST_MODE;
            
            
            if (thumb.size.width>widThumb) {
                UIImage *resizedSmall=[ILLogic resizeImageWithImage:thumb scaledToWidth:widThumb];
                self.dataThumb=UIImageJPEGRepresentation(resizedSmall, 1);
            }
            else{
                self.dataThumb=UIImageJPEGRepresentation(thumb, 1);
            }
            
//            [GC hideLoader];
            [self videoUpload];

        }
        
        NSLog(@"upload size: %.2f MB", _dataUpload.length/(1024.0*1024));
        NSLog(@"upload thumb size: %.2f MB", _dataThumb.length/(1024.0*1024));
        
        
        TEST_MODE;
        
        //        [_btnUpload setImage:[UIImage imageWithData:self.dataThumb] forState:UIControlStateNormal];
        

        TEST_MODE;
    }];
    
    
    
}

@end
