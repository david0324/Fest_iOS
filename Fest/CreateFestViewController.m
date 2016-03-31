//
//  CreateFestViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 24/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "CreateFestViewController.h"
#import "FindFestViewController.h"
#import "InviteViewController.h"
#import "MyFestViewController.h"
#import "HostViewController.h"
//#import "RESideMenu.h"

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/-"



@interface CreateFestViewController ()

@end

@implementation CreateFestViewController
@synthesize view_header,view_bottom,lbl_header,btnMenu,txtTitle,txtStartDate,txtEndDate,txtTime,txtStreet,txtCity,txtState,txtZipcode,txtViewDescrip,txtViewNotification,scrollFest,sliderDistance,lblDistance,btnPrivate,btnPublic,mytxtfield,mytxtView,isVideo,isCamera,flag_btn,btnUpload1,btnUpload2,btnUpload3,imgViewCover1,imgViewCover2,imgViewCover3,dicAddress,strAddress,miles,btnHost;

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
    
    lbl_header.font = [UIFont fontWithName:LatoRegular size:18.0];
    
    tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeypad:)];
    tapScroll.delegate = self;
    [self.scrollFest addGestureRecognizer:tapScroll];
    
    UIEdgeInsets edgeInsets = txtViewDescrip.textContainerInset;
    edgeInsets.left = 10.0f;
    [txtViewDescrip setTextContainerInset:edgeInsets];
    [txtViewNotification setTextContainerInset:edgeInsets];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Create & Customize tool bars//
        [self customizeToolbar];
        
        //Date Picker//
        datePicker = [[UIDatePicker alloc]init];
        datePicker.minimumDate = [NSDate date];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        
        endDatePicker=[[JCDatePicker alloc] initWithFrame:datePicker.frame];
        endDatePicker.dateFormat = JCDateFormatFull;
        endDatePicker.font = [UIFont systemFontOfSize:16];
        endDatePicker.date = [NSDate date];
        endDatePicker.delegate=self;
        //endDatePicker.minimumDate = [NSDate date];
        //[endDatePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        
        txtStartDate.inputView = datePicker;
        txtStartDate.inputAccessoryView = toolbar2;
        
        txtEndDate.inputView = datePicker;
        txtEndDate.inputAccessoryView = toolbar2;
        //--------//
        
        //Time Picker//
        timePicker = [[UIDatePicker alloc]init];
        [timePicker setDatePickerMode:UIDatePickerModeTime];
        txtTime.inputView = timePicker;
        txtTime.inputAccessoryView = toolbar2;
        
        txtTitle.inputAccessoryView = toolbar1;
        txtStreet.inputAccessoryView = toolbar2;
        txtCity.inputAccessoryView = toolbar2;
        txtState.inputAccessoryView = toolbar2;
        txtZipcode.inputAccessoryView = toolbar2;
        txtViewDescrip.inputAccessoryView = toolbar3;
        txtViewNotification.inputAccessoryView = toolbar4;
    });
    
    [txtStreet addTarget:self action:@selector(txtDidChange:) forControlEvents:UIControlEventEditingChanged];
    [txtCity addTarget:self action:@selector(txtDidChange:) forControlEvents:UIControlEventEditingChanged];
    [txtState addTarget:self action:@selector(txtDidChange:) forControlEvents:UIControlEventEditingChanged];
    [txtZipcode addTarget:self action:@selector(txtDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:txtViewDescrip];
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:txtViewNotification];
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:mytxtView];
    
    CALayer *txtViewLayer = [txtViewDescrip layer];
    txtViewLayer.borderColor = setColor(223, 223, 223).CGColor;
    txtViewLayer.borderWidth = 0.5f;
    
    CALayer *txtViewLayer2 = [txtViewNotification layer];
    txtViewLayer2.borderColor = setColor(223, 223, 223).CGColor;
    txtViewLayer2.borderWidth = 0.5f;
    
    formatter = [[NSDateFormatter alloc] init];
    
    imgViewCover1.clipsToBounds = YES;
    imgViewCover1.layer.cornerRadius = 30;
    
    imgViewCover2.clipsToBounds = YES;
    imgViewCover2.layer.cornerRadius = 30;
    
    imgViewCover3.clipsToBounds = YES;
    imgViewCover3.layer.cornerRadius = 30;
    
    [btnPrivate setImage:[UIImage imageNamed:@"icon_radio_unselect"] forState:UIControlStateNormal];
    [btnPrivate setImage:[UIImage imageNamed:@"icon_radio_select"] forState:UIControlStateSelected];
    
    [btnPublic setImage:[UIImage imageNamed:@"icon_radio_unselect"] forState:UIControlStateNormal];
    [btnPublic setImage:[UIImage imageNamed:@"icon_radio_select"] forState:UIControlStateSelected];
    
    [btnPublic addTarget:self action:@selector(setPublic:) forControlEvents:UIControlEventTouchUpInside];
    [btnPrivate addTarget:self action:@selector(setPrivate:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnPrivate setSelected:YES];
    [btnPublic setSelected:NO];
    
    [self.lblTitle setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblImages setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblMax3 setFont:[UIFont fontWithName:LatoRegular size:12.0]];
    [self.lblDate setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblTime setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblLocation setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblType setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblPrivate setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblPublic setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblRadius_title setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblDistance setFont:[UIFont fontWithName:LatoBold size:16.0]];
    //[self.lbl50Yards setFont:[UIFont fontWithName:ProximaNovaLight size:11.0]];
    //[self.lbl50Miles setFont:[UIFont fontWithName:ProximaNovaLight size:11.0]];
    [self.lblMile setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblDescrip setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.lblNotification setFont:[UIFont fontWithName:LatoBold size:16.0]];
    
    [txtTitle setFont:[UIFont fontWithName:LatoRegular size:17.0]];
    [txtStartDate setFont:[UIFont fontWithName:LatoRegular size:17.0]];
    [txtEndDate setFont:[UIFont fontWithName:LatoRegular size:17.0]];
    [txtTime setFont:[UIFont fontWithName:LatoRegular size:17.0]];
    [txtStreet setFont:[UIFont fontWithName:LatoRegular size:17.0]];
    [txtCity setFont:[UIFont fontWithName:LatoRegular size:17.0]];
    [txtState setFont:[UIFont fontWithName:LatoRegular size:17.0]];
    [txtZipcode setFont:[UIFont fontWithName:LatoRegular size:17.0]];
    [txtViewDescrip setFont:[UIFont fontWithName:LatoRegular size:16.0]];
    [txtViewNotification setFont:[UIFont fontWithName:LatoRegular size:16.0]];
    
    txtStartDate.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtStartDate.placeholder attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}];
    txtEndDate.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtEndDate.placeholder attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}];
    txtStreet.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtStreet.placeholder attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}];
    txtCity.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtCity.placeholder attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}];
    txtState.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtState.placeholder attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}];
    txtZipcode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtZipcode.placeholder attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}];
    
    //sliderDistance.thumbTintColor = COLOR_MAINTINTCOLOR;
    
    dicAddress = [NSMutableDictionary new];
    strAddress = [NSString new];
    //lblDistance.text = @"50";
    miles = 50;
    flagExit = 0;
    flagAppear = 0;
    flagEdit = 0;
    self.lblMile.text = @"Yards";
    isTxt = NO;
    isTxtView = NO;
    isVideo = NO;
    isCamera = NO;
    id1 = 0;
    id2 = 0;
    id3 = 0;
    
    self.userModel = [[GC arrUserDetails] firstObject];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight_CF:)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyPadNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    if([GetValue_Key(@"Host") isEqualToString:@"Role"])
    {
        [btnHost setTitleColor:setColor(223, 223, 223) forState:UIControlStateNormal];
        btnHost.enabled = NO;
    }
    else
    {
        [btnHost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    SetValue_Key(@"", @"Role");
    
    [GC setParentVC:self];
    
    if(self.isEdit)
    {
        lbl_header.text = @"Edit Fest";
        [btnMenu setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        
        [GC showLoader];
        
        if(isReach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self loadSelectedFest];
            });
        }
        else
        {
            [self showAlertView_CF:@"" message:No_Internet];
        }
    }
    else
    {
        [self.btnMenu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self setupNewUIForPrivateAndPublic];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [GC setParentVC:self];
    
    if(flagAppear == 0)
    {
        [self FunctionSpace:txtTitle];
        [self FunctionSpace:txtStartDate];
        [self FunctionSpace:txtEndDate];
        [self FunctionSpace:txtTime];
        [self FunctionSpace:txtStreet];
        [self FunctionSpace:txtCity];
        [self FunctionSpace:txtState];
        [self FunctionSpace:txtZipcode];
        
        flagAppear = 1;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([GetValue_Key(@"MapAddress") isEqualToString:@"MapAddress"])
    {
        dicAddress = [[NSMutableDictionary alloc] initWithDictionary:[[GC collections] objectForKey:@"Location"]];
        
        txtStreet.text = [dicAddress valueForKey:@"Street"];
        txtStreet.text = [txtStreet.text stringByReplacingOccurrencesOfString:@"," withString:@" "];
        
        txtCity.text = [dicAddress valueForKey:@"City"];
        txtCity.text = [txtCity.text stringByReplacingOccurrencesOfString:@"County" withString:@""];
        
        txtState.text = [dicAddress valueForKey:@"State"];
        txtZipcode.text = [dicAddress valueForKey:@"Zipcode"];
        
        miles = [[dicAddress objectForKey:@"Radius"] integerValue];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.sliderDistance setValue:miles animated:YES];
            
            [self calculateRadius];
        }];
        
        flagEdit = 0;
        
        cLatitude = [[dicAddress objectForKey:@"Latitude"] doubleValue];
        cLongitude = [[dicAddress objectForKey:@"Longitude"] doubleValue];
        
        [dicAddress removeAllObjects];
        
        [dicAddress setObject:txtStreet.text forKey:@"0"];
        [dicAddress setObject:txtCity.text forKey:@"1"];
        [dicAddress setObject:txtState.text forKey:@"2"];
        [dicAddress setObject:txtZipcode.text forKey:@"3"];
        
        SetValue_Key(@"", @"MapAddress");
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    if(flagExit == 1)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        
        toolbar1 = nil;
        toolbar2 = nil;
        toolbar3 = nil;
        toolbar4 = nil;
        
        datePicker = nil;
        timePicker = nil;
        
        formatter =nil;
        
        mytxtfield = nil;
        mytxtView = nil;
        dicAddress = nil;
        
        swipeLeft = nil;
        tapScroll = nil;
        strAddress = nil;
        
        self.data1 = nil;
        self.data2 = nil;
        self.data3 = nil;
        self.locationManager = nil;
        self.dataRequest = nil;
        self.userModel = nil;
        
        [[GC arrInvite] removeAllObjects];
        
        [[GC arrHost] removeAllObjects];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MyMethods
