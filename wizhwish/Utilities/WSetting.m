//
//  WSetting.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-10-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WSetting.h"

static WSetting *_sharedInstance = nil;
@implementation WSetting

+ (WSetting *)getSharedSetting {
    
    if (!_sharedInstance) {
        _sharedInstance = [[WSetting alloc] init];
    }
    return _sharedInstance;
}

+ (void)distroySetting {
 
    _sharedInstance = nil;
}


@end
