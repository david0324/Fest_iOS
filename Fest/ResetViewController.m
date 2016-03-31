//
//  ResetViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 20/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "ResetViewController.h"
#import "ActivationViewController.h"

@interface ResetViewController ()

@end

@implementation ResetViewController
@synthesize txtNew,txtOld,btnReset,myTxt,lbl_header,view_header,scrollReset,strOldNumber,lblOld,lblNew;

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
    
    CGFloat x = self.view.frame.size.width - 280;
    x = x/2;
    
    lblOld = [[UILabel alloc] initWithFrame:CGRectMake(x, 80, 280, 20)];
    lblOld.text = @"Enter Old Number:";
    lblOld.textColor = [UIColor blackColor];
    lblOld.font = [UIFont fontWithName:ProximaNovaSemibold size:17.0];
    lblOld.textAlignment = NSTextAlignmentLeft;
    [self.scrollReset addSubview:lblOld];
    
    lblNew = [[UILabel alloc] initWithFrame:CGRectMake(x, 170, 280, 20)];
    lblNew.text = @"Enter New Number:";
    lblNew.textColor = [UIColor blackColor];
    lblNew.font = [UIFont fontWithName:ProximaNovaSemibold size:17.0];
    lblNew.textAlignment = NSTextAlignmentLeft;
    [self.scrollReset addSubview:lblNew];
    
    txtOld = [[UITextField alloc] initWithFrame:CGRectMake(x, 110, 280, 40)];
    txtOld.delegate = self;
    txtOld.font = [UIFont fontWithName:ProximaNovaRegular size:17.0];
    txtOld.textColor = [UIColor blackColor];
    txtOld.textAlignment = NSTextAlignmentLeft;
    txtOld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtOld.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtOld.layer.borderWidth = 0.6f;
    txtOld.backgroundColor = [UIColor clearColor];
    txtOld.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    txtOld.autocorrectionType = UITextAutocorrectionTypeNo;
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:txtOld];
    txtOld.placeholder = @"Enter your phone number";
    [txtOld setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    txtNew = [[UITextField alloc] initWithFrame:CGRectMake(x, 200, 280, 40)];
    txtNew.delegate = self;
    txtNew.font = [UIFont fontWithName:ProximaNovaRegular size:17.0];
    txtNew.textColor = [UIColor blackColor];
    txtNew.textAlignment = NSTextAlignmentLeft;
    txtNew.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtNew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtNew.layer.borderWidth = 0.6f;
    txtNew.backgroundColor = [UIColor clearColor];
    txtNew.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    txtNew.autocorrectionType = UITextAutocorrectionTypeNo;
//    [ILLogic enableAutoCorrectionForTextFieldAndTextView:txtNew];
    txtNew.placeholder = @"Enter your phone number";
    [txtNew setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self leftSpaceView:txtOld];
    [self leftSpaceView:txtNew];
    
    x = self.view.frame.size.width - 100;
    x = x/2;
    
    btnReset = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReset.frame = CGRectMake(x, 270, 100, 40);
    btnReset.backgroundColor = setColor(46, 188, 194);
    [btnReset setTitle:@"Submit" forState:UIControlStateNormal];
    [btnReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReset.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnReset.titleLabel setFont:[UIFont fontWithName:ProximaNovaSemibold size:17.0]];
    [btnReset addTarget:self action:@selector(resetPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollReset addSubview:txtOld];
    [self.scrollReset addSubview:txtNew];
    [self.scrollReset addSubview:btnReset];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_Reset:)];
    tap.numberOfTapsRequired = 1;
    [self.scrollReset addGestureRecognizer:tap];
    
    self.userModel  = [[GC arrUserDetails] firstObject];
    
    strOldNumber = [NSString new];
    
    [GC setParentVC:self];
    
    [GC showLoader];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self getOldNumberRequest];
        
    });
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.userModel = [[GC arrUserDetails] firstObject];
    [GC setParentVC:self];
    
    if([GetValue_Key(@"ResetNumber") isEqualToString:@"ResetNumber"])
    {
        txtOld.text = txtNew.text.copy;
        strOldNumber = txtNew.text.copy;
        
        txtNew.text = @"";
        
        [txtOld setEnabled:NO];
        
        SetValue_Key(@"", @"ResetNumber");
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.userModel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap On Scroll
-(void)tap_Reset:(UITapGestureRecognizer *)gest
{
    if(gest.state == UIGestureRecognizerStateEnded)
    {
        [myTxt resignFirstResponder];
        
        [self.scrollReset setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - Left Space View
-(void)leftSpaceView:(UITextField*) textFields
{
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [textFields setLeftViewMode:UITextFieldViewModeAlways];
    [textFields setLeftView:spacerView];
}

#pragma mark - Text Field Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    myTxt = textField;
    
    [self.scrollReset setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-70)];
    
    CGPoint pt;
    CGRect rc;
    rc = [myTxt bounds];
    rc = [myTxt convertRect:rc toView:scrollReset];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= (216-70-myTxt.frame.size.height-10);
    
    [scrollReset setContentOffset:CGPointMake(0, pt.y) animated:YES];
    
    [self.scrollReset setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-70+60)];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [myTxt resignFirstResponder];
    
    [self.scrollReset setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-70)];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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

#pragma mark - Show Alert View
-(void)showAlert_Reset:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex])
    {
        SetValue_Key(@"ResetNumber", @"ResetNumber");
        
        ActivationViewController *AV = [self.storyboard instantiateViewControllerWithIdentifier:Activation_ViewController];
        [self.navigationController pushViewController:AV animated:YES];
    }
}

