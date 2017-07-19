//
//  UIView+Extras.m
//  RetainDirector
//
//  Created by Arslan Raza on 04/02/2015.
//
//

#import "UIView+Extras.h"
#define kANIM_TIME  0.5

@implementation UIView (Extras)

#pragma mark - UIVIEW FRAME SETTERS

- (void)setOrigin:(CGPoint)point {
    [self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
}
- (void)setSize:(CGSize)size {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
}

- (void)setFrameX:(CGFloat)newX {
    [self setOrigin:CGPointMake(newX, self.frame.origin.y)];
}
- (void)setFrameY:(CGFloat)newY {
    [self setOrigin:CGPointMake(self.frame.origin.x, newY)];
}
- (void)setFrameWidth:(CGFloat)width {
    [self setSize:CGSizeMake(width, self.frame.size.height)];
}
- (void)setFrameHeight:(CGFloat)height {
    [self setSize:CGSizeMake(self.frame.size.width, height)];
}

#pragma mark - UIVIEW SCALE SETTERS

- (void)setScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY);
}

- (void)setScale:(CGFloat)scale {
    [self setScaleX:scale scaleY:scale];
}

- (void)setScaleX:(CGFloat)scaleX {
    [self setScaleX:scaleX scaleY:1.0f];
}

- (void)setScaleY:(CGFloat)scaleY {
    [self setScaleX:1.0f scaleY:scaleY];
}

- (void)fadeInWithCompletion:(void (^)(BOOL finished))completion {
    
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 1.0f;
    } completion:completion];
    
}

- (void)fadeInWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    
    [UIView animateWithDuration:kANIM_TIME delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1.0f;
    } completion:completion];
    
}

- (void)fadeOutWithCompletion:(void (^)(BOOL finished))completion {
    
    [UIView animateWithDuration:kANIM_TIME animations:^{
        self.alpha = 0.0f;
    } completion:completion];
}

- (void)fadeOutWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    
    [UIView animateWithDuration:kANIM_TIME delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0.0f;
    } completion:completion];
    
}

- (void)fadeTo:(CGFloat)alpha withDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kANIM_TIME delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = alpha;
    } completion:completion];
}

- (void)fadeTo:(CGFloat)alpha completion:(void (^)(BOOL finished))completion {
    [self fadeTo:alpha withDelay:0.0 completion:completion];
}

- (void)setHiddenAnimated:(BOOL)hide {
    /*
    [UIView animateWithDuration:kANIM_TIME
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         if (hide) {
                             self.alpha = 0;
                         } else {
                             self.hidden = NO;
                             self.alpha = 1;
                         }
                     }
                     completion:^(BOOL b) {
                         
                         if (hide) {
                             self.hidden= YES;
                         }
                         
                     }
     ];
    */
    
    if(self.isHidden == hide)
        return;
    if(hide)
        self.alpha = 1;
    else {
        self.alpha = 0;
        [self setHidden:NO];
    }
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:kANIM_TIME animations:^{
        if (hide)
            weakSelf.alpha = 0;
        else
            weakSelf.alpha = 1;
    } completion:^(BOOL finished) {
        if(finished)
            [weakSelf setHidden:hide];
    }];
}


- (void)setRoundCornersForSpecificSidesOnTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0; //holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }
        
        UIView *roundedView = self;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
    }
    
}

- (void)setRoundCornersForLeftSideWithRadius:(float)radius {
    [self setRoundCornersForSpecificSidesOnTopLeft:YES topRight:NO bottomLeft:YES bottomRight:NO radius:radius];
}

- (void)setRoundCornersForRightSideWithRadius:(float)radius {
    [self setRoundCornersForSpecificSidesOnTopLeft:NO topRight:YES bottomLeft:NO bottomRight:YES radius:radius];
}

- (void)setRoundCornersForTopSideWithRadius:(float)radius {
    [self setRoundCornersForSpecificSidesOnTopLeft:YES topRight:YES bottomLeft:NO bottomRight:NO radius:radius];
}

- (void)setRoundCornersForBottomSideWithRadius:(float)radius {
    [self setRoundCornersForSpecificSidesOnTopLeft:NO topRight:NO bottomLeft:YES bottomRight:YES radius:radius];
}

- (void)setRoundCornersWithRadius:(float)radius {
    [self.layer setCornerRadius:radius];
}

- (void)setRoundCornersAsCircle {
  
    [self setRoundCornersForSpecificSidesOnTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:self.frame.size.width/2];
    //float minValue = MIN(self.frame.size.width, self.frame.size.height);
    //[self.layer setCornerRadius:minValue/2];
}

- (void)setBorderWidth:(CGFloat)radius withColor:(UIColor*)color {
    self.layer.borderWidth = radius;
    self.layer.borderColor = color.CGColor;
}

- (UIImage *)getScreenshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}



- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return cropped;
}





- (void)addShadow {
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(2, 4)];
    [self.layer setShadowOpacity:0.3];
}


- (UIView *)getViewHexagonShape {
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.frame = self.bounds;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat hPadding = width * 1 / 8 / 2;
    
    UIGraphicsBeginImageContext(self.frame.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width - hPadding, height / 4)];
    [path addLineToPoint:CGPointMake(width - hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2, height)];
    [path addLineToPoint:CGPointMake(hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(hPadding, height / 4)];
    [path closePath];
    [path closePath];
    [path fill];
    [path stroke];
    
    maskLayer.path = path.CGPath;
    UIGraphicsEndImageContext();
    
    self.layer.mask = maskLayer;
    return self;
  //  img_profilepic.image=[UIImage imageNamed:@"profile_picture"];

}



@end
