//
//  ProfileViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 22/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "ProfileViewController.h"
#import "ResetViewController.h"
//#import "RESideMenu.h"
#import "CellProfile.h"
#import "UserModel.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize view_header,tableProfile,lbl_header,btnMenu,arrTitles,arrContents,btnProfile1,btnProfile2,btnProfile3,btnProfile4,btnProfile5,btnProfile6,isCamera,flag_btn,btnBack;

int id2,id3,id4,id5,id6;

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
    
    
    isCamera = NO;
    flag_btn = 0;
    id2=0;
    id3=0;
    id4=0;
    id5=0;
    id6=0;
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    
    //[self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    self.tableProfile.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //self.tableProfile.separatorColor=[UIColor grayColor];
    //self.tableProfile.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    lbl_header.font=[UIFont fontWithName:LatoRegular size:18.0];
    
    [self.imgProfile1 setClipsToBounds:YES];
    self.imgProfile1.layer.masksToBounds = YES;
    self.imgProfile1.layer.cornerRadius = ([UIScreen mainScreen].bounds.size.width-10)/2;
    self.imgProfile1.layer.borderWidth=5;
    self.imgProfile1.layer.borderColor=[UIColor colorWithRed:(225/255.0) green:(232/255.0) blue:(242/255.0) alpha:1].CGColor;
    
    
    [self.imgProfile2 setClipsToBounds:YES];
    self.imgProfile2.layer.masksToBounds = YES;
    self.imgProfile2.layer.cornerRadius = 30;
    
    [self.imgProfile3 setClipsToBounds:YES];
    self.imgProfile3.layer.masksToBounds = YES;
    self.imgProfile3.layer.cornerRadius = 30;
    
    [self.imgProfile4 setClipsToBounds:YES];
    self.imgProfile4.layer.masksToBounds = YES;
    self.imgProfile4.layer.cornerRadius = 30;
    
    [self.imgProfile5 setClipsToBounds:YES];
    self.imgProfile5.layer.masksToBounds = YES;
    self.imgProfile5.layer.cornerRadius = 30;
    
    //[self.imgProfile6 setClipsToBounds:YES];
    //self.imgProfile6.layer.cornerRadius = 80;
    
    [self.btnMenu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnEdit setSelected:NO];
    [self.btnEdit setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
    [self.btnEdit setImage:[UIImage imageNamed:@"icon_edit_save"] forState:UIControlStateSelected];
    
    [btnProfile1 setEnabled:NO];
    [btnProfile2 setEnabled:NO];
    [btnProfile3 setEnabled:NO];
    [btnProfile4 setEnabled:NO];
    [btnProfile5 setEnabled:NO];
    [btnProfile6 setEnabled:NO];
    
    btnMe=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnMe];
    [btnMe addTarget:self action:@selector(btnProfileImgClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tapHideProf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideFullProfileImage)];
    [[self viewFullImage] addGestureRecognizer:tapHideProf];
    
    
    CGFloat x = self.view.frame.size.width - 140;
    x = x/2;
    
    /*btnReset = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReset.frame = CGRectMake(x, (self.view.frame.size.height-50), 140, 40);
    btnReset.backgroundColor = setColor(46, 188, 194);
    [btnReset setTitle:@"Reset Number" forState:UIControlStateNormal];
    [btnReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReset.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnReset.titleLabel setFont:[UIFont fontWithName:ProximaNovaSemibold size:17.0]];
    btnReset.layer.cornerRadius = 3.0;
    [btnReset addTarget:self action:@selector(goto_resetView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:btnReset aboveSubview:self.tableProfile];*/
    
    self.userModel = [UserModel new];
    self.userModel = [[GC arrUserDetails] firstObject];
    
    arrTitles=[NSMutableArray arrayWithObjects:@"First Name",@"Last Name", nil];
    
    [GC setParentVC:self];
    
    [GC showLoader:self withText:@"loading data..."];
    
    if(isReach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getProfileData];
            
        });
    }
    else
    {
        [GC hideLoader];
        
        [self showAlert_Profile:@"" message:No_Internet];
    }
    
    [self getFbProfileImage];

}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self setupUI];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if(self.localID.length != 0)
    {
        btnMenu.hidden = YES;
        
        btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(0, 30, 50, 30);
        [btnBack setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.view_header addSubview:btnBack];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MyMethods
-(void)setupUI{
    UIImageView *viewOuter = (UIImageView*)[self.view viewWithTag:99];
    [NSLayoutConstraint deactivateConstraints:viewOuter.constraints];
    float offset = 6;
    [viewOuter setFrame:CGRectMake(5, self.imgProfile1.frame.origin.y-offset, [UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.width-10)];
    
    [NSLayoutConstraint deactivateConstraints:btnMe.constraints];
    [btnMe setFrame:viewOuter.frame];
    [btnMe setCenter:CGPointMake(SCREEN_WIDTH/2.0, btnMe.frame.size.height/2.0 + view_header.frame.size.height+ viewOuter.frame.origin.y)];
    [btnMe setBackgroundColor:[UIColor clearColor]];
    
    
}
- (UIImage*)resizeImageWithImage:(UIImage*)image scaledToHeight:(float)newHeight
{
    float newWidth=newHeight*image.size.width/image.size.height*1.0;
    
    newWidth=round(newWidth);
    
    CGSize newSize=CGSizeMake(newWidth, newHeight);
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
-(UIView*)viewFullImage{
    return [self.view viewWithTag:100];
}
-(IBAction)btnProfileImgClicked:(id)sender{
    DISPLAY_METHOD_NAME;
    
    [[self viewFullImage] setHidden:NO];
    [self.view bringSubviewToFront:[self viewFullImage]];
    
}
-(void)hideFullProfileImage{
    [[self viewFullImage] setHidden:YES];
    id sub=[self viewFullImage];
    UIScrollView *sc=[[sub subviews]lastObject];
    [sc setZoomScale:1.0];
}
-(void)getFbProfileImage{
    
    ILLog(@"[GC arrUserDetails]: %@", [GC arrUserDetails]);
    ILLog(@"user: %@", self.userModel);

    
}
-(void)updateProfileImage:(UIImage*)img{
    [self.imgProfile1 setImage:img];
    
    id sub=[self viewFullImage];
    UIScrollView *sc=[[sub subviews]lastObject];
    [sc setBackgroundColor:[UIColor blackColor]];
    
    sc.scrollEnabled = NO;
    sc.minimumZoomScale = 1.0;
    sc.maximumZoomScale = 3.0;
    sc.delegate=self;

    
    
    
    UIImageView *imgViewFull=[[sc subviews] firstObject];
    [imgViewFull setContentMode:UIViewContentModeScaleAspectFit];
    [imgViewFull setImage:img];
    [imgViewFull setBackgroundColor:[UIColor clearColor]];
    
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    
    UIImageView *imgViewFull=[[aScrollView subviews] firstObject];

    return imgViewFull;
}
#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellProfile *cellProfile = [tableView dequeueReusableCellWithIdentifier:CellProfile_ID];
    
    if(cellProfile==nil)
    {
        cellProfile = [(CellProfile *) [ UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellProfile_ID];
    }
    
    cellProfile.lbl_title.font = [UIFont fontWithName:LatoBold size:16.0];
    cellProfile.lbl_content.font = [UIFont fontWithName:LatoRegular size:16.0];

    
    cellProfile.lbl_title.text = [arrTitles objectAtIndex:indexPath.row];
    cellProfile.lbl_content.text = [arrContents objectAtIndex:indexPath.row];
    
    return cellProfile;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight=0.0;
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(140, 11, 170, 21);
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    
    label.text=[arrContents objectAtIndex:indexPath.row];
    
    CGSize max_lblSize=CGSizeMake(170, FLT_MAX);
    
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineBreakMode = label.lineBreakMode;
    
    CGSize curr_lblSize=[label.text boundingRectWithSize:max_lblSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont fontWithName:ProximaNovaRegular size:14.0], NSParagraphStyleAttributeName:para}
                                                 context:nil].size;
    
    
    CGRect new_lblFrame=label.frame;
    new_lblFrame.size.height=curr_lblSize.height;
    label.frame=new_lblFrame;
    
    if(new_lblFrame.size.height<21)
    {
        cellHeight=44;
    }
    else
    {
        cellHeight=new_lblFrame.size.height + 22;
    }
    
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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

#pragma mark - Open Camera
-(void)openCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        isCamera = YES;
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
        [self showAlert_Profile:@"" message:No_Camera];
    }
    
}

