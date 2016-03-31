//
//  MyFest.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 17/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "MyFest.h"

@implementation MyFest

@dynamic userId;
@dynamic festEventId;
@dynamic festLocation;
@dynamic festTitle;
@dynamic latitude;
@dynamic longitude;
@dynamic festEventStatus;
@dynamic festImagePath;
@dynamic festRadius;
@dynamic pushNotification;
@dynamic festDate;

+(NSString *)entityName {
    return @"MyFest";
}
-(NSString *)description{
    
    ILLog(@"userId : %@", self.userId);
    ILLog(@"festEventId : %@", self.festEventId);
    ILLog(@"festLocation : %@", self.festLocation);
    ILLog(@"festTitle : %@", self.festTitle);
    ILLog(@"latitude : %@", self.latitude);
    ILLog(@"longitude : %@", self.longitude);
    ILLog(@"festEventStatus : %@", self.festEventStatus);
    ILLog(@"festImagePath : %@", self.festImagePath);
    ILLog(@"festRadius : %@", self.festRadius);
    ILLog(@"pushNotification : %@", self.pushNotification);
    ILLog(@"festDate : %@", self.festDate);
    
    
    return NSStringFromClass(self.class);
}

@end
