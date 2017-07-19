//
//  WPostTableViewCell.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-30.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"
#import "SCVideoPlayerView.h"
#import <ASPVideoPlayer/ASPVideoPlayer-Swift.h>
#import "YMCAudioPlayer.h"
//#import "WZVideoView.h"
#import "InstagramVideoView.h"
#import "AWEasyVideoPlayer.h"
@interface WZPostTableViewCell : UITableViewCell
@property(nonatomic ,retain) IBOutlet UIImageView *imageViewProfile;

@property(nonatomic ,retain) IBOutlet KIImagePager *imageViewPost;

@property(nonatomic ,retain) IBOutlet AWEasyVideoPlayer *postVideoView;

@property(nonatomic ,retain) IBOutlet UILabel *labelProfileName;

@property(nonatomic ,retain) IBOutlet UIButton *buttonLike;

@property(nonatomic ,retain) IBOutlet UIButton *buttonComment;

@property(nonatomic ,retain) IBOutlet UIButton *buttonRewhiz;

@property(nonatomic ,retain) IBOutlet UILabel *labelPostDate;

@property(nonatomic ,retain) IBOutlet UILabel *labelCommentTitle;

@property(nonatomic ,retain) IBOutlet UILabel *labelComment;

@property(nonatomic ,retain) IBOutlet UILabel *labelPostTitle;

@property(nonatomic ,retain) IBOutlet UILabel *labelPostText;

@property(nonatomic ,retain) IBOutlet UIButton *playButton;

@property(nonatomic ,retain)  NSArray *imageArray;

@property(nonatomic)  BOOL isText;

@property(nonatomic ,retain) IBOutlet UILabel *labelOtherComment;


//FOR AUDIO PLAYER
@property(nonatomic ,retain) IBOutlet UILabel *timeElapsed;

@property(nonatomic ,retain) IBOutlet UILabel *timeDuration;

@property(nonatomic ,retain) IBOutlet UISlider *slider;

@property(nonatomic ,retain) IBOutlet UIButton *buttonPlay;

@property(nonatomic ,retain) IBOutlet UIImageView *audioImageView;

@property(nonatomic, retain) YMCAudioPlayer *audioPlayer;


- (void)setupAudioPlayer:(NSString*)fileName;



- (IBAction)playAudioPressed:(id)sender;

- (IBAction)userIsScrubbing:(id)sender;






- (void)setUpImagePager;


@end

