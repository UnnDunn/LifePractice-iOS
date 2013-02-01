//
//  UsingDateUtilities.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/31/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "UsingDateUtilities.h"

@implementation UsingDateUtilities

-(void)testGetMidnightForDateReturnsProperDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSUInteger unitflags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *inputDate = [NSDate date];
    NSDate *resultDate = [DateUtilities getMidnightOfDate:inputDate];
    
    NSDateComponents *inputComponents = [currentCalendar components:unitflags fromDate:inputDate];
    NSDateComponents *resultComponents = [currentCalendar components:unitflags fromDate:resultDate];
    
    STAssertTrue([inputComponents year] == [resultComponents year], @"Year component of input and result should be equal");
    STAssertTrue([inputComponents month] == [resultComponents month], @"Month component of input and result should be equal");
    STAssertTrue([inputComponents day] == [resultComponents day], @"Day component of input and result should be equal");
    STAssertTrue([resultComponents hour] == 0, @"Hour component of result should be 0");
    STAssertTrue([resultComponents minute] == 0, @"Minute component of result should be 0");
    STAssertTrue([resultComponents second] == 0, @"Second component of result should be 0");
}
@end
