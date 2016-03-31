//
//  AppDelegate.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 11/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeNavigationController.h"
#import "SlideNavigationController.h"
#import "FindFestViewController.h"
//#import "RESideMenu.h"
#import "SlideViewController.h"
#import "GAI.h"
#import "FestDetailViewController.h"
#import "ChatViewController.h"
#import "NavPushController.h"
#import "GeofenceMonitor.h"
#import "BackendManager.h"


#import <GoogleMaps/GoogleMaps.h>

#define remoteNotifTypes UIRemoteNotificationTypeBadge | \
UIRemoteNotificationTypeAlert | \
UIRemoteNotificationTypeSound

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize locationManager,delLatitude,delLongitude,formatter,dateToday;

static NSString * const kDBName = @"FestCoreData.sqlite";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TEST_MODE;
    NSLog(@"push: %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"push"]);
    TEST_MODE;
    
    
    self.selectedIndexMenu=1;
    
    // Override point for customization after application launch.
    [self initUI];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if(localNotification)
    {
        NSLog(@"triggered.");
    }
    
    [self getCurrentLocation];
    
    TEST_MODE_GEO_FENCE;
    [self addAllMyFestsForGeoFenceEntryMonitoring];
    TEST_MODE_GEO_FENCE;
    
    [NSThread sleepForTimeInterval:1.0];
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRegisterExternalChangeCallback(addressBook, addressBookChanged, nil);
    
    [GMSServices provideAPIKey:@"AIzaSyBADbulXuIweLNcgEiMMuyvrLkM45anjKQ"];
    
    //[GMSServices provideAPIKey:@"AIzaSyBADbulXuIweLNcgEiMMuyvrLkM45anjKQ"];

    //[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-56511167-1"];
    
    [GAI sharedInstance].defaultTracker = tracker;
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    [application registerForRemoteNotifications];

    
    // Whenever a person opens app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // Call this method EACH time the session state changes,
                                          //  NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    //register for push notifications (JP's code 16DEC2014)
    /*if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }*/

    // Register for push notifications (from India devs)
    /*[[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    if (([[NSUserDefaults standardUserDefaults] stringForKey: deviceTokenKey]) &&
        
        ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] != (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)))
    {
        //user has probably disabled push. react accordingly.
        NSLog(@"User disabled push.");
    }*/
    

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self saveContext];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [GC requestAddressBookAccess];
    
    [FBAppEvents activateApp];
    
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
    
    
    //[FBAppCall handleDidBecomeActive];
    
    NSLog(@"DocDir: %@", [[self applicationDocumentsDirectory] absoluteString]);

    

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //[FBSession.activeSession closeAndClearTokenInformation];
    [[FBSession activeSession] closeAndClearTokenInformation];
    
    [self saveContext];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    //return [FBSession.activeSession handleOpenURL:url];
    // Note this handler block should be the exact same as the handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [self sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    //return [FBAppCall handleOpenURL:url];
    
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [self sessionStateChanged:session state:state error:error];
     }];
    
    return [[FBSession activeSession] handleOpenURL:url];
}
#pragma mark - Misc
-(void)localNotification{
    
    TEST_MODE;
    
    return;

    
//    DISPLAY_METHOD_NAME;
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.userInfo = @{@"EventId":@"57",@"Type":@"0"};
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertBody = @"fest local notification";
    localNotification.alertLaunchImage = @"icon_drop";
    
    TEST_MODE;
    localNotification.fireDate = [NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]];
    TEST_MODE;
    
    
    localNotification.hasAction = YES;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
        TEST_MODE;
}

#pragma mark - Global UI Change

- (void)initUI{
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"bg_sliderThumb"] forState:UIControlStateNormal];

}

#pragma mark - Address Book Change
void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    NSLog(@"AddressBook Changed");
}

