//
//  Contact.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 06/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "Contact.h"

@implementation Contact


-(NSString *)fullName
{
    if([self.firstName isEqualToString:@""] && [self.lastName isEqualToString:@""]) {
        self.firstName=[NSString stringWithFormat:@"%@",[[self.emails firstObject] componentsSeparatedByString:@"@"][0]];
        self.firstName=[self.firstName capitalizedString];
        return self.firstName;
    }
    else if(![self.firstName isEqualToString:@""] && ![self.lastName isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    }
    else
    {
        return self.firstName;
    }
}

@end
