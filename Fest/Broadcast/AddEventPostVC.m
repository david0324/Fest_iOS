//
//  AddEventPostVC.m
//  Fest
//
//  Created by Denow Cleetus on 18/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "AddEventPostVC.h"
#import <AVFoundation/AVFoundation.h>
#import "BackendManager.h"
#import "EventPostLsitVC.h"

#define PLACEHOLDER_TEXT @"Whats in your mind..."




@interface AddEventPostVC ()

@end

@implementation AddEventPostVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetupDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    DISPLAY_METHOD_NAME;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notifications
-(void)textViewTextChanged:(NSNotification*)not{
    DISPLAY_METHOD_NAME;
    
    
    UITextView *textView=[not object];
    if (!textView.text.length) {
        textView.textColor = [UIColor lightGrayColor];
        [textView setText:PLACEHOLDER_TEXT];
        
    }
    else if ([textView.text isEqualToString:PLACEHOLDER_TEXT]) {
        textView.text=@"";
    }
    else{
        textView.textColor = [UIColor blackColor];
    }
    
}
#pragma mark - MyMethods
-(void)initialSetupDidLoad{
    UIButton *btnBack = (id)[_viewTopbar viewWithTag:100];
    UILabel *lblTop = (id)[_viewTopbar viewWithTag:101];
    
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    lblTop.font = [UIFont fontWithName:LatoRegular size:18.0];
    lblTop.font = [UIFont fontWithName:LatoBold size:20];
    [lblTop setTextColor:COLOR_TEAL];
    [lblTop setText:@"Update Status"];
 
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];;
    
    [_txtViewStatus setDelegate:self];
    [_txtViewStatus setFont:[UIFont fontWithName:LatoRegular size:15]];
 
    [_btnPost setTitleColor:COLOR_TEAL forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont fontWithName:LatoBold size:15]];
    [_btnPost.titleLabel setFont:[UIFont fontWithName:LatoBold size:15]];
    
    [_lblUpload setFont:[UIFont fontWithName:LatoRegular size:18]];
    [_lblUpload setTextColor:COLOR_TEAL];
    [_lblUpload.layer setCornerRadius:3];
    [_lblUpload setClipsToBounds:YES];;
//    [_lblUpload setBackgroundColor:_imgVThumb.backgroundColor];

    
    [_btnCancel addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnPost addTarget:self action:@selector(btnPostClicked) forControlEvents:UIControlEventTouchUpInside];

    [_btnUpload setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
    [_btnUpload.layer setCornerRadius:CGRectGetHeight(_btnUpload.frame)/2.0];
    [_btnUpload.layer setBorderColor:COLOR_TEAL.CGColor];
    [_btnUpload.layer setBorderWidth:2];
    [_btnUpload setBackgroundColor:[UIColor whiteColor]];
    [_btnUpload setTitle:nil forState:UIControlStateNormal]; 
    [_btnUpload setClipsToBounds:YES];
    
    [_imgVThumb setHidden:NO];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChanged:) name:UITextViewTextDidChangeNotification object:nil];
}
-(void)btnBackClicked{
       DISPLAY_METHOD_NAME;
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)btnPostClicked{
    DISPLAY_METHOD_NAME;
    
    if (_tagUploading==tagUploadImageCamera || _tagUploading==tagUploadImageGalley)
    {
        [self imageUpload];
    }
    else if (_tagUploading==tagUploadVideoCamera || _tagUploading==tagUploadVideoGalley)
    {
        [self videoUpload];
    }
    else if(_txtViewStatus.text.length && ![_txtViewStatus.text isEqualToString:PLACEHOLDER_TEXT])
    {
        [self textUpload];
    }
    else{
        [self showAlertView_CF:@"Sorry !!" message:@"Nothing to post"];
    }
    
}
-(void)hideKeyboard{
    [self.view endEditing:YES];
    [self updateTextViewText];
}
-(void)updateTextViewText{
    if (!_txtViewStatus.text.length) {
        [_txtViewStatus setText:PLACEHOLDER_TEXT];
        _txtViewStatus.textColor = [UIColor lightGrayColor];
    }
}
-(IBAction)btnUploadClicked{
    DISPLAY_METHOD_NAME;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Pictures Gallery",@"Take a picture",@"Take a Video",@"Video Gallery",nil];
    [actionSheet showInView:self.view];
    
    
}
-(void)textUpload{
    DISPLAY_METHOD_NAME;
    
    NSString *festId=[self.dictFestDetails objectForKey:@"Id"];
    
    NSString *lat=[NSString stringWithFormat:@"%f", [APPDELEGATE delLatitude]];
    NSString *lon=[NSString stringWithFormat:@"%f", [APPDELEGATE delLongitude]];
    NSString *title=_txtViewStatus.text;
    if([title isEqualToString:PLACEHOLDER_TEXT]){
        title=@"";
    }
    
    
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    [d setObject:festId forKey:@"EventId"];
    [d setObject:title forKey:@"Message"];
    [d setObject:@"0" forKey:@"Type"];
    [d setObject:lat forKey:@"Latitude"];
    [d setObject:lon forKey:@"Longitude"];
    [d setObject:@"" forKey:@"Resolution"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GC showLoader:self withText:@""];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagCreateEventPost andDictionary:d andDelegate:self];
    });
    

}
-(void)imageUpload{
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    
    NSString *festId=[self.dictFestDetails objectForKey:@"Id"];

    NSData *datIm=self.dataUpload;
    NSData *datImThUmb=self.dataThumb;

    
    
    
    NSString *lat=[NSString stringWithFormat:@"%f", [APPDELEGATE delLatitude]];
    NSString *lon=[NSString stringWithFormat:@"%f", [APPDELEGATE delLongitude]];
    NSString *title=_txtViewStatus.text;
    if([title isEqualToString:PLACEHOLDER_TEXT]){
        title=@"";
    }
    
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
    NSString *title=_txtViewStatus.text;
    if([title isEqualToString:PLACEHOLDER_TEXT]){
        title=@"";
    }

    
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
#pragma mark - Textview Delegates
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACEHOLDER_TEXT]) {
        textView.text=@"";
    }
    return YES;
}