#pragma mark - Push Notification Delegates
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    NSString *deviceToken = [newDeviceToken description];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString: @"<" withString: @""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString: @">" withString: @""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey: deviceTokenKey])
    {
        if (![[[NSUserDefaults standardUserDefaults] stringForKey: deviceTokenKey] isEqualToString: deviceToken])
        {
            [[NSUserDefaults standardUserDefaults] setObject: deviceToken forKey: deviceTokenKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //user allowed push.
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject: deviceToken forKey: deviceTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //user allowed push.
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Local Notification triggered.");
    
    // My Logic
    //Type - 0: Geo-Welcome, 1: Chat, 2: Geo-Thanks, 3: Comments, 4: Like, 5: Fest Invite
    
    if(!(application.applicationState == UIApplicationStateActive))
    {
        NSLog(@"notification.userInfo=>%@",notification.userInfo);
        
        int type = [[notification.userInfo valueForKey:@"Type"] intValue];
        
        switch (type) {
                
            case 0://Geo Fence Entry
            {
                [GC setEventID:[[notification.userInfo valueForKey:@"EventId"] integerValue]];
                
                SetValue_Key(@"Notification", @"Notification");
                SetValue_Key(@"Invite", @"Invite");
                SetValue_Key(@"FindFest", @"Nav");
                SetValue_Key(@"GeoFence", @"GeoFence");
                
                [self move_To_Controller];
            }
                break;

               /*
            case 1://Chat
            {
                [GC setEventID:[[notification.userInfo valueForKey:@"EventId"] integerValue]];
                
                SetValue_Key(@"Notification", @"Notification");
                SetValue_Key(@"", @"Reload");
                SetValue_Key(@"MyFest", @"Nav");
                SetValue_Key(@"1", @"isChat");
                
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[[[notification.userInfo valueForKey:@"Chat"] valueForKey:@"Notification"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
                
                [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                
                SetValue_Key([json valueForKeyPath:@"Data.PostedChat"], @"ChatData");
                SetValue_Key([json valueForKeyPath:@"Data.EventTitle"], @"EventTitle");
                
                [self move_To_Controller];
            }
                break;
                
            case 2://Geo Fence Exit
            {
                //Nothing doing ****
            }
                break;
            case 3://Comment
            {
                [GC setEventID:[[notification.userInfo valueForKey:@"EventId"] integerValue]];
                
                SetValue_Key(@"Notification", @"Notification");
                SetValue_Key(@"", @"Reload");
                SetValue_Key(@"MyFest", @"Nav");
                SetValue_Key(@"1", @"isComment");
                
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[[[notification.userInfo valueForKey:@"Comment"] valueForKey:@"Notification"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
                
                [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                
                //SetValue_Key([json valueForKeyPath:@"Data.Chat.Id"], @"ChatId");
                [GC setChatID:[[json valueForKeyPath:@"Data.Chat.Id"] integerValue]];
                SetValue_Key([json valueForKeyPath:@"Data.PostedComment"], @"CommentData");
                
                SetValue_Key([json valueForKeyPath:@"Data.Chat.TotalLike"], @"TotalLike");
                SetValue_Key([json valueForKeyPath:@"Data.Chat.LikeStatus"], @"LikeStatus");
                SetValue_Key([json valueForKeyPath:@"Data.Chat.MediaType"], @"MediaType");
                SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ImageChat");
                
                if([GetValue_Key(@"MediaType") intValue] == 1) // For Video
                {
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.ThumbPath"], @"ImageChat");
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ChatVideo");
                }
                
                [self move_To_Controller];
            }
                break;
                
            case 4://Like
            {
                [GC setEventID:[[notification.userInfo valueForKey:@"EventId"] integerValue]];
                
                SetValue_Key(@"Notification", @"Notification");
                SetValue_Key(@"", @"Reload");
                SetValue_Key(@"MyFest", @"Nav");
                SetValue_Key(@"1", @"isComment");
                
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[[[notification.userInfo valueForKey:@"Like"] valueForKey:@"Notification"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
                
                [GC setChatID:[[json valueForKeyPath:@"Data.Chat.Id"] integerValue]];
                
                SetValue_Key([json valueForKeyPath:@"Data.Chat.TotalLike"], @"TotalLike");
                SetValue_Key([json valueForKeyPath:@"Data.Chat.LikeStatus"], @"LikeStatus");
                SetValue_Key([json valueForKeyPath:@"Data.Chat.MediaType"], @"MediaType");
                SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ImageChat");
                
                if([GetValue_Key(@"MediaType") intValue] == 1) // For Video
                {
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.ThumbPath"], @"ImageChat");
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ChatVideo");
                }
                
                [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                
                [self move_To_Controller];
            }
                break;
                
            case 5://Fest Invite
            {
                [GC setEventID:[[notification.userInfo valueForKey:@"EventId"] integerValue]];
                
                SetValue_Key(@"Invite", @"Invite");
                SetValue_Key(@"Notification", @"Notification");
                SetValue_Key(@"FindFest", @"Nav");
                
                [self move_To_Controller];
            }
                break;
                */
                
                
            default:
                break;
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Push Notification Error: %@", [error localizedDescription]);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    DISPLAY_METHOD_NAME;
    NSLog(@"userInfo: %@", userInfo);
    
    TEST_MODE;
    NSMutableDictionary *d=[NSMutableDictionary new];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"push"]) {
        [d addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"push"]];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:d forKey:@"push"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    TEST_MODE;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[[userInfo valueForKey:@"Notification"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
    
    int type = [[json valueForKey:@"Type"] intValue];
    
    //Type - 0: Invite, 1: Chat, 2- Comments, 3- Like
    
    switch (type) {
            
        case 0://Fest Invite
        {
            if([[json valueForKeyPath:@"Data.EventId"] intValue]>0)
            {
                
                if (application.applicationState == UIApplicationStateActive)
                {
                    
                    if(![GetValue_Key(@"Screen") isEqualToString:@"X"])
                    {
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.userInfo = @{@"EventId" : [json valueForKeyPath:@"Data.EventId"], @"Type" : @"5"};
                        localNotification.soundName = UILocalNotificationDefaultSoundName;
                        localNotification.alertBody = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"aps.alert"]];
                        localNotification.alertLaunchImage = @"icon_drop";
                        localNotification.fireDate = [NSDate date];
                        localNotification.hasAction = YES;
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    }
                    
                }
                else
                {
                    SetValue_Key(@"Invite", @"Invite");
                    SetValue_Key(@"Notification", @"Notification");
                    SetValue_Key(@"FindFest", @"Nav");
                    
                    [GC setEventID:[[json valueForKeyPath:@"Data.EventId"] integerValue]];
                    [self move_To_Controller];
                }
                
                completionHandler(UIBackgroundFetchResultNewData);
            }
            else
            {
                completionHandler(UIBackgroundFetchResultNoData);
                NSLog(@"No Data avaiable");
                return;
            }
        }
            break;
            
        case 1://Chat Push
        {
            if([[json valueForKeyPath:@"Data.PostedChat.Id"] intValue]>0)
            {
                if (application.applicationState == UIApplicationStateActive) {
                    
                    if([GetValue_Key(@"Screen") isEqualToString:@"Chat"])
                    {
                        
                        NSInteger eventId = [[json valueForKeyPath:@"Data.EventId"] integerValue];
                        
                        if(eventId == [GC eventID])
                        {
                            SetValue_Key(@"Notification", @"Notification");
                            SetValue_Key(@"MyFest", @"Nav");
                            SetValue_Key(@"1", @"isChat");
                            SetValue_Key(@"Reload", @"Reload");
                            SetValue_Key([json valueForKeyPath:@"Data.PostedChat"], @"ChatData");
                            
                            [GC setEventID:[[json valueForKeyPath:@"Data.EventId"] integerValue]];
                            [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                            
                            [self move_To_Controller];
                        }
                        else
                        {
                            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                            localNotification.userInfo = @{@"Chat" : userInfo, @"EventId" : [json valueForKeyPath:@"Data.EventId"], @"Type" : @"1"};
                            localNotification.soundName = UILocalNotificationDefaultSoundName;
                            localNotification.alertBody = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"aps.alert"]];
                            localNotification.alertLaunchImage = @"icon_drop";
                            localNotification.fireDate = [NSDate date];
                            localNotification.hasAction = YES;
                            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                        }
                    }
                    else
                    {
                        
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.userInfo = @{@"Chat" : userInfo, @"EventId" : [json valueForKeyPath:@"Data.EventId"], @"Type" : @"1"};
                        localNotification.soundName = UILocalNotificationDefaultSoundName;
                        localNotification.alertBody = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"aps.alert"]];
                        localNotification.alertLaunchImage = @"icon_drop";
                        localNotification.fireDate = [NSDate date];
                        localNotification.hasAction = YES;
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    }
                }
                else
                {
                    SetValue_Key(@"Notification", @"Notification");
                    SetValue_Key(@"MyFest", @"Nav");
                    SetValue_Key(@"1", @"isChat");
                    SetValue_Key(@"", @"Reload");
                    
                    [GC setEventID:[[json valueForKeyPath:@"Data.EventId"] integerValue]];
                    [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                    
                    [self move_To_Controller];
                }
                
                completionHandler(UIBackgroundFetchResultNewData);
            }
            else
            {
                completionHandler(UIBackgroundFetchResultNoData);
                NSLog(@"No Data avaiable");
                return;
            }
        }
            break;
            
        case 2://Comment Push
        {
            if([[json valueForKeyPath:@"Data.PostedComment.Id"] intValue]>0)
            {
                
                if (application.applicationState == UIApplicationStateActive) {
                    
                    if([GetValue_Key(@"Screen") isEqualToString:@"Comment"])
                    {
                        
                        NSInteger chatId = [[json valueForKeyPath:@"Data.Chat.Id"] integerValue];
                        
                        if(chatId == [GC chatID])
                        {
                            SetValue_Key(@"Notification", @"Notification");
                            SetValue_Key(@"MyFest", @"Nav");
                            SetValue_Key(@"1", @"isComment");
                            
                            [GC setChatID:[[json valueForKeyPath:@"Data.Chat.Id"] integerValue]];
                            
                            SetValue_Key([json valueForKeyPath:@"Data.Chat.TotalLike"], @"TotalLike");
                            SetValue_Key([json valueForKeyPath:@"Data.Chat.LikeStatus"], @"LikeStatus");
                            SetValue_Key([json valueForKeyPath:@"Data.Chat.MediaType"], @"MediaType");
                            SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ImageChat");
                            
                            if([GetValue_Key(@"MediaType") intValue] == 1) // For Video
                            {
                                SetValue_Key([json valueForKeyPath:@"Data.Chat.ThumbPath"], @"ImageChat");
                                SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ChatVideo");
                            }
                            
                            SetValue_Key(@"Reload", @"Reload");
                            SetValue_Key([json valueForKeyPath:@"Data.PostedComment"], @"CommentData");
                            
                            [GC setEventID:[[json valueForKeyPath:@"Data.EventId"] integerValue]];
                            [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                            
                            [self move_To_Controller];
                        }
                        else
                        {
                            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                            localNotification.userInfo = @{@"Comment" : userInfo, @"EventId" : [json valueForKeyPath:@"Data.EventId"], @"Type" : @"3"};
                            localNotification.soundName = UILocalNotificationDefaultSoundName;
                            localNotification.alertBody = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"aps.alert"]];
                            localNotification.alertLaunchImage = @"icon_drop";
                            localNotification.fireDate = [NSDate date];
                            localNotification.hasAction = YES;
                            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                        }
                        
                    }
                    else
                    {
                        
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.userInfo = @{@"Comment" : userInfo, @"EventId" : [json valueForKeyPath:@"Data.EventId"], @"Type" : @"3"};
                        localNotification.soundName = UILocalNotificationDefaultSoundName;
                        localNotification.alertBody = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"aps.alert"]];
                        localNotification.alertLaunchImage = @"icon_drop";
                        localNotification.fireDate = [NSDate date];
                        localNotification.hasAction = YES;
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    }
                }
                else
                {
                    SetValue_Key(@"Notification", @"Notification");
                    SetValue_Key(@"MyFest", @"Nav");
                    SetValue_Key(@"1", @"isComment");
                    
                    [GC setChatID:[[json valueForKeyPath:@"Data.Chat.Id"] integerValue]];
                    
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.TotalLike"], @"TotalLike");
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.LikeStatus"], @"LikeStatus");
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.MediaType"], @"MediaType");
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ImageChat");
                    
                    if([GetValue_Key(@"MediaType") intValue] == 1) // For Video
                    {
                        SetValue_Key([json valueForKeyPath:@"Data.Chat.ThumbPath"], @"ImageChat");
                        SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ChatVideo");
                    }
                    
                    SetValue_Key(@"", @"Reload");
                    [GC setEventID:[[json valueForKeyPath:@"Data.EventId"] integerValue]];
                    [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                    [self move_To_Controller];
                }
                
                completionHandler(UIBackgroundFetchResultNewData);
            }
            else
            {
                completionHandler(UIBackgroundFetchResultNoData);
                NSLog(@"No Data avaiable");
                return;
            }
        }
            break;
        case 3://Like Push
        {
            if([[json valueForKeyPath:@"Data.Chat.Id"] intValue]>0)
            {
                
                if (application.applicationState == UIApplicationStateActive) {
                    
                    if([GetValue_Key(@"Screen") isEqualToString:@"Comment"])
                    {
                        NSInteger chatId = [[json valueForKeyPath:@"Data.Chat.Id"] integerValue];
                        
                        if(chatId == [GC chatID])
                        {
                            SetValue_Key(@"Notification", @"Notification");
                            SetValue_Key(@"MyFest", @"Nav");
                            SetValue_Key(@"1", @"isComment");
                            SetValue_Key(@"", @"Reload");
                            
                            SetValue_Key([json valueForKeyPath:@"Data.Chat.TotalLike"], @"TotalLike");
                            SetValue_Key([json valueForKeyPath:@"Data.Chat.LikeStatus"], @"LikeStatus");
                            SetValue_Key([json valueForKeyPath:@"Data.Chat.MediaType"], @"MediaType");
                            SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ImageChat");
                            
                            if([GetValue_Key(@"MediaType") intValue] == 1) // For Video
                            {
                                SetValue_Key([json valueForKeyPath:@"Data.Chat.ThumbPath"], @"ImageChat");
                                SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ChatVideo");
                            }
                            
                            [GC setChatID:[[json valueForKeyPath:@"Data.Chat.Id"] integerValue]];
                            [GC setEventID:[[json valueForKeyPath:@"Data.EventId"] integerValue]];
                            [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                            
                            [self move_To_Controller];
                        }
                        else
                        {
                            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                            localNotification.userInfo = @{@"Like" : userInfo, @"EventId" : [json valueForKeyPath:@"Data.EventId"], @"Type" : @"4"};
                            localNotification.soundName = UILocalNotificationDefaultSoundName;
                            localNotification.alertBody = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"aps.alert"]];
                            localNotification.alertLaunchImage = @"icon_drop";
                            localNotification.fireDate = [NSDate date];
                            localNotification.hasAction = YES;
                            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                        }
                    }
                    else
                    {
                        
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.userInfo = @{@"Like" : userInfo, @"EventId" : [json valueForKeyPath:@"Data.EventId"], @"Type" : @"4"};
                        localNotification.soundName = UILocalNotificationDefaultSoundName;
                        localNotification.alertBody = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"aps.alert"]];
                        localNotification.alertLaunchImage = @"icon_drop";
                        localNotification.fireDate = [NSDate date];
                        localNotification.hasAction = YES;
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    }
                }
                else
                {
                    SetValue_Key(@"Notification", @"Notification");
                    SetValue_Key(@"MyFest", @"Nav");
                    SetValue_Key(@"1", @"isComment");
                    SetValue_Key(@"", @"Reload");
                    
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.TotalLike"], @"TotalLike");
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.LikeStatus"], @"LikeStatus");
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.MediaType"], @"MediaType");
                    SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ImageChat");
                    
                    if([GetValue_Key(@"MediaType") intValue] == 1) // For Video
                    {
                        SetValue_Key([json valueForKeyPath:@"Data.Chat.ThumbPath"], @"ImageChat");
                        SetValue_Key([json valueForKeyPath:@"Data.Chat.Message"], @"ChatVideo");
                    }
                    
                    [GC setChatID:[[json valueForKeyPath:@"Data.Chat.Id"] integerValue]];
                    [GC setEventID:[[json valueForKeyPath:@"Data.EventId"] integerValue]];
                    [GC setEventTitle:[NSString stringWithFormat:@"%@",[json valueForKeyPath:@"Data.EventTitle"]]];
                    [self move_To_Controller];
                }
                
                completionHandler(UIBackgroundFetchResultNewData);
            }
            else
            {
                completionHandler(UIBackgroundFetchResultNoData);
                NSLog(@"No Data avaiable");
                return;
            }
        }
            break;
            