-(void)setupNewUIForPrivateAndPublic{
   
    UISwitch *sw=[[UISwitch alloc]init];
    [sw setCenter:CGPointMake(CGRectGetMinX(txtZipcode.frame)+22, CGRectGetMidY(_lblType.frame)-8)];
    [sw setOnTintColor:COLOR_RGB(76, 204, 174)];
    [sw addTarget:self action:@selector(switchPrivateValChanged:) forControlEvents:UIControlEventValueChanged];
    [sw setOn:YES];
    self.switchPrivate=sw;
    [scrollFest addSubview:self.switchPrivate];

    
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [lbl setText:@"Private"];
    [lbl setFont:_lblPrivate.font];
    [lbl setCenter:CGPointMake(CGRectGetMaxX(_switchPrivate.frame)+70, _switchPrivate.center.y)];
    
    self.lblPrivatePublic=lbl;
    
    [scrollFest addSubview:self.lblPrivatePublic];
    
    [_lblPrivate setHidden:YES];
    [_lblPublic setHidden:YES];
    
    [btnPrivate setHidden:YES];
    [btnPublic setHidden:YES];

}
-(IBAction)switchPrivateValChanged:(id)sender{
    if (_switchPrivate.isOn) {
        festType=0;
    }
    else{
        festType=1;
    }
    
    [self updateLabelBasedOnFestType];
}
-(void)updateLabelBasedOnFestType{
    if (festType==0) {
        [_lblPrivatePublic setText:@"Private"];
    }
    else{
        [_lblPrivatePublic setText:@"Public"];
    }
}

#pragma mark - Swipe Gesture
-(void)swipeRight_CF:(UISwipeGestureRecognizer *)gest
{
    flagExit = 1;
    
    [mytxtfield resignFirstResponder];
    [mytxtView resignFirstResponder];
    
    MyFestViewController *MV = [self.storyboard instantiateViewControllerWithIdentifier:MyFest_ViewController];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController pushViewController:MV animated:NO];
}

#pragma mark - Detec Tap on Scroll View
-(void)exitKeypad:(UITapGestureRecognizer *)gest
{
    if(gest.state == UIGestureRecognizerStateEnded)
    {
        [mytxtfield resignFirstResponder];
        [mytxtView resignFirstResponder];
        
        if(mytxtfield!=txtTitle && (isTxt))
            [self.scrollFest setContentOffset:svos animated:YES];
        else if( isTxtView)
            [self.scrollFest setContentOffset:svosTxtView animated:YES];
        
    }
}

#pragma mark - Keypad tool bar customization
-(void)customizeToolbar
{
    toolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolbar1.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *_btnItemNext = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(Next)];
    [_btnItemNext setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *_btnItemDone = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Done)];
    [_btnItemDone setTintColor:[UIColor whiteColor]];
    toolbar1.items = [NSArray arrayWithObjects:_btnItemNext,
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      _btnItemDone,
                      nil];
    
    [toolbar1 sizeToFit];
    UIBarButtonItem *_btnItemPrev = [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(Previous)];
    [_btnItemPrev setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *_btnItemNext2 = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(Next)];
    [_btnItemNext2 setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *_btnItemDone2 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Done)];
    [_btnItemDone2 setTintColor:[UIColor whiteColor]];
    toolbar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolbar2.barStyle = UIBarStyleBlackTranslucent;
    toolbar2.items = [NSArray arrayWithObjects:_btnItemPrev,_btnItemNext2,
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],_btnItemDone2,nil];
    
    [toolbar2 sizeToFit];
    
    toolbar3 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolbar3.barStyle = UIBarStyleBlackTranslucent;
    toolbar3.items = [NSArray arrayWithObjects:
                      [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(Previous_txtView)],
                      [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(Next_txtView)],
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Done_txtView)],
                      nil];
    
    [toolbar3 sizeToFit];
    
    toolbar4 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolbar4.barStyle = UIBarStyleBlackTranslucent;
    toolbar4.items = [NSArray arrayWithObjects:
                      [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(Previous_txtView)],
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Done_txtView)],
                      nil];
    
    [toolbar4 sizeToFit];
    
    
}

