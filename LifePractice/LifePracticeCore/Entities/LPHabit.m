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

NSMutableArray *performances;

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
    performances = [[NSMutableArray alloc] init];
    timeOfDay.startHour = 0;
    timeOfDay.endHour = 24;    
}

-(BOOL)addPerformance
{
    return [self addPerformance:[NSDate date]];
}

-(BOOL)addPerformance:(NSDate *)referenceDate
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateDifference = [gregorian components:(NSDayCalendarUnit) fromDate:referenceDate toDate:[NSDate date] options:0];
    NSComparisonResult comparisonResult = [[NSDate date] compare:referenceDate];
    if (comparisonResult == NSOrderedAscending || [dateDifference day] >= 2) {
        return false;
    }
    LPPerformance *currentPerformance = [self getPerformanceOnDate:[DateUtilities getMidnightOfDate:referenceDate]];
    if (currentPerformance != Nil) {
        return false;
    }
    
    currentPerformance = [[LPPerformance alloc] initWithReferenceDate:referenceDate];
    [performances addObject:currentPerformance];
    return true;
}

-(NSArray *)listPerformances
{
    return [performances sortedArrayUsingSelector:@selector(referenceDateCompare:)];
}

-(LPPerformance *)getPerformanceOnDate:(NSDate *)date
{
    for (LPPerformance *performance in performances) {
        if ([[performance referenceDate] isEqualToDate:date]) {
            return performance;
        }
    }
    return Nil;
}
@end

