//
//  EventPostCell.m
//  Fest
//
//  Created by Denow Cleetus on 18/06/15.
//  Copyright (c) 2015 Mac Mini i7 #1. All rights reserved.
//

#import "EventPostCell.h"

float padding = 5;

@implementation EventPostCell

- (void)awakeFromNib {

    [self initialSetup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - 
-(void)initialSetup{
    
    rectInitialViewImageOrVideo = self.viewImageOrVideo.frame;
    rectInitialLblPostTitle = self.lblPostTitle.frame;
    rectInitialViewBottom = self.viewBottom.frame;
    recInitialLblTime = self.lblTime.frame;
    
    [self.imgUserPic.layer setCornerRadius:CGRectGetHeight(self.imgUserPic.frame)/2.0];
    [self.imgUserPic setClipsToBounds:YES];
    [self.imgUserPic setBackgroundColor:[UIColor clearColor]];
    
    [self.lblUserName setTextColor:[ILLogic colorWithHex:@"#45556e" alpha:1]];
    [self.lblTime setTextColor:[ILLogic colorWithHex:@"#b1bbcc" alpha:1]];
    [self.lblPostTitle setTextColor:[ILLogic colorWithHex:@"#45556e" alpha:1]];

    [self.lblUserName setFont:[UIFont fontWithName:LatoRegular size:14]];
    [self.lblTime setFont:[UIFont fontWithName:LatoRegular size:12]];
    [self.lblPostTitle setFont:[UIFont fontWithName:LatoRegular size:13]];
    [self.btnLikeCount.titleLabel setFont:[UIFont fontWithName:LatoRegular size:13]];
    
    [self.lblPostTitle setNumberOfLines:0];
    
    [self.btnLikeCount setTitleColor:COLOR_TEAL forState:UIControlStateNormal];
    
    [self.lblUserName setBackgroundColor:[UIColor clearColor]];
    [self.lblTime setBackgroundColor:[UIColor clearColor]];
    [self.lblPostTitle setBackgroundColor:[UIColor clearColor]];
    [self.btnLike setBackgroundColor:[UIColor clearColor]];
    [self.viewBottom setBackgroundColor:[UIColor clearColor]];
    [self.imgTime setBackgroundColor:[UIColor clearColor]];
    
    [self.imgTime setImage:[UIImage imageNamed:@"time_broadcast"]];
    [self.btnLike setImage:[UIImage imageNamed:@"likeNor"] forState:UIControlStateNormal];
    [self.btnLike setImage:[UIImage imageNamed:@"likeSel"] forState:UIControlStateSelected];
    
    
    [self.btnLike addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLikeCount addTarget:self action:@selector(btnLikeCountClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imgVPost setClipsToBounds:YES];
    
    [self.btnPlay addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tappTwice=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedTwice:)];
    [tappTwice setNumberOfTapsRequired:2];
    [self.viewImageOrVideo addGestureRecognizer:tappTwice];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedPlaying:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(float)heightForTheCellWithPostData:(NSDictionary*)dict{
    self.dictPost=dict;
    [self updateUIBasedOnPostData:self.dictPost withDelegate:self];

    
//     follow the order and update the frames one by one ***********
    float height = CGRectGetHeight(self.viewTop.frame);
    height += CGRectGetHeight(self.viewImageOrVideo.frame);
    height += padding;
    height += CGRectGetHeight(self.lblPostTitle.frame);
    height += padding;
    height += CGRectGetHeight(self.viewBottom.frame);
    height += padding;
    
    
    return height;
    
}
-(void)updateUIBasedOnPostData:(NSDictionary*)dict withDelegate:(id)del{
    self.delegateFrom=del;
    self.dictPost=dict;
    [self updateLikeUI];

    /*
     {
     Comments =     (
     );
     CreatedDate = 1434691009;
     EventID = 76;
     FacebookID = 1588401588111681;
     FirstName = Denow;
     LastName = ILeaf;
     Likes =     (
     );
     MediaType = 0;
     Message = "http://54.69.37.46/festapp.api.com/Content/Medias/Image_63570287809422.png";
     PostID = 167;
     Resolution = "640,425";
     ThumbPath = "";
     Title = "image update 8";
     TotalComments = 0;
     TotalLikes = 0;
     Type = 1;
     UserID = 19;
     UserImage = "http://54.69.37.46/festapp.api.com/Content/Medias/Image_63570215223231.png";
     UserLikeStatus = 0;
     },
     */
    
    [self resetUI];
    
    self.postTitle=@"";
    self.type = [[_dictPost objectForKey:@"Type"] integerValue];
    self.mediaType=[[_dictPost objectForKey:@"MediaType"] integerValue];
    
    self.resolution=@"";
    id res=[_dictPost objectForKey:@"Resolution"];
    if(res && ![res isEqual:[NSNull null]] && [res length]){
        self.resolution=[res stringVal];
    }
    
    
    self.strUrlImageOrThumb=@"";

    
    if (_type==0)  // text message
    {
        self.postTitle=[[_dictPost objectForKey:@"Message"] stringVal];
        self.strUrlImageOrThumb=@"";

    }
    else if (_type==1) // image/video
    {
        self.postTitle=[[_dictPost objectForKey:@"Title"] stringVal];


        if (_mediaType==0) // image
        {
            self.strUrlImageOrThumb=[[_dictPost objectForKey:@"Message"] stringVal];  // large image url
        }
        else if (_mediaType==1) // video
        {
            self.strUrlImageOrThumb=[[_dictPost objectForKey:@"ThumbPath"] stringVal];  // video thumb image url
        }
    }
    
    
    
    if (self.resolution.length) {
        float wid=[[[_resolution componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
        float hgt=[[[_resolution componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
        
        float newWid=rectInitialViewImageOrVideo.size.width;
        float newHgt=hgt/wid*newWid;
        
        [self.viewImageOrVideo setFrame:CGRectMake(rectInitialViewImageOrVideo.origin.x, rectInitialViewImageOrVideo.origin.y, rectInitialViewImageOrVideo.size.width, newHgt)];
    }
    else{
        if (self.type==0) {
            
            CGRect rec=rectInitialViewImageOrVideo;
            rec.size.height=0;
            [self.viewImageOrVideo setFrame:rec];
        }
        else{
            [self.viewImageOrVideo setFrame:rectInitialViewImageOrVideo];
        }
    }
    
    
    
    [self.lblPostTitle setText:self.postTitle];
    [self.lblPostTitle sizeToFit];
    
    [self.lblPostTitle setFrame:CGRectMake(CGRectGetMinX(_lblPostTitle.frame), CGRectGetMaxY(_viewImageOrVideo.frame) + padding, CGRectGetWidth(self.lblPostTitle.frame), CGRectGetHeight(self.lblPostTitle.frame))];

    

    [self.viewBottom setFrame:CGRectMake(CGRectGetMinX(_viewBottom.frame), CGRectGetMaxY(_lblPostTitle.frame)+padding, CGRectGetWidth(_viewBottom.frame), CGRectGetHeight(_viewBottom.frame))];
    
//    [self addVideoPlayerIfVideo];

    [self updateDataToUIElements];

}
-(void)addVideoPlayerIfVideo{
    
    [self removeMoviePlayer];
    
    
    
    if (self.type==1 && self.mediaType==1) { // video

        self.alMoviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, self.viewImageOrVideo.frame.size.width, self.viewImageOrVideo.frame.size.height)];
        
        
        self.alMoviePlayer.view.alpha = 1.0f;
        [self.viewImageOrVideo addSubview:self.alMoviePlayer.view];

        [self.alMoviePlayer.view setHidden:YES];
        

        self.alMoviePlayer.delegate = self;

        [self.alMoviePlayer setControlStyle:MPMovieControlStyleNone]; 
        
        
    }
    else{
        [self removeMoviePlayer];
    }
}
-(void)removeMoviePlayer{
    
    [self.alMoviePlayer stop];
    
    if (self.alMoviePlayer.view.superview) {
        [self.alMoviePlayer.view removeFromSuperview];
    }
    self.alMoviePlayer.contentURL=nil;
    self.alMoviePlayer.controls = nil;
    self.alMoviePlayer = nil;
    
}
-(void)updateDataToUIElements{
    
    if (self.type==1 && self.mediaType==1) {
//        video
        [_btnPlay setHidden:NO];
    }
    else{
        [_btnPlay setHidden:YES];
    }
    
    [self.lblPostTitle setText:_postTitle];
    self.lblTime.text=[ILLogic timeStampConversion:[[_dictPost objectForKey:@"CreatedDate"] doubleValue]];
    
    float yPos=CGRectGetMinY(self.lblTime.frame);
    float hgtTime=CGRectGetHeight(self.lblTime.frame);
    
    [self.lblTime sizeToFit];
    CGRect r1=self.lblTime.frame;
    r1.origin.y=yPos;
    r1.size.height=hgtTime;
    r1.origin.x=CGRectGetMaxX(recInitialLblTime) - CGRectGetWidth(self.lblTime.frame);
    [self.lblTime setFrame:r1];
    
    CGRect rec=self.imgTime.frame;
    rec.origin.x=CGRectGetMinX(self.lblTime.frame) - rec.size.width-6;
    [self.imgTime setFrame:rec];
    [self.imgTime setCenter:CGPointMake(self.imgTime.center.x, self.lblTime.center.y)];
}
-(void)playVideo{
    DISPLAY_METHOD_NAME;
    [self addVideoPlayerIfVideo];
    
    
    if (self.alMoviePlayer) {
        NSString *str=[[self.dictPost objectForKey:@"Message"] stringVal];
        NSURL *url=[NSURL URLWithString:str];
        [self.alMoviePlayer setContentURL:url];
        
        if (self.delegateFrom && [self.delegateFrom respondsToSelector:@selector(videoPlayBackStarting:)]) {
            [self.delegateFrom videoPlayBackStarting:self];
        }
        
        [self.alMoviePlayer play];
        

        
        [self.viewImageOrVideo bringSubviewToFront:self.alMoviePlayer.view];
        [self.alMoviePlayer.view setHidden:NO];
        

        
        
        NSLog(@"url: %@", url);
    }
    else{
//        [self.btnPlay setHidden:YES];
    }

}
-(void)resetUI{
    float height = CGRectGetHeight(self.viewTop.frame);
    height += CGRectGetHeight(self.viewImageOrVideo.frame);
    height += padding;
    height += CGRectGetHeight(self.lblPostTitle.frame);
    height += padding;
    height += CGRectGetHeight(self.viewBottom.frame);
    height += padding;
    
    [self.viewImageOrVideo setFrame:rectInitialViewImageOrVideo];
    [self.lblPostTitle setFrame:rectInitialLblPostTitle];
    [self.viewBottom setFrame:rectInitialViewBottom];
    [self removeMoviePlayer];
    
}
-(void)updateLikeUI{
    
    NSInteger count=[[self.dictPost objectForKey:@"TotalLikes"] integerValue];
    BOOL liked=[[self.dictPost objectForKey:@"UserLikeStatus"] boolValue];
    [self.btnLike setSelected:liked];



    if (count>0) {
        NSString *likes=[NSString stringWithFormat:@"%zd Likes", count];
        [self.btnLikeCount setTitle:likes forState:UIControlStateNormal];
        [self.btnLikeCount setHidden:NO];
    }
    else{
        [self.btnLikeCount setHidden:YES];
    }
    
    
    

}
#pragma mark - Actions
-(void)tappedTwice:(UIGestureRecognizer*)tap{
    [self btnLikeClicked:nil];
    
}
-(void)btnLikeClicked:(UIButton*)btn{
    [btn setSelected:!btn.selected];
    
    DISPLAY_METHOD_NAME;
    if (self.delegateFrom && [self.delegateFrom respondsToSelector:@selector(btnLikeClicked:)]) {
        [self.delegateFrom btnLikeClicked:self.dictPost];
    }
}
-(void)btnLikeCountClicked:(UIButton*)btn{
    
    DISPLAY_METHOD_NAME;
    if (self.delegateFrom && [self.delegateFrom respondsToSelector:@selector(btnLikeCountClicked:)]) {
        [self.delegateFrom btnLikeCountClicked:self.dictPost];
    }
}
#pragma mark - ScrollDelegate From TableviewClass
-(void)scrollViewDidScroll:(UIScrollView *)scrollView andTableView:(UITableView*)tableView{
    DISPLAY_METHOD_NAME;
    


}

#pragma mark - Videoplayer Delegates
-(void)finishedPlaying:(NSNotification*)not{
    

    
    ALMoviePlayerController *mov=[not object];
    
    NSLog(@"mov url: %@", mov.contentURL);
    MPMoviePlaybackState state= [mov playbackState];
    NSLog(@"playback state: %zd", state);
    if ([mov playableDuration] == mov.currentPlaybackTime) {
        NSLog(@"playback finished **");
        [mov.view setHidden:YES];
        [mov setInitialPlaybackTime:0];
    }
    else{
        NSLog(@"tot: %f", mov.playableDuration);
        NSLog(@"current: %f", mov.currentPlaybackTime);
    }

}
-(void)exitPlayer{
        DISPLAY_METHOD_NAME;
    [self.alMoviePlayer.view setHidden:YES];
}
-(void)exitPlayeSwipeLeft{
        DISPLAY_METHOD_NAME;
}
-(void)exitPlayeSwipeRight{
        DISPLAY_METHOD_NAME;
}
- (void)movieTimedOut{
    DISPLAY_METHOD_NAME;
}
- (void)moviePlayerWillMoveFromWindow{
    DISPLAY_METHOD_NAME;
}


@end
