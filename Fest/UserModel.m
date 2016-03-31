//
//  userModel.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 25/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(id)init {
    if(self) {
        return self;
    }
    
    _facebookID=[NSString new];
    _firstName=[NSString new];
    _lastName=[NSString new];
    _email=[NSString new];
    _birthday=[NSString new];
    _profileURL=[NSString new];
    _schooling=[NSString new];
    
    return self;
}

-(NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}



-(NSString *)description{
    
    ILLog(@"_facebookID: %@", _facebookID);
    ILLog(@"_firstName: %@", _firstName);
    ILLog(@"_lastName: %@", _facebookID);
    ILLog(@"_email: %@", _email);
    ILLog(@"_birthday: %@", _birthday);
    ILLog(@"_profileURL: %@", _profileURL);
    ILLog(@"_schooling: %@", _schooling);
    
    
    return NSStringFromClass(self.class);
}
@end
