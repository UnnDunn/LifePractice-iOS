//
//  LPHabit.h
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/26/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFDayOfWeek.h"
#import "LFTimeOfDay.h"

@interface LPHabit : NSObject
{
    NSString *habitName, *description;
    NSDate *createdDate;
    NSMutableArray *performances;
    struct LFDayOfWeek skippedDays;
    struct LFTimeOfDay timeOfDay;
}
@property NSString *habitName;
@property NSString *habitDescription;
@property NSDate *createdDate;
@property NSMutableArray *performances;
@property struct LFDayOfWeek skippedDays;
@property struct LFTimeOfDay timeOfDay;

-init;
-initWithName:(NSString *) initName;
@end
