//
//  CommonVideoView.m
//  Example
//
//  Created by stoncle on 1/6/16.
//  Copyright © 2016 stoncle. All rights reserved.
//

#import "CommonVideoView.h"
#import "ZOWVideoView.h"
#import "ZOWVideoIndicator.h"
#import "ZOWVideoMuteIndicator.h"
#import "ZOWVideoPlayerLayerContainerView.h"


@interface CommonVideoView()

@property(nonatomic ,assign) BOOL isPause;
@property (nonatomic ,retain) ZOWVideoIndicator *videoIndicator;
@property (nonatomic ,retain) ZOWVideoMuteIndicator *muteIndicator;
@property (nonatomic ,retain) UIProgressView *progressView;


@property (nonatomic ,retain) UIButton *retryButton;

@end
@implementation CommonVideoView
- (instancetype)initWithFrame:(CGRect)frame {
    
self =  [super initWithFrame:frame];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    
    self.videoPlayer.delegate = self;
    
    [self addGestureRecognizer:singleTapGesture];

    return self;
    
}

#pragma mark - PUBLIC
- (void)playVideoWithURL:(NSURL *)url
{
    if(!url)
    {
        NSLog(@"stoncle debug : video url is nil.");
        return;
    }
    self.hidden = NO;
    
    [self initIndicator];
    [self initMuteIndicator];
    [self initProgressBar];
    
    [self showIndicator];
    [super playVideoWithURL:url];
}

- (void)stopVideoPlay
{
    [self hideIndicator];
    [self hidesRetryButton];
    self.hidden = YES;
    [super stopVideoPlay];
}

#pragma mark - PRIVATE

- (void)initIndicator
{
    if(!_videoIndicator)
    {
        _videoIndicator = [[ZOWVideoIndicator alloc] initWithFrame:CGRectMake(self.bounds.size.width-32-4, 4, 32, 32)];
        [self addSubview:_videoIndicator];
    }
}

- (void)initMuteIndicator
{
    if(!_muteIndicator)
    {
        _muteIndicator = [[ZOWVideoMuteIndicator alloc] initWithFrame:CGRectMake(11, self.bounds.size.height-32-11, 32, 32)];
    }
}

- (void)initProgressBar
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 10, 32, 32)];
        _progressView.progressViewStyle = UIProgressViewStyleBar;
        _progressView.backgroundColor = [UIColor redColor];
        [self addSubview:_progressView];
    }
}

#pragma mark - Overide
- (void)initVideoLayerContainerView
{
    if(!self.videoLayerContainerView)
    {
        self.videoLayerContainerView = [[ZOWVideoPlayerLayerContainerView alloc] initWithFrame:self.bounds];
        self.videoLayerContainerView.layer.opacity = 0;
        [self insertSubview:self.videoLayerContainerView atIndex:0];
    }
}

#pragma mark - ZOWVideoPlayerDelegate
- (void)videoPlayerDidStartPlayVideo:(ZOWVideoPlayer *)player
{
    [player setMute:YES];
    [self hidesRetryButton];
}

- (void)videoPlayerDidStartStreamVideo:(ZOWVideoPlayer *)player
{
    [self hideIndicator];
    [self hidesRetryButton];
    [self animateVideoLayer];
}

- (void)videoPlayerDidStuck:(ZOWVideoPlayer *)player
{
    [self showIndicator];
}

- (void)videoPlayerDidResume:(ZOWVideoPlayer *)player
{
    [self hideIndicator];
    [self hidesRetryButton];
}

- (void)videoPlayerDidEndPlayVideo:(ZOWVideoPlayer *)player
{
    [self hideIndicator];
    [self hidesRetryButton];
}

- (void)videoPlayerDidFailedPlayVideo:(ZOWVideoPlayer *)player
{
    
}

- (void)videoPlayer:(ZOWVideoPlayer *)player didMuted:(BOOL)mute
{
    if(!_muteIndicator.superview)
    {
        [self addSubview:_muteIndicator];
    }
    else
    {
        
    }
    
    _muteIndicator.mute = mute;
}

#pragma mark Animation
- (void)animateVideoLayer
{
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ani.fromValue = [NSNumber numberWithFloat:0.0];
    ani.toValue = [NSNumber numberWithFloat:1.0];
    ani.duration = 0.5;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    [self.videoLayerContainerView.layer removeAnimationForKey:@"fadeAnimation"];
    [self.videoLayerContainerView.layer addAnimation:ani forKey:@"fadeAnimation"];
}

#pragma mark Indicator
- (void)hideIndicator
{
    if(_videoIndicator)
    {
        _videoIndicator.hidden = YES;
        [_videoIndicator stopAnimating];
    }
}

- (void)showIndicator
{
    if(_videoIndicator)
    {
        _videoIndicator.hidden = NO;
        [_videoIndicator startAnimating];
    }
}

#pragma mark Retry
- (void)initRetryButton
{
    if(!_retryButton)
    {
        _retryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _retryButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [_retryButton setImage:[[UIImage imageNamed:@"refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _retryButton.tintColor = [UIColor whiteColor];
        _retryButton.alpha = 0.7;
        [_retryButton addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showsRetryButton
{
    [self initRetryButton];
    [self addSubview:_retryButton];
}

- (void)hidesRetryButton
{
    if(_retryButton && _retryButton.superview)
    {
        [_retryButton removeFromSuperview];
    }
}

- (void)retry:(id)sender
{
    if(!self.playingURL)
    {
        NSLog(@"stoncle debug : nothing to retry");
        return;
    }
    [self playVideoWithURL:self.playingURL];
    [self hidesRetryButton];
}

#pragma mark Gesture
- (void)addTapGesture
{
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    [self addGestureRecognizer:singleTapGesture];
    [self addGestureRecognizer:doubleTapGesture];
}

- (void)singleTap:(id)sender
{
    NSLog(@"single tap on player view");
    if(self.videoPlayer)
    {
        if(self.videoPlayer.mute)
        {
            self.videoPlayer.mute = NO;
        }
        else
        {
            self.videoPlayer.mute = YES;
        }
        
        if (self.isPause) {
            [self resume];
            self.isPause = NO;
        }
        else {
            [self pause];
            self.isPause = YES;
        }
    }
    else
    {
        NSLog(@"stoncle debug : video player nil.");
    }
    
//    if([self.delegate respondsToSelector:@selector(videoViewDidSingleTap:)])
//    {
//        [self.delegate videoViewDidSingleTap:self];
//    }
}

- (void)doubleTap:(id)sender
{
    NSLog(@"double tap on player view");
//    if([self.delegate respondsToSelector:@selector(videoViewDidDoubleTap:)])
//    {
//        [self.delegate videoViewDidDoubleTap:self];
//    }
}

#pragma mark ZOWVideoPlayerProtocol
- (void)notifyLoadingVideoSuccessed
{
    [super notifyLoadingVideoSuccessed];
}

- (void)notifyLoadingVideoFailed
{
    [self hideIndicator];
    [self showsRetryButton];
    [super notifyLoadingVideoFailed];
}

- (void)notifyCancelLoadingVideo
{
    [super notifyCancelLoadingVideo];
}



@end
