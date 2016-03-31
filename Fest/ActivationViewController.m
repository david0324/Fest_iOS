//
//  ActivationViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 08/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "ActivationViewController.h"
#import "SlideNavigationController.h"
#import "FindFestViewController.h"
#import "SlideViewController.h"
//#import "RESideMenu.h"

//#define ACCEPTABLE_CHARACTERS @"0123456789"

@interface ActivationViewController ()

@end

@implementation ActivationViewController

@synthesize txtActivation,txtMobile,lblActivation,btnEnter,myTxt,imgViewLink,flagCode;

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
    
//    [self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    [self.lbl_header setFont:[UIFont fontWithName:ProximaNovaSemibold size:20.0]];
    
    lblActivation.font = [UIFont fontWithName:ProximaNovaSemibold size:17.0];
    txtMobile.font = [UIFont fontWithName:ProximaNovaRegular size:17.0];
    
    CGFloat x = self.view.frame.size.width - 280;
    x = x/2;
    
    txtMobile = [[UITextField alloc] initWithFrame:CGRectMake(x, 230, 280, 44)];
    txtMobile.delegate = self;
    txtMobile.font = [UIFont fontWithName:ProximaNovaRegular size:17.0];
    txtMobile.textColor = [UIColor whiteColor];
    txtMobile.textAlignment = NSTextAlignmentLeft;
    txtMobile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //txtMobile.layer.borderColor = [UIColor whiteColor].CGColor;
    //txtMobile.layer.borderWidth = 0.6f;
    txtMobile.backgroundColor = [UIColor clearColor];
    txtMobile.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    txtMobile.autocorrectionType = UITextAutocorrectionTypeNo;
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:txtMobile];
    txtMobile.placeholder = @"Enter your phone number";
    [txtMobile setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIImage *fieldBGImage = [UIImage imageNamed:@"activation_input"];
    [txtMobile setBackground:fieldBGImage];
    
    
    txtActivation = [[UITextField alloc] initWithFrame:CGRectMake(0, 270, 110, 40)];
    txtActivation.center=CGPointMake(self.view.center.x, txtActivation.center.y);
    txtActivation.delegate = self;
    txtActivation.font = [UIFont fontWithName:ProximaNovaRegular size:17.0];
    txtActivation.textColor = [UIColor whiteColor];
    txtActivation.textAlignment = NSTextAlignmentLeft;
    txtActivation.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
   // txtActivation.layer.borderColor = [UIColor whiteColor].CGColor;
    //txtActivation.layer.borderWidth = 0.6f;
    txtActivation.backgroundColor = [UIColor clearColor];
    txtActivation.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [txtActivation setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txtActivation setBackground:fieldBGImage];
//    txtActivation.autocorrectionType = UITextAutocorrectionTypeNo;
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:txtActivation];

    
    [btnEnter.titleLabel setTextColor:COLOR_TEAL];
    
    [txtActivation addTarget:self action:@selector(txtFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [txtMobile addTarget:self action:@selector(txtFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[btnEnter titleLabel] setFont:[UIFont fontWithName:ProximaNovaSemibold size:17.0]];
    
    [self leftSpace:txtMobile];
    [self leftSpace:txtActivation];
    
    [btnEnter addTarget:self action:@selector(processActivation:) forControlEvents:UIControlEventTouchUpInside];
    
    btnEnter.layer.cornerRadius = 3.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_Activation:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    self.userModel = [[GC arrUserDetails] firstObject];
    
    if([GetValue_Key(@"ResetNumber") isEqualToString:@"ResetNumber"])
    {
        flagCode = 1;
    }
    
    if(flagCode == 0)
    {
        [self.view addSubview:txtMobile];
        [lblActivation setHidden:YES];
        [imgViewLink setHidden:YES];
        [btnEnter setTitle:@"Submit" forState:UIControlStateNormal];
    }
    else
    {
        [self.view addSubview:txtActivation];
        [lblActivation setHidden:NO];
        [imgViewLink setHidden:NO];
        [btnEnter setTitle:@"Activate" forState:UIControlStateNormal];
    }
    
    [GC setParentVC:self];
    
    lblActivation.center=CGPointMake(self.view.center.x, lblActivation.center.y);
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    txtActivation = nil;
    txtMobile = nil;
    myTxt = nil;
    self.dataRequest = nil;
    self.userModel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap Gesture
-(void)tap_Activation:(UITapGestureRecognizer *)gest
{
    if(gest.state == UIGestureRecognizerStateEnded)
    {
        if(flagCode == 0)
            [txtMobile resignFirstResponder];
        else
            [txtActivation resignFirstResponder];
        
    }
}

#pragma mark - Text Field Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    myTxt = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [myTxt resignFirstResponder];
    return YES;
}

-(void)txtFieldDidChange:(UITextField *)textField
{
    NSString *str;

    if (myTxt == txtActivation)
    {
        if(txtActivation.text.length>4)
        {
            str = txtActivation.text;
            txtActivation.text = [str substringToIndex:str.length-1].copy;
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    TEST_MODE;

    if(textField == txtMobile)
    {
        return YES;
    }
    
    TEST_MODE;
    
    
    
    
    
    
    if(textField == txtMobile)
    {
        
        if([string isEqualToString:@""])
        {
            return  YES;
        }
        
        if(textField.text.length>13)
        {
            return NO;
        }
        
        switch (textField.text.length)
        {
            case 0:
            {
                textField.text = [NSString stringWithFormat:@"1%@",string];
            }
                break;
                case 2:
            {
                textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            }
                break;
            case 3:
            {
                textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            }
                break;
            case 4:
            {
                NSString *areaCode = [textField.text substringWithRange:NSMakeRange(1, 3)];
                textField.text = [NSString stringWithFormat:@"1-%@-%@",areaCode,string];
            }
                break;
            case (7 | 8):
            {
                textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            }
                break;
            case 9:
            {
                NSString *center = [textField.text substringWithRange:NSMakeRange(6, 3)];
                NSString *before = [textField.text substringWithRange:NSMakeRange(0, 6)];
                textField.text = [NSString stringWithFormat:@"%@%@-%@",before,center,string];
            }
                break;
            default:
            {
                textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            }
                break;
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Left Space View
-(void)leftSpace:(UITextField*) textFields
{
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [textFields setLeftViewMode:UITextFieldViewModeAlways];
    [textFields setLeftView:spacerView];
}

#pragma mark - Show Alert View Activation
-(void)showAlert_Activation:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self goto_FindFest];
        });
    }
}

#pragma mark - Button Action Event
-(void)processActivation:(id)sender
{
    
//    DELETE_HARD_CODED;
//    txtMobile.text=@"919995867711";
//    DELETE_HARD_CODED;
    
    
    [GC showLoader];
    
    if(isReach)
    {
        if(flagCode == 0)
        {
            [txtMobile resignFirstResponder];
            
            if(txtMobile.text.length == 0)
            {
                [GC hideLoader];
                [self showAlert_Activation:@"" message:@"Please enter your mobile number."];
            }
//            else if(txtMobile.text.length<14)
//            {
//                [GC hideLoader];
//                [self showAlert_Activation:@"" message:@"Please enter a valid mobile number."];
//            }
//            else if (txtMobile.text.length>14)
//            {
//                [GC hideLoader];
//                [self showAlert_Activation:@"" message:@"Please enter a valid mobile number."];
//            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getActivationCodeRequest];
                });
            }
        }
        else
        {
            [txtActivation resignFirstResponder];
            
            if(txtActivation.text.length == 0)
            {
                [GC hideLoader];
                [self showAlert_Activation:@"" message:@"Please enter Activation code."];
            }
            else if (txtActivation.text.length<4)
            {
                [GC hideLoader];
                [self showAlert_Activation:@"" message:@"Please enter a valid activation code."];
            }
            else if(txtActivation.text.length == 4)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self codeProcessingRequest];
                });
                
            }
        }
    }
    else
    {
        [GC hideLoader];
        [self showAlert_Activation:@"" message:No_Internet];
    }
}

