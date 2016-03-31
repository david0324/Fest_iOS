//
//  GlobalClass.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 23/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "GlobalClass.h"
#import "DejalActivityView.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "HomeNavigationController.h"

@implementation GlobalClass

@synthesize parentVC;

+(id)sharedInstance {
    static GlobalClass *store = nil;
    static dispatch_once_t staticToken = 0;
    
    dispatch_once(&staticToken, ^{
        store = [[self alloc] init];
    });
    
    return store;
}

- (id)init {
    if (self = [super init])
    {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
            [self networkReachablityChangeNotification:status];
        }];
        
        [self allocObjects];
    }
    
    return self;
}

#pragma mark - Instance Allocations
-(void) allocObjects
{
    self.collections = [NSMutableDictionary new];
    self.arrUserDetails = [NSMutableArray new];
    self.dicUserDefaults = [NSMutableDictionary new];
    self.arrPreviews = [NSMutableArray new];
    self.arrContacts = [NSMutableArray new];
    self.arrFest = [NSMutableArray new];
    self.arrInvite = [NSMutableArray new];
    self.arrHost = [NSMutableArray new];
    self.eventTitle = [NSString new];
    self.formatter = [[NSDateFormatter alloc] init];
    self.arrChat = [NSMutableArray new];
    self.arrChatId = [NSMutableArray new];
    self.arrChatImages = [NSMutableArray new];
    self.arrComment = [NSMutableArray new];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

-(void)networkReachablityChangeNotification:(AFNetworkReachabilityStatus)status {
    
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            break;
        default:
            NSLog(@"Network Status Unknown");
            break;
    }
}

#pragma mark - SDWeb Image Cache to retrieve image
-(void)getImageForUrl:(NSURL *)url with:(imageDownloadcompletionBlock) completed
{
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(error){
            //NSLog(@"Error-Image Download=>%@",error);
        }
        if(image) {
            completed(image);
        } else {
            completed(nil);
            NSLog(@"No Image");
        }
    }];
}

#pragma mark - Show & Hide Loader
-(void)showLoader
{
    [self showLoader:parentVC withText:@"Loading"];
}

-(void)showLoader:(UIViewController*) parent withText:(NSString*) txt
{
    DejalActivityView *dejalActivityView= [DejalBezelActivityView activityViewForView:parent.view withLabel:txt];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingIcon"]];
    imageView.frame=CGRectMake(0, 0, 50, 50);
    imageView.center=CGPointMake(parentVC.view.center.x, parentVC.view.center.y-10);
    [dejalActivityView addSubview:imageView];
    
    [dejalActivityView.activityIndicator bringSubviewToFront:dejalActivityView.activityIndicator.superview];
    dejalActivityView.borderView.backgroundColor=[UIColor colorWithRed:(147.0/225.0) green:(147.0/225.0) blue:(208.0/225.0) alpha:0.5];;//[UIColor colorWithRed:147/225 green:147/225 blue:208/225 alpha:0.5];
}

-(void)hideLoader
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

