//
//  LPHabit.h
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/26/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Types/LFDayOfWeek.h"
#import "../Types/LFTimeOfDay.h"

@interface LPHabit : NSObject
{
    NSString *name, *description;
    NSDate *createdDate;
    NSMutableArray *performances;
    struct LFDayOfWeek *skippedDays;
    struct LFTimeOfDay *timeOfDay;
}
@property NSString *name;
@property NSString *description;
@property NSDate *createdDate;
@property NSMutableArray *performances;
@property struct LFDayOfWeek *skippedDays;
@property struct LFTimeOfDay *timeOfDay;



@end
