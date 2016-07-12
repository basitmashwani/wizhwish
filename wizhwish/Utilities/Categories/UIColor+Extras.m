//
//  UIColor+Extras.m
//  ZemCar
//
//  Created by Arslan Raza on 15/05/2015.
//  Copyright (c) 2015 Arslan Raza. All rights reserved.
//

#import "UIColor+Extras.h"

@implementation UIColor (Extras)


+ (UIColor*)blackAlertColor {
    return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
}


+ (UIColor*)navigationBarColor {
    return [UIColor colorWithRed:29/255.0 green:127/255.0 blue:127/255.0 alpha:1];
}


+ (UIColor*)getTabBarColor {
    return [UIColor colorWithRed:34/255.0 green:143/255.0 blue:143/255.0 alpha:1];
}

+ (UIColor*)getLightGrayColor {
    return [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
}


+ (UIColor*)getLightGrayButtonColor {
    return [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
}




//+ (UIColor*)zemCarBgColor {
//    return [UIColor colorWithRed:239/255.0 green:249/255.0 blue:247/255.0 alpha:1];
//}
//
//+ (UIColor*)zemCarGreenColor {
//    return [UIColor colorWithRed:55/255.0 green:179/255.0 blue:74/255.0 alpha:1];
//}

@end
