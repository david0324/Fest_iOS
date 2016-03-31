//
//  PictureFeedViewController.m
//  Fest
//
//  Created by J.P.  on 2/25/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "PictureFeedViewController.h"

@interface PictureFeedViewController ()

@end

@implementation PictureFeedViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesArray = [[NSMutableArray alloc] init];
    self.strMediaType = [[NSString alloc] init];
    self.strCoverURL = [[NSString alloc] init];
    self.strMediaType = [[NSString alloc] init];
    self.strChatType = [[NSString alloc] init];
    self.arrChat = [[NSMutableArray alloc] init];
    self.arrChatId = [NSMutableArray arrayWithArray:[GC arrChatId]];
    
    self.userModel = [[GC arrUserDetails] firstObject];
    
    refCount = 0;
    
    [self getImages:@"0"];

    [GC setParentVC:self];
    
    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
    {
        //self.lbl_header.text = [GC eventTitle];
        
        if([GetValue_Key(@"Reload") isEqualToString:@"Reload"])
        {
            SetValue_Key(@"", @"Reload");
            
            self.arrChat = [NSMutableArray arrayWithArray:[GC arrChat]];
            
            self.arrChatId = [NSMutableArray arrayWithArray:[GC arrChatId]];
            
            self.imagesArray = [NSMutableArray arrayWithArray:[GC arrChatImages]];
            
            NSMutableArray *arrTemp = [NSMutableArray new];
            arrTemp = [NSMutableArray arrayWithObjects:GetValue_Key(@"ChatData"), nil];
            
            int valType = 0;
            
            for(long int i=0;i<arrTemp.count;i++)
            {
                NSMutableDictionary *dicTemp = [NSMutableDictionary new];
                
                valType = [[[arrTemp objectAtIndex:i] valueForKey:@"Type"] intValue];
                
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FullName"]  forKey:@"Name"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FacebookId"]  forKey:@"FacebookId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.Id"]  forKey:@"LocalId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Type"] forKey:@"Type"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"] forKey:@"ChatId"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"LikeStatus"] forKey:@"LikeStatus"];
                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"TotalLike"] forKey:@"TotalLike"];
                
                NSString *strTest = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                
                if(valType == 0 && (![strTest isEqualToString:@"<null>"]))
                {
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Message"]  forKey:@"Message"];
                    [self.arrChat addObject:dicTemp];
                }
                
                self.strMediaURL = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                
                if(valType == 1)
                {
                    [dicTemp setObject:self.strMediaURL forKey:@"Path"];
                    [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"] forKey:@"MediaType"];
                    
                    if([[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"]intValue]==1)
                    {
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"ThumbPath"] forKey:@"ThumbPath"];
                    }
                    
                    [self.imagesArray addObject:dicTemp];
                    
                }
                
                [self.arrChatId addObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"]];
            }
            
            refCount += arrTemp.count;
            
            arrTemp = nil;
            
            [self.feedTableView reloadData];
            //[tableChat reloadData];
            
            [[GC arrChat] removeAllObjects];
            [[GC arrChatId] removeAllObjects];
            [[GC arrChatImages] removeAllObjects];
            
            [GC setArrChat:[NSMutableArray arrayWithArray:self.arrChat]];
            
            [GC setArrChatId:[NSMutableArray arrayWithArray:self.arrChatId]];
            
            [GC setArrChatImages:[NSMutableArray arrayWithArray:self.imagesArray]];
        }
        else
        {
            [GC showLoader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //[self getAllChat:@"0"];
                
            });
        }
    }
    else
    {
        //[self loadChatData];
    }
    
    
    // Do any additional setup after loading the view.
    
    //self.imagesArray = [NSMutableArray arrayWithArray:[GC arrChatImages]];
    
    //NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getImages:(NSString *)tag
{
    NSMutableDictionary *dicMain = [NSMutableDictionary new];
    NSMutableDictionary *dicUserToken = [NSMutableDictionary new];
    
    [dicUserToken setObject:self.userModel.localID forKey:@"Id"];
    [dicUserToken setObject:self.userModel.authToken forKey:@"AuthToken"];
    
    [dicMain setObject:dicUserToken forKey:@"UserToken"];
    [dicMain setObject:[NSString stringWithFormat:@"%ld",(long)[GC eventID]] forKey:@"EventId"];
    [dicMain setObject:tag forKey:@"LastReceivedChatId"];
    
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dicMain options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    NSData *dataMyJson = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",IP2,AllChats];
    NSURL *url=[NSURL URLWithString:strUrl];
    
    self.dataRequest = [ASIHTTPRequest new];
    self.dataRequest = [ASIHTTPRequest requestWithURL:url];
    self.dataRequest.delegate=self;
    [self.dataRequest setRequestMethod:@"POST"];
    [self.dataRequest addRequestHeader:@"content-type" value:@"application/json"];
    [self.dataRequest setPostBody:[NSMutableData dataWithData:dataMyJson]];
    [self.dataRequest startSynchronous];
    
    if(self.dataRequest)
    {
        [GC hideLoader];
        
        if([self.dataRequest error])
        {
            /*dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showAlert_Chat:@"" message:self.dataRequest.error.localizedDescription];
                
            });*/
        }
        else if ([self.dataRequest responseString])
        {
            NSData *dat = [[self.dataRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableLeaves error:nil];
            
            int result = [[json objectForKey:@"IsSuccessful"] intValue];
            
            if(result == 1) {
                
                NSMutableArray *arrTemp = [NSMutableArray new];
                arrTemp = [NSMutableArray arrayWithArray:[json valueForKeyPath:@"Data.Chats"]];
                
                SetValue_Key(@"", @"HitLike");
                
                /*if(refCount == arrTemp.count)
                {
                    if(self.arrChat.count>1)
                        [self.feedTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrChat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                    return;
                }*/
                //else
                //{
                    int valType = 0;
                    
                    for(long int i=0;i<arrTemp.count;i++)
                    {
                        NSMutableDictionary *dicTemp = [NSMutableDictionary new];
                        
                        valType = [[[arrTemp objectAtIndex:i] valueForKey:@"Type"] intValue];
                        
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FullName"]  forKey:@"Name"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.FacebookId"]  forKey:@"FacebookId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKeyPath:@"User.Id"]  forKey:@"LocalId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Type"] forKey:@"Type"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"] forKey:@"ChatId"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"LikeStatus"] forKey:@"LikeStatus"];
                        [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"TotalLike"] forKey:@"TotalLike"];
                        
                        NSString *strTest = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                        
                        if(valType == 0 && (![strTest isEqualToString:@"<null>"]))
                        {
                            [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"Message"]  forKey:@"Message"];
                            [self.arrChat addObject:dicTemp];
                        }
                        
                        strTest = nil;
                        
                        self.strMediaURL = [NSString stringWithFormat:@"%@",[[arrTemp objectAtIndex:i] valueForKey:@"Message"]];
                        
                        if(valType == 1)
                        {
                            [dicTemp setObject:self.strMediaURL forKey:@"Path"];
                            [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"] forKey:@"MediaType"];
                            
                            if([[[arrTemp objectAtIndex:i] valueForKey:@"MediaType"]intValue]==1)
                            {
                                [dicTemp setObject:[[arrTemp objectAtIndex:i] valueForKey:@"ThumbPath"] forKey:@"ThumbPath"];
                            }
                            
                            //[self.imagesArray addObject:dicTemp];
                            [self.imagesArray addObject:[dicTemp valueForKey:@"Path"]];
                        }
                        
                        [self.arrChatId addObject:[[arrTemp objectAtIndex:i] valueForKey:@"Id"]];
                        
                    }
                    
                    refCount = arrTemp.count;
                    
                    arrTemp = nil;
                    
                    [GC setArrChat:[NSMutableArray arrayWithArray:self.arrChat]];
                    
                    [GC setArrChatId:[NSMutableArray arrayWithArray:self.arrChatId]];
                    
                    [GC setArrChatImages:[NSMutableArray arrayWithArray:self.imagesArray]];
                    
                    [self.feedTableView reloadData];
                    
                    /*if(self.arrChat.count>1)
                        [self.tableChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrChat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];*/
            
                    
                    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
                    {
                        /*if(self.imagesArray.count>0)
                            [self showChatCoverImage:self.imagesArray.count-1];
                        else
                            [self showChatCoverImage:0];*/
                    }
                    /*else
                        [self showChatCoverImage:0];*/
                    
                //}
                
            }
            else
            {
                [GC hideLoader];
                
                NSString *strFailure = [NSString stringWithFormat:@"%@",[json objectForKey:@"ReasonForFailure"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([strFailure rangeOfString:UnAuthorised].location == NSNotFound)
                    {
                        if([strFailure isEqualToString:@"Record Not found"])
                        {
                            /*if(arrImages.count == 0)
                            {
                                btnLeft.hidden = YES;
                                btnRight.hidden= YES;
                                
                            }*/
                        }
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
            
            //[self showAlert_Chat:@"" message:ServerError];
        });
    }
}




