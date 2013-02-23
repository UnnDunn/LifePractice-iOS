//
//  LPHabit.h
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/26/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPWeekday.h"
#import "LPTimeOfDay.h"
#import "LPPerformance.h"
#import "DateUtilities.h"

@interface LPHabit : NSObject
{
    NSString *habitName, *description;
    NSDate *createdDate;
    NSUInteger skippedDays;
    struct LPTimeOfDay timeOfDay;
}
@property NSString *habitName;
@property NSString *habitDescription;
@property NSDate *createdDate;
@property NSUInteger skippedDays;
@property NSMutableDictionary *performances;
@property struct LPTimeOfDay timeOfDay;

-init;
-initWithName:(NSString *) initName;
-initWithXML:(NSString *)xml;
-(NSArray *)listPerformances;
-(BOOL)addPerformance;
-(BOOL)addPerformance:(NSDate *) forDate;
-(BOOL)removePerformance:(NSDate *) forDate;
-(LPPerformance *)getPerformance:(NSDate *)forDate;
@end
