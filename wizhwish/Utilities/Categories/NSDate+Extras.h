//
//  NSDate+Extras.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-24.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extras)

+ (NSString*)getMinutesDifferenceFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;

+ (NSDate*)getDateFromEpochValue:(NSTimeInterval)epoch;
@end
