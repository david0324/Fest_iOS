//
//  EventPostCell.h
//  Fest
//
//  Created by Denow Cleetus on 18/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALMoviePlayerController.h"

@class EventPostCell;

@protocol EventCellDelegate <NSObject>

-(void)btnLikeClicked:(NSDictionary*)dict;
-(void)btnLikeCountClicked:(NSDictionary*)dict;
-(void)videoPlayBackStarting:(EventPostCell*)cell;


@end

@interface EventPostCell : UITableViewCell<ALMoviePlayerControllerDelegate>
{
    CGRect rectInitialViewImageOrVideo, rectInitialLblPostTitle, rectInitialViewBottom, recInitialLblTime;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UIImageView *imgTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIView *viewImageOrVideo;
@property (strong, nonatomic) IBOutlet UIImageView *imgVPost;
@property (strong, nonatomic) IBOutlet UILabel *lblPostTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnLikeCount;
@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;

@property(nonatomic, retain)NSDictionary *dictPost;

@property(nonatomic, weak) id<EventCellDelegate> delegateFrom;


@property NSInteger type;
@property NSInteger mediaType;
@property (nonatomic, retain) NSString *postTitle;
@property (nonatomic, retain) NSString *resolution;
@property (nonatomic, retain) NSString *strUrlImageOrThumb;
@property (nonatomic,strong) ALMoviePlayerController *alMoviePlayer;

@property (nonatomic, retain)NSIndexPath *indexPath;

-(void)updateUIBasedOnPostData:(NSDictionary*)dict withDelegate:(id)del;
-(float)heightForTheCellWithPostData:(NSDictionary*)dict;
-(void)resetUI;
-(void)removeMoviePlayer;
-(void)playVideo;



#pragma mark - ScrollDelegate From TableviewClass
-(void)scrollViewDidScroll:(UIScrollView *)scrollView andTableView:(UITableView*)tableView;

@end