//        case 11:{ // Anything related to broadcast push [let it navigate to fest event screen, need to test]
//            [GC setEventID:[[json valueForKeyPath:@"Data.EventId"] integerValue]];
//            [self move_To_Controller];
//        }
//            break;
            
        default:
            break;
    }
}

#pragma mark - Move To Corresponding Controller
-(void)move_To_Controller
{
    NavPushController *PV = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NavPush_Controller];
    
    [self.window setRootViewController:PV];
    [self.window makeKeyAndVisible];
}

#pragma mark - Get Current Location
-(void)getCurrentLocation
{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    delLatitude = locationManager.location.coordinate.latitude;
    delLongitude = locationManager.location.coordinate.longitude;
    
    if([CLLocationManager locationServicesEnabled])
    {
        [locationManager startUpdatingLocation];
        NSLog(@"Location Update-Yes");
    }else
    {
        NSLog(@"Location Update-No");
    }
}

#pragma mark - Location Manager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    DISPLAY_METHOD_NAME;
    
    if(delLatitude == 0.0 && delLongitude == 0.0)
    {
        [self getCurrentLocation];
    }
    
    if((delLatitude!=0.0 && delLongitude!=0.0) && (locationManager.location.coordinate.latitude!=0 && locationManager.location.coordinate.longitude!=0.0))
    {
        
        delLatitude = manager.location.coordinate.latitude;
        delLongitude = manager.location.coordinate.longitude;
        
        
        TEST_MODE_GEO_FENCE;
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            if([GlobalClass DB_Load_AllData:@"MyFest"].count>0)
            {
                [self performSelector:@selector(geoFenceEntry) withObject:nil];
                
                [self performSelector:@selector(geoFenceExit) withObject:nil];
            }
            
        });
        */
        TEST_MODE_GEO_FENCE;
    }
}

