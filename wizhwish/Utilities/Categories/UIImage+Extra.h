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

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

//+ (UIImage*)drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point;


+(UIImage*) drawImage:(UIImage*)fgImage inImage:(UIImage*)bgImage atPoint:(CGPoint)point;

+ (UIImage *)drawToImage:(UIImage *)img withText:(NSString *)text withFrame:(CGRect)textRec;

+ (UIImage*)image:(UIImage*)image withText:(NSString*)text atPoint:(CGPoint)point;


@end
