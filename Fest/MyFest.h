//
//  MyFest.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 17/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyFest : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * festEventId;
@property (nonatomic, retain) NSString * festLocation;
@property (nonatomic, retain) NSString * festTitle;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSNumber * festEventStatus;
@property (nonatomic, retain) NSString * festImagePath;
@property (nonatomic, retain) NSString * festRadius;
@property (nonatomic, retain) NSString * pushNotification;
@property (nonatomic, retain) NSDate   * festDate;

@end
