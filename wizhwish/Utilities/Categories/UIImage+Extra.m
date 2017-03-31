//
//  UIImage+Extra.m
//  Yatter
//
//  Created by Syed Abdul Basit on 2016-03-21.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "UIImage+Extra.h"


@implementation UIImage (Extra)

- (instancetype)init {
    
    self = [super init];
    
   

    return self;
}

- (UIImage *)imageWithOverlayColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    if (&UIGraphicsBeginImageContextWithOptions) {
        CGFloat imageScale = 1.0f;
        if ([self respondsToSelector:@selector(scale)])  // The scale property is new with iOS4.
            imageScale = self.scale;
        UIGraphicsBeginImageContextWithOptions(self.size, NO, imageScale);
    }
    
    [self drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    
    CGFloat scale = [fgImage scale];
    if (scale > 1.5)
        UIGraphicsBeginImageContextWithOptions(fgImage.size, NO, scale);
    else {
        UIGraphicsBeginImageContext(fgImage.size);
    }
    [fgImage drawInRect:CGRectMake(0, 0, fgImage.size.width, fgImage.size.height)];
    [bgImage drawInRect:CGRectMake(0, 0, fgImage.size.width, fgImage.size.height)];

    UIImage* screenshot = UIGraphicsGetImageFromCurrentImageContext();
   // UIGraphicsEndImageContext();
    //UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
   // [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
   // [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
   // UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

+ (UIImage*)image:(UIImage*)image withText:(NSString*)text atPoint:(CGPoint)point
{
    CGRect rect = [[UIScreen mainScreen] bounds];

    point = CGPointMake(point.x, point.y+47);
    //CGRect rect = CGRectMake(0, 0, 320, 369);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [image drawInRect:rect];
    
    //NSDictionary *attributes = @{NSFontAttributeName           : [UIFont fontWithName:@"MicrosoftPhagsPa" size:23] ,
      //                           NSStrokeWidthAttributeName    : @(0),
        //                         NSStrokeColorAttributeName    : [UIColor whiteColor]};
    
    UIFont* font = [UIFont fontWithName:@"MicrosoftPhagsPa" size:23];
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [text drawAtPoint:point withAttributes:attributes];
    [[UIColor whiteColor] set];

    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//+ (UIImage*)drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point {
//
//    
//    UIFont *font = [UIFont fontWithName:@"MicrosoftPhagsPa" size:23];
//    UIGraphicsBeginImageContext(image.size);
//    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
//    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
//    [[UIColor whiteColor] set];
//    [text drawInRect:CGRectIntegral(rect) withFont:font];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

+ (UIImage *)drawToImage:(UIImage *)img withText:(NSString *)text withFrame:(CGRect)textRect
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    // create a context according to image size
    UIGraphicsBeginImageContext(rect.size);
    
    // draw image
    [img drawInRect:rect];
    
    
    UIFont* font = [UIFont fontWithName:@"MicrosoftPhagsPa" size:25];
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    textRect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width , textRect.size.height);
    
    /// draw text
    [text drawInRect:textRect withAttributes:attributes];
    
    // get as image
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
    
    
    + (UIImage*)getFilterImageWithIndex:(NSInteger)filterIndex withImage:(UIImage*)image {
        
       NSArray  *filteredArray = [[NSArray alloc] initWithObjects:@"No Filter" ,@"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess", @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer" , nil];
        
        if (filterIndex == 0) {
            
            return image;
        }
        
        
        
        // Create and apply filter
        // 1 - create source image
        
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        CIImage *ciImage = [CIImage imageWithData:data];
        
        // 2 - create filter using name
        
        CIFilter *filter = [CIFilter filterWithName:filteredArray[filterIndex]];
        [filter setDefaults];
        
        // 3 - set source image
        [filter setValue:ciImage forKey:kCIInputImageKey];
        
        // 4 - create core image context
        // CIContext *context = [[CIContext alloc] init];
        // 5 - output filtered image as cgImage with dimension.
        //CIImage *filterImage = (CIImage*)[context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
        
        CIImage *filteredImageData = [filter valueForKey:@"outputImage"];
        
        CIContext *context = [[CIContext alloc] init];
        CGImageRef cgiimg = [context createCGImage:filteredImageData fromRect:filteredImageData.extent];
        UIImageOrientation originalOrientation = image.imageOrientation;
        CGFloat originalScale = image.scale;
        
    
        return [UIImage imageWithCGImage: cgiimg scale:originalScale orientation:originalOrientation];

        
        // 6 - convert filtered CGImage to UIImage
        //let filteredImage = UIImage(cgImage: outputCGImage!)
        return  [[UIImage alloc] initWithCIImage:filteredImageData];
        
        // if No filter selected then apply default image and return.
        
        
    }


@end
