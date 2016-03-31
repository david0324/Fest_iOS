//
//  AboutViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 22/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "AboutViewController.h"
#import "FestWebViewController.h"
//#import "RESideMenu.h"

#define ScrollHeight 580

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize view_header,lbl_header,lblAbout,lblFollow,lblContact,txtEmail,txtViewMessage,txtViewAbout,scrollAbout,btnMenu,btnFacebook,btnInsta,btnSend,btnTwitter;

CGFloat svos;

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
    
    [self.btnMenu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.lbl_header setFont:[UIFont fontWithName:LatoRegular size:18.0]];
    [self.lblAbout setFont:[UIFont fontWithName:LatoRegular size:14.0]];
    [self.lblFollow setFont:[UIFont fontWithName:LatoBold size:18.0]];
    [self.lblContact setFont:[UIFont fontWithName:LatoBold size:18.0]];
    //[self.txtViewAbout setFont:[UIFont fontWithName:LatoBold size:16.0]];
    [self.txtEmail setFont:[UIFont fontWithName:LatoRegular size:16.0]];
    [self.txtViewMessage setFont:[UIFont fontWithName:LatoRegular size:16.0]];
    
    txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtEmail.placeholder attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}];
    //[txtEmail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    txtViewMessage.text = @"Comments";
    //txtViewMessage.textColor = COLOR_MAINTINTCOLOR;
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [txtEmail setLeftViewMode:UITextFieldViewModeAlways];
    [txtEmail setLeftView:spacerView];
    
    //CALayer *txtViewLayer = [txtViewMessage layer];
    //txtViewLayer.borderColor = setColor(223, 223, 223).CGColor;
    //txtViewLayer.borderWidth = 0.5f;
    
    UIEdgeInsets edgeInsets = txtViewMessage.textContainerInset;
    edgeInsets.left = 5.0f;
    [txtViewMessage setTextContainerInset:edgeInsets];
    
    btnSend.layer.cornerRadius = 3.0;
    [btnSend addTarget:self action:@selector(requestFeedback) forControlEvents:UIControlEventTouchUpInside];
    
    //[btnFacebook setImage:[UIImage imageNamed:@"icon_fb"] forState:UIControlStateNormal];
    //[btnTwitter setImage:[UIImage imageNamed:@"icon_twitter"] forState:UIControlStateNormal];
    //[btnInsta setImage:[UIImage imageNamed:@"icon_instagram"] forState:UIControlStateNormal];
    
    [btnFacebook addTarget:self action:@selector(openSelectedURL:) forControlEvents:UIControlEventTouchUpInside];
    [btnInsta addTarget:self action:@selector(openSelectedURL:) forControlEvents:UIControlEventTouchUpInside];
    [btnTwitter addTarget:self action:@selector(openSelectedURL:) forControlEvents:UIControlEventTouchUpInside];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    tap.numberOfTapsRequired = 1;
    [self.scrollAbout addGestureRecognizer:tap];
    
    self.userModel = [[GC arrUserDetails] firstObject];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [GC setParentVC:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap On View
-(void)tapOnView:(UITapGestureRecognizer *)gest
{
    if(gest.state == UIGestureRecognizerStateEnded)
    {
        [txtViewMessage resignFirstResponder];
        [txtEmail resignFirstResponder];
        
        [self.scrollAbout setContentOffset:CGPointMake(0, svos) animated:YES];
        [scrollAbout setContentSize:CGSizeMake(self.view.frame.size.width, (ScrollHeight))];
    }
}

#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtEmail = textField;
    
    [scrollAbout setContentSize:CGSizeMake(self.view.frame.size.width, (ScrollHeight+100))];
    
    CGPoint pt;
    CGRect rc;
    rc = [txtEmail bounds];
    rc = [txtEmail convertRect:rc toView:scrollAbout];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= (self.view.frame.size.height-216-70-txtEmail.frame.size.height-10);
    svos = pt.y;
    
    [scrollAbout setContentOffset:pt animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scrollAbout setContentOffset:CGPointMake(0, svos) animated:YES];
    [scrollAbout setContentSize:CGSizeMake(self.view.frame.size.width, (ScrollHeight))];
    return YES;
}