#pragma mark - Open Camera
-(void)openCamera_CF
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _tagUploading = tagUploadImageCamera;

        UIImagePickerController *takePhoto=[[UIImagePickerController alloc] init];
        takePhoto.delegate=(id)self;
        takePhoto.allowsEditing=NO;
        takePhoto.sourceType=UIImagePickerControllerSourceTypeCamera;

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

        [self presentViewController:picker animated:NO completion:nil];
        
    }
}

#pragma mark - Capture Video
-(void)captureVideo_CF
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
        pickerVideo.mediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];

        [self.navigationController presentViewController:pickerVideo animated:NO completion:nil];
        
    }
    else
    {
        [self showAlertView_CF:@"" message:No_Camera];
    }
}
-(BOOL)prefersStatusBarHidden{
    return NO;
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
-(void)updateUIafterUpload{
    
    [self.imgVThumb setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgVThumb setClipsToBounds:YES];
    
    if (_tagUploading==tagUploadImageCamera || _tagUploading==tagUploadImageGalley)
    {
        [self.imgVVidId setHidden:YES];
    }
    else if (_tagUploading==tagUploadVideoCamera || _tagUploading==tagUploadVideoGalley){
        [self.imgVVidId setHidden:NO];
    }
    [self.imgVThumb setImage:[UIImage imageWithData:self.dataThumb]];
    [_imgVThumb setHidden:NO];
    [_lblUpload setHidden:YES];
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
            
        case 2:{
            [self performSelectorOnMainThread:@selector(captureVideo_CF) withObject:nil waitUntilDone:YES];
        }
            
            break;
        case 3:
        {
            [self performSelectorOnMainThread:@selector(getVideoFromGallery_CF) withObject:nil waitUntilDone:YES];
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
        
        
        if (_tagUploading==tagUploadImageCamera || _tagUploading==tagUploadImageGalley)
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
            
        }
        else if (_tagUploading==tagUploadVideoCamera || _tagUploading==tagUploadVideoGalley){
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
            
            [GC hideLoader];
        }
        
        NSLog(@"upload size: %.2f MB", _dataUpload.length/(1024.0*1024));
        NSLog(@"upload thumb size: %.2f MB", _dataThumb.length/(1024.0*1024));
        
        
        TEST_MODE;
        
//        [_btnUpload setImage:[UIImage imageWithData:self.dataThumb] forState:UIControlStateNormal];
        
        [self updateUIafterUpload];
        TEST_MODE;
    }];

    

}

#pragma mark - BackendMangaer Delegate
-(void)backendConnectionSuccess:(BOOL)flagSuccess withResponse:(NSDictionary*)dictResponse andConnectionTag:(ConnectionTags)connectionTag{
    if(flagSuccess){
        [self.obEventList setReload:YES];
//        [self showAlertView_CF:nil message:@"post successfull"];
        [self btnBackClicked];
    }
    else{
        [GC hideLoader];
    }
    
}

@end
