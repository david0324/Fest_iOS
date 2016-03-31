//
//  userModel.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 25/09/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,strong) NSString *facebookID;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *profileURL;
@property (nonatomic,strong) NSString *schooling;
@property (nonatomic,strong) NSString *authToken;
@property (nonatomic,strong) NSString *localID;
@property (nonatomic,strong) NSString *activation;

-(NSString *)fullName;

@end
