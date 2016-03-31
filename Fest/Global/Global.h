//
//  Global.h
//  Fest
//
//  Created by Denow Cleetus on 22/04/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <Foundation/Foundation.h>




//ShortCodes **********
#pragma mark - ShortCodes
#define iOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define COLOR_RGB(a, b, c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]
#define RANDOM_COLOR [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1]
#define APPDELEGATE (AppDelegate*)[[UIApplication sharedApplication]delegate]
#define FILE_MGR [NSFileManager defaultManager]

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IS_IPHONE_4 ([[UIScreen mainScreen] bounds].size.height > 480.0) ? 0 : 1
#define IS_IPHONE_5 ([UIScreen mainScreen].bounds.size.height == 568.0) ? 1 : 0
#define IS_IPHONE_6 ([UIScreen mainScreen].bounds.size.height == 667.0) ? 1 : 0
#define IS_IPHONE_6_PLUS ([UIScreen mainScreen].bounds.size.height == 736.0) ? 1 : 0

#define DISPLAY_METHOD_NAME ILLog(@"\n\n%s\n\n",__FUNCTION__)
#define DELETE_HARD_CODED NSLog(@"\n\n\n******* DELETE_HARD_CODED ********\n\n\n")
#define UNCOMMENT_CODE NSLog(@"\n\n\n******* UNCOMMENT_CODE ********\n\n\n")
#define TEST_MODE NSLog(@"\n\n\n******* TEST_MODE ********\n\n\n")
#define TEST_MODE_GEO_FENCE NSLog(@"\n\n\n******* TEST_MODE_GEO_FENCE ********\n\n\n")
#define TASK_LISTED ILLog(@"\n\n\n******* TASK_LISTED ********\n\n\n")
#define TASK_EXTRA ILLog(@"\n\n\n******* TASK_EXTRA ********\n\n\n")

#define COLOR_TEAL COLOR_RGB(90, 211, 188)

#pragma mark - Log

#ifdef DEBUG
#define ILLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define ILLog(...)
#endif

#define NSLog ILLog

#pragma mark - Integer Constants
typedef enum : NSUInteger{
    tagActionEditDelete    = 1,
    tagAlertDelete         = 2,
    tagAlertDeleteSuccess  = 3,
    tagAlertLocationDenied = 4,
    tagAlertSignout        = 5,

} Tags;

typedef enum : NSUInteger{

    tagUploadImageGalley = 1,
    tagUploadVideoGalley = 2,
    tagUploadImageCamera = 3,
    tagUploadVideoCamera = 4,
    
    
} TagUpload;

typedef enum : NSUInteger{
    connectionTagCreateEventPost            = 100,
    connectionTagGetAllEventPosts           = 101,
    connectionTagGetEventPostComments       = 102,
    connectionTagLikeDisLikeEventPost       = 103,
    connectionTagGetEventPostDetails        = 104,
    connectionTagDeleteFest                 = 105,
    connectionTagGetLikersList              = 106,
    
} ConnectionTags;