#pragma mark - Check Geo Location Entry and Exit
-(void)geoFenceEntry
{
    NSArray *arrDB = [GlobalClass DB_Load_ByID:@"MyFest" withColName:@"festEventStatus" andParam:@"0"];
    
    for (MyFest *myFest in arrDB) {


        if(![[[NSUserDefaults standardUserDefaults] stringForKey:myFest.festEventId] isEqualToString:myFest.festEventId])
        {
            NSDate *dt=[self localTime];
            NSDate *dtFest=myFest.festDate;

            float t=[dtFest timeIntervalSinceDate:dt];
      
            //  this means event's start date is less than current time ****
            if(t<=0)
            {
                CLLocation *locA = [[CLLocation alloc] initWithLatitude:delLatitude longitude:delLongitude];
                
                CLLocation *locB = [[CLLocation alloc] initWithLatitude:[myFest.latitude doubleValue] longitude:[myFest.longitude doubleValue]];
                
                CLLocationDistance distance = [locA distanceFromLocation:locB];
                
                distance = distance/1609.34;
                
//                TEST_MODE;
//                distance = 10;
//                TEST_MODE;
                
                float festRad=[myFest.festRadius floatValue];
                
                if(distance<=festRad)
                {
                    [myFest setFestEventStatus:[NSNumber numberWithInteger:1]];
                    
                    // Save everything
                    NSError *error = nil;
                    if ([self.managedObjectContext save:&error]) {
                        NSLog(@"AppDel - Update was successful!");
                        
                        [[NSUserDefaults standardUserDefaults] setObject:myFest.festEventId forKey:myFest.festEventId];
                        
                        TEST_MODE;
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        TEST_MODE;
                        
                    } else {
                        NSLog(@"AppDel - Update wasn't successful: %@", [error userInfo]);
                    }
                    
                    TEST_MODE;
                    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                        NSString *body = [NSString stringWithFormat:@"%@",[myFest.pushNotification capitalizedString]];
                        [ILLogic showTAlert2WithMessage:body];
                    }
                    else{
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.userInfo = @{@"EventId":myFest.festEventId,@"Type":@"0"};
                        localNotification.soundName = UILocalNotificationDefaultSoundName;
                        localNotification.alertBody = [NSString stringWithFormat:@"%@",[myFest.pushNotification capitalizedString]];
                        localNotification.alertLaunchImage = @"icon_drop";
                        localNotification.fireDate = [NSDate date];
                        
                        //                    TEST_MODE;
                        //                    localNotification.fireDate = [NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]];
                        //                    TEST_MODE;
                        
                        
                        localNotification.hasAction = YES;
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    }
                    TEST_MODE;

                }
            }
        }
    }
}

