//
//  UsingHabitEntity.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/25/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "UsingHabitEntity.h"
#import "../LifePracticeCore/Entities/LPHabit.h"

@implementation UsingHabitEntity

-(void)testNewHabitWithoutDescriptionIsProperlyInitialized
{
    LPHabit *habit = [[LPHabit alloc] init];
    STAssertTrue([[habit name] isEqualToString: NSLocalizedString(@"Habit_Name_Default", "The default name for a new habit, e.g. 'Do Something'")], @"Habit name should be the default.");
    STAssertNil([habit description], @"Habit Description Is Not Nil.");
    NSTimeInterval dateCreatedInterval = [[habit createdDate] timeIntervalSinceNow];
    STAssertTrue(abs((int)dateCreatedInterval) < 1, @"Habit Created date not should be set to within 1 second of current time.");
    int currentHour = [[NSDate date] hour];
    STAssertTrue([habit timeOfDay]->startHour <= currentHour, @"Habit time of day should start before current time of day");
    STAssertTrue([habit timeOfDay]->endHour > currentHour, @"Habit time of day should end after current time of day");
    STAssertNil([habit skippedDays], @"Habit Skipped Days should be nil.");
    STAssertTrue([[habit performances] count] == 0, @"Habit performances list should be nil");
}

@end