#pragma mark - Request To Get Activation Code
-(void)getActivationCodeRequest
{
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    NSMutableDictionary *dicActivation = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicActivation setObject:self.userModel.localID forKey:@"Id"];
    [dicActivation setObject:txtMobile.text forKey:@"PhoneNumber"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicActivation forKey:@"Activation"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL=[NSString stringWithFormat:@"%@%@",IP2,GetActivationCode];
    NSURL *url=[NSURL URLWithString:strURL];
    
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
                
                NSString *strError = [NSString new];
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    strError =  No_Internet;
                else
                    strError = self.dataRequest.error.localizedDescription;
                
                [self showAlert_Activation:@"" message:strError];
                
            });
            
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1)
            {
                flagCode = [[json valueForKeyPath:@"Data.Status"] integerValue];
                
                self.userModel.activation = [NSString stringWithFormat:@"%ld",(long)self.flagCode];
                
                [[GC arrUserDetails] replaceObjectAtIndex:0 withObject:self.userModel];
                
                [GC user_Data_Plist_SaveData_Settings];
                
                [txtMobile removeFromSuperview];
                [self.view addSubview:txtActivation];
                [lblActivation setHidden:NO];
                [imgViewLink setHidden:NO];
                [btnEnter setTitle:@"Activate" forState:UIControlStateNormal];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showAlert_Activation:@"" message:@"Activation code has been sent to you via SMS."];
                });
                
            }
            else
            {
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        if ([strFailure rangeOfString:@"Cannot route message"].length!=0)
                            [self showAlert_Activation:@"" message:@"Mobile format should be your country code followed by mobile number."];
                        else
                            [self showAlert_Activation:@"" message:strFailure];
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
            
            [self showAlert_Activation:@"" message:ServerError];
            
        });
    }
    
}

