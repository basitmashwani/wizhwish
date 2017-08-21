//
//  SCustomProgressView.h
//  WallpaperApp
//
//  Created by Syed Abdul Basit on 2016-06-14.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCustomProgressView : UIView<CAAnimationDelegate>


@property(nonatomic ,retain) IBOutlet  CAShapeLayer *circle;

- (void)animateViewWithduration:(NSTimeInterval)duration initialValue:(NSTimeInterval)value;

- (void)pauseAnimation;

- (void)resumeAnimation;

- (void)removeAnimation;

@end
