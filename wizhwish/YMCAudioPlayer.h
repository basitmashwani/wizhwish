//
//  YMCAudioPlayer.h
//  AudioPlayerTemplate
//
//  Created by ymc-thzi on 13.08.13.
//  Copyright (c) 2013 ymc-thzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YMCAudioPlayer : UIViewController

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (nonatomic, assign) float currentTime;

@property (nonatomic, assign) float duration;

// Public methods
- (void)initPlayerWithURL:(NSURL*)audioURL;
- (void)playAudio;
- (void)pauseAudio;
- (BOOL)isPlaying;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;
- (NSString*)timeFormat:(float)value;
- (float)getCurrentAudioTime;

@end
