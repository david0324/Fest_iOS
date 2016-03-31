//
//  BroadcastEventsLikesVC.m
//  Fest
//
//  Created by Denow Cleetus on 19/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "BroadcastEventsLikesVC.h"
#import "EventLikesCell.h"
#import "BackendManager.h"

static NSString *cellIdentifier =@"EventLikesCell";

@interface BroadcastEventsLikesVC ()

@end

@implementation BroadcastEventsLikesVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _arrTableView=[[NSMutableArray alloc]init];
    
    [self initialSetupDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
}

#pragma mark - MyMethods
-(void)initialSetupDidLoad{
    
    UIButton *btnBack = (id)[_viewTopbar viewWithTag:100];
    UILabel *lblTop = (id)[_viewTopbar viewWithTag:101];
    
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    lblTop.font = [UIFont fontWithName:LatoRegular size:18.0];
    [lblTop setTextColor:COLOR_TEAL];
    [lblTop setText:@"Likes"];

    _tableView.dataSource=self;
    _tableView.delegate=self;

    
    [self getLikersList];
}
-(void)getLikersList{
    /*
     URL: http://54.69.37.46/festapp.api.com/api/EventPosts/
     GetLikersList
     Type:POST
     Request:{"UserToken":{"AuthToken":"1136917495","Id":7},"EventChatId":154}
     */
    NSString *festId=[self.dictPostDetails objectForKey:@"PostID"];
    
    NSMutableDictionary *d=[NSMutableDictionary new];
    
    [d setObject:festId forKey:@"EventChatId"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GC showLoader:self withText:@""];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[BackendManager sharedManager] establishBackendConnectionWithConnectionTag:connectionTagGetLikersList andDictionary:d andDelegate:self];
    });
}
-(void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateTableView:(NSArray*)arr{
    [_arrTableView removeAllObjects];
    [_arrTableView addObjectsFromArray:arr];
    
    [self.tableView reloadData];
}

#pragma mark - Tableview Delegates
#pragma mark - Tableview Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrTableView.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
     {
     Data =     (
     {
     FacebookId = 1588401588111681;
     FirstName = Denow;
     LastName = ILeaf;
     UserId = 19;
     UserImage = "http://54.69.37.46/festapp.api.com/Content/Medias/Image_63570215223231.png";
     }
     );
     IsSuccessful = 1;
     ReasonForFailure = "";
     }
     */
    
    
    EventLikesCell *cell = (EventLikesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (EventLikesCell *)[nib objectAtIndex:0];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *d=[_arrTableView objectAtIndex:indexPath.row];
    NSString *fn=([d objectForKey:@"FirstName"])?[d objectForKey:@"FirstName"]:@"";
    NSString *ln=([d objectForKey:@"LastName"])?[d objectForKey:@"LastName"]:@"";
    NSString *name=[NSString stringWithFormat:@"%@ %@", fn, ln];
    [cell.lblName setText:name];

    NSURL *url=[NSURL URLWithString:[d objectForKey:@"UserImage"]];
    [cell.imgVUserPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_icon_transparent"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(([error.localizedDescription rangeOfString:@"operation"].location == NSNotFound) && (isReach))
        {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if(image){
            cell.imgVUserPic.image = image;
        }
    }];


    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - BackendMangaer Delegate
-(void)backendConnectionSuccess:(BOOL)flagSuccess withResponse:(NSDictionary*)dictResponse andConnectionTag:(ConnectionTags)connectionTag{
    
    [GC hideLoader];
    if(flagSuccess){
        NSArray *arr=[dictResponse objectForKey:@"Data"];
        [self updateTableView:arr];
    }
}

@end
