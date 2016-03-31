//
//  Contact.h
//  Fest
//
//  Created by Mac Mini i7 #1 on 06/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) NSString *phone;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableAttributedString *name;

-(NSString *)fullName;

@end