#pragma mark - Open Gallery
-(void)openImageGallery
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        isCamera = NO;
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing=NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self addChildViewController:picker];
        [picker didMoveToParentViewController:self];
        [self.view addSubview:picker.view];
    }
}

#pragma mark - Image Picker Delegates
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [picker.view removeFromSuperview];
        [picker removeFromParentViewController];
        
        flag_btn = 0;
        isCamera = NO;
    });
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [GC showLoader];
    
    __block UIImage *selectedImage = [UIImage new];
    
    switch (flag_btn) {
        case 1:{
            selectedImage = [self getProfileImage:picker dictionary:info];
            [self updateProfileImage:selectedImage];
            self.data1=UIImageJPEGRepresentation(selectedImage, 1.0);
        }
            break;
        case 2:{
            
            selectedImage = [self getProfileImage:picker dictionary:info];
            [self.imgProfile2 setImage:selectedImage];
            self.data2=UIImageJPEGRepresentation(selectedImage, 1.0);
        }
            break;
        case 3:{
            selectedImage = [self getProfileImage:picker dictionary:info];
            [self.imgProfile3 setImage:selectedImage];
            self.data3=UIImageJPEGRepresentation(selectedImage, 1.0);
        }
            break;
        case 4:{
            selectedImage = [self getProfileImage:picker dictionary:info];
            [self.imgProfile4 setImage:selectedImage];
            self.data4=UIImageJPEGRepresentation(selectedImage, 1.0);
        }
            break;
        case 5:{
            selectedImage = [self getProfileImage:picker dictionary:info];
            [self.imgProfile5 setImage:selectedImage];
            self.data5=UIImageJPEGRepresentation(selectedImage, 1.0);
        }
            break;
        case 6:{
            selectedImage = [self getProfileImage:picker dictionary:info];
            [self.imgProfile6 setImage:selectedImage];
            self.data6=UIImageJPEGRepresentation(selectedImage, 1.0);
        }
            
            break;
            
        default:
            break;
    }
}

