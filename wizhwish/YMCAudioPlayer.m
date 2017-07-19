//
//  YMCAudioPlayer.m
//  AudioPlayerTemplate
//
//  Created by ymc-thzi on 13.08.13.
//  Copyright (c) 2013 ymc-thzi. All rights reserved.
//

#import "YMCAudioPlayer.h"

@implementation YMCAudioPlayer

/*
 * Init the Player with Filename and FileExtension
 */
- (void)initPlayerWithURL:(NSURL*)audioURL
{
    

        //AVAsset *asset = [AVAsset assetWithURL:audioURL];
        //AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    NSData *data = [NSData dataWithContentsOfURL:audioURL];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
        self.currentTime = [self getCurrentAudioTime];
        self.duration = [self getAudioDuration];
    
    //self.duration = [self getAudioDuration];
    //self.currentTime = [self getCurrentAudioTime];
    
}

/*
 * Simply fire the play Event
 */
- (void)playAudio {
    [self.audioPlayer play];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [self.audioPlayer pause];
}

/*
 * get playingState
 */
- (BOOL)isPlaying {
   
 //   if (self.audioPlayer.status == AVPlayerTimeControlStatusPlaying) {
  //
      //  return YES;
    //}
    return NO;
    // return [self.audioPlayer ispla];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
- (void)setCurrentAudioTime:(float)value {
    
    CMTime newTime = CMTimeMakeWithSeconds(value, 1);
  //  [self.audioPlayer seekToTime:newTime];
    [self.audioPlayer setCurrentTime:value];
}

/*
 * Get the time where audio is playing right now
 */
- (float)getCurrentAudioTime {
    NSTimeInterval currentTime =     [self.audioPlayer currentTime];
//CMTimeGetSeconds(self.audioPlayer.currentTime);
    return currentTime;
}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration {
    //CMTime duration = //self.audioPlayer.currentItem.asset.duration;
    float durationSeconds = self.audioPlayer.duration;//CMTimeGetSeconds(duration);
    

    return durationSeconds;//self.audioPlayer.currentItem.asset.duration.epoch;
}


@end