#pragma mark - Validation
-(int)validation
{
    int val = 0;
    
    if(txtOld.text.length<14)
    {
        val = 1;
        [GC hideLoader];
        [self showAlert_Reset:@"" message:@"Please enter valid old mobile number."];
    }
    else if (txtNew.text.length<14)
    {
        val = 1;
        [GC hideLoader];
        [self showAlert_Reset:@"" message:@"Please enter valid new mobile number."];
    }
    else if (![txtOld.text isEqualToString:strOldNumber])
    {
        val = 1;
        [GC hideLoader];
        [self showAlert_Reset:@"" message:@"Old number not matching with your account."];
        
    }
    
    return val;
}

#pragma mark - Reset Number Request
-(void)changeNumberRequest
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    NSMutableDictionary *dicActivation = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicActivation setObject:self.userModel.localID forKey:@"Id"];
    [dicActivation setObject:txtNew.text forKey:@"PhoneNumber"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicActivation forKey:@"Activation"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL=[NSString stringWithFormat:@"%@%@",IP2,GetActivationCode];
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
                
                [self showAlert_Reset:@"" message:self.dataRequest.error.localizedDescription];
                
            });
            
        }
        else if ([request responseString])
        {
            NSData *dat = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1)
            {
                int flagCode = [[json valueForKeyPath:@"Data.Status"] intValue];
                
                self.userModel.activation = [NSString stringWithFormat:@"%d",flagCode];
                
                [[GC arrUserDetails] replaceObjectAtIndex:0 withObject:self.userModel];
                
                [GC user_Data_Plist_SaveData_Settings];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Updated Successfully." message:@"Activation code has been sent to you via SMS." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                });
                
            }
            else
            {
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlert_Reset:@"" message:strFailure];
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
            
            [self showAlert_Reset:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Reset Number
-(void)resetPhoneNumber:(id)sender
{
    [myTxt resignFirstResponder];
    [self.scrollReset setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.scrollReset setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [GC showLoader];
    
    if(isReach)
    {
        if([self validation] == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self changeNumberRequest];
                
            });
        }
    }
    else
    {
        [GC hideLoader];
        
        [self showAlert_Reset:@"" message:No_Internet];
    }
}

#pragma mark - Get Old Number Request
-(void)getOldNumberRequest
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:self.userModel.localID forKey:@"UserId"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL=[NSString stringWithFormat:@"%@%@",IP2,GetMyNumber];
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
                
                [self showAlert_Reset:@"" message:self.dataRequest.error.localizedDescription];
                
            });
            
        }
        else if ([request responseString])
        {
            NSData *dat = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1)
            {
                strOldNumber = [NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.PhoneNumber"]];
            }
            else
            {
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlert_Reset:@"" message:strFailure];
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
            
            [self showAlert_Reset:@"" message:ServerError];
            
        });
    }
}

#pragma mark - Go Back
- (IBAction)goBack:(id)sender
{
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