-(UIImage *)getProfileImage:(UIImagePickerController *)picker dictionary:(NSDictionary *)info
{
    UIImage *image = [UIImage new];
    
    isCamera = NO;
    
    [picker.view removeFromSuperview];
    [picker removeFromParentViewController];
    
    image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if(!image){
        image = [UIImage new];
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    [GC hideLoader];
    
    return image;
}

#pragma mark - Show Image Upload Options
-(void)imageUploadOptions
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open Gallery",@"Take a picture",@"Default icon", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Action Sheet Delegate

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (id btn in actionSheet.subviews) {
        
        if([btn isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)btn;
            
            if([button.titleLabel.text isEqualToString:@"Cancel"])
            {
                [button.titleLabel setTextColor:[UIColor redColor]];
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            [self openImageGallery];
        }
            
            break;
        case 1:{
            [self openCamera];
        }
            
            break;
        case 2:{
            
            if(flag_btn==1){
                self.data1=nil;
                [self updateProfileImage:[UIImage imageNamed:@"icon_ghost1"]];
                return;
            }
            else if (flag_btn==2){
                self.data2=nil;
                [self.imgProfile2 setImage:[UIImage imageNamed:@"icon_ghost2"]];
                return;
            }
            else if (flag_btn==3){
                self.data3=nil;
                [self.imgProfile3 setImage:[UIImage imageNamed:@"icon_ghost2"]];
                return;
            }
            else if (flag_btn==4){
                self.data4=nil;
                [self.imgProfile4 setImage:[UIImage imageNamed:@"icon_ghost2"]];
                return;
            }
            else if (flag_btn==5){
                self.data5=nil;
                [self.imgProfile5 setImage:[UIImage imageNamed:@"icon_ghost2"]];
                return;
            }
            else if (flag_btn==6){
                self.data6=nil;
                [self.imgProfile6 setImage:[UIImage imageNamed:@"icon_ghost2"]];
                return;
            }
        }
            flag_btn=0;
            
            break;
            
        default:
            break;
    }
}

#pragma mark - Retrieve Data from Server
-(void)getProfileData
{
    
    if(self.localID.length == 0)
    {
        self.viewToolBar.hidden = NO;
        self.localID = self.userModel.localID;
        [self.tableProfile setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.viewToolBar.frame.size.height, 0)];
    }
    else
    {
        self.btnEdit.hidden = YES;
        self.viewToolBar.hidden = YES;
        [self.tableProfile setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%@",self.localID]  forKey:@"UserId"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,Selected];
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
                
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    [self showAlert_Profile:@"" message:No_Internet];
                else
                    [self showAlert_Profile:@"" message:self.dataRequest.error.localizedDescription];
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *data= [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result == 1)
            {
                NSMutableArray *arrTemp = [NSMutableArray arrayWithObjects:[json valueForKey:@"Data"], nil];
                
                arrContents = [NSMutableArray new];
                
                [arrContents addObject:[NSString stringWithFormat:@"%@",[[arrTemp firstObject] valueForKey:@"FirstName"]]];
                [arrContents addObject:[NSString stringWithFormat:@"%@",[[arrTemp firstObject] valueForKey:@"LastName"]]];
                
                self.lbUserName.text = [NSString stringWithFormat:@"%@ %@",[[arrTemp firstObject] valueForKey:@"FirstName"],[[arrTemp firstObject] valueForKey:@"LastName"]];
                [self.tableProfile reloadData];
                
                NSMutableArray *arrImageData = [[NSMutableArray alloc] initWithArray:[json valueForKeyPath:@"Data.Medias"]];
                
                if(arrImageData.count == 0)
                {
                    UIImage* myImage = [UIImage imageWithData:
                                        [NSData dataWithContentsOfURL:
                                         FBURL([[arrTemp firstObject] valueForKey:@"FacebookId"])]];
                    
                    self.imgProfile1.contentMode = UIViewContentModeScaleAspectFill;
                    
                    [self updateProfileImage:myImage];
                }
                else
                {
                    
                    NSInteger val = 0;
                    NSString *str;
                    NSURL *url;
                    
                    str = [NSString stringWithFormat:@"%@",[[arrTemp firstObject] valueForKey:@"FacebookId"]];
                    
                    [self.imgProfile1 sd_setImageWithURL:FBURL(str) placeholderImage:[UIImage imageNamed:@"icon_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound))
                        {
                            [self showMainImage:imageURL];
                        }
                        else{
                            
                            self.imgProfile1.contentMode = UIViewContentModeScaleAspectFill;
                            
                            [self updateProfileImage:image];
                        }
                    }];
                    
                    
                    for (int i=0; i<arrImageData.count; i++) {
                        
                        str = [NSString stringWithFormat:@"%@",[[arrImageData objectAtIndex:i] valueForKey:@"Path"]];
                        url = [NSURL URLWithString:str];
                        
                        val = [[[arrImageData objectAtIndex:i] valueForKey:@"Tag"] integerValue];
                        
                        switch (val) {
                            case 0:{
                                
                                [self.imgProfile1 sd_setImageWithURL:URL(url) placeholderImage:[UIImage imageNamed:@"icon_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound))
                                    {
                                        [self showMainImage:imageURL];
                                    }
                                    else{
                                        
                                        self.imgProfile1.contentMode = UIViewContentModeScaleAspectFill;
                                        
                                        [self updateProfileImage:image];
                                    }
                                }];
                                
                            }
                                break;
                            case 1:{
                                
                                id2 = [[[arrImageData objectAtIndex:i] valueForKey:@"Id"] intValue];
                                
                                [self.imgProfile2 sd_setImageWithURL:URL(url) placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound))
                                    {
                                        [self.imgProfile2 sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed];
                                    }
                                    else{
                                        self.imgProfile2.image = image;
                                    }
                                }];
                                
                            }
                                break;
                            case 2:{
                                
                                id3 = [[[arrImageData objectAtIndex:i] valueForKey:@"Id"] intValue];
                                
                                [self.imgProfile3 sd_setImageWithURL:URL(url) placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound))
                                    {
                                        [self.imgProfile3 sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed];
                                    }
                                    else{
                                        self.imgProfile3.image = image;
                                    }
                                }];
                                
                            }
                                break;
                            case 3:{
                                
                                id4 = [[[arrImageData objectAtIndex:i] valueForKey:@"Id"] intValue];
                                
                                [self.imgProfile4 sd_setImageWithURL:URL(url) placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound))
                                    {
                                        [self.imgProfile4 sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed];
                                    }
                                    else{
                                        self.imgProfile4.image = image;
                                    }
                                }];
                                
                            }
                                break;
                            case 4:{
                                
                                id5 = [[[arrImageData objectAtIndex:i] valueForKey:@"Id"] intValue];
                                
                                [self.imgProfile5 sd_setImageWithURL:URL(url) placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound))
                                    {
                                        [self.imgProfile5 sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed];
                                    }
                                    else{
                                        self.imgProfile5.image = image;
                                    }
                                }];
                                
                            }
                                break;
                            case 5:{
                                
                                id6 = [[[arrImageData objectAtIndex:i] valueForKey:@"Id"] intValue];
                                
                                [self.imgProfile6 sd_setImageWithURL:URL(url) placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound))
                                    {
                                        [self.imgProfile6 sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon_ghost2"] options:SDWebImageRetryFailed];
                                    }
                                    else{
                                        self.imgProfile6.image = image;
                                    }
                                }];
                                
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                    if(self.imgProfile1.image == nil)
                    {
                        UIImage* myImage = [UIImage imageWithData:
                                            [NSData dataWithContentsOfURL:
                                             [NSURL URLWithString: self.userModel.profileURL]]];
                        
                        [self updateProfileImage:myImage];
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
                        [self showAlert_Profile:@"" message:strFailure];
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
            
            [self showAlert_Profile:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Save Changes
-(void)profileChangeRequest
{
    self.userModel = [[GC arrUserDetails] firstObject];
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    NSMutableDictionary *dicUser = [NSMutableDictionary new];
    [dicUser setObject:self.userModel.localID forKey:@"Id"];
    [dicUser setObject:self.userModel.facebookID forKey:@"FacebookId"];
    [dicUser setObject:self.userModel.firstName forKey:@"FirstName"];
    [dicUser setObject:self.userModel.lastName forKey:@"LastName"];
    [dicUser setObject:self.userModel.birthday forKey:@"DateOfBirth"];
    
    NSMutableArray *arrDevice = [NSMutableArray new];
    NSMutableDictionary *dicDevices = [NSMutableDictionary new];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:deviceTokenKey].length>6)
        [dicDevices setObject:[[NSUserDefaults standardUserDefaults] stringForKey:deviceTokenKey] forKey:@"Udid"];
    else
        [dicDevices setObject:@"" forKey:@"Udid"];
    
    [dicDevices setObject:@"0" forKey:@"Type"];
    [arrDevice addObject:dicDevices];
    
    NSMutableArray *arrMedias = [NSMutableArray new];
    
    
    if(self.data2!=nil){
        if(id2 == 0)
            [arrMedias addObject:@{@"Path":[self.data2 base64EncodedString],@"Type":@"0",@"Tag":@"1"}];
        else
            [arrMedias addObject:@{@"Path":[self.data2 base64EncodedString],@"Type":@"0",@"Tag":@"1",@"Id":[NSString stringWithFormat:@"%d",id2]}];
    }
    
    if(self.data3!=nil){
        if(id3 == 0)
            [arrMedias addObject:@{@"Path":[self.data3 base64EncodedString ],@"Type":@"0",@"Tag":@"2"}];
        else
            [arrMedias addObject:@{@"Path":[self.data3 base64EncodedString ],@"Type":@"0",@"Tag":@"2",@"Id":[NSString stringWithFormat:@"%d",id3]}];
    }
    
    if(self.data4!=nil){
        if(id4 == 0)
            [arrMedias addObject:@{@"Path":[self.data4 base64EncodedString],@"Type":@"0",@"Tag":@"3"}];
        else
            [arrMedias addObject:@{@"Path":[self.data4 base64EncodedString],@"Type":@"0",@"Tag":@"3",@"Id":[NSString stringWithFormat:@"%d",id4]}];
    }
    
    if(self.data5!=nil){
        if(id5 == 0)
            [arrMedias addObject:@{@"Path":[self.data5 base64EncodedString],@"Type":@"0",@"Tag":@"4"}];
        else
            [arrMedias addObject:@{@"Path":[self.data5 base64EncodedString],@"Type":@"0",@"Tag":@"4",@"Id":[NSString stringWithFormat:@"%d",id5]}];
    }
    
    if(self.data6!=nil){
        if(id6 == 0)
            [arrMedias addObject:@{@"Path":[self.data6 base64EncodedString],@"Type":@"0",@"Tag":@"5"}];
        else
            [arrMedias addObject:@{@"Path":[self.data6 base64EncodedString],@"Type":@"0",@"Tag":@"5",@"Id":[NSString stringWithFormat:@"%d",id6]}];
    }
    
    [dicUser setObject:arrDevice forKey:@"Devices"];
    [dicUser setObject:arrMedias forKey:@"Medias"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicUser forKey:@"User"];
    
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,UpdateUser];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:myJSONData]];
    
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        [GC hideLoader];
        
        if([self.dataRequest error])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    [self showAlert_Profile:@"" message:No_Internet];
                else
                    [self showAlert_Profile:@"" message:self.dataRequest.error.localizedDescription];
                
            });
            
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                flag_btn = 0;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showAlert_Profile:@"Success" message:@"You have saved the change(s) successfully."];
                });
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlert_Profile:@"" message:strFailure];
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
            
            [self showAlert_Profile:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Show Alert View
-(void)showAlert_Profile:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - Image Processing
-(void)showMainImage:(NSURL *)url
{
    
    [self.imgProfile1 sd_setImageWithURL:URL(url) placeholderImage:[UIImage imageNamed:@"icon_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(!error){
            [self updateProfileImage:image];
        }
        
    }];
    
}

