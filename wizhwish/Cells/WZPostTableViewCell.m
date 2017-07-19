//
//  WPostTableViewCell.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-30.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZPostTableViewCell.h"
#import "YMCAudioPlayer.h"

@interface WZPostTableViewCell()<KIImagePagerDataSource,KIImagePagerDelegate>


@property(nonatomic, retain) NSTimer *timer;

@property(nonatomic ,assign) BOOL isPaused;

@property(nonatomic ,assign) BOOL scrubbing;
@end

@implementation WZPostTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.imageViewProfile setRoundCornersAsCircle];
    self.audioPlayer = [[YMCAudioPlayer alloc] init];

    //self.imageViewPost.delegate = self;
  

}


- (void)setUpImagePager {
    
    self.imageViewPost.userInteractionEnabled = YES;
    self.imageViewPost.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.imageViewPost.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    if (self.imageArray.count<2)
        self.imageViewPost.imageCounterDisabled = YES;
    // pager.slideshowTimeInterval = 3.5f;
    self.imageViewPost.slideshowShouldCallScrollToDelegate = YES;
    self.imageViewPost.delegate = self;
    self.imageViewPost.dataSource = self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    
    return  self.imageArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

- (NSString *) captionForImageAtIndex:(NSUInteger)index inPager:(KIImagePager *)pager
{
    return @"";
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}



- (void)setupAudioPlayer:(NSString*)fileName
{
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.center;
    [self addSubview:spinner];
    [spinner setHidesWhenStopped:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [spinner startAnimating];

        NSURL *url = [NSURL URLWithString:fileName];
        //init the Player to get file properties to set the time labels
        [self.audioPlayer initPlayerWithURL:url];
        float duration = [self.audioPlayer getAudioDuration];

        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];

            //Your main thread code goes in here
            self.slider.maximumValue = duration;
            self.slider.minimumValue = 0.0;
            
            //init the current timedisplay and the labels. if a current time was stored
            //for this player then take it and update the time display
            
            self.timeElapsed.text = @"0:00";
            
            self.slider.continuous = YES;
            self.timeDuration.text = [NSString stringWithFormat:@"-%@",
                                      [self.audioPlayer timeFormat:duration]];
            //Your main thread code goes in here
            
            
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"Image_Play_Audio"]
                                       forState:UIControlStateNormal];

        });
    });
    
    
    
    
    
    
    
    
}

/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"Image_Pause_Audio"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer playAudio];
        self.isPaused = YES;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"Image_Play_Audio"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pauseAudio];
        self.isPaused = NO;
    }
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        //self.slider.value = [self.audioPlayer getCurrentAudioTime];
        [self.slider setValue:[self.audioPlayer getCurrentAudioTime] animated:YES];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
    
    self.timeDuration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
    //When resetted/ended reset the playButton
    if (!self.audioPlayer.audioPlayer.isPlaying) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"Image_Play_Audio"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer.audioPlayer stop];
        self.isPaused = FALSE;
        self.slider.value = 0.0;
        self.timeElapsed.text = @"0:00";
       // [self.audioPlayer.audioPlayer seekToTime:CMTimeMake(0, 1)];
        [self.audioPlayer setCurrentTime:0.0];
        self.slider.continuous = YES;
        self.timeDuration.text = [NSString stringWithFormat:@"-%@",
                                  [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
        
    }
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.audioPlayer setCurrentAudioTime:self.slider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scru

*/
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}


@end