-(void)geoFenceExit
{
    NSArray *arrDB = [GlobalClass DB_Load_ByID:@"MyFest" withColName:@"festEventStatus" andParam:@"1"];
    
    for (MyFest *myfest in arrDB) {
        
        if(myfest.festEventStatus == [NSNumber numberWithInt:1] && ([[[NSUserDefaults standardUserDefaults] stringForKey:myfest.festEventId] isEqualToString:myfest.festEventId]))
        {
            CLLocation *locA = [[CLLocation alloc] initWithLatitude:delLatitude longitude:delLongitude];
            
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:[myfest.latitude doubleValue] longitude:[myfest.longitude doubleValue]];
            
            CLLocationDistance distance = [locA distanceFromLocation:locB];
            
            distance = distance/1609.34;
            
            if(distance>[myfest.festRadius floatValue])
            {
                for (NSString *key in [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys])
                {
                    if([key isEqualToString:myfest.festEventId]){
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:myfest.festEventId];
                        TEST_MODE;
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        TEST_MODE;
                    }
                    
                }
                
                
                TEST_MODE;
                if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                    NSString *body = [NSString stringWithFormat:@"Thank you for attending %@",[myfest.festTitle capitalizedString]];
                    [ILLogic showTAlert2WithMessage:body];
                }
                else{
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.userInfo = @{@"Type":@"2"};
                    localNotification.soundName = UILocalNotificationDefaultSoundName;
                    localNotification.alertBody = [NSString stringWithFormat:@"Thank you for attending %@",[myfest.festTitle capitalizedString]];
                    localNotification.alertLaunchImage = @"icon_drop";
                    localNotification.fireDate = [NSDate date];
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }
                TEST_MODE;
                
                
                NSError *error = nil;
                if ([self.managedObjectContext deletedObjects]) {
                    if([self.managedObjectContext save:&error]){
                        NSLog(@"Delete was successful!");
                    }
                } else {
                    NSLog(@"Delete wasn't successful: %@", [error userInfo]);
                }
            }
        }
    }
}

#pragma mark - Get Current Address
-(void)getAddressFromLocation:(double)lat longitude:(double)lng
{
    if (isReach) {
        
        NSString *strURL=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%lf,%lf&sensor=true",lat,lng];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"OK"]) {
                
                self.strCurrentAddress = [NSString new];
                self.strCurrentAddress = [NSString stringWithFormat:@"%@",[[[responseObject valueForKey:@"results"] objectAtIndex:0] valueForKey:@"formatted_address"]];
                
                self.strCurrentAddress = [self.strCurrentAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                
                [GC hideLoader];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddressUpdate" object:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [GC hideLoader];
            self.strCurrentAddress = @"";
        }];
    }
    else
    {
        [GC hideLoader];
        self.strCurrentAddress = @"";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network disconnected." message:@"Unable to fetch location details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
}

#pragma mark - AppDelegate Shared Instance
+(AppDelegate *)getDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(NSDateFormatter *)formatter {
    
    static dispatch_once_t staticToken = 0;
    
    dispatch_once(&staticToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    return formatter;
}


#pragma mark - Change Status Bar Color
-(void)changeStatusbarColor
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - Move to View Controller
-(void)move_to_ViewController
{
//    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//    SlideViewController *SVC = [storyboard1 instantiateViewControllerWithIdentifier:Slide_ViewController];
    FindFestViewController *FVC = [storyboard2 instantiateViewControllerWithIdentifier:FindFest_ViewController];
//    SlideNavigationController *SlideNav = [[SlideNavigationController alloc] initWithRootViewController:FVC];
//    
//    RESideMenu *BV = [[RESideMenu alloc] initWithContentViewController:SlideNav leftMenuViewController:SVC rightMenuViewController:nil];
    TEST_MODE;
    [self.window setRootViewController:FVC];
    TEST_MODE;
    [self.window makeKeyAndVisible];
}

#pragma mark - Facebook Session
- (void)openSession
{
    NSLog(@"opening session");
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             
             TEST_MODE;
             [FBSession setActiveSession:session];
             TEST_MODE;
             ;
             
             
             
            [self sessionStateChanged:session state:state error:error];
             // Retrieve the app delegate
             //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             //[appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
    /*NSArray *permissions = [NSArray arrayWithObjects:@"public_profile", nil];
    NSArray arrayWithObjects: @"user_location",
     @"user_birthday",
     @"email",
     @"user_photos",
     @"user_likes",
     @"friends_photos",
     @"user_friends",
     @"public_profile",
     @"user_education_history",nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];*/
}


// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookStateChange" object:nil];
        // Show the user the logged-in UI
        //[self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            //alertTitle = @"Something went wrong";
            NSLog(@"Something went wrong");
            alertText = [FBErrorUtility userMessageForError:error];
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                //alertTitle = @"Session Error";
                //alertText = @"Your current session is no longer valid. Please log in again.";
                NSLog(@"Your current session is no longer valid. Please log in again.");
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                NSLog(@"final else");
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}
    /*switch (state) {
        case FBSessionStateOpen: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookStateChange" object:nil];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Login failed"
                                  message:@"Permission denied"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }*/
//}

#pragma mark - Auth Token Expired
-(void)sessionExpired
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Session Expired." message:@"This account is curently opened in another device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
    {
        [self move_To_Controller];
    }
    else
    {
        [self redirect_to_Login];
    }
}

#pragma mark - Redirect to Login
-(void)redirect_to_Login
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    
    [GC remove_User_Data_From_Plist];
    
    LoginViewController *homePage=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:Login_ViewController];
    HomeNavigationController *homeNav=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:Home_NavigationController];
    [homeNav setViewControllers:@[homePage]];
    [self.window setRootViewController:homeNav];
    [self.window makeKeyAndVisible];
}

