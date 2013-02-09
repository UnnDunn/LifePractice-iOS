//
//  DateUtilities.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/30/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "DateUtilities.h"

@implementation DateUtilities
+(NSDate *)dateFromParameters:(NSUInteger)year withMonth:(NSUInteger)month withDate:(NSUInteger)date
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *targetReferenceDateComponents = [[NSDateComponents alloc] init];
    [targetReferenceDateComponents setYear:2012];
    [targetReferenceDateComponents setMonth:2];
    [targetReferenceDateComponents setDay:5];
    NSDate *result = [currentCalendar dateFromComponents:targetReferenceDateComponents];
    return result;
    
}

+(NSDate *)dateFromParameters:(NSUInteger)year withMonth:(NSUInteger)month withDate:(NSUInteger)date withHour:(NSUInteger)hour withMinute:(NSUInteger)minute withSecond:(NSUInteger)second
{
    NSDate *initialDate = [self dateFromParameters:year withMonth:month withDate:date];
    NSDateComponents *targetDateComponents = [[NSDateComponents alloc] init];
    [targetDateComponents setHour:hour];
    [targetDateComponents setMinute:minute];
    [targetDateComponents setSecond:second];
    NSDate *result = [[NSCalendar currentCalendar] dateByAddingComponents:targetDateComponents toDate:initialDate options:0];
    
    return result;
}

+(NSDate *)getMidnightOfDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSDate *result = [gregorian dateFromComponents:dateComponents];
    return result;
}
@end
