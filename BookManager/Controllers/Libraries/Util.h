//
//  Util.h
//  BookManager
//
//  Created by 小堀輝 on 2016/09/02.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (id)fromDateToDateComponents:(NSDate *)date;
+ (id)fromStringToDate:(NSString *)date;
@end
