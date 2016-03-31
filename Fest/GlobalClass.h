//
//  GlobalClass.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 23/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDWebImageManager.h"
#import "Contact.h"
#import "UserModel.h"

@protocol ContactsDelegate <NSObject>

-(void)refreshContactsList;

@end

@interface GlobalClass : NSObject

typedef void(^imageDownloadcompletionBlock)(UIImage *cachedImages);

@property (nonatomic,strong) UIViewController *parentVC;
@property (nonatomic,strong) NSMutableDictionary *collections;
@property (nonatomic,strong) NSMutableDictionary *dicUserDefaults;
@property (nonatomic,strong) NSMutableArray *arrUserDetails;
@property (nonatomic,strong) NSMutableArray *arrContacts;
@property (nonatomic,strong) NSMutableArray *arrPreviews;
@property (nonatomic,strong) NSMutableArray *arrFest;
@property (nonatomic,strong) NSMutableArray *arrInvite;
@property (nonatomic,strong) NSMutableArray *arrHost;
@property (nonatomic,strong) NSMutableArray *arrChat;
@property (nonatomic,strong) NSMutableArray *arrComment;
@property (nonatomic,strong) NSMutableArray *arrChatId;
@property (nonatomic,strong) NSMutableArray *arrChatImages;
@property (nonatomic,assign) NSInteger eventID,chatID;
@property (nonatomic,strong) NSString *eventTitle;
@property (nonatomic,strong) ALAssetsLibrary *defaultLibrary;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) id<ContactsDelegate>delegateContact;

+(id)sharedInstance;
-(void)showLoader:(UIViewController*) parent withText:(NSString*) txt;
-(void)showLoader;
-(void)hideLoader;
-(int)isInternet;
-(void)requestAddressBookAccess;
-(NSString *)checkNumberFormat:(Contact *)selContact;
-(void)user_Data_Plist_SaveData_Settings;
-(NSDictionary *)user_Data_Plist_RetrievedData_Settings:(NSString *)keyMain;
-(void)remove_User_Data_From_Plist;

-(void)saveEventIdValuesinPlist:(NSString *)keyMain keyValue:(NSString *)val;
-(void)removeEventIdValuesFromPlist:(NSString *)keyMain subKey:(NSString *)keySub;

+(NSArray*)DB_Load_AllData:(NSString*)tblName;

+(NSArray*)DB_Load_ByID:(NSString*)tblName withColName:(NSString *)colName andParam:(NSString *)val;

+(NSArray*)DB_Load_ByDate:(NSString*)tblName withColName:(NSString *)colName;

+(void)DB_Delete;

-(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar;

-(UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;

-(CGFloat)distanceCalc:(double)fLat From:(double)fLng To:(double)tLat and:(double)tLng;

@end
