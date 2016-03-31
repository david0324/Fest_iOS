//
//  FestMacro.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 16/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#ifndef Fest_FestMacro_h
#define Fest_FestMacro_h

#define MR_SHORTHAND
#define MR_ENABLE_ACTIVE_RECORD_LOGGING 0 // disable logging in Magical record

#pragma mark - Load Classes
#import "GlobalClass.h"
#import "AFNetworkReachabilityManager.h"
#import "UIImageView+WebCache.h"
#import "MyFest.h"

#define GC [GlobalClass sharedInstance]

#pragma mark - NSUserDefaults Process
#define allocUserDefault NSUserDefaults *dVal = [NSUserDefaults standardUserDefaults]
#define getUserDefault(key) [dVal objectForKey:key]
#define setUserDefault(values,key) [dVal setObject:values forKey:key]

#pragma mark - Set Keys and Values
#define SetValue_Key(value,key)  [[[GlobalClass sharedInstance] dicUserDefaults] setObject:value forKey:key]
#define GetValue_Key(key) [[[GlobalClass sharedInstance] dicUserDefaults] objectForKey:key]

#define KeyValue(X) [NSString stringWithFormat:@"%ld",(long)X]

#define deviceTokenKey   @"token"

#pragma mark - Screen Detection
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : [regular stringByAppendingString:@"-568h"])

#define getScreen_Height (NSString*) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? @"regular" : @"long")

#pragma mark - Set Color
#define setColor(r,g,b) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:1.0]

#pragma mark - Form Image URL to Pass
#define URL(Val) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,Val]]

#pragma mark - FB Image URL
#define FBURL(Val) [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/v2.3/%@/picture?type=large",Val]]

#pragma mark - Make Sub View Center
#define ALIGHN_SUBVIEW_CENTER(subView,inView) CGRectMake((inView.frame.size.width/2) - (subView.frame.size.width/2),(inView.frame.size.height/2) - (subView.frame.size.height/2),subView.frame.size.width,subView.frame.size.height)


#pragma mark - Go to View Controller
#define go_to(to) {\
UIViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:to];\
[self.navigationController pushViewController:vc animated:YES];\
}

#pragma mark - Check OS Version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - IP and URL

//Amazon URL
#define IP2 @"http://ec2-54-69-37-46.us-west-2.compute.amazonaws.com/festapp.api.com"
#define ImageURL @"http://ec2-54-69-37-46.us-west-2.compute.amazonaws.com/festapp.api.com/Content/Medias/"
#define IP3 @"http://54.69.37.46/festapp.api.com" // newly created for broadcast section and all

// - Development
//#define IP2  @"http://114.69.235.57:5559"
//#define ImageURL @"http://114.69.235.57:5559/Content/Medias/"

// - Demo
//#define IP2  @"http://114.69.235.57:5560"
//#define ImageURL @"http://114.69.235.57:5560/Content/Medias/"

//Login
#define LoginURL @"/api/user/login"

//Get Activation Code
#define GetActivationCode @"/api/User/UpdatePhoneNumber"

//Process Activation Code
#define ProcessCode @"/api/User/UpdateActivationCode"

//Get Old Number
#define GetMyNumber @"/api/User/ResetPhoneNumber"

//Reset Phone Number
#define ResetNumber @"/api/User/ResetPhoneNumber"

//Update User Info
#define UpdateUser @"/api/user/UpdateUser"

//Get Updated User Info
#define Selected @"/api/user/SelectUser"

//Create Fest
#define CreateFest @"/api/Event/CreateEvent"

//Update Fest
#define UpdateFest @"/api/Event/UpdateEvent"

//Update Fest
#define DeleteFest @"/api/Event/DeleteUserFromEvent"

//Find Fest
#define FindFest @"/api/Event/SelectEvents"

//User Created Fest
#define AllMyFest @"/api/UserEvent/SelectMyEvents"

//Accept or Reject Event
#define UpdateEventStatus @"/api/EventInvite/UpdateEventInviteStatus"

//Individual Fest Event
#define GetFest @"/api/event/SelectEvent"

//Invite People Additionally
#define Invite @"/api/EventInvite/InviteEvent"

//Get Attending List
#define Attending @"/api/EventUser/SelectAttendingUsers"

//Get All Comments
#define AllComments @"/api/EventChatComment/SelectEventChatComments"

//Post Comment
#define PostComment @"/api/EventChatComment/CreateEventChatComment"

//Like Event
#define LikeEvent @"/api/EventChatLike/UpdateEventChatLike"

//Get All Chats
#define AllChats @"/api/EventChat/SelectEventChats"

//Post Chat
#define PostChat @"/api/EventChat/CreateEventChat"

//All Users
#define AllUsers @"/api/user/SelectAllUser"

//Feedback
#define Feedback @"/api/ContactUs/ContactUsEMail"


//Get Create Event Post  [broadcast section]
#define CreateEventPost @"/api/EventPosts/PostToEvent"

//Get All EventPosts  [broadcast section]
#define AllEventPosts @"/api/EventPosts/GetAllEventPosts"

