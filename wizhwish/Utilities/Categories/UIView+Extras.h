//
//  UIView+Extras.h
//  RetainDirector
//
//  Created by Arslan Raza on 04/02/2015.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Extras)

// FRAME SETTERS
- (void)setOrigin:(CGPoint)point;
- (void)setSize:(CGSize)size;
- (void)setFrameX:(CGFloat)newX;
- (void)setFrameY:(CGFloat)newY;
- (void)setFrameWidth:(CGFloat)width;
- (void)setFrameHeight:(CGFloat)height;

// SCALE SETTERS
- (void)setScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY;
- (void)setScale:(CGFloat)scale;
- (void)setScaleX:(CGFloat)scaleX;
- (void)setScaleY:(CGFloat)scaleY;


- (void)fadeInWithCompletion:(void (^)(BOOL finished))completion;
- (void)fadeInWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)fadeOutWithCompletion:(void (^)(BOOL finished))completion;
- (void)fadeOutWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)fadeTo:(CGFloat)alpha withDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)fadeTo:(CGFloat)alpha completion:(void (^)(BOOL finished))completion;
- (void)setHiddenAnimated:(BOOL)hide;
- (void)setRoundCornersForSpecificSidesOnTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius;
- (void)setRoundCornersForLeftSideWithRadius:(float)radius;
- (void)setRoundCornersForRightSideWithRadius:(float)radius;
- (void)setRoundCornersForTopSideWithRadius:(float)radius;
- (void)setRoundCornersForBottomSideWithRadius:(float)radius;
- (void)setRoundCornersWithRadius:(float)radius;
- (void)setRoundCornersAsCircle;
- (void)setBorderWidth:(CGFloat)radius withColor:(UIColor*)color;
- (UIImage *)getScreenshotImage;
/**
 Add shadow to the View bottom
 */
- (void)addShadow;

@end
