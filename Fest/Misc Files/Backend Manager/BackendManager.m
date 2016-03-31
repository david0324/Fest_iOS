//
//  BackendManager.m
//  Fest
//
//  Created by Denow Cleetus on 17/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "BackendManager.h"
#import "ASIHTTPRequest.h"
#import "UserModel.h"
#import "NSData+Base64.h"

static BackendManager *sSharedBackendManager = nil;

@implementation BackendManager
+(BackendManager*)sharedManager{
    
    @synchronized(self){
        if (!sSharedBackendManager) {
            sSharedBackendManager=[[BackendManager alloc]init];
        }
    }
    
    
    return sSharedBackendManager;
    
}

-(void)establishBackendConnectionWithConnectionTag:(ConnectionTags)connectionTag andDictionary:(NSDictionary*)dict andDelegate:(id)delegateFrom{
    self.delegateBackend=delegateFrom;
    
    

    NSDictionary *dicMain=[self setupDictionaryBasedOnConnectionTag:connectionTag andParamDictionary:dict];

    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *strUrl;
    
    switch (connectionTag) {
        case connectionTagCreateEventPost:{
            strUrl=[NSString stringWithFormat:@"%@%@",IP3,CreateEventPost];
        }
            break;
        case connectionTagGetAllEventPosts:{
            strUrl=[NSString stringWithFormat:@"%@%@",IP3,AllEventPosts];
        }
            break;
        case connectionTagGetEventPostComments:{
            strUrl=[NSString stringWithFormat:@"%@%@",IP3,EventPostComments];
        }
            break;
        case connectionTagLikeDisLikeEventPost:{
            strUrl=[NSString stringWithFormat:@"%@%@",IP3,LikeDisLikeEventPost];
        }
            break;
        case connectionTagGetEventPostDetails:{
            strUrl=[NSString stringWithFormat:@"%@%@",IP3,EventPostDetails];
        }
            break;
        case connectionTagDeleteFest:{
            strUrl=[NSString stringWithFormat:@"%@%@",IP3,DeleteFest];
        }
            break;
        case connectionTagGetLikersList:{
            strUrl=[NSString stringWithFormat:@"%@%@",IP3,EventLikersList];
        }
            break;
            
        default:
            break;
    }

    

    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest new];
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:myJSONData]];
    [self.dataRequest startSynchronous];
    [self.dataRequest setTimeOutSeconds:500000];
    
    if(self.dataRequest)
    {
        
        if([self.dataRequest error])
        {
            [GC hideLoader];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    [self showAlertView_CF:@"" message:No_Internet];
                else
                    [self showAlertView_CF:@"" message:self.dataRequest.error.localizedDescription];
                
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (connectionTag!=connectionTagLikeDisLikeEventPost) {
                        [GC hideLoader];
                    }


                    if (self.delegateBackend && [self.delegateBackend respondsToSelector:@selector(backendConnectionSuccess:withResponse:andConnectionTag:)]) {
                        [self.delegateBackend backendConnectionSuccess:YES withResponse:json andConnectionTag:connectionTag];
                    }

                    
                });
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        if (self.delegateBackend && [self.delegateBackend respondsToSelector:@selector(backendConnectionSuccess:withResponse:andConnectionTag:)]) {
                            [self.delegateBackend backendConnectionSuccess:NO withResponse:json andConnectionTag:connectionTag];
                        }
                        [self showAlertView_CF:@"" message:strFailure];
                    }
                    else
                    {
                        [[AppDelegate getDelegate] sessionExpired];
                    }
                    
                });
            }
        }
    }
    else
    {
        [GC hideLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlertView_CF:@"" message:ServerError];
            
        });
    }

}