#pragma mark - Notification For Keypad
-(void)keyPadNotification:(NSNotification *)notify
{
    keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

-(void)getCurrentLocation
{
    //[self.locationManager requestWhenInUseAuthorization];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    cLatitude = self.locationManager.location.coordinate.latitude;
    cLongitude = self.locationManager.location.coordinate.longitude;
    
}

#pragma mark - Previous, Next and Done Button Actions
-(void)Previous
{
    
    switch (mytxtfield.tag) {
        case 2:
            [txtTitle becomeFirstResponder];
            break;
        case 3:
            [txtStartDate becomeFirstResponder];
            break;
        case 4:
            [txtEndDate becomeFirstResponder];
            break;
        case 5:
            [txtTime becomeFirstResponder];
            break;
        case 6:
            [txtStreet becomeFirstResponder];
            break;
        case 7:
            [txtCity becomeFirstResponder];
            break;
        case 8:
            [txtState becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

-(void)Next
{
    switch (mytxtfield.tag) {
        case 1:
            [txtStartDate becomeFirstResponder];
            break;
        case 2:
            [txtEndDate becomeFirstResponder];
            break;
        case 3:
            [txtTime becomeFirstResponder];
            break;
        case 4:
            [txtStreet becomeFirstResponder];
            break;
        case 5:
            [txtCity becomeFirstResponder];
            break;
        case 6:
            [txtState becomeFirstResponder];
            break;
        case 7:
            [txtZipcode becomeFirstResponder];
            break;
        case 8:
            [txtViewDescrip becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

-(void)Done
{
    if(mytxtfield.tag == 2){
        
        formatter.dateStyle=NSDateFormatterShortStyle;
        formatter.dateFormat=@"MM/dd/yyyy";
        txtStartDate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
        [txtEndDate becomeFirstResponder];
        
    }
    else if(mytxtfield.tag == 3){
        
        formatter.dateStyle=NSDateFormatterLongStyle;
        formatter.dateFormat=@"MM/dd/yyyy";
        txtEndDate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
        [txtTime becomeFirstResponder];
    }
    else if (mytxtfield.tag == 4){
        
        formatter.timeStyle=NSTimeZoneNameStyleShortStandard;
        formatter.dateFormat=@"h:mm a";
        txtTime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:timePicker.date]];
        [txtStreet becomeFirstResponder];
        
    }
    else
    {
        isTxt = NO;
        isTxtView = NO;
        
        [mytxtfield resignFirstResponder];
        if(mytxtfield!=txtTitle)
        {
            [self.scrollFest setContentOffset:svos animated:YES];
        }
    }
}

-(void)Previous_txtView
{
    if(mytxtView == txtViewNotification)
    {
        [txtViewDescrip becomeFirstResponder];
    }
    else if(mytxtView == txtViewDescrip)
    {
        [txtZipcode becomeFirstResponder];
    }
}

-(void)Next_txtView
{
    if (mytxtView == txtViewDescrip)
    {
        [txtViewNotification becomeFirstResponder];
    }
}

-(void)Done_txtView
{
    isTxt = NO;
    isTxtView = NO;
    
    if(mytxtView == txtViewNotification)
    {
        [mytxtView resignFirstResponder];
        [self.scrollFest setContentOffset:CGPointMake(0, svosTxtView.y-txtViewNotification.frame.size.height-10-50) animated:YES];
    }
    else
    {
        [mytxtView resignFirstResponder];
        [self.scrollFest setContentOffset:svosTxtView animated:YES];
    }
}

#pragma mark - JCDatePicker Delegate

- (void)datePicker:(JCDatePicker *)datePicker dateDidChange:(NSDate *)date
{
    formatter.dateStyle=NSDateFormatterLongStyle;
    formatter.dateFormat=@"MM/dd/yyyy h:mm a";
    txtEndDate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
}
#pragma mark - Left Space View
-(void)FunctionSpace:(UITextField*) textFields
{
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [textFields setLeftViewMode:UITextFieldViewModeAlways];
    [textFields setLeftView:spacerView];
}

#pragma mark - Textfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:textField];
    
    mytxtfield=textField;
    CGFloat y = 0.0;
    
    isTxt = YES;
    isTxtView = NO;
    
    if(keyboardFrame.origin.y == 0.0)
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            y = [[UIScreen mainScreen] bounds].size.height - 216 - 44 - 20;
        else
            y = [[UIScreen mainScreen] bounds].size.height - 216 - 44;
    }
    else
    {
        y = keyboardFrame.origin.y;
    }
    
    CGPoint pt;
    CGRect rc;
    rc = [mytxtfield bounds];
    rc = [mytxtfield convertRect:rc toView:scrollFest];
    pt = rc.origin;
    pt.x = 0;
    
    if([getScreen_Height isEqualToString:@"regular"]){
        
        if(mytxtfield!=txtTitle){
            pt.y -= (y-70-mytxtfield.frame.size.height-10);
            svos = CGPointMake(0, pt.y);
            [scrollFest setContentOffset:pt animated:YES];
        }
    }
    else{
        
        if(mytxtfield!=txtTitle){
            pt.y -= (y-70-mytxtfield.frame.size.height-10);
            svos = CGPointMake(0, pt.y);
            [scrollFest setContentOffset:pt animated:YES];
        }
    }
    
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    isTxt = NO;
    isTxtView = NO;
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    NSString *filtered;
    
    if(textField!=txtTitle)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if(![string isEqualToString:filtered])
        {
            return NO;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
        
    }
    else
        return YES;
    
    return YES;
}

-(void)txtDidChange:(UITextField *)txt
{
    switch (txt.tag)
    {
        case 5:
        {
            flagEdit = 1;
            
            if(txtStreet.text.length>0){
                [dicAddress setObject:txtStreet.text forKey:@"0"];
            }
            else
            {
                [dicAddress removeObjectForKey:@"0"];
            }
        }
            break;
        case 6:
        {
            flagEdit = 1;
            
            if(txtCity.text.length>0){
                [dicAddress setObject:txtCity.text forKey:@"1"];
            }
            else
            {
                [dicAddress removeObjectForKey:@"1"];
            }
        }
            break;
        case 7:
        {
            flagEdit = 1;
            
            if(txtState.text.length>0){
                [dicAddress setObject:txtState.text forKey:@"2"];
            }
            else
            {
                [dicAddress removeObjectForKey:@"2"];
            }
        }
            break;
        case 8:
        {
            flagEdit = 1;
            
            if(txtZipcode.text.length>0){
                
                if(txtZipcode.text.length>10)
                {
                    NSString *str = txtZipcode.text;
                    txtZipcode.text = [[str substringToIndex:(str.length-1)] copy];
                }
                else
                    [dicAddress setObject:txtZipcode.text forKey:@"3"];
            }
            else
            {
                [dicAddress removeObjectForKey:@"3"];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - TextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    mytxtView=textView;
    
    CGFloat y = 0.0;
    
    isTxt = NO;
    isTxtView = YES;
    
    if(keyboardFrame.origin.y == 0.0)
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            y = [[UIScreen mainScreen] bounds].size.height - 216 - 44 - 20;
        else
            y = [[UIScreen mainScreen] bounds].size.height - 216 - 44;
    }
    else
    {
        y = keyboardFrame.origin.y;
    }
    
    CGPoint pt;
    CGRect rc;
    rc = [mytxtView bounds];
    rc = [mytxtView convertRect:rc toView:scrollFest];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= (y-70-mytxtView.frame.size.height-15);
    svosTxtView = CGPointMake(0, pt.y);
    svos = svosTxtView;
    [scrollFest setContentOffset:pt animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        
        // Cannot animate with setContentOffset:animated: or caret will not appear
        
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

#pragma mark - Alert View
-(void)showAlertView_CF:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}

#pragma mark - Open Camera
-(void)openCamera_CF
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
        [self showAlertView_CF:@"" message:No_Camera];
    }
}

#pragma mark - Open Gallery

-(void)openGallery
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing=NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: picker.sourceType];
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        picker.videoMaximumDuration = 60.0;
        [self addChildViewController:picker];
        [picker didMoveToParentViewController:self];
        [self.view addSubview:picker.view];
        
    }
}
-(void)openCamera
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing=NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: picker.sourceType];
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        picker.videoMaximumDuration = 60.0;
        [self addChildViewController:picker];
        [picker didMoveToParentViewController:self];
        [self.view addSubview:picker.view];
    }

}
-(void)openImageGallery_CF
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing=NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self addChildViewController:picker];
        [picker didMoveToParentViewController:self];
        [self.view addSubview:picker.view];
        
    }
}