//Get EventPost Comments  [broadcast section]
#define EventPostComments @"/api/EventPosts/GetEventPostComments"

//like/dislike EventPost Comments  [broadcast section]
#define LikeDisLikeEventPost @"/api/EventPosts/UpdateEventPostLike"

//get EventPost details  [broadcast section]
#define EventPostDetails @"/api/EventPosts/GetEventPost"

//delete Fest event
#define DeleteFest @"/api/Event/DeleteUserFromEvent"

//get Fest event likers list
#define EventLikersList @"/api/EventPosts/GetLikersList"



#pragma mark - Login Request Parameters
#define LoginFacebookId @"FacebookId"
#define LoginFirstName @"FirstName"
#define LoginLastName @"LastName"
#define LoginDateOfBirth @"DateOfBirth"
#define LoginDevices @"Devices"
#define LoginMedias @"Medias"

#pragma mark - Common Alert Messages
#define ServerError @"Server Error, Please try later."
#define InternalServerError @"Internal Server error. Please try later."
#define No_Internet @"Network disconnected."
#define Connection_Timed_Out @"Connection timed out."
#define No_Camera @"Device has no camera."
#define No_GalleryImages @"No image is in the gallery"
#define No_Email_Account @"Please configure email account in your mobile."
#define Unknown_Alert @"Something went wrong, please try later."
#define UnAuthorised @"Unauthorized request."

#pragma mark - Check Network Availability
#define isReach [[AFNetworkReachabilityManager sharedManager] isReachable]
#define isMobileData [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN]
#define isWifi [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]

#pragma mark - App Fonts
#define Ionicons @"ionicons"
#define MontserratAlternatesBold @"MontserratAlternates-Bold"
#define MontserratAlternatesRegular @"MontserratAlternates-Regular"
#define ProximaNovaBold @"ProximaNova-Bold"
#define ProximaNovaLight @"ProximaNova-Light"
#define ProximaNovaRegular @"ProximaNova-Regular"
#define ProximaNovaSemibold @"ProximaNova-Semibold"
#define MisoRegular @"miso"


#define COLOR_MAINCOLOR [UIColor colorWithRed:.25 green:.87 blue:.7 alpha:1.0]
#define COLOR_MAINTINTCOLOR [UIColor colorWithRed:.6 green:.7 blue:.8 alpha:1.0]
#define COLOR_TOOLBARCOLOR [UIColor colorWithRed:.2 green:.25 blue:.35 alpha:1.0]

#define LatoLight @"Lato-Light"
#define LatoRegular @"Lato-Regular"
#define LatoBold @"Lato-Bold"

#pragma mark - View Controller Story board ID
#define Home_NavigationController @"HomeNavigationController"
#define NavPush_Controller @"NavPushController"
#define Login_ViewController @"LoginViewController"
#define Activation_ViewController @"ActivationViewController"
#define Reset_ViewController @"ResetViewController"
#define FindFest_ViewController @"FindFestViewController"
#define MyFest_ViewController @"MyFestViewController"
#define FestDetail_ViewController @"FestDetailViewController"
#define SlideNavigation_controller @"SlideNavigationController"
#define Base_ViewController @"BaseViewController"
#define Slide_ViewController @"SlideViewController"
#define Profile_ViewController @"ProfileViewController"
#define CreateFest_ViewController @"CreateFestViewController"
#define Map_ViewController @"MapViewController"
#define Host_ViewController @"HostViewController"
#define Contact_ViewController @"ContactViewController"
#define Comment_ViewController @"CommentViewController"
#define Attending_ViewController @"AttendingViewController"
#define Preview_ViewController @"PreviewViewController"
#define Page_ViewController @"PageViewController"
#define Content_ViewController @"ContentViewController"
#define RouteMap_ViewController @"RouteMapViewController"
#define Invite_ViewController @"InviteViewController"
#define Chat_ViewController @"ChatViewController"
#define ChatImage_ViewController @"ChatImageViewController"
#define About_ViewController @"AboutViewController"
#define FestWeb_ViewController @"FestWebViewController"
#define Help_ViewController @"HelpViewController"
#define Player_ViewController @"PlayerViewController"

#define EventPostsList_VC @"EventPostsList"


#pragma mark - Table View Cell ID's
#define CellSlide_ID @"CellSlide"
#define CellEven_ID @"CellEven"
#define CellOdd_ID @"CellOdd"
#define CellFindFest_ID @"CellFindFest"
#define CellMyFest_ID @"CellMyFest"
#define CellEvenMyFest_ID @"CellEvenMyFest"
#define CellOddMyFest_ID @"CellOddMyFest"
#define CellProfile_ID @"CellProfile"
#define CellHost_ID @"CellHost"
#define CellComment_ID @"CellComment"
#define CellInvite_ID @"CellInvite"
#define CellChatEven_ID @"CellChatEven"
#define CellChatOdd_ID @"CellChatOdd"
#define CellAttending_ID @"CellAttending"

#endif