#pragma mark - MiscMethods
-(NSMutableDictionary *)setupDictionaryBasedOnConnectionTag:(ConnectionTags)connTag andParamDictionary:(NSDictionary*)dictParam{

    NSMutableDictionary *dicMain = [NSMutableDictionary new];



    /*
     
     e.g. Create Event Post
     API: PostToEvent
     
     EventID: EventID
     Type: 0 or 1(0=Text,1=Media)
     MediaType: 0 or 1(0=Image,1=video)
     Message: if Type=0 then Text message else Image or video in base64 string
     MediaExtension: file extension of media Message field
     ThumbPath: Thumbnail image in base64 format applicable only if type is 1
     ThumbExtension: Thumbnail image extension
     Title: Title for the image or video if the Type is 1
     Location: Location information of user
     
     */
    
    if (connTag==connectionTagCreateEventPost) {
   
        
//        parameter dictionary *****
        id messageDatOrStr=[dictParam objectForKey:@"Message"];                 // NSData or NSString, image/video data or text
        NSString *type=[dictParam objectForKey:@"Type"];
        NSString *mediaType=[dictParam objectForKey:@"MediaType"];
        NSData *thumbPathData=[dictParam objectForKey:@"ThumbPath"];            // NSData, thumb image data
        NSString *thumbExtension=[dictParam objectForKey:@"ThumbExtension"];    // thumb image extension for image/video
        NSString *mediaExtension=[dictParam objectForKey:@"MediaExtension"];    // media extension for image/video
        NSString *eventId=[dictParam objectForKey:@"EventId"];
        NSString *title=[dictParam objectForKey:@"Title"];                      // title for image/video
        NSString *resolution=[dictParam objectForKey:@"Resolution"];            // resolution for image/video
//        parameter dictionary *****
        
        
        
        
//      for posting data
        NSString *thumbPath=@""; // NSString
        NSString *message=@""; // NSString

        
        if(type.integerValue==0)  // text only
        {
            message = messageDatOrStr;      // text update
            
            
            mediaType=@"";
            mediaExtension=@"";
            thumbPath=@"";
            thumbExtension=@"";
            title=@"";
        }
        else if(type.integerValue==1)  // image/video
        {
            message = [(NSData*)messageDatOrStr base64EncodedString]; // image/video converted to string

            if (mediaType.integerValue==0) // image
            {
                
            }
            else if (mediaType.integerValue==1) //video
            {
                
            }
            
            thumbPath = [thumbPathData base64EncodedString];        // thumb image of image/video converted to string
        }
       
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        [dicPost setObject:message forKey:@"Message"];
        [dicPost setObject:type forKey:@"Type"];
        [dicPost setObject:mediaType forKey:@"MediaType"];
        [dicPost setObject:thumbPath forKey:@"ThumbPath"];
        [dicPost setObject:thumbExtension forKey:@"ThumbExtension"];
        [dicPost setObject:mediaExtension forKey:@"MediaExtension"];
        [dicPost setObject:eventId forKey:@"EventId"];
        [dicPost setObject:title forKey:@"Title"];
        [dicPost setObject:resolution forKey:@"Resolution"];

        NSMutableDictionary *dicLocation = [NSMutableDictionary new];
        NSString *lat=[dictParam objectForKey:@"Latitude"];
        NSString *lon=[dictParam objectForKey:@"Longitude"];
        [dicLocation setObject:lat forKey:@"Latitude"];
        [dicLocation setObject:lon forKey:@"Longitude"];
        
        [dicMain setObject:dicLocation forKey:@"Location"];
        [dicMain setObject:dicPost forKey:@"Post"];

    }
    else if (connTag==connectionTagGetAllEventPosts){
        
        NSString *eventId =[dictParam objectForKey:@"EventId"];
        NSString *lastReceivedChatId =[dictParam objectForKey:@"LastReceivedChatId"];
        NSString *noOfRows =[dictParam objectForKey:@"NoOfRows"];
        NSString *noOfComments =[dictParam objectForKey:@"NoOfComments"];
        
        [dicMain setObject:eventId forKey:@"EventId"];
        [dicMain setObject:lastReceivedChatId forKey:@"LastReceivedChatId"];
        [dicMain setObject:noOfRows forKey:@"NoOfRows"];
        [dicMain setObject:noOfComments forKey:@"NoOfComments"];

    }
    else if (connTag==connectionTagGetEventPostComments){
        NSString *eventChatId =[dictParam objectForKey:@"EventChatId"];
        NSString *lastReceivedCommentId =[dictParam objectForKey:@"LastReceivedCommentId"];
        NSString *noOfRows =[dictParam objectForKey:@"NoOfRows"];
        
        
        [dicMain setObject:eventChatId forKey:@"EventChatId"];
        [dicMain setObject:lastReceivedCommentId forKey:@"LastReceivedCommentId"];
        [dicMain setObject:noOfRows forKey:@"NoOfRows"];
    }
    else if (connTag==connectionTagLikeDisLikeEventPost){
        
        NSString *userId =[dictParam objectForKey:@"UserId"];
        NSString *eventChatId =[dictParam objectForKey:@"EventChatId"];

        
        [dicMain setObject:userId forKey:@"UserId"];
        [dicMain setObject:eventChatId forKey:@"EventChatId"];
    }
    else if (connTag==connectionTagGetEventPostDetails){
        
        NSString *eventChatId =[dictParam objectForKey:@"EventChatId"];
        NSString *noOfRows =[dictParam objectForKey:@"NoOfRows"];

        
        [dicMain setObject:noOfRows forKey:@"NoOfRows"];
        [dicMain setObject:eventChatId forKey:@"EventChatId"];
    }
    else if (connTag==connectionTagDeleteFest){
        
        NSString *eventId =[dictParam objectForKey:@"EventID"];
        
        [dicMain setObject:eventId forKey:@"EventID"];
    }
    else if (connTag==connectionTagGetLikersList){
        NSString *eventChatId =[dictParam objectForKey:@"EventChatId"];
        
        [dicMain setObject:eventChatId forKey:@"EventChatId"];

    }
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    UserModel *userModel = [[GC arrUserDetails] firstObject];
    [dicUserToken setObject:userModel.localID forKey:@"Id"];
    [dicUserToken setObject:userModel.authToken forKey:@"AuthToken"];
    

    
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];

    return dicMain;
}
-(void)showAlertView_CF:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}


