//
//  NSDate+Extras.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-24.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "NSDate+Extras.h"

@implementation NSDate (Extras)

+ (NSString *)getMinitesDifferenceFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSCalendar *calender = [NSCalendar currentCalendar];
   
    NSDateComponents *components = [calender components:NSCalendarUnitMinute fromDate:fromDate toDate:toDate options:0];
    NSInteger diff = components.minute;
    NSString *stringDate = nil;
    if (diff >1) {
        stringDate = [NSString stringWithFormat:@"%ld minute ago",diff];
        
    }
    else {
    stringDate = [NSString stringWithFormat:@"%ld minutes ago",diff];
    }
    
    if (diff>60) {
        diff = diff/60;
        
        if (diff >1) {
            
            stringDate = [NSString stringWithFormat:@"%ld hour ago",diff];

        }
        else {
            stringDate = [NSString stringWithFormat:@"%ld hours ago",diff];

        }
    }
    else if (diff>1440) {
        diff = diff/1440;
        
        if (diff >1) {
            
            stringDate = [NSString stringWithFormat:@"%ld days ago",diff];
            
        }
        else {
            stringDate = [NSString stringWithFormat:@"%ld day ago",diff];
            
        }
    }
    
    return stringDate;
   // NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
}
@end
