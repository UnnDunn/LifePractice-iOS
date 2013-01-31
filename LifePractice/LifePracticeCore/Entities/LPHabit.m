//
//  LPHabit.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/26/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "LPHabit.h"

@implementation LPHabit
@synthesize habitName, habitDescription, createdDate, skippedDays, timeOfDay;

NSMutableDictionary *performances;

- init
{
    if(self = [super init])
    {
        habitName = [[NSString alloc] initWithString:NSLocalizedString(@"Habit_Name_Default", @"Default name for 'Habit' entity")];
        [self initializeProperties];
    }
    
    return self;
}

- (id)initWithName:(NSString *)initName
{
    if(self = [super init])
    {
        habitName = [[NSString alloc] initWithString:initName];
        [self initializeProperties];
    }
    
    return self;
}

-(void)initializeProperties
{
    habitDescription = [[NSString alloc] init];
    createdDate = [NSDate date];
    skippedDays.None = 1;
    performances = [[NSMutableDictionary alloc] init];
    timeOfDay.startHour = 0;
    timeOfDay.endHour = 24;    
}

-(BOOL)addPerformance
{
    return [self addPerformance:[NSDate date]];
}

-(BOOL)addPerformance:(NSDate *)forDate
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *dateDifference = [gregorian components:(NSDayCalendarUnit) fromDate:forDate toDate:[NSDate date] options:0];
    NSComparisonResult comparisonResult = [now compare:forDate];
    if (comparisonResult == NSOrderedAscending || [dateDifference day] >= 2) {
        return false;
    }
    LPPerformance *currentPerformance = [self getPerformance:[DateUtilities getMidnightOfDate:forDate]];
    if (currentPerformance != Nil) {
        return false;
    }
    
    currentPerformance = [[LPPerformance alloc] initWithReferenceDate:forDate];
    [performances setObject:currentPerformance forKey:[currentPerformance referenceDate]];
    return true;
}

-(NSArray *)listPerformances
{
    return [[performances allValues] sortedArrayUsingSelector:@selector(referenceDateCompare:)];
}

-(LPPerformance *)getPerformance:(NSDate *)forDate
{    
    NSDate *referenceDate = [DateUtilities getMidnightOfDate:forDate];
    return [performances objectForKey:referenceDate];
}
@end

