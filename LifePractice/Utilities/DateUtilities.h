//
//  DateUtilities.h
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/30/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtilities : NSObject
+(NSDate *)dateFromParameters:(NSUInteger)year withMonth:(NSUInteger)month withDate:(NSUInteger)date;
+(NSDate *)dateFromParameters:(NSUInteger)year withMonth:(NSUInteger)month withDate:(NSUInteger)date withHour:(NSUInteger)hour withMinute:(NSUInteger)minute withSecond:(NSUInteger)second;
+(NSDate *)getMidnightOfDate:(NSDate *)date;
@end
