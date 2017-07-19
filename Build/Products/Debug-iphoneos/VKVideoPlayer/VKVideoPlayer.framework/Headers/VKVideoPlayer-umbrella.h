#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "VKVideoPlayer.h"
#import "VKVideoPlayerAirPlay.h"
#import "VKVideoPlayerCaption.h"
#import "VKVideoPlayerCaptionSRT.h"
#import "VKVideoPlayerConfig.h"
#import "VKVideoPlayerExternalMonitor.h"
#import "VKVideoPlayerLayerView.h"
#import "VKVideoPlayerSettingsManager.h"
#import "VKVideoPlayerTrack.h"
#import "VKVideoPlayerView.h"
#import "VKVideoPlayerViewController.h"

FOUNDATION_EXPORT double VKVideoPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char VKVideoPlayerVersionString[];

