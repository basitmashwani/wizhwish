//
//  NSDate+Extras.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-24.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "NSDate+Extras.h"

@implementation NSDate (Extras)

+ (NSString *)getMinutesDifferenceFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSCalendar *calender = [NSCalendar currentCalendar];
   
    NSDateComponents *components = [calender components:NSCalendarUnitMinute fromDate:fromDate toDate:toDate options:0];
    NSInteger diff = components.minute;
    NSString *stringDate = nil;
    if (diff <60) {
        stringDate = [NSString stringWithFormat:@"%ld minutes ago",(long)diff];
        
        if (diff == 1) {
            
                stringDate = [NSString stringWithFormat:@"%ld minute ago",(long)diff];
            }

        
    }
    
   else if (diff<1440) {
       
       diff = diff/60;
        
        if (diff >1) {
            
            stringDate = [NSString stringWithFormat:@"%ld hours ago",(long)diff];

        }
        else {
            stringDate = [NSString stringWithFormat:@"%ld hour ago",(long)diff];

        }
    }
 else  if (diff>1440) {
        diff = diff/1440;
        
        if (diff >1) {
            
            stringDate = [NSString stringWithFormat:@"%ld days ago",(long)diff];
            
        }
        else {
            stringDate = [NSString stringWithFormat:@"%ld day ago",(long)diff];
            
        }
    }
    
    return stringDate;
   // NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
}

+ (NSDate*)getDateFromEpochValue:(NSTimeInterval)epoch {
    //    NSString *dateString = [[NSDate dateWithTimeIntervalSince1970:epoch] description];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:epoch]; //[NSDate dateWithTimeIntervalSinceReferenceDate:118800];
    //
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //  [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:5]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm aa"];
  //  [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter dateFromString:formattedDateString];
    //
    //    NSLog(@"formattedDateString for locale %@: %@", [[dateFormatter locale] localeIdentifier], formattedDateString);
    //
    return date;
}

@end
