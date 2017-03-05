//
//  WSetting.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-10-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSetting : NSObject

@property(nonatomic ,retain) NSString *frontVideoUrlPath;

@property(nonatomic ,retain) NSString *rearVideoUrlPath;

@property(nonatomic ,retain) NSString *audioUrlPath;


+ (WSetting*)getSharedSetting;


@end