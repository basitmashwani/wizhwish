//
//  UITextField+Extras.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-08.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "UITextField+Extras.h"

@implementation UITextField (Extras)

- (void)setTextFieldPlaceHolderColor:(UIColor*)color {
    
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat  blue = 0;
    CGFloat alpha = 0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    
    [self setValue:[UIColor colorWithRed:red green:green blue:blue alpha:alpha] forKeyPath:@"_placeholderLabel.textColor"];

}
@end
