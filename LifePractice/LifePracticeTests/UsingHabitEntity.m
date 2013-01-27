//
//  UsingHabitEntity.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/25/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "UsingHabitEntity.h"

@implementation UsingHabitEntity

-(void)testNewHabitWithoutDescriptionIsProperlyInitialized
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
    STAssertTrue([[habit performances] count] == 0, @"Habit performances list should be nil");
}

-(void)testNewHabitWithDescriptionIsProperlyInitialized
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
    STAssertTrue([[habit performances] count] == 0, @"Habit performances list should be nil");
}

@end