#pragma mark - Capture Video
-(void)captureVideo_CF
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
        pickerVideo.videoQuality = UIImagePickerControllerQualityTypeMedium;
        pickerVideo.videoMaximumDuration = 60.0;
        pickerVideo.mediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
        [self addChildViewController:pickerVideo];
        [pickerVideo didMoveToParentViewController:self];
        [self.view addSubview:pickerVideo.view];
        
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
-(void)uploadOptions
{
    [mytxtfield resignFirstResponder];
    [mytxtView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery",@"Camera",nil];
    [actionSheet showInView:self.view];
    //[self openCamera];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //NSLog(@"buttonIndex=>%ld",(long)buttonIndex);
    
    isVideo = NO;
    
    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([buttonTitle isEqualToString:@"Gallery"])
    {
        [self performSelectorOnMainThread:@selector(openGallery) withObject:nil waitUntilDone:YES];
    }
    else if ([buttonTitle isEqualToString:@"Camera"])
    {
        [self performSelectorOnMainThread:@selector(openCamera) withObject:nil waitUntilDone:YES];
    }
    /*switch (buttonIndex) {
        case 0:{
            [self performSelectorOnMainThread:@selector(openGallery) withObject:nil waitUntilDone:YES];
        }
            
            break;
        case 1:{
            [self performSelectorOnMainThread:@selector(openCamera) withObject:nil waitUntilDone:YES];
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
     */
    
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];

    if (alertView.tag==tagAlertSignout){
//        it will be done in the parent class
        ILLog(@"it will be done in the parent class");
        
    }
    else if(alertView.tag==tagAlertLocationDenied){
        ILLog(@"no need to push or pop, just dismiss the alertview, thats all");
    }
    else if(buttonIndex == [alertView cancelButtonIndex])
    {
        flagExit = 1;
        
        [mytxtfield resignFirstResponder];
        [mytxtView resignFirstResponder];
        
        MyFestViewController *MFV = [self.storyboard instantiateViewControllerWithIdentifier:MyFest_ViewController];
        [self.navigationController pushViewController:MFV animated:YES];
    }
}

#pragma mark - Image Picker Controller Delegates
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [picker.view removeFromSuperview];
        [picker removeFromParentViewController];
        
        flag_btn = 0;
        isVideo = NO;
        isCamera = NO;
    });
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker.view removeFromSuperview];
    [picker removeFromParentViewController];
    
    [GC showLoader];
    
    __block UIImage *selectedImage = [UIImage new];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage] )
    {
        isVideo=false;
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie] )
    {
        isVideo=TRUE;
    }
    if(isVideo)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.type1 = @"1";
            
            NSURL *urlVideo = [info objectForKey:UIImagePickerControllerMediaURL];
            
            if(isCamera)
                UISaveVideoAtPathToSavedPhotosAlbum([urlVideo path], nil, nil, nil);
            
            AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:urlVideo options:nil];
            CMTime duration = asset1.duration;
            float videoLenght = CMTimeGetSeconds(duration);
            
            if(videoLenght>61.0)
            {
                [GC hideLoader];
                [self showAlertView_CF:@"" message:@"Video playback time should be one minute."];
            }
            else
            {
                self.dataVideo = [NSData dataWithContentsOfURL:urlVideo];
                
                AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
                generate1.appliesPreferredTrackTransform = YES;
                NSError *err = NULL;
                CMTime time = CMTimeMake(1, 2);
                CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
                selectedImage = [[UIImage alloc] initWithCGImage:oneRef];
                imgViewCover1.image = selectedImage;
                self.data1 = UIImageJPEGRepresentation(selectedImage, 0.8);
                
                [GC hideLoader];
                
            }
        });
    }
    else
    {
        isVideo = NO;
        switch (flag_btn) {
            case 1:{
                
                selectedImage = [self getProfileImage:picker dictionary:info];
                [self.imgViewCover1 setImage:selectedImage];
                self.data1 = UIImageJPEGRepresentation(selectedImage, 0.8);
                self.type1 = @"0";
            }
                break;
            case 2:{
                
                selectedImage = [self getProfileImage:picker dictionary:info];
                [self.imgViewCover2 setImage:selectedImage];
                self.data2 = UIImageJPEGRepresentation(selectedImage, 0.8);
                self.type2 = @"0";
            }
                break;
            case 3:{
                selectedImage = [self getProfileImage:picker dictionary:info];
                [self.imgViewCover3 setImage:selectedImage];
                self.data3 = UIImageJPEGRepresentation(selectedImage, 0.8);
                self.type3 = @"0";
            }
                break;
                
            default:
                break;
        }
        
        [GC hideLoader];
    }
}

-(void)imageFromMovieFrame:(NSNotification *)notify
{
    NSDictionary *userInfo = [notify userInfo];
    UIImage *image = [userInfo valueForKey:MPMoviePlayerThumbnailImageKey];
    self.data1 = UIImageJPEGRepresentation(image, 0.8);
    
    [GC hideLoader];
    
}

-(UIImage *)getProfileImage:(UIImagePickerController *)picker dictionary:(NSDictionary *)info
{
    UIImage *image = [UIImage new];
    
    image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    return image;
}

-(void)formMediaData:(UIImage *)img
{
    
    switch (flag_btn) {
        case 1:{
            
            [self.imgViewCover1 setImage:img];
            self.data1 = UIImageJPEGRepresentation(img, 0.8);
            isVideo = NO;
            self.type1 = @"1";
            
        }
            break;
        case 2:{
            
            [self.imgViewCover2 setImage:img];
            self.data2 = UIImageJPEGRepresentation(img, 0.8);
            isVideo = NO;
            self.type2 = @"1";
        }
            break;
        case 3:{
            
            [self.imgViewCover3 setImage:img];
            self.data3 = UIImageJPEGRepresentation(img, 0.8);
            isVideo = NO;
            self.type3 = @"1";
        }
            break;
            
        default:
            break;
    }
    
    
    [GC hideLoader];
}

#pragma mark - Write File To Path
-(void)writeContentsToPath:(NSData *)content
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString* strPathToSave = [documentsDirectory stringByAppendingPathComponent:[self fileName]];
    
    //save content to the documents directory
    [content writeToFile:strPathToSave atomically:NO];
    
}

-(NSString *)fileName
{
    // return a formatted string for a file name
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"ddMMMYY_hhmmssa";
    return [[formatter1 stringFromDate:[NSDate date]] stringByAppendingString:@".mov"];
}