#pragma mark - Convert address to latitude & longitude
-(void)getLocationFromAddressString:(NSString*)addressStr
{
    double latitude , longitude;
    
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false", esc_addr];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    NSData *data1 = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
    if([[json valueForKey:@"status"] isEqualToString:@"OK"])
    {
        NSMutableArray *arrlat = [[NSMutableArray alloc] initWithObjects:[[[[json valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"], nil];
        
        latitude=[[[arrlat objectAtIndex:0] objectAtIndex:0] doubleValue];
        
        NSMutableArray *arrlong = [[NSMutableArray alloc] initWithObjects:[[[[json valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"], nil];
        
        longitude=[[[arrlong objectAtIndex:0] objectAtIndex:0] doubleValue];
        
        [self hideLoader];
    }
    else
    {
        latitude=0.0;
        longitude=0.0;
        
       [self hideLoader];
        
    }

}

#pragma mark - Check Internet Availability
-(int)isInternet
{
    int flagNet=0;
    
    Reachability *reach=[Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus NW=[reach currentReachabilityStatus];
    //NSLog(@"NetworkStatus=>%d",NW);
    if(NW==NotReachable)
    {
        flagNet=1;
        [self performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
        
    }
    else{
        
        flagNet=0;
    }
    
    return flagNet;
    
}

#pragma mark - Request Permission To Access Contacts
-(void)requestAddressBookAccess
{
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if(addressBook) {
        //self.addressBook = CFAutorelease(addressBook);
        /*
         Register for a callback if the addressbook data changes this is important to be notified of new data when the user grants access to the contacts. the application should also be able to handle a nil object being returned as well if the user denies access to the address book.
         */
        //ABAddressBookRegisterExternalChangeCallback(self.addressBook, handleAddressBookChange, (__bridge void *)(self));
        
        /*
         When the application requests to receive address book data that is when the user is presented with a consent dialog.
         */
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if(granted)
            {
                self.arrContacts = [[NSMutableArray alloc]init];
                
                if (addressBook) {
                    NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
                    NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:allContacts.count];
                    
                    NSUInteger i = 0;
                    for (i = 0; i<[allContacts count]; i++)
                    {
                        Contact *contact = [[Contact alloc] init];
                        ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                        // Get first and last names
                        NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                        
                        // Set Contact properties
                        if([firstName isEqualToString:@""] || firstName==nil)
                            contact.firstName=@"";
                        else
                            contact.firstName = firstName;
                        
                        if([lastName isEqualToString:@""] || lastName==nil)
                            contact.lastName=@"";
                        else
                            contact.lastName = lastName;
                        
                        if([contact.firstName isEqualToString:@""] || contact.firstName==nil) {
                            if(![contact.lastName isEqualToString:@""] || contact.lastName!=nil) {
                                contact.firstName = [NSString stringWithString:contact.lastName];
                                contact.lastName = @"";
                            }
                        }
                        
                        // Get mobile number
                        ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                        contact.phone = [self getMobilePhoneProperty:phonesRef];
                        if(phonesRef) {
                            CFRelease(phonesRef);
                        }
                        
                        // Get image if it exists have to find better way to do
                        NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
                        contact.image = [UIImage imageWithData:imgData];
                        if (!contact.image) {
                            contact.image = [UIImage imageNamed:@"icon_ghost2"];
                        }
                        
                        NSMutableArray *contactEmails = [NSMutableArray new];
                        
                        ABMultiValueRef multiEmails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
                        
                        for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                            CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                            NSString *contactEmail = (__bridge NSString *)contactEmailRef;
                            
                            [contactEmails addObject:contactEmail];
                        }
                        
                        //Check Contact has email id
                        /*if(contactEmails.count > 0) {
                            [contact setEmails:contactEmails];
                            [mutableContacts addObject:contact];
                        }*/
                        
                        //Check Contact has phone number
                        if(contact.phone.length>0)
                        {
                            [mutableContacts addObject:contact];
                        }
                        
                    }
                    
                    if(addressBook) {
                        CFRelease(addressBook);
                    }
                    
                    self.arrContacts = [NSMutableArray arrayWithArray:mutableContacts];
                    NSLog(@"GS- arrContacts=>%lu",(long) self.arrContacts.count);
                    [self.delegateContact refreshContactsList];
                    
                    [mutableContacts removeAllObjects];
                }
                else
                {
                    NSLog(@"Error");
                }
            }
            else
            {
                NSLog(@"Denied");
            }
            
        });
    }
}

-(NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}

#pragma mark - Check Number Format
-(NSString *)checkNumberFormat:(Contact *)selContact
{
    NSString *strPhone = [NSString stringWithFormat:@"%@",selContact.phone.copy];
    
    NSMutableCharacterSet *characterSet =
    [NSMutableCharacterSet characterSetWithCharactersInString:@"-()+ "];
    
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [strPhone componentsSeparatedByCharactersInSet:characterSet];
    
    // Create string from the array components
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    
    strOutput = [strOutput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(strOutput.length == 10)
        strPhone = [NSString stringWithFormat:@"1%@",strOutput.copy];
    
    characterSet = nil;
    arrayOfComponents = nil;
    
    return strPhone;
}

#pragma mark - Image Resizing
-(UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Format Phone Number
-(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar
{
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is too long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
    
}

#pragma mark - Distance Calculation
-(CGFloat)distanceCalc:(double)fLat From:(double)fLng To:(double)tLat and:(double)tLng
{
    CGFloat distance = 0.0;
    
    NSString *req = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%lf,%lf&destination=%lf,%lf&sensor=false", fLat,fLng,tLat,tLng];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data!=nil)
    {
        NSMutableDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *StatusResult=[json valueForKey:@"status"];
        
        if([StatusResult isEqualToString:@"OK"])
        {
            NSMutableArray *total=[[NSMutableArray alloc] initWithObjects:[[[[json valueForKey:@"routes"] valueForKey:@"legs"] valueForKey:@"distance"] valueForKey:@"text" ] , nil];
            
            NSString *strDist = [[[total objectAtIndex:0] objectAtIndex:0] objectAtIndex:0] ;
            NSArray *distArr = [strDist componentsSeparatedByString:@" "];
            
            if([[distArr objectAtIndex:1] isEqualToString:@"km"] || [[distArr objectAtIndex:1] isEqualToString:@"Km"])
            {
                distance=[[[distArr objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                distance = distance * 0.621371;
                
            }else
            {
                distance=[[[distArr objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            }
        }
        else
        {
            distance=0.0;
        }

    }
    else
    {
        distance=0.0;
    }
    
    return distance;
}

#pragma mark - Save Data in Plist
-(void)user_Data_Plist_SaveData_Settings
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Fest.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Fest" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    self.userModel = [self.arrUserDetails firstObject];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:self.userModel.facebookID forKey:@"facebookID"];
    [dic setObject:self.userModel.firstName forKey:@"firstName"];
    [dic setObject:self.userModel.lastName forKey:@"lastName"];
    [dic setObject:self.userModel.profileURL forKey:@"profileURL"];
    [dic setObject:self.userModel.localID forKey:@"localID"];
    [dic setObject:self.userModel.authToken forKey:@"authToken"];
    [dic setObject:self.userModel.email forKey:@"email"];
    [dic setObject:self.userModel.birthday forKey:@"birthday"];
    [dic setObject:self.userModel.schooling forKey:@"schooling"];
    [dic setObject:self.userModel.activation forKey:@"activation"];
    
    [data setObject:dic forKey:@"UserModel"];
    
    [data writeToFile: path atomically:YES];
    
}

#pragma mark - Retrieve Data in Plist
-(NSDictionary *)user_Data_Plist_RetrievedData_Settings:(NSString *)keyMain
{
    NSDictionary *dic;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Fest.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Fest" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    dic = [NSDictionary new];
    dic = [savedStock objectForKey:keyMain];
    
    return dic;
    
}

#pragma mark - Remove Data in Plist
-(void)remove_User_Data_From_Plist
{
    NSMutableDictionary *dic;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Fest.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Fest" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    dic = [NSMutableDictionary new];
    dic = [data objectForKey:@"UserModel"];
    
    [dic removeAllObjects];
    [dic setObject:@"0" forKey:@"localID"];
    
    [data setObject:dic forKey:@"UserModel"];
    
    [data writeToFile:path atomically:YES];

}

#pragma mark - Remove Fest Event Id Values From Plist
-(void)saveEventIdValuesinPlist:(NSString *)keyMain keyValue:(NSString *)val
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Fest.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Fest" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:val forKey:val];

    [data setObject:dic forKey:keyMain];
    
    [data writeToFile:path atomically:YES];
}

#pragma mark - Remove Fest Event Id Values From Plist
-(void)removeEventIdValuesFromPlist:(NSString *)keyMain subKey:(NSString *)keySub
{
    NSMutableDictionary *dic;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Fest.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Fest" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    dic = [NSMutableDictionary new];
    dic = [data objectForKey:keyMain];
    
    [dic removeObjectForKey:keySub];
    
    [data setObject:dic forKey:keyMain];
    
    [data writeToFile:path atomically:YES];
}

#pragma mark - Local DB
+(NSArray*)DB_Load_AllData:(NSString*)tblName
{
    NSArray *lookupArray;
    NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tblName
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // Add an NSSortDescriptor to sort the labels alphabetically
    /*NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:colName ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];*/
    
    NSError *error = nil;
    lookupArray = [context executeFetchRequest:fetchRequest error:&error];
    return lookupArray;
}

+(NSArray*)DB_Load_ByID:(NSString*)tblName withColName:(NSString *)colName andParam:(NSString *)val
{
    NSArray *lookupArray;
    NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tblName
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@=%@",colName,val]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    lookupArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        ILLog(@"err: %@", error.localizedDescription);
    }
    
    return lookupArray;
}

+(NSArray*)DB_Load_ByDate:(NSString*)tblName withColName:(NSString *)colName
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM/dd/yyyy";
    NSDate *curDate = [NSDate date];
    NSString *strDate = [format stringFromDate:curDate];
    curDate = [format dateFromString:strDate];

    NSArray *lookupArray;
    NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tblName
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@=%@",colName,curDate]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    lookupArray = [context executeFetchRequest:fetchRequest error:&error];
    
    return lookupArray;
}

+(NSArray*)DB_Load_ByGroupID:(NSString*)tblName withColValue:(int)groupIdValue
{
    NSArray *lookupArray;
    NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tblName
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@=%d",@"",4]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    lookupArray = [context executeFetchRequest:fetchRequest error:&error];
    
    return lookupArray;
}

-(void)DB_SaveInLocalDB:(NSMutableDictionary*)resDic
{
    //Lookup Items Save
    NSMutableArray *array = [resDic objectForKey:@""];
    NSLog(@"Lookups Array Cound ====> %lu",(unsigned long)[array count]);
    for(int i=0; i<[array count]; i++)
    {
        // Grab the context
        NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
        // Grab the Label entity
        //MyFest *myFest = [NSEntityDescription insertNewObjectForEntityForName:@"MyFest" inManagedObjectContext:context];
        
        // Save everything
        NSError *error = nil;
        if ([context save:&error]) {
            NSLog(@"Lookups The save was successful!");
        } else {
            NSLog(@"Lookups The save wasn't successful: %@", [error userInfo]);
        }
    }
}

+(void)DB_Delete
{
    //Delete Table
    NSManagedObjectContext *context = [[AppDelegate getDelegate] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MyFest"];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
}

@end