#pragma mark - TextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    txtViewMessage = textView;
    
    if([txtViewMessage.text isEqualToString:@"Comments"])
    {
        txtViewMessage.text = @"";
        txtViewMessage.textColor = COLOR_MAINTINTCOLOR;//[UIColor blackColor];
    }
    
    [scrollAbout setContentSize:CGSizeMake(self.view.frame.size.width, (ScrollHeight+180))];
    
    CGPoint pt;
    CGRect rc;
    rc = [txtViewMessage bounds];
    rc = [txtViewMessage convertRect:rc toView:scrollAbout];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= (self.view.frame.size.height-216-70-txtViewMessage.frame.size.height-10);
    svos = pt.y;
    
    [scrollAbout setContentOffset:pt animated:YES];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(txtViewMessage.text.length == 0)
    {
        txtViewMessage.text = @"Comments";
        txtViewMessage.textColor = COLOR_MAINTINTCOLOR;//[UIColor lightGrayColor];
    }
    else
    {
        txtViewMessage.textColor = COLOR_MAINTINTCOLOR;//[UIColor blackColor];
    }
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

#pragma mark - Email validation
- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

#pragma mark - Open URL
-(void)openSelectedURL:(UIButton *)sender
{
    [self.scrollAbout setContentOffset:CGPointMake(0, 0) animated:YES];
    [scrollAbout setContentSize:CGSizeMake(self.view.frame.size.width, (ScrollHeight))];
    [txtViewMessage resignFirstResponder];
    
    switch (sender.tag) {
        case 1:
            SetValue_Key(@"https://facebook.com", @"FollowURL");
            break;
            
        case 2:
            SetValue_Key(@"https://twitter.com/FestApplication", @"FollowURL");
            break;
            
        case 3:
            SetValue_Key(@"http://instagram.com/festapp", @"FollowURL");
            break;
            
        default:
            break;
    }
    
    FestWebViewController *FV = [self.storyboard instantiateViewControllerWithIdentifier:FestWeb_ViewController];
    [self.navigationController pushViewController:FV animated:YES];
}

#pragma mark - Show Alert View
-(void)showAlertView_About:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - Request For Feedback
-(void)requestFeedback
{
    [txtEmail resignFirstResponder];
    [txtViewMessage resignFirstResponder];
    
    [self.scrollAbout setContentOffset:CGPointMake(0, svos) animated:YES];
    
    [scrollAbout setContentSize:CGSizeMake(self.view.frame.size.width, (ScrollHeight))];
    
    [GC showLoader];
    
    if(isReach)
    {
        if(txtEmail.text.length == 0)
        {
            [GC hideLoader];
            
            [self showAlertView_About:@"" message:@"Please enter email id."];
        }
        else if (![self validateEmail:txtEmail.text])
        {
            [GC hideLoader];
            
            [self showAlertView_About:@"" message:@"Please enter valid email id."];
        }
        else if ([txtViewMessage.text isEqualToString:@"Comments"] || txtViewMessage.text.length == 0)
        {
            [GC hideLoader];
            
            [self showAlertView_About:@"" message:@"Please enter message."];
        }
        else
        {
            [self sendFeedback];
        }
    }
    else
    {
        [GC hideLoader];
        
        [self showAlertView_About:@"" message:No_Internet];
    }
    
}

#pragma mark - Send Feedback
-(void)sendFeedback
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:txtEmail.text forKey:@"UserEmail"];
    [dicMain setObject:txtViewMessage.text forKey:@"EmailContent"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *strJson = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *dataMyJson =[strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,Feedback];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:dataMyJson]];
    
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        
        if([self.dataRequest error])
        {
            [GC hideLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    [self showAlertView_About:@"" message:No_Internet];
                else
                    [self showAlertView_About:@"" message:self.dataRequest.error.localizedDescription];
                
            });
            
        }
        else if ([self.dataRequest responseString])
        {
            
            NSData *data= [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result == 1)
            {
                txtEmail.text = @"";
                txtViewMessage.text = @"";
                
                [self showAlertView_About:@"" message:@"Your feedback has sent successfully."];
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
                            [self showAlertView_About:@"" message:strFailure];
                        }
                        else
                            [self showAlertView_About:@"" message:strFailure];
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
            
            [self showAlertView_About:@"" message:ServerError];
            
        });
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