/*- (fbuser *)populateUserDetails
 {
 fbuser *data = [fbuser new];
 if (FBSession.activeSession.isOpen) {
 [[FBRequest requestForMe] startWithCompletionHandler:
 ^(FBRequestConnection *connection,
 NSDictionary<FBGraphUser> *user,
 NSError *error) {
 if (!error) {
 //NSLog(@"%@",user);
 data.firstName = user.first_name;
 data.lastName = user.last_name;
 data.email = [user valueForKey:@"email"];
 }
 }];
 }
 return data;
 }*/

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(NSDate *)localTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: [NSDate date]];
    return [NSDate dateWithTimeInterval: seconds sinceDate: [NSDate date]];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FestCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GoGoHealth.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    return _persistentStoreCoordinator;
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Geofence Activities using Corelocation
//-(void)addGeofences
//{
//    
//    TEST_MODE_GEO_FENCE;
////    GeofenceMonitor  * gfm = [GeofenceMonitor sharedObj];
////    NSMutableDictionary * fenceRajagiri = [NSMutableDictionary new];
////    [fenceRajagiri setValue:@"SFC Plus" forKey:@"identifier"];
////    [fenceRajagiri setValue:@"9.996549" forKey:@"latitude"];
////    [fenceRajagiri setValue:@"76.351102" forKey:@"longitude"];
////    [fenceRajagiri setValue:@"700" forKey:@"radius"];
////    
////    NSMutableDictionary * fence2 = [NSMutableDictionary new];
////    [fence2 setValue:@"Thapasysa" forKey:@"identifier"];
////    [fence2 setValue:@"10.010953" forKey:@"latitude"];
////    [fence2 setValue:@"76.361233" forKey:@"longitude"];
////    [fence2 setValue:@"600" forKey:@"radius"];
////    
////    
////    NSMutableDictionary * fence3 = [NSMutableDictionary new];
////    [fence3 setValue:@"Fence 3" forKey:@"identifier"];
////    [fence3 setValue:@"17.224758206624667" forKey:@"latitude"];
////    [fence3 setValue:@"78.453369140625" forKey:@"longitude"];
////    [fence3 setValue:@"1000" forKey:@"radius"];
////    
////    if([gfm checkLocationManager])
////    {
////        [gfm addGeofence:fenceRajagiri];
////        [gfm addGeofence:fence2];
////        [gfm addGeofence:fence3];
////        [gfm findCurrentFence];
////    }
//    TEST_MODE_GEO_FENCE;
//}
-(void)addAllMyFestsForGeoFenceEntryMonitoring{
    NSArray *arrDB = [GlobalClass DB_Load_ByID:@"MyFest" withColName:@"festEventStatus" andParam:@"0"];
    
    
    BOOL flagAdedOne=NO;
    for (MyFest *myFest in arrDB) {
        
        // which means not monitored b4
        if(![[[NSUserDefaults standardUserDefaults] stringForKey:myFest.festEventId] isEqualToString:myFest.festEventId])
        {
            NSDate *dt=[self localTime];
            NSDate *dtFest=myFest.festDate;
            
            float t=[dtFest timeIntervalSinceDate:dt];
            
            //  this means event's start date is less than current time ****
            if(t<=0)
            {
                
                CLLocationCoordinate2D cord=CLLocationCoordinate2DMake(myFest.latitude.doubleValue, myFest.longitude.doubleValue);
                
                [self addGeoFence:cord radius:myFest.festRadius.floatValue geoFenceIdentifier:myFest.festEventId];
                
                flagAdedOne=YES;
                
                /*
                 CLLocation *locA = [[CLLocation alloc] initWithLatitude:delLatitude longitude:delLongitude];
                 
                 CLLocation *locB = [[CLLocation alloc] initWithLatitude:[myFest.latitude doubleValue] longitude:[myFest.longitude doubleValue]];

                 
                CLLocationDistance distance = [locA distanceFromLocation:locB];
                
                distance = distance/1609.34;
                
                //                TEST_MODE;
                //                distance = 10;
                //                TEST_MODE;
                
                float festRad=[myFest.festRadius floatValue];
                
                if(distance<=festRad)
                {
                    [myFest setFestEventStatus:[NSNumber numberWithInteger:1]];
                    
                    // Save everything
                    NSError *error = nil;
                    if ([self.managedObjectContext save:&error]) {
                        NSLog(@"AppDel - Update was successful!");
                        
                        [[NSUserDefaults standardUserDefaults] setObject:myFest.festEventId forKey:myFest.festEventId];
                        
                        TEST_MODE;
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        TEST_MODE;
                        
                    } else {
                        NSLog(@"AppDel - Update wasn't successful: %@", [error userInfo]);
                    }
                    
                    TEST_MODE;
                    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                        NSString *body = [NSString stringWithFormat:@"%@",[myFest.pushNotification capitalizedString]];
                        [ILLogic showTAlert2WithMessage:body];
                    }
                    else{
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.userInfo = @{@"EventId":myFest.festEventId,@"Type":@"0"};
                        localNotification.soundName = UILocalNotificationDefaultSoundName;
                        localNotification.alertBody = [NSString stringWithFormat:@"%@",[myFest.pushNotification capitalizedString]];
                        localNotification.alertLaunchImage = @"icon_drop";
                        localNotification.fireDate = [NSDate date];
                        
                        //                    TEST_MODE;
                        //                    localNotification.fireDate = [NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]];
                        //                    TEST_MODE;
                        
                        
                        localNotification.hasAction = YES;
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    }
                    TEST_MODE;
                    
                }
                 */
            }
            else  // upcoming event
            {
                CLLocationCoordinate2D cord=CLLocationCoordinate2DMake(myFest.latitude.doubleValue, myFest.longitude.doubleValue);

                [self removeGeoFence:cord radius:myFest.festRadius.floatValue geoFenceIdentifier:myFest.festEventId];
            }
        }
    }
    
    
    TEST_MODE_GEO_FENCE;
    if (flagAdedOne) {
        GeofenceMonitor  * gfm = [GeofenceMonitor sharedObj];
        [gfm findCurrentFence];
    }
    TEST_MODE_GEO_FENCE;

}
-(void)addGeoFence:(CLLocationCoordinate2D)cord radius:(float)radius geoFenceIdentifier:(NSString*)identifier{
    
    GeofenceMonitor  * gfm = [GeofenceMonitor sharedObj];

    NSString *lat=[NSString stringWithFormat:@"%f", cord.latitude];
    NSString *lon=[NSString stringWithFormat:@"%f", cord.longitude];
    NSString *rad=[NSString stringWithFormat:@"%f", radius];
    
    
    NSMutableDictionary * fence = [NSMutableDictionary new];
    [fence setValue:identifier forKey:@"identifier"];
    [fence setValue:lat forKey:@"latitude"];
    [fence setValue:lon forKey:@"longitude"];
    [fence setValue:rad forKey:@"radius"];
    if([gfm checkLocationManager])
    {
        [gfm addGeofence:fence];
        
        TEST_MODE_GEO_FENCE;
//        [gfm findCurrentFence];
        TEST_MODE_GEO_FENCE;
    }
    
}
-(void)removeGeoFence:(CLLocationCoordinate2D)cord radius:(float)radius geoFenceIdentifier:(NSString*)identifier{
    GeofenceMonitor  * gfm = [GeofenceMonitor sharedObj];
    
    NSString *lat=[NSString stringWithFormat:@"%f", cord.latitude];
    NSString *lon=[NSString stringWithFormat:@"%f", cord.longitude];
    NSString *rad=[NSString stringWithFormat:@"%f", radius];
    
    
    NSMutableDictionary * fence = [NSMutableDictionary new];
    [fence setValue:identifier forKey:@"identifier"];
    [fence setValue:lat forKey:@"latitude"];
    [fence setValue:lon forKey:@"longitude"];
    [fence setValue:rad forKey:@"radius"];
    
    [gfm removeGeofence:fence];
}