-(UIImage *)showSubImages:(NSURL*)url imageView:(UIImageView *)imgView
{
    UIImage *img;
    
    return img;
}

#pragma mark - Button Actions
- (IBAction)menuFest:(id)sender {
}

#pragma mark - Upload Images

- (IBAction)upload_image1:(id)sender
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Denied" message:@"Facebook image cannot be changed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)upload_image2:(id)sender
{
    flag_btn = 2;
    [self imageUploadOptions];
}

- (IBAction)upload_image3:(id)sender
{
    flag_btn = 3;
    [self imageUploadOptions];
}

- (IBAction)upload_image4:(id)sender
{
    flag_btn = 4;
    [self imageUploadOptions];
}

- (IBAction)upload_image5:(id)sender
{
    flag_btn = 5;
    [self imageUploadOptions];
}

- (IBAction)upload_image6:(id)sender
{
    flag_btn = 6;
    [self imageUploadOptions];
}

#pragma mark - Edit Profile
- (IBAction)edit_profile:(id)sender
{
    if(!self.btnEdit.isSelected)
    {
        [self.btnEdit setSelected:YES];
        
        [btnProfile1 setEnabled:YES];
        [btnProfile2 setEnabled:YES];
        [btnProfile3 setEnabled:YES];
        [btnProfile4 setEnabled:YES];
        [btnProfile5 setEnabled:YES];
        [btnProfile6 setEnabled:YES];
        
    }
    else
    {
        [self.btnEdit setSelected:NO];
        
        [btnProfile1 setEnabled:NO];
        [btnProfile2 setEnabled:NO];
        [btnProfile3 setEnabled:NO];
        [btnProfile4 setEnabled:NO];
        [btnProfile5 setEnabled:NO];
        [btnProfile6 setEnabled:NO];
        
        if(flag_btn!=0)
        {
            [GC showLoader:self withText:@"saving..."];
            
            if(isReach)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self profileChangeRequest];
                });
            }
            else
            {
                [GC hideLoader];
                [self showAlert_Profile:@"" message:No_Internet];
            }
        }
    }
}

#pragma mark - Go to Reset View
-(IBAction)goto_resetView:(id)sender
{

    TASK_LISTED;
    return;
    
    /*
     - Take out reset number button in the My Profile tab. Remove reset phone button.
     */
    TASK_LISTED;

    
    
    ResetViewController *RV = [self.storyboard instantiateViewControllerWithIdentifier:Reset_ViewController];
    self.localID = @"";
    [self.navigationController pushViewController:RV animated:YES];
}

#pragma mark - Go Back
-(void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
