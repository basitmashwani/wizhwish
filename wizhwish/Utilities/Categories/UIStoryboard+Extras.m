//
//  UIStoryboard+Extras.m
//  Yatter
//
//  Created by Syed Abdul Basit on 2016-03-21.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "UIStoryboard+Extras.h"

@implementation UIStoryboard (Extras)

+ (UIStoryboard*)getLoginStoryBoard {
   
   return [UIStoryboard storyboardWithName:@"Login" bundle:nil];
}

+ (UIStoryboard*)getHomeStoryBoard {
    
    return [UIStoryboard storyboardWithName:@"home" bundle:nil];
}

+ (UIStoryboard*)getProfileStoryBoard {
    
    return [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
}


+ (UIStoryboard*)getChatStoryBoard {
    
    return [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
}
+ (UIStoryboard*)getMediaStoryBoard {
    
    return [UIStoryboard storyboardWithName:@"Media" bundle:nil];
}

+ (UIStoryboard*)getWhizStoryBoard {
    
    return [UIStoryboard storyboardWithName:@"whiz" bundle:nil];
}

@end
