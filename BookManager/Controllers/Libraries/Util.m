#import "Util.h"
#import "AddViewController.h"

@implementation Util

/**
 * NSDateをYear、Month、Dayに分ける処理
 * @param NSDate date
 * @return NSDateComponents calendarComponents
 */
+ (id)fromDateToDateComponents:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *calendarComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return calendarComponents;
}

/**
 * NSStringをDateFormatterを用いてNSDate型に変換するメソッド
 * @param NSString date
 * @return NSDate changedDate
 */
+ (id)fromStringToDate:(NSString *)date {
    NSMutableString *dateString = [[NSMutableString alloc] initWithString:date];
    [dateString deleteCharactersInRange:NSMakeRange(0, 4)];
    [dateString deleteCharactersInRange:NSMakeRange(dateString.length - 3, 3)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *changedDate = [formatter dateFromString:dateString];
    return changedDate;
}

@end

