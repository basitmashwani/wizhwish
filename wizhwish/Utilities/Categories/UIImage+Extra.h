//
//  UIImage+Extra.h
//  Yatter
//
//  Created by Syed Abdul Basit on 2016-03-21.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extra)

- (UIImage *)imageWithOverlayColor:(UIColor *)color;
+ (UIImage*)getMissedCallImage;
+ (UIImage*)getRecievedCallImage;
+ (UIImage*)getDialCallImage;

@end
