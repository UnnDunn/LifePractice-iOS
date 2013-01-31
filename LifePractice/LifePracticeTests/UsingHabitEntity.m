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
    
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSDate *todayMidnight = [gregorian dateFromComponents:todayComponents];
    NSDateComponents *yesterdayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:yesterday];
    NSDate *yesterdayMidnight = [gregorian dateFromComponents:yesterdayComponents];

    STAssertTrue([habit addPerformance], @"Adding first performance for today should succeed"); // should succeed with performance date added now and reference date today
    STAssertFalseNoThrow([habit addPerformance:today], @"Adding second performance for today should fail"); // should fail because you can't have two performances on the same date
    STAssertTrue([habit addPerformance:yesterday], @"Adding performance for yesterday should succeed"); // should succeed with reference date yesterday and created date today
    STAssertFalseNoThrow([habit addPerformance:twoDaysAgo], @"Adding performance for two days ago should fail"); // should fail, you can't add a performance for more than 1 day ago
    STAssertFalseNoThrow([habit addPerformance:tomorrow], @"Adding performance for future date should fail"); // should fail, you can't add a performance for a date in the future
    
    NSArray *performances = [habit listPerformances];
    
    // performances should have two entries, one with date=now and reference date today, and one with date=now and reference date yesterday
    STAssertTrue([performances count] == 2, @"Performances array should have 2 entries.");
    
    // test first performance
    LPPerformance *performance1 = [performances objectAtIndex:0];
    NSTimeInterval performance1CreatedInterval = [[performance1 createdDate] timeIntervalSinceDate:today];
    STAssertTrue(abs((int)performance1CreatedInterval) < 1, @"Performance1 created date should be within 1 second of current time.");
    STAssertTrue([[performance1 referenceDate] isEqualToDate:yesterdayMidnight], @"Performance1 reference date should be midnight of today");
    
    // test second performance
    LPPerformance *performance2 = [performances objectAtIndex:1];
    NSTimeInterval performance2CreatedInterval = [[performance2 createdDate] timeIntervalSinceDate:today];
    STAssertTrue(abs((int)performance2CreatedInterval) < 1, @"Performance2 created date must be within 1 second of current date.");
    STAssertTrue([[performance2 referenceDate] isEqualToDate:todayMidnight], @"Performance2 created date should be midnight yesterday");
    
    
}

-(void)testDeletePerformanceMethodHandlesDatesCorrectly
{    
    LPHabit *habit = [[LPHabit alloc] initWithName:@"Test Habit"];
    
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24 * -1];
    NSDate *today = [NSDate date];
    NSDate *twoDaysAgo = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 48 * -1];
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24];
        
    [habit addPerformance:today];
    [habit addPerformance:yesterday];
    
    STAssertTrue([[habit listPerformances] count] == 2, @"Number of performances should be 2");
    
    STAssertTrue([habit deletePerformance:today], @"Deleting performance for today should succeed.");
    
    NSArray *performances = [habit listPerformances];
    STAssertTrue([performances count] == 1, @"Number of performances should be 1.");
    STAssertTrue([[[performances objectAtIndex:0] referenceDate] isEqualToDate:[DateUtilities getMidnightOfDate:yesterday]], @"Reference date for performance 0 should be midnight yesterday.");
    
    [habit addPerformance];
    STAssertTrue([[habit listPerformances] count] == 2, @"Number of performances should be 2");
    
    STAssertFalseNoThrow([habit deletePerformance:tomorrow], @"Deleting performance for tomorrow should fail, for obvious reasons");
    STAssertFalseNoThrow([habit deletePerformance:twoDaysAgo], @"Deleting performance for two days ago should fail");
    
    [habit deletePerformance:yesterday];
    performances = [habit listPerformances];
    STAssertTrue([performances count] == 1, @"Number of performances should be 1.");
    STAssertTrue([[[performances objectAtIndex:0] referenceDate] isEqualToDate:[DateUtilities getMidnightOfDate:today]], @"Reference date for performance 0 should be midnight today.");
}

@end