#pragma mark - Clear View
-(void)clearFest
{
    txtTitle.text = @"";
    txtStartDate.text = @"";
    txtEndDate.text = @"";
    txtTime.text = @"";
    txtStreet.text = @"";
    txtCity.text = @"";
    txtState.text = @"";
    txtZipcode.text = @"";
    txtViewDescrip.text = @"";
    txtViewNotification.text = @"";
    
    [btnPrivate setSelected:YES];
    [btnPublic setSelected:NO];
    
    festType = 1;
    [self updateLabelBasedOnFestType];

}

#pragma mark - Set Private or Public

// Private = 0 & Public = 1;

-(void)setPrivate:(id)sender
{
    if(!btnPrivate.selected)
    {
        [btnPrivate setSelected:YES];
        [btnPublic setSelected:NO];
        festType=0;
    }
    [self updateLabelBasedOnFestType];
}

-(void)setPublic:(id)sender
{
    if(!btnPublic.selected)
    {
        [btnPublic setSelected:YES];
        [btnPrivate setSelected:NO];
        festType=1;
    }
    [self updateLabelBasedOnFestType];

}

#pragma mark - Convert address to latitude & longitude
-(int)getLocationFromAddress:(NSString*)addressStr
{
    int val=0;
    
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false", esc_addr];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    NSData *data1 = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data1!=nil)
    {
        NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
        
        if([[json valueForKey:@"status"] isEqualToString:@"OK"])
        {
            NSMutableArray *arrlat = [[NSMutableArray alloc] initWithObjects:[[[[json valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"], nil];
            
            cLatitude=[[[arrlat objectAtIndex:0] objectAtIndex:0] doubleValue];
            
            NSMutableArray *arrlong = [[NSMutableArray alloc] initWithObjects:[[[[json valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"], nil];
            
            cLongitude=[[[arrlong objectAtIndex:0] objectAtIndex:0] doubleValue];
            
            NSLog(@"cLatitude & cLongitude=>%lf,%lf",cLatitude,cLongitude);
        }
        else
        {
            cLatitude = 0.0;
            cLongitude = 0.0;
            
            val = 1;
            
            [GC hideLoader];
            
            strMsg = @"Please enter correct address.";
        }
    }
    else
    {
        cLatitude=0.0;
        cLongitude=0.0;
        
        val = 1;
        [GC hideLoader];
        
        strMsg = No_Internet;
        
    }
    
    return val;
}

#pragma mark - Validation Alert
-(int)validation_CF
{
    flagAlert = 0;
    
    if(txtTitle.text.length == 0)
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please enter title."];
    }
    else if (txtStartDate.text.length == 0)
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please select start date."];
    }
    else if (txtEndDate.text.length == 0)
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please select end date."];
    }
    else if ([self CompareDate:txtStartDate.text])
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please select valid start date."];
    }
    else if ([self CompareDate:txtEndDate.text])
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please select valid end date."];
    }
    else if (txtTime.text.length == 0)
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please select time."];
    }
    else if ([self compareStartDate:[NSString stringWithFormat:@"%@",txtStartDate.text] endDate:txtEndDate.text])
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"End date should be greater than start date."];
    }
    
    else if ([self compareTime:txtTime.text])
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please select valid time."];
    }
    else if (txtStreet.text.length == 0)
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please enter street name."];
    }
    else if (txtCity.text.length == 0)
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please enter city name."];
    }
    else if (txtState.text.length == 0)
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please enter state name."];
    }
    else if (txtZipcode.text.length == 0)
    {
        flagAlert = 1;
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:@"Please enter zipcode."];
    }
    
    return flagAlert;
}

#pragma mark - Compare Current & Selected Date
-(BOOL)CompareDate:(NSString*)reservedate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    if([reservedate hasSuffix:@"m"])
    {
        [format setDateFormat:@"MM/dd/yyyy h:mm a"];
    }
    NSDate *now = [NSDate date];
    
    NSString *nsstr = [format stringFromDate:now];
    
    NSDate *date2 = [format dateFromString:reservedate]; // Pass Selected Date From Picker//
    NSDate *date3 = [format dateFromString:nsstr];//Pass Current Date//
    
    if(([date2 compare: date3] == NSOrderedDescending) || ([reservedate isEqualToString:nsstr]))
    {
        return NO; //Greater
    }
    else
    {
        return YES;//Lesser
    }
}

-(BOOL)compareStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    if([startDate hasSuffix:@"m"] && [endDate hasSuffix:@"m"])
    {
        [format setDateFormat:@"MM/dd/yyyy h:mm a"];
    }
    NSDate *dateStart = [format dateFromString:startDate];
    NSDate *dateEnd = [format dateFromString:endDate];
    
    if(([dateEnd compare: dateStart] == NSOrderedDescending) || ([dateEnd compare: dateStart] == NSOrderedSame))
    {
        NSTimeInterval distanceBetweenDates = [dateEnd timeIntervalSinceDate:dateStart];
        double secondsInMinute = 60;
        NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
        
        if (secondsBetweenDates == 0)
            return YES;
        else if (secondsBetweenDates < 0)
            return YES;
        else
            return NO;
        
        return NO; //Greater
    }
    else
    {
        return YES;//Lesser
    }
    
}

#pragma mark - Compare Selected Time
-(BOOL)compareTime:(NSString *)selectedTime
{
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    
    NSString *strDate=[NSString new];
    selectedTime=[selectedTime lowercaseString];
    
    if([selectedTime rangeOfString:@"m"].length==0)
    {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [format setLocale:locale];
        format.dateFormat = @"HH:mm";
        NSDate *date = [format dateFromString:selectedTime];
        
        format.dateFormat = @"h:mm a";
        strDate= [format stringFromDate:date];
    }
    else
    {
        strDate=selectedTime;
    }
    
    format.dateFormat = @"MM/dd/yyyy h:mm a";
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *strSelected=[NSString stringWithFormat:@"%@ %@",txtStartDate.text,strDate];
    
    NSDate *date1=[format dateFromString:strSelected];
    
    NSDate *date2 = [self toLocalTime];
    
    if([date1 compare:date2] == NSOrderedDescending || ([date1 compare:date2] == NSOrderedSame))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(NSDate *)toLocalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: [NSDate date]];
    return [NSDate dateWithTimeInterval: seconds sinceDate: [NSDate date]];
}

#pragma mark - Update Local DB
-(void)updateLocalDB
{
    NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
    
    NSArray *arrDB = [GlobalClass DB_Load_ByID:@"MyFest" withColName:@"festEventId" andParam:[NSString stringWithFormat:@"%ld",(long)[GC eventID]]];
    
    for (MyFest *myFest in arrDB) {
        
        [myFest setUserId:self.userModel.localID];
        [myFest setFestTitle:txtTitle.text];
        [myFest setFestLocation:[NSString stringWithFormat:@"%@,%@,%@,%@",
                                 txtStreet.text,
                                 txtCity.text,
                                 txtState.text,
                                 txtZipcode.text]];
        
        [myFest setLatitude:[NSString stringWithFormat:@"%lf",cLatitude]];
        [myFest setLongitude:[NSString stringWithFormat:@"%lf",cLongitude]];
        [myFest setFestEventId:[NSString stringWithFormat:@"%ld",(long)[GC eventID]]];
        
        if([self.lblMile.text isEqualToString:@"Yards"])
        {
            [myFest setFestRadius:[NSString stringWithFormat:@"%f",(float)miles * 0.000568182]];
        }
        else
        {
            [myFest setFestRadius:[NSString stringWithFormat:@"%f",(float)miles]];
        }
        
        if(txtViewNotification.text.length>0)
            [myFest setPushNotification:txtViewNotification.text];
        else
            [myFest setPushNotification:@"You've been invited to a Fest!"];
        
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        formatter.dateFormat = @"MM/dd/yyyy h:mm a";
        NSDate *festDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",txtStartDate.text,txtTime.text]];
        [myFest setFestDate:festDate];
        
        // Save everything
        NSError *error = nil;
        if ([context save:&error]) {
            NSLog(@"Create Fest - updated local data ");
        } else {
            NSLog(@"Create Fest - Not updated to local data: %@", [error userInfo]);
        }
    }
}

