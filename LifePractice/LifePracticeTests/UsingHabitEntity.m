//
//  UsingHabitEntity.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/25/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "UsingHabitEntity.h"

@implementation UsingHabitEntity

-(void)testNewHabitIsProperlyInitialized
{
    LPHabit *habit = [[LPHabit alloc] init];
    STAssertTrue([[habit habitName] isEqualToString: NSLocalizedString(@"Habit_Name_Default", "The default name for a new habit, e.g. 'Do Something'")], @"Habit name should be the default.");
    STAssertTrue([[habit habitDescription] length] == 0, @"Habit Description should be nil.");
    NSTimeInterval dateCreatedInterval = [[habit createdDate] timeIntervalSinceNow];
    STAssertTrue(abs((int)dateCreatedInterval) < 1, @"Habit Created date not should be set to within 1 second of current time.");
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *hourComponent = [gregorian components:(NSHourCalendarUnit) fromDate:today];
    NSUInteger currentHour = [hourComponent hour];
    STAssertTrue([habit timeOfDay].startHour <= currentHour, @"Habit time of day should start before current time of day");
    STAssertTrue([habit timeOfDay].endHour > currentHour, @"Habit time of day should end after current time of day");
    STAssertTrue([habit skippedDays].None == 1, @"Habit Skipped Days should be nil.");
    STAssertTrue([[habit listPerformances] count] == 0, @"Habit performances list should be nil");
}

-(void)testNewHabitWithNameIsProperlyInitialized
{
    NSString *initalizationString = @"Wake up early";
    LPHabit *habit = [[LPHabit alloc] initWithName:initalizationString];
    STAssertTrue([[habit habitName] isEqualToString:initalizationString], @"Habit name should be equal to the initalization string");
    STAssertTrue([[habit habitDescription] length] == 0, @"Habit Description should be nil.");
    NSTimeInterval dateCreatedInterval = [[habit createdDate] timeIntervalSinceNow];
    STAssertTrue(abs((int)dateCreatedInterval) < 1, @"Habit Created date not should be set to within 1 second of current time.");
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *hourComponent = [gregorian components:(NSHourCalendarUnit) fromDate:today];
    NSUInteger currentHour = [hourComponent hour];
    STAssertTrue([habit timeOfDay].startHour <= currentHour, @"Habit time of day should start before current time of day");
    STAssertTrue([habit timeOfDay].endHour > currentHour, @"Habit time of day should end after current time of day");
    STAssertTrue([habit skippedDays].None == 1, @"Habit Skipped Days should be nil.");
    STAssertTrue([[habit listPerformances] count] == 0, @"Habit performances list should be nil");
}

-(void)testAddPerformanceMethodHandlesDatesCorrectly
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    LPHabit *habit = [[LPHabit alloc] initWithName:@"Test Habit"];
    
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24 * -1];
    NSDate *today = [NSDate date];
    NSDate *twoDaysAgo = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 48 * -1];
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24];
    
    NSDateComponents *todayMidnight = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSDateComponents *yesterdayMidnight = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:yesterday];

    [habit addPerformance]; // should succeed with performance date added now and reference date today
    [habit addPerformance]; // should fail because you can't have two performances on the same date
    [habit addPerformance:yesterday]; // should succeed with reference date yesterday and created date today
    [habit addPerformance:twoDaysAgo]; // should fail, you can't add a performance for more than 1 day ago
    [habit addPerformance:tomorrow]; // should fail, you can't add a performance for a date in the future
    
    NSArray *performances = [habit listPerformances];
    
    // performances should have two entries, one with date=now and reference date today, and one with date=now and reference date yesterday
    STAssertTrue([performances count] == 2, @"Performances array should have 2 entries.");
    
    // test first performance
    LPPerformance *performance1 = [performances objectAtIndex:0];
    NSTimeInterval performance1CreatedInterval = [[performance1 createdDate] timeIntervalSinceNow];
    STAssertTrue(abs((int)performance1CreatedInterval) < 1, @"Performance1 created date should be within 1 second of current time.");
    STAssertEquals([performance1 referenceDate], [todayMidnight date], @"Performance1 reference date should be midnight of today");
    
    // test second performance
    LPPerformance *performance2 = [performances objectAtIndex:1];
    NSTimeInterval performance2CreatedInterval = [[performance2 createdDate] timeIntervalSinceNow];
    STAssertTrue(abs((int)performance2CreatedInterval) < 1, @"Performance2 created date must be within 1 second of current date.");
    STAssertEquals([performance2 referenceDate], [yesterdayMidnight date], @"Performance2 created date should be midnight yesterday");
    
    
}

@end