-(void)clearAllGeofences
{
    GeofenceMonitor  * gfm = [GeofenceMonitor sharedObj];
    
    [gfm clearGeofences];
}
-(void)geoFenceEntryDetected:(CLRegion*)region{
    DISPLAY_METHOD_NAME;


    
    NSString *eventId=region.identifier;
    
    NSArray *arrDB = [GlobalClass DB_Load_ByID:@"MyFest" withColName:@"festEventId" andParam:eventId];

    MyFest *myFest=[arrDB lastObject];
    
//    
//    if(distance<=festRad)
//    {
        [myFest setFestEventStatus:[NSNumber numberWithInteger:1]];
        
        // Save everything
        NSError *error = nil;
        if ([self.managedObjectContext save:&error]) {
            NSLog(@"AppDel - Update was successful!");
            
            [[NSUserDefaults standardUserDefaults] setObject:myFest.festEventId forKey:myFest.festEventId];
            
            TEST_MODE;
            [[NSUserDefaults standardUserDefaults] synchronize];
            TEST_MODE;
            
        } else {
            NSLog(@"AppDel - Update wasn't successful: %@", [error userInfo]);
        }
        
        TEST_MODE;
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            NSString *body = [NSString stringWithFormat:@"%@",[myFest.pushNotification capitalizedString]];
            [ILLogic showTAlert2WithMessage:body];
        }
        else{
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.userInfo = @{@"EventId":myFest.festEventId,@"Type":@"0"};
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.alertBody = [NSString stringWithFormat:@"%@",[myFest.pushNotification capitalizedString]];
            localNotification.alertLaunchImage = @"icon_drop";
            localNotification.fireDate = [NSDate date];
            
            //                    TEST_MODE;
            //                    localNotification.fireDate = [NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]];
            //                    TEST_MODE;
            
            
            localNotification.hasAction = YES;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
        TEST_MODE;
        
//    }
}
-(void)geoFenceExitDetected:(CLRegion *)region{
    DISPLAY_METHOD_NAME;
    
    NSString *eventId=region.identifier;
    
    NSArray *arrDB = [GlobalClass DB_Load_ByID:@"MyFest" withColName:@"festEventId" andParam:eventId];
    
    MyFest *myfest=[arrDB lastObject];
    
    if(myfest.festEventStatus == [NSNumber numberWithInt:1] && ([[[NSUserDefaults standardUserDefaults] stringForKey:myfest.festEventId] isEqualToString:myfest.festEventId]))
    {
//        CLLocation *locA = [[CLLocation alloc] initWithLatitude:delLatitude longitude:delLongitude];
//        
//        CLLocation *locB = [[CLLocation alloc] initWithLatitude:[myfest.latitude doubleValue] longitude:[myfest.longitude doubleValue]];
//        
//        CLLocationDistance distance = [locA distanceFromLocation:locB];
        
//        distance = distance/1609.34;
//        
//        if(distance>[myfest.festRadius floatValue])
//        {
        for (NSString *key in [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys])
        {
            if([key isEqualToString:myfest.festEventId]){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:myfest.festEventId];
                TEST_MODE;
                [[NSUserDefaults standardUserDefaults] synchronize];
                TEST_MODE;
            }
            
        }
        
        
        TEST_MODE;
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            NSString *body = [NSString stringWithFormat:@"Thank you for attending %@",[myfest.festTitle capitalizedString]];
            [ILLogic showTAlert2WithMessage:body];
        }
        else{
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.userInfo = @{@"Type":@"2"};
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.alertBody = [NSString stringWithFormat:@"Thank you for attending %@",[myfest.festTitle capitalizedString]];
            localNotification.alertLaunchImage = @"icon_drop";
            localNotification.fireDate = [NSDate date];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
        TEST_MODE;
        
        
        NSError *error = nil;
        if ([self.managedObjectContext deletedObjects]) {
            if([self.managedObjectContext save:&error]){
                NSLog(@"Delete was successful!");
            }
        } else {
            NSLog(@"Delete wasn't successful: %@", [error userInfo]);
        }
        
        
        
        CLLocationCoordinate2D cord=CLLocationCoordinate2DMake(myfest.latitude.doubleValue, myfest.longitude.doubleValue);
        [self removeGeoFence:cord radius:myfest.festRadius.floatValue geoFenceIdentifier:myfest.festEventId];
        
        //        }
    }
}