#pragma mark - Reference [createFest]
/*
-(void)createFest:(NSString *)eventId
{
    
    CGFloat valMiles;
    
    if([self.lblMile.text isEqualToString:@"Yards"])
    {
        valMiles = miles * 0.000568182;
    }
    else
    {
        valMiles =  (float)miles;
    }
    
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    NSMutableDictionary *dicEvent = [NSMutableDictionary new];
    [dicEvent setObject:eventId forKey:@"Id"];
    [dicEvent setObject:@{@"Id" : self.userModel.localID} forKey:@"User"];
    [dicEvent setObject:txtTitle.text forKey:@"Title"];
    [dicEvent setObject:txtViewDescrip.text forKey:@"Description"];
    [dicEvent setObject:txtStreet.text forKey:@"Street"];
    [dicEvent setObject:txtCity.text forKey:@"City"];
    [dicEvent setObject:txtState.text forKey:@"State"];
    [dicEvent setObject:txtZipcode.text forKey:@"Zip"];
    [dicEvent setObject:@"xxx" forKey:@"Country"];
    [dicEvent setObject:[NSNumber numberWithFloat:valMiles] forKey:@"Miles"];
    
    if(txtViewNotification.text.length>0)
        [dicEvent setObject:txtViewNotification.text forKey:@"Notification"];
    else
        [dicEvent setObject:[NSString stringWithFormat:@"Welcome to %@!",txtTitle.text] forKey:@"Notification"];
    
    [dicEvent setObject:[NSString stringWithFormat:@"%lf",cLatitude] forKey:@"Latitude"];
    [dicEvent setObject:[NSString stringWithFormat:@"%lf",cLongitude] forKey:@"Longitude"];
    [dicEvent setObject:[NSString stringWithFormat:@"%@ %@",txtStartDate.text,txtTime.text] forKey:@"StartDate"];
    [dicEvent setObject:[NSString stringWithFormat:@"%@",txtEndDate.text] forKey:@"EndDate"];
    [dicEvent setObject:[NSString stringWithFormat:@"%d",festType] forKey:@"Type"];
    
    NSMutableArray *arrInvites = [NSMutableArray new];
    NSString *strPhone = [NSString new];
    NSString *strHost = [NSString new];
    NSMutableArray *arrIndex = [NSMutableArray new];
    
    for(long int i=0;i<[GC arrInvite].count;i++)
    {
        
        NSMutableDictionary *dicInvites = [NSMutableDictionary new];
        [dicInvites setObject:self.userModel.localID forKey:@"InviteBy"];
        [dicInvites setObject:[NSString stringWithFormat:@"%@",[[GC arrInvite] objectAtIndex:i]] forKey:@"InviteFor"];
        [dicInvites setObject:@"0" forKey:@"Type"];
        [dicInvites setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"IsHost"];
        
        strPhone = [NSString stringWithFormat:@"%@",[[GC arrInvite] objectAtIndex:i]];
        
        for(long int j=0;j<[GC arrHost].count;j++)
        {
            strHost = [NSString stringWithFormat:@"%@",[[GC arrHost] objectAtIndex:j]];
            
            if([strPhone isEqualToString:strHost])
            {
                [arrIndex addObject:[NSNumber numberWithInteger:j]];
                [dicInvites setObject:[NSString stringWithFormat:@"%@",@"true"] forKey:@"IsHost"];
            }
        }
        
        [arrInvites addObject:dicInvites];
        
    }
    
    // Remove Added Host From Array
    for(long int i=0;arrIndex.count;i++)
    {
        NSInteger index = [[arrIndex objectAtIndex:i] integerValue];
        [[GC arrHost] removeObjectAtIndex:index];
    }
    
    for (long int i=0; i<[GC arrHost].count; i++)
    {
        NSMutableDictionary *dicHost = [NSMutableDictionary new];
        [dicHost setObject:self.userModel.localID forKey:@"InviteBy"];
        [dicHost setObject:[NSString stringWithFormat:@"%@",[[GC arrHost] objectAtIndex:i]] forKey:@"InviteFor"];
        [dicHost setObject:@"0" forKey:@"Type"];
        [dicHost setObject:[NSString stringWithFormat:@"%@",@"true"] forKey:@"IsHost"];
        
        [arrInvites addObject:dicHost];
    }
    
    NSMutableArray *arrMedias = [NSMutableArray new];
    
    if(self.data1!=nil)
    {
        NSMutableDictionary *dicMediaData1 = [NSMutableDictionary new];
        
        if([self.type1 isEqualToString:@"1"])
        {
            [dicMediaData1 setObject:[self.dataVideo base64EncodedStringWithOptions:0] forKey:@"Path"];
            [dicMediaData1 setObject:[self.data1 base64EncodedString] forKey:@"ThumbPath"];
            [dicMediaData1 setObject:self.type1 forKey:@"Type"];
            
        }
        else
        {
            [dicMediaData1 setObject:[self.data1 base64EncodedString] forKey:@"Path"];
            [dicMediaData1 setObject:self.type1 forKey:@"Type"];
            
        }
        
        [dicMediaData1 setObject:[NSString stringWithFormat:@"%d",id1] forKey:@"Id"];
        [dicMediaData1 setObject:@"0" forKey:@"Tag"];
        [arrMedias addObject:dicMediaData1];
    }
    
    if(self.data2!=nil)
    {
        NSMutableDictionary *dicMediaData2 = [NSMutableDictionary new];
        [dicMediaData2 setObject:[self.data2 base64EncodedString] forKey:@"Path"];
        [dicMediaData2 setObject:self.type2 forKey:@"Type"];
        [dicMediaData2 setObject:@"1" forKey:@"Tag"];
        [dicMediaData2 setObject:[NSString stringWithFormat:@"%d",id2] forKey:@"Id"];
        [arrMedias addObject:dicMediaData2];
    }
    
    if(self.data3!=nil)
    {
        NSMutableDictionary *dicMediaData3 = [NSMutableDictionary new];
        [dicMediaData3 setObject:[self.data3 base64EncodedString] forKey:@"Path"];
        [dicMediaData3 setObject:self.type3 forKey:@"Type"];
        [dicMediaData3 setObject:@"2" forKey:@"Tag"];
        [dicMediaData3 setObject:[NSString stringWithFormat:@"%d",id3] forKey:@"Id"];
        [arrMedias addObject:dicMediaData3];
    }
    
    [dicEvent setObject:arrMedias forKey:@"Medias"];
    [dicEvent setObject:arrInvites forKey:@"Invites"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:dicEvent forKey:@"Event"];
    
    NSData *dataJSON =[NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSData *myJSONData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *strUrl;
    
    if([eventId isEqualToString:@"0"])
        strUrl=[NSString stringWithFormat:@"%@%@",IP2,CreateFest];
    else
        strUrl=[NSString stringWithFormat:@"%@%@",IP2,UpdateFest];
    
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest new];
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:myJSONData]];
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        
        if([self.dataRequest error])
        {
            [GC hideLoader];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([self.dataRequest.error.localizedDescription rangeOfString:@"A connection failure occurred"].length!=0)
                    [self showAlertView_CF:@"" message:No_Internet];
                else
                    [self showAlertView_CF:@"" message:self.dataRequest.error.localizedDescription];
                
            });
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result==1){
                
                if(self.isEdit)
                    [self performSelectorOnMainThread:@selector(updateLocalDB) withObject:nil waitUntilDone:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [GC hideLoader];
                    
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Fest saved successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                });
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        [self showAlertView_CF:@"" message:strFailure];
                    }
                    else
                    {
                        [[AppDelegate getDelegate] sessionExpired];
                    }
                    
                });
            }
        }
    }
    else
    {
        [GC hideLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlertView_CF:@"" message:ServerError];
            
        });
    }
}
*/


@end
