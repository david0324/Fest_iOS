//
//  ILLogic.h
//  Fest
//
//  Created by Denow Cleetus on 30/04/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILLogic : NSObject

+(BOOL)flagLocationAccessDenied;
+(BOOL)checkTheEligibiltyOfShowingAnotherPageWithCurrentIndex:(NSInteger)current newIndex:(NSInteger)newIndex;
+(void)enableAutoCorrectionForTextFieldAndTextView:(id)text;
+(UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;


#pragma mark - 
+(NSString*)savingPathForProfileImage:(NSString *)fbId;
+ (void)showTAlert2WithMessage:(NSString*)msg;
+ (UIImage*)resizeImageWithImage:(UIImage*)image scaledToWidth:(float)newWidth;
+(UIStoryboard*)storyBoardMain;
+(UIStoryboard*)storyboardNoAutolayout;
+(NSString*)timeStampConversion:(double)timeStamp;


@end
