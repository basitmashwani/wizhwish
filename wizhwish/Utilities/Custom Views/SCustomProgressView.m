//
//  SCustomProgressView.m
//  WallpaperApp
//
//  Created by Syed Abdul Basit on 2016-06-14.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "SCustomProgressView.h"

@implementation SCustomProgressView

- (void)animateViewWithduration:(NSTimeInterval)duration initialValue:(NSTimeInterval)value {
    
    NSLog(@"%f:%f",value,duration);
    [self animateCircularwithDuration:duration initialValue:value];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}


- (void)animateCircularwithDuration:(NSTimeInterval)duration initialValue:(NSTimeInterval)value {
    
    // Set up the shape of the circle
    int radius = self.frame.size.width/2;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
   // int axis = radius+3;
    circle.position = CGPointMake(0.9, 0.8); //CGPointMake(CGRectGetMidX(self.frame)-axis,
                      //           CGRectGetMidY(self.frame)-axis);
   // NSLog(@"position %@",NSStringFromCGPoint(circle.position));
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 2;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration            = duration; // "animate over 10 seconds or so.."
   // drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    NSString *toValueString = [NSString stringWithFormat:@"%.1f",value];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *toValue = [formatter numberFromString:toValueString];
    
    drawAnimation.delegate = self;
    NSLog(@"to value %@",toValueString);
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = toValue;
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
   // drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag) {
        
     //   [self animateViewWithduration:1.0 initialValue:1.0];
    }
}


@end
