//
//  ILLogic.m
//  Fest
//
//  Created by Denow Cleetus on 30/04/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "ILLogic.h"
#import "TAlertView.h"

#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a]


@implementation ILLogic

#pragma mark -
+(BOOL)flagLocationAccessDenied{
    
    BOOL denied=NO;
    
    /*
     kCLAuthorizationStatusNotDetermined = 0,
     kCLAuthorizationStatusRestricted
     kCLAuthorizationStatusDenied 
     kCLAuthorizationStatusAuthorizedAlways
     kCLAuthorizationStatusAuthorizedWhenInUse
     kCLAuthorizationStatusAuthorized
     */
    
    
    
    
    int status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        denied = YES;
    }
    
    return denied;
}
+(BOOL)checkTheEligibiltyOfShowingAnotherPageWithCurrentIndex:(NSInteger)current newIndex:(NSInteger)newIndex{
    
    BOOL eligible=NO;
    if (newIndex>=0 && newIndex<[[GC arrPreviews] count] && newIndex!=current) {
        eligible=YES;
    }
    
    return eligible;
}
+(void)enableAutoCorrectionForTextFieldAndTextView:(id)text{

    TASK_LISTED;
    /*
     Add autocorrect throughout application
     */
    
    [text setAutocorrectionType:UITextAutocorrectionTypeYes];
    [text setSpellCheckingType:UITextSpellCheckingTypeYes];
}


#pragma mark - Color
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha {
    
    assert(7 == [hex length]);
    assert('#' == [hex characterAtIndex:0]);
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(3, 2)]];
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(5, 2)]];
    
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [ILLogic colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
}


+ (UIColor*)colorWithRandomRGBVAlue{
    NSInteger rInt = arc4random() % 256;
    NSInteger gInt = arc4random() % 256;
    NSInteger bInt = arc4random() % 256;
    return RGB(rInt, gInt, bInt);
}

#pragma mark - misc
+(NSString*)savingPathForProfileImage:(NSString *)fbId{
    NSString *cache=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *prof=[NSString stringWithFormat:@"%@/ProfileImages/",cache];
    
    NSFileManager *mgr=[NSFileManager defaultManager];
    BOOL dir=YES;
    if (![mgr fileExistsAtPath:prof isDirectory:&dir]) {
        [mgr createDirectoryAtPath:prof withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path=[NSString stringWithFormat:@"%@/%@.png",prof,fbId];
    
    return path;
}
+ (void)showTAlert2WithMessage:(NSString*)msg{
    TAlertView *alert=[[TAlertView alloc] initWithTitle:nil andMessage:msg];
    alert.timeToClose = 3;
    [alert showAsMessage];
    
}
+ (UIImage*)resizeImageWithImage:(UIImage*)image scaledToWidth:(float)newWidth
{
    
    
    
    float newHeight=newWidth*image.size.height/image.size.width*1.0;
    
    newHeight=round(newHeight);
    
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
+(UIStoryboard*)storyBoardMain{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];

}
+(UIStoryboard*)storyboardNoAutolayout{
    return [UIStoryboard storyboardWithName:@"NoAutolayout" bundle:nil];
}
+(NSString*)timeStampConversion:(double)timeStamp
{
    
    NSTimeInterval _interval=timeStamp;
    
    NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    
    int unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    NSDateComponents *comps =
    
    [calendar components:unitFlags
     
                fromDate:eventDate toDate:[NSDate date] options:0];
    
    
    
    NSString *timeAgoString = [NSString string];
    
    if ([comps year] > 0) {
        
        timeAgoString =
        
        [NSString stringWithFormat:@"%zd year ago", [comps year]];
        
    }
    
    else if ([comps month] > 0) {
        
        timeAgoString =
        
        [NSString stringWithFormat:@"%zd month ago", [comps month]];
        
    }
    
    else if ([comps day] > 0) {
        
        timeAgoString =
        
        [NSString stringWithFormat:@"%zd days ago", [comps day]];
        
    }
    
    else if ([comps hour] > 0) {
       
        
        timeAgoString =
        
        [NSString stringWithFormat:@"%zd hours ago", [comps hour]];

        
        if ([comps hour] == 1) {
            
            timeAgoString =
            
            [NSString stringWithFormat:@"%zd hour ago", [comps hour]];

        }
    }
    
    else if ([comps minute] > 0) {
        
        timeAgoString =
        
        [NSString stringWithFormat:@"%zd mins ago", [comps minute]];
        
    }
    
    else if ([comps second] > 0) {
        
        timeAgoString =
        
        [NSString stringWithFormat:@"%zd secs ago", [comps second]];
        
    }
    else if ([comps second] < 0 || [comps second]==0)
    {
        timeAgoString =
        
        [NSString stringWithFormat:@"a moment ago"];
    }
    return timeAgoString;
    
}
@end