#pragma mark - Process Activation Code
-(void)codeProcessingRequest
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    NSMutableDictionary *dicActivation = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicActivation setObject:self.userModel.localID forKey:@"Id"];
    [dicActivation setObject:txtActivation.text forKey:@"ActivationCode"];
    
    [dicActivation setObject:txtMobile.text forKey:@"PhoneNumber"];

    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicActivation forKey:@"Activation"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL=[NSString stringWithFormat:@"%@%@",IP2,ProcessCode];
    NSURL *url=[NSURL URLWithString:strURL];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate=self;
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"content-type" value:@"application/json"];
    [request setPostBody:[NSMutableData dataWithData:myJSONData]];
    
    [request startSynchronous];
    
    if(request)
    {
        [GC hideLoader];
        
        if([request error])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showAlert_Activation:@"" message:self.dataRequest.error.localizedDescription];
                
            });
            
        }
        else if ([request responseString])
        {
            NSData *dat = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
                        
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1)
            {
                flagCode = [[json valueForKeyPath:@"Data.Status"] integerValue];
                
                self.userModel.activation = [NSString stringWithFormat:@"%ld",(long)self.flagCode];
                
                [[GC arrUserDetails] replaceObjectAtIndex:0 withObject:self.userModel];
                
                [GC user_Data_Plist_SaveData_Settings];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([GetValue_Key(@"ResetNumber") isEqualToString:@"ResetNumber"])
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Your account mobile number has been successfully updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                    }
                    else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Your Fest account has been successfully created." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                    }
                    
                });
                
            }
            else
            {
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlert_Activation:@"" message:strFailure];
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
            
            [self showAlert_Activation:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Move To Find Fest
-(void)goto_FindFest
{
    [GC requestAddressBookAccess];
    
    SlideViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:Slide_ViewController];
    FindFestViewController *FVC = [self.storyboard instantiateViewControllerWithIdentifier:FindFest_ViewController];
//    SlideNavigationController *SlideNav = [[SlideNavigationController alloc] initWithRootViewController:FVC];
//    
//    RESideMenu *BV = [[RESideMenu alloc] initWithContentViewController:SlideNav leftMenuViewController:SVC rightMenuViewController:nil];
    
    
    TEST_MODE;
    [self.navigationController pushViewController:FVC animated:YES];
    TEST_MODE;
}

#pragma mark - Go back to Change Mobile Number
- (IBAction)click_to_Change:(id)sender
{
    if([GetValue_Key(@"ResetNumber") isEqualToString:@"ResetNumber"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if(!imgViewLink.hidden)
        {
            [txtActivation removeFromSuperview];
            [self.view addSubview:txtMobile];
            [lblActivation setHidden:YES];
            [imgViewLink setHidden:YES];
            [btnEnter setTitle:@"Submit" forState:UIControlStateNormal];
            flagCode = 0;
        }
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

@end