#pragma mark - 
-(void)testAPI{
    
    NSLog(@"DocDir: %@", [[self applicationDocumentsDirectory] absoluteString]);
//    festId= 76
//    [self getEventPostComments];
    
    
}
-(void)createEventPost{
    DISPLAY_METHOD_NAME;
    
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    //        parameter dictionary *****
    //    id messageDatOrStr=[dictParam objectForKey:@"Message"];                 // NSData or NSString, image/video data or text
    //    NSString *type=[dictParam objectForKey:@"Type"];
    //    NSString *mediaType=[dictParam objectForKey:@"MediaType"];
    //    NSData *thumbPathData=[dictParam objectForKey:@"ThumbPath"];            // NSData, thumb image data
    //    NSString *thumbExtension=[dictParam objectForKey:@"ThumbExtension"];    // thumb image extension for image/video
    //    NSString *mediaExtension=[dictParam objectForKey:@"MediaExtension"];    // media extension for image/video
    //    NSString *eventId=[dictParam objectForKey:@"EventId"];
    //    NSString *title=[dictParam objectForKey:@"Title"];                      // title for image/video
    //    //        parameter dictionary *****
    
    
    [d setObject:@"76" forKey:@"EventId"];
    [d setObject:@"Post caption" forKey:@"Message"];
    [d setObject:@"0" forKey:@"Type"];
    [d setObject:@"10" forKey:@"Latitude"];
    [d setObject:@"76" forKey:@"Longitude"];
    
    
    
    
    [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagCreateEventPost andDictionary:d andDelegate:self];

}
-(void)createEventPostImage{
    DISPLAY_METHOD_NAME;
    
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    //        parameter dictionary *****
    //    id messageDatOrStr=[dictParam objectForKey:@"Message"];                 // NSData or NSString, image/video data or text
    //    NSString *type=[dictParam objectForKey:@"Type"];
    //    NSString *mediaType=[dictParam objectForKey:@"MediaType"];
    //    NSData *thumbPathData=[dictParam objectForKey:@"ThumbPath"];            // NSData, thumb image data
    //    NSString *thumbExtension=[dictParam objectForKey:@"ThumbExtension"];    // thumb image extension for image/video
    //    NSString *mediaExtension=[dictParam objectForKey:@"MediaExtension"];    // media extension for image/video
    //    NSString *eventId=[dictParam objectForKey:@"EventId"];
    //    NSString *title=[dictParam objectForKey:@"Title"];                      // title for image/video
    //    //        parameter dictionary *****
    
    UIImage *image=[UIImage imageNamed:@"icon_accept"];
    NSData *datIm=UIImagePNGRepresentation(image);
    UIImage *imgThumb=[ILLogic resizeImageWithImage:image scaledToWidth:50];
    NSData *datImThUmb=UIImageJPEGRepresentation(imgThumb, .5);
    
    [d setObject:@"76" forKey:@"EventId"];
    [d setObject:datIm forKey:@"Message"];
    [d setObject:@"1" forKey:@"Type"];
    [d setObject:@"10" forKey:@"Latitude"];
    [d setObject:@"76" forKey:@"Longitude"];
    [d setObject:@"Post caption image" forKey:@"Title"];
    [d setObject:@"0" forKey:@"MediaType"];  // image
    [d setObject:datImThUmb forKey:@"ThumbPath"];
    [d setObject:@".png" forKey:@"MediaExtension"];
    [d setObject:@".jpg" forKey:@"ThumbExtension"];

    
    
    
    [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagCreateEventPost andDictionary:d andDelegate:self];
    
}
-(void)createEventPostVideo{
    DISPLAY_METHOD_NAME;
    
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    //        parameter dictionary *****
    //    id messageDatOrStr=[dictParam objectForKey:@"Message"];                 // NSData or NSString, image/video data or text
    //    NSString *type=[dictParam objectForKey:@"Type"];
    //    NSString *mediaType=[dictParam objectForKey:@"MediaType"];
    //    NSData *thumbPathData=[dictParam objectForKey:@"ThumbPath"];            // NSData, thumb image data
    //    NSString *thumbExtension=[dictParam objectForKey:@"ThumbExtension"];    // thumb image extension for image/video
    //    NSString *mediaExtension=[dictParam objectForKey:@"MediaExtension"];    // media extension for image/video
    //    NSString *eventId=[dictParam objectForKey:@"EventId"];
    //    NSString *title=[dictParam objectForKey:@"Title"];                      // title for image/video
    //    //        parameter dictionary *****
    
    UIImage *image=[UIImage imageNamed:@"icon_done"];
    NSData *datVid=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fest-vid.m4v" ofType:nil]];
    UIImage *imgThumb=[ILLogic resizeImageWithImage:image scaledToWidth:50];
    NSData *datImThUmb=UIImageJPEGRepresentation(imgThumb, .5);
    
    [d setObject:@"76" forKey:@"EventId"];
    [d setObject:datVid forKey:@"Message"];
    [d setObject:@"1" forKey:@"Type"];
    [d setObject:@"10" forKey:@"Latitude"];
    [d setObject:@"76" forKey:@"Longitude"];
    [d setObject:@"Post caption image" forKey:@"Title"];
    [d setObject:@"1" forKey:@"MediaType"]; //video
    [d setObject:datImThUmb forKey:@"ThumbPath"];
    [d setObject:@".jpg" forKey:@"ThumbExtension"];
    [d setObject:@".m4v" forKey:@"MediaExtension"];

    
    
    
    [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagCreateEventPost andDictionary:d andDelegate:self];
    
}
-(void)allEventPosts{
    DISPLAY_METHOD_NAME;
    
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    //        parameter dictionary *****
    //    id messageDatOrStr=[dictParam objectForKey:@"Message"];                 // NSData or NSString, image/video data or text
    //    NSString *type=[dictParam objectForKey:@"Type"];
    //    NSString *mediaType=[dictParam objectForKey:@"MediaType"];
    //    NSData *thumbPathData=[dictParam objectForKey:@"ThumbPath"];            // NSData, thumb image data
    //    NSString *thumbExtension=[dictParam objectForKey:@"ThumbExtension"];    // thumb image extension for image/video
    //    NSString *mediaExtension=[dictParam objectForKey:@"MediaExtension"];    // media extension for image/video
    //    NSString *eventId=[dictParam objectForKey:@"EventId"];
    //    NSString *title=[dictParam objectForKey:@"Title"];                      // title for image/video
    //    //        parameter dictionary *****
    
    
    [d setObject:@"76" forKey:@"EventId"];
    [d setObject:@"" forKey:@"LastReceivedChatId"];
    [d setObject:@"100" forKey:@"NoOfRows"];
    [d setObject:@"100" forKey:@"NoOfComments"];
    
    
    
    
    [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagGetAllEventPosts andDictionary:d andDelegate:self];
    
}
-(void)likeDisLikeEventPost{
    NSMutableDictionary *d=[NSMutableDictionary new];
    
/*
 {
 Comments =     (
 );
 CreatedDate = "2015-06-17T10:59:41.4";
 EventID = 76;
 FacebookID = 1588401588111681;
 FirstName = Denow;
 LastName = ILeaf;
 Likes =     (
 );
 MediaType = 0;
 Message = "Post caption";
 PostID = 150;
 ThumbPath = "";
 Title = "";
 TotalComments = 0;
 TotalLikes = 0;
 Type = 0;
 UserID = 19;
 UserImage = "http://54.69.37.46/festapp.api.com/Content/Medias/Image_63570129620150.png";
 UserLikeStatus = 0;
 },
 */
    UserModel *userModel = [[GC arrUserDetails] firstObject];
    
    [d setObject:@"150" forKey:@"EventChatId"];
    [d setObject:userModel.localID forKey:@"UserId"];

    
    
    
    [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagLikeDisLikeEventPost andDictionary:d andDelegate:self];
 
}
-(void)getEventPostDetails{
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    
    [d setObject:@"150" forKey:@"EventChatId"];
    [d setObject:@"100" forKey:@"NoOfRows"];
    
    
    
    
    
    [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagGetEventPostDetails andDictionary:d andDelegate:self];
}
-(void)getEventPostComments{
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    
    [d setObject:@"150" forKey:@"EventChatId"];
    [d setObject:@"100" forKey:@"NoOfRows"];
    [d setObject:@"" forKey:@"LastReceivedCommentId"];
    
    
    
    
    
    [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagGetEventPostComments andDictionary:d andDelegate:self];
}
-(void)backendConnectionSuccess:(BOOL)flagSuccess withResponse:(NSDictionary*)dictResponse andConnectionTag:(ConnectionTags)connectionTag{
    DISPLAY_METHOD_NAME;
    
    
}

@end