#pragma mark - Load Fest For Edit
-(void)loadSelectedFest
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,GetFest];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest new];
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
                    [self showAlertView_CF:@"" message:No_Internet];
                else
                    [self showAlertView_CF:@"" message:self.dataRequest.error.localizedDescription];
                
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                NSMutableArray *arrData = [json valueForKey:@"Data"];
                
                txtTitle.text = [NSString stringWithFormat:@"%@",[[arrData valueForKey:@"Title"] capitalizedString]];
                txtStartDate.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"StartDateString"]];
                
                NSDateFormatter  *endDtaeFormat = [[NSDateFormatter alloc] init];
                endDtaeFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                NSDate *EndDateFest = [endDtaeFormat dateFromString:[NSString stringWithFormat:@"%@",[arrData valueForKey:@"EndDate"]]];
                endDtaeFormat.timeStyle=NSTimeZoneNameStyleShortStandard;
                endDtaeFormat.dateFormat=@"MM/dd/yyyy";
                txtEndDate.text = [NSString stringWithFormat:@"%@",[endDtaeFormat stringFromDate:EndDateFest]];
                NSDate *endDate = [[NSDate alloc] init];
                endDate = [endDtaeFormat dateFromString:txtEndDate.text];
                endDatePicker.date=endDate;
                
               // txtEndDate.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"EndDateString"]];
                txtStreet.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"Street"]];
                txtCity.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"City"]];
                txtState.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"State"]];
                txtZipcode.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"Zip"]];
                txtViewDescrip.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"Description"]];
                txtViewNotification.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"Notification"]];
                
               // [self setDtae:txtStartDate.text toPicker:datePicker];
                
                cLatitude = [[arrData valueForKey:@"Latitude"] doubleValue];
                cLongitude = [[arrData valueForKey:@"Longitude"] doubleValue];
                
                festType = [[arrData valueForKey:@"Type"] intValue];
                
                if(festType == 0)
                {
                    [btnPrivate setSelected:YES];
                    [btnPublic setSelected:NO];
                    [_switchPrivate setOn:YES];
                }
                else
                {
                    [btnPrivate setSelected:NO];
                    [btnPublic setSelected:YES];
                    [_switchPrivate setOn:NO];
                }
                [self updateLabelBasedOnFestType];

                miles = [[arrData valueForKey:@"Miles"] integerValue];
                
                if(miles>1)
                    miles = (miles+36) * 1760;
                else
                {
                    miles = miles * 36;
                }
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self.sliderDistance setValue:miles animated:YES];
                    
                    [self calculateRadius];
                }];
                
                NSDateFormatter  *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                NSDate *dateFest = [format dateFromString:[NSString stringWithFormat:@"%@",[arrData valueForKey:@"StartDate"]]];
                format.timeStyle=NSTimeZoneNameStyleShortStandard;
                format.dateFormat=@"h:mm a";
                txtTime.text = [NSString stringWithFormat:@"%@",[format stringFromDate:dateFest]];
                
                for(int i=0;i<[GC arrPreviews].count;i++)
                {
                    int tag = [[[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Tag"] intValue];
                    
                    switch (tag) {
                        case 0:
                        {
                            self.type1 = [NSString stringWithFormat:@"%@",[[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Type"]];
                            
                            id1 = [[[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Id"] intValue];
                            
                            if([self.type1 isEqualToString:@"0"])
                            {
                                [imgViewCover1 sd_setImageWithURL:URL([[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Path"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if(!error)
                                    {
                                        imgViewCover1.image = image;
                                        self.data1 = UIImageJPEGRepresentation(image, 1.0);
                                    }
                                    else{
                                        imgViewCover1.image = [UIImage imageNamed:@"icon_fest_ghost1"];
                                    }
                                }];
                            }
                            else
                            {
                                self.dataVideo = [NSData dataWithContentsOfURL:URL([[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Path"])];
                                
                                [imgViewCover1 sd_setImageWithURL:URL([[[GC arrPreviews] objectAtIndex:i] valueForKey:@"ThumbPath"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if(!error)
                                    {
                                        imgViewCover1.image = image;
                                        self.data1 = UIImageJPEGRepresentation(image, 1.0);
                                    }
                                    else{
                                        imgViewCover1.image = [UIImage imageNamed:@"icon_fest_ghost1"];
                                    }
                                }];
                            }
                        }
                            break;
                        case 1:
                        {
                            self.type2 = [NSString stringWithFormat:@"%@",[[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Type"]];
                            
                            id2 = [[[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Id"] intValue];
                            
                            [imgViewCover2 sd_setImageWithURL:URL([[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Path"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                                if(!error)
                                {
                                    imgViewCover2.image = image;
                                    self.data2 = UIImageJPEGRepresentation(image, 1.0);
                                }
                                else{
                                    imgViewCover2.image = [UIImage imageNamed:@"icon_fest_ghost1"];
                                }
                            }];
                            
                        }
                            break;
                        case 2:
                        {
                            self.type3 = [NSString stringWithFormat:@"%@",[[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Type"]];
                            
                            id3 = [[[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Id"] intValue];
                            
                            [imgViewCover3 sd_setImageWithURL:URL([[[GC arrPreviews] objectAtIndex:i] valueForKey:@"Path"]) placeholderImage:[UIImage imageNamed:@"icon_fest_ghost1"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                                if(!error)
                                {
                                    imgViewCover3.image = image;
                                    self.data3 = UIImageJPEGRepresentation(image, 1.0);
                                }
                                else{
                                    imgViewCover3.image = [UIImage imageNamed:@"icon_fest_ghost1"];
                                }
                            }];
                        }
                            break;
                            
                        default:
                            break;
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
                        [self showAlertView_CF:@"" message:strFailure];
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
            
            [self showAlertView_CF:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Create Fest Request
-(void)createFest:(NSString *)eventId
{
    
    CGFloat valMiles;
    
    if([self.lblMile.text isEqualToString:@"Yards"])
    {
        valMiles = miles * 0.000568182;
    }
    else
    {
        valMiles =  (float)miles;
    }
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    NSMutableDictionary *dicEvent = [NSMutableDictionary new];
    [dicEvent setObject:eventId forKey:@"Id"];
    [dicEvent setObject:@{@"Id" : self.userModel.localID} forKey:@"User"];
    [dicEvent setObject:txtTitle.text forKey:@"Title"];
    [dicEvent setObject:txtViewDescrip.text forKey:@"Description"];
    [dicEvent setObject:txtStreet.text forKey:@"Street"];
    [dicEvent setObject:txtCity.text forKey:@"City"];
    [dicEvent setObject:txtState.text forKey:@"State"];
    [dicEvent setObject:txtZipcode.text forKey:@"Zip"];
    [dicEvent setObject:@"xxx" forKey:@"Country"];
    [dicEvent setObject:[NSNumber numberWithFloat:valMiles] forKey:@"Miles"];
    
    if(txtViewNotification.text.length>0)
        [dicEvent setObject:txtViewNotification.text forKey:@"Notification"];
    else
        [dicEvent setObject:[NSString stringWithFormat:@"Welcome to %@!",txtTitle.text] forKey:@"Notification"];
    
    [dicEvent setObject:[NSString stringWithFormat:@"%lf",cLatitude] forKey:@"Latitude"];
    [dicEvent setObject:[NSString stringWithFormat:@"%lf",cLongitude] forKey:@"Longitude"];
    [dicEvent setObject:[NSString stringWithFormat:@"%@ %@",txtStartDate.text,txtTime.text] forKey:@"StartDate"];
    [dicEvent setObject:[NSString stringWithFormat:@"%@",txtEndDate.text] forKey:@"EndDate"];
    [dicEvent setObject:[NSString stringWithFormat:@"%d",festType] forKey:@"Type"];
    
    NSMutableArray *arrInvites = [NSMutableArray new];
    NSString *strPhone = [NSString new];
    NSString *strHost = [NSString new];
    NSMutableArray *arrIndex = [NSMutableArray new];
    
    for(long int i=0;i<[GC arrInvite].count;i++)
    {
        
        NSMutableDictionary *dicInvites = [NSMutableDictionary new];
        [dicInvites setObject:self.userModel.localID forKey:@"InviteBy"];
        [dicInvites setObject:[NSString stringWithFormat:@"%@",[[GC arrInvite] objectAtIndex:i]] forKey:@"InviteFor"];
        [dicInvites setObject:@"0" forKey:@"Type"];
        [dicInvites setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"IsHost"];
        
        strPhone = [NSString stringWithFormat:@"%@",[[GC arrInvite] objectAtIndex:i]];
        
        for(long int j=0;j<[GC arrHost].count;j++)
        {
            strHost = [NSString stringWithFormat:@"%@",[[GC arrHost] objectAtIndex:j]];
            
            if([strPhone isEqualToString:strHost])
            {
                [arrIndex addObject:[NSNumber numberWithInteger:j]];
                [dicInvites setObject:[NSString stringWithFormat:@"%@",@"true"] forKey:@"IsHost"];
            }
        }
        
        [arrInvites addObject:dicInvites];
        
    }
    
    // Remove Added Host From Array
    for(long int i=0;arrIndex.count;i++)
    {
        NSInteger index = [[arrIndex objectAtIndex:i] integerValue];
        [[GC arrHost] removeObjectAtIndex:index];
    }
    
    for (long int i=0; i<[GC arrHost].count; i++)
    {
        NSMutableDictionary *dicHost = [NSMutableDictionary new];
        [dicHost setObject:self.userModel.localID forKey:@"InviteBy"];
        [dicHost setObject:[NSString stringWithFormat:@"%@",[[GC arrHost] objectAtIndex:i]] forKey:@"InviteFor"];
        [dicHost setObject:@"0" forKey:@"Type"];
        [dicHost setObject:[NSString stringWithFormat:@"%@",@"true"] forKey:@"IsHost"];
        
        [arrInvites addObject:dicHost];
    }
    
    NSMutableArray *arrMedias = [NSMutableArray new];
    
    if(self.data1!=nil)
    {
        NSMutableDictionary *dicMediaData1 = [NSMutableDictionary new];
        
        if([self.type1 isEqualToString:@"1"])
        {
            [dicMediaData1 setObject:[self.dataVideo base64EncodedStringWithOptions:0] forKey:@"Path"];
            [dicMediaData1 setObject:[self.data1 base64EncodedString] forKey:@"ThumbPath"];
            [dicMediaData1 setObject:self.type1 forKey:@"Type"];
            
        }
        else
        {
            [dicMediaData1 setObject:[self.data1 base64EncodedString] forKey:@"Path"];
            [dicMediaData1 setObject:self.type1 forKey:@"Type"];
            
        }
        
        [dicMediaData1 setObject:[NSString stringWithFormat:@"%d",id1] forKey:@"Id"];
        [dicMediaData1 setObject:@"0" forKey:@"Tag"];
        [arrMedias addObject:dicMediaData1];
    }
    
    if(self.data2!=nil)
    {
        NSMutableDictionary *dicMediaData2 = [NSMutableDictionary new];
        [dicMediaData2 setObject:[self.data2 base64EncodedString] forKey:@"Path"];
        [dicMediaData2 setObject:self.type2 forKey:@"Type"];
        [dicMediaData2 setObject:@"1" forKey:@"Tag"];
        [dicMediaData2 setObject:[NSString stringWithFormat:@"%d",id2] forKey:@"Id"];
        [arrMedias addObject:dicMediaData2];
    }
    
    if(self.data3!=nil)
    {
        NSMutableDictionary *dicMediaData3 = [NSMutableDictionary new];
        [dicMediaData3 setObject:[self.data3 base64EncodedString] forKey:@"Path"];
        [dicMediaData3 setObject:self.type3 forKey:@"Type"];
        [dicMediaData3 setObject:@"2" forKey:@"Tag"];
        [dicMediaData3 setObject:[NSString stringWithFormat:@"%d",id3] forKey:@"Id"];
        [arrMedias addObject:dicMediaData3];
    }
    
    [dicEvent setObject:arrMedias forKey:@"Medias"];
    [dicEvent setObject:arrInvites forKey:@"Invites"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicEvent forKey:@"Event"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *strUrl;
    
    if([eventId isEqualToString:@"0"])
        strUrl=[NSString stringWithFormat:@"%@%@",IP2,CreateFest];
    else
        strUrl=[NSString stringWithFormat:@"%@%@",IP2,UpdateFest];
    
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest new];
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
                    [self showAlertView_CF:@"" message:No_Internet];
                else
                    [self showAlertView_CF:@"" message:self.dataRequest.error.localizedDescription];
                
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                if(self.isEdit)
                    [self performSelectorOnMainThread:@selector(updateLocalDB) withObject:nil waitUntilDone:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [GC hideLoader];
                    
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Fest saved successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                });
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlertView_CF:@"" message:strFailure];
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
            
            [self showAlertView_CF:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Upload Video to Server
-(void)uploadVideotoServer:(NSURL *)urlVideo
{
    NSString *urlString=[urlVideo path];
    
    NSString *videoName = urlString.lastPathComponent;

    NSString *username = @"Demo-FestApp";
    NSString *password = @"SmartWork";
    
    NSString *urlpath = [NSString stringWithFormat:@"http://114.69.235.57:5560/Content/Medias"];
    urlpath = [urlpath stringByAppendingString:@"username="];
    urlpath = [urlpath stringByAppendingString:username];
    urlpath = [urlpath stringByAppendingString:@"&password="];
    urlpath = [urlpath stringByAppendingString:password];
    
    NSURL *url = [NSURL URLWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:videoName forKey:@"Filename"];
    [request setFile:urlString forKey:@"videoFile"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setUploadProgressDelegate:self];
    [request setTimeOutSeconds:50000];
    [request startAsynchronous];
    
}

#pragma mark - Fest Menu
- (IBAction)menuFest:(id)sender
{
    flagExit = 1;
    
    [mytxtfield resignFirstResponder];
    [mytxtView resignFirstResponder];
    
    if(self.isEdit)
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Image or Video Uploads
- (IBAction)upload1:(id)sender
{
    flag_btn = 1;
    [mytxtfield resignFirstResponder];
    [mytxtView resignFirstResponder];
    
   /* UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery",@"Capture",nil];
    [actionSheet showInView:self.view];
    */
    [self uploadOptions];
}

- (IBAction)upload2:(id)sender
{
    flag_btn = 2;
    [self uploadOptions];
}

- (IBAction)upload3:(id)sender
{
    flag_btn = 3;
    [self uploadOptions];
}

#pragma mark - Invite People
- (IBAction)invitePeople:(id)sender
{
    flagExit = 0;
    
    InviteViewController *IV = [self.storyboard instantiateViewControllerWithIdentifier:Invite_ViewController];
    IV.isAdditionalInvite = NO;
    [self.navigationController pushViewController:IV animated:YES];
    
}

#pragma mark - Save Fest
- (IBAction)saveFest:(id)sender
{
    NSLog(@"festType: %zd", festType);
    
    flagExit = 0;
    
    [GC showLoader:self withText:@"Processing..."];
    
    if(isReach)
    {
        if([self validation_CF] == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(flagEdit == 1)
                {
                    [self getFullAddress];
                    
                    if([self getLocationFromAddress:strAddress] == 0)
                    {
                        if(!self.isEdit)
                            [self createFest:@"0"];
                        else
                            [self createFest:[NSString stringWithFormat:@"%ld",(long)[GC eventID]]];
                        
                    }
                    else
                    {
                        [self showAlertView_CF:@"" message:strMsg];
                    }
                }
                else
                {
                    if(!self.isEdit)
                        [self createFest:@"0"];
                    else
                        [self createFest:[NSString stringWithFormat:@"%ld",(long)[GC eventID]]];
                }
            });
        }
    }
    else
    {
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:No_Internet];
    }
}

#pragma mark - Add Host
- (IBAction)addHost:(id)sender
{
    flagExit = 0;
    
    HostViewController *HV = [self.storyboard instantiateViewControllerWithIdentifier:Host_ViewController];
    [self.navigationController pushViewController:HV animated:YES];
}

#pragma mark - Open Location
/*- (IBAction)openLocation:(id)sender
{
    flagExit = 0;
    
    [mytxtfield resignFirstResponder];
    [mytxtView resignFirstResponder];
    
    if(isReach)
    {
        MapViewController *MV = [self.storyboard instantiateViewControllerWithIdentifier:Map_ViewController];
        
        if(flagEdit == 1)
        {
            [self getFullAddress];
            SetValue_Key(txtStreet.text, @"Street");
            MV.strAddress = self.strAddress.copy;
            MV.latitude = 0.0;
            MV.longitude = 0.0;
        }
        else{
            SetValue_Key(txtStreet.text, @"Street");
            MV.strAddress = @"";
            MV.latitude = cLatitude;
            MV.longitude = cLongitude;
        }
        
        MV.miles = roundf(self.sliderDistance.value);
        [self.navigationController pushViewController:MV animated:YES];
    }
    else
    {
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:No_Internet];
    }
    
}*/

#pragma mark - Distance Slider Changes
- (IBAction)sliderDistanceChange:(id)sender
{
    [self calculateRadius];
}

-(void)calculateRadius
{
    DISPLAY_METHOD_NAME;
    float val=self.sliderDistance.value;
    ILLog(@"val: %f", val);
    miles = (NSInteger) roundf(self.sliderDistance.value);
    
    if(miles<63360)
    {
        
        miles = (NSInteger) roundf(miles/1760) * 100 ;
        
        if(miles<=50)
            miles = 50;
        
        if(miles>50)
            miles = miles/2;
        NSMutableAttributedString *_attStrMiles = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)miles] attributes:@{NSForegroundColorAttributeName: COLOR_MAINCOLOR}];
        [_attStrMiles appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" yards" attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}]];
        self.lblDistance.attributedText = _attStrMiles;
        //self.lblMile.text = @"Yards";
    }
    else
    {
        miles = (NSInteger ) roundf(self.sliderDistance.value/1760);
        miles -= 36;
        
        if(miles == 0 || miles == 1)
            miles = 2;
        
        NSMutableAttributedString *_attStrMiles = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)miles] attributes:@{NSForegroundColorAttributeName: COLOR_MAINCOLOR}];
        [_attStrMiles appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" miles(s)" attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}]];
        self.lblDistance.attributedText = _attStrMiles;
        
        //self.lblDistance.text = [NSString stringWithFormat:@"%ld",(long)miles];
        //self.lblMile.text = @"";
    }
    
}

#pragma mark - Move to Map View
-(void)getFullAddress
{
    flagExit = 0;
    NSArray *arrKeys = [dicAddress allKeys];
    
    if(arrKeys.count>0)
    {
        arrKeys = [arrKeys sortedArrayUsingSelector:@selector(compare:)];
        
        int val = 0;
        for (int i=0; i<arrKeys.count; i++)
        {
            val = [[arrKeys objectAtIndex:i] intValue];
            
            switch (val) {
                case 0:
                    strAddress = [dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]];
                    break;
                case 1:
                {
                    if(strAddress.length>0)
                        strAddress =[NSString stringWithFormat:@"%@,%@",strAddress,[dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]]];
                    else
                        strAddress = [dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]];
                }
                    break;
                case 2:
                {
                    if(strAddress.length>0)
                        strAddress =[NSString stringWithFormat:@"%@,%@",strAddress,[dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]]];
                    else
                        strAddress = [dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]];
                }
                    break;
                case 3:
                {
                    if(strAddress.length>0)
                        strAddress =[NSString stringWithFormat:@"%@,%@",strAddress,[dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]]];
                    else
                        strAddress = [dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]];
                }
                    
                    break;
                case 4:
                {
                    if(strAddress.length>0)
                        strAddress =[NSString stringWithFormat:@"%@,%@",strAddress,[dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]]];
                    else
                        strAddress = [dicAddress objectForKey:[NSString stringWithFormat:@"%d",val]];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    else
    {
        strAddress = @"";
    }
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

#pragma mark - open mapView button pressed
- (IBAction)openMapViewButtonPressed:(id)sender
{
    flagExit = 0;
    
    [mytxtfield resignFirstResponder];
    [mytxtView resignFirstResponder];
    
    if(isReach)
    {
        TASK_EXTRA;
        TEST_MODE;
        if ([ILLogic flagLocationAccessDenied]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Location access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = tagAlertLocationDenied;
            [alert show];
        }
        else{

            MapViewController *MV = [self.storyboard instantiateViewControllerWithIdentifier:Map_ViewController];
            if(flagEdit == 1)
            {
                [self getFullAddress];
                SetValue_Key(txtStreet.text, @"Street");
                MV.strAddress = self.strAddress.copy;
                MV.latitude = 0.0;
                MV.longitude = 0.0;
            }
            else{
                SetValue_Key(txtStreet.text, @"Street");
                MV.strAddress = @"";
                MV.latitude = cLatitude;
                MV.longitude = cLongitude;
            }
            
            MV.miles = roundf(self.sliderDistance.value);
            [self.navigationController pushViewController:MV animated:YES];
        }
        TEST_MODE;
        TASK_EXTRA;
    }
    else
    {
        [GC hideLoader];
        
        [self showAlertView_CF:@"" message:No_Internet];
    }
    
    
}

-(void)setDtae:(NSString *)dateStr toPicker:(UIDatePicker *)date_Picker
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *anyDate = [dateFormat dateFromString:dateStr];
    [date_Picker setDate:anyDate animated:YES];
}
@end