#pragma mark - Table View Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"pictureFeedCell";
    PictureFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[PictureFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSMutableArray *arrMedia = [[NSMutableArray alloc] initWithArray:[[[GC arrFest] objectAtIndex:indexPath.row] valueForKey:@"Medias"]];
    
    if(arrMedia.count > 0) {
    
        int mediaType = [[[arrMedia firstObject] valueForKey:@"Type"] intValue];
        NSString *strImgPath;
        if(mediaType == 0)
            strImgPath = [NSString stringWithFormat:@"%@",[[arrMedia firstObject] valueForKey:@"Path"]];
        else
            strImgPath = [NSString stringWithFormat:@"%@",[[arrMedia firstObject] valueForKey:@"ThumbPath"]];
        
        [cell.imageViewOfCell sd_setImageWithURL:URL(strImgPath) placeholderImage:[UIImage imageNamed:@"default_fest_icon"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
            {
                //[self.tableMyFest reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else{
                
                cell.imageViewOfCell.image = image;
            }
        }];
    }
    else
    {
        cell.imageViewOfCell.image = [UIImage imageNamed:@"default_fest_icon"];
    }

    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.imagesArray.count;
    return [GC arrChatImages].count; 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender {
    //flagExit = 1;
    
    if([GetValue_Key(@"Notification") isEqualToString:@"Notification"])
    {
        FestDetailViewController *FD = [self.storyboard instantiateViewControllerWithIdentifier:FestDetail_ViewController];
        FD.isMyFest = YES;
        FD.pageIndex = 0;
        [self.navigationController pushViewController:FD animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
