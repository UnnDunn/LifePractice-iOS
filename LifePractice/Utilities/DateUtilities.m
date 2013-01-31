//
//  DateUtilities.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/30/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "DateUtilities.h"

@implementation DateUtilities
+(NSDate *)getMidnightOfDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSDate *result = [gregorian dateFromComponents:dateComponents];
    return result;
}
@end
