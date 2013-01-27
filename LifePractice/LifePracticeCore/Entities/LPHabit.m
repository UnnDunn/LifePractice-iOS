//
//  LPHabit.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/26/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "LPHabit.h"

@implementation LPHabit
@synthesize habitName, habitDescription, createdDate, skippedDays, performances, timeOfDay;

- init
{
    if(self = [super init])
    {
        habitName = [[NSString alloc] initWithString:NSLocalizedString(@"Habit_Name_Default", @"Default name for 'Habit' entity")];
        habitDescription = [[NSString alloc] init];
        createdDate = [NSDate date];
        skippedDays.None = 1;
        performances = [[NSMutableArray alloc] init];
        timeOfDay.startHour = 0;
        timeOfDay.endHour = 24;
    }
    
    return self;
}

- (id)initWithName:(NSString *)initName
{
    if(self = [super init])
    {
        habitName = [[NSString alloc] initWithString:initName];
        habitDescription = [[NSString alloc] init];
        createdDate = [NSDate date];
        skippedDays.None = 1;
        performances = [[NSMutableArray alloc] init];
        timeOfDay.startHour = 0;
        timeOfDay.endHour = 24;
    }
    
    return self;
}

@end

