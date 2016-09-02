//
//  Util.m
//  BookManager
//
//  Created by 小堀輝 on 2016/09/02.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (id)fromDateToDateComponents:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *calendarComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return calendarComponents;
}

+ (id)fromStringToDate:(NSString *)date {
    NSMutableString *dateString = [[NSMutableString alloc] initWithString:date];
    [dateString deleteCharactersInRange:NSMakeRange(0,4)];
    [dateString deleteCharactersInRange:NSMakeRange(dateString.length - 3,3)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *changedDate = [formatter dateFromString:dateString];
    return changedDate;
}


@end

