//
//  BackendManager.h
//  Fest
//
//  Created by Denow Cleetus on 17/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;

@protocol BackendMangerDelegate <NSObject>

@required
-(void)backendConnectionSuccess:(BOOL)flagSuccess withResponse:(NSDictionary*)dictResponse andConnectionTag:(ConnectionTags)connectionTag;

@end



@interface BackendManager : NSObject

@property(nonatomic, weak) id<BackendMangerDelegate> delegateBackend;
@property (nonatomic,strong) ASIHTTPRequest *dataRequest;


+(BackendManager*)sharedManager;
-(void)establishBackendConnectionWithConnectionTag:(ConnectionTags)tagConnection andDictionary:(NSDictionary*)dict andDelegate:(id)delegateFrom;



@end
