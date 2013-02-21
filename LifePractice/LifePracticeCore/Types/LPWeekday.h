//
//  Header.h
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/26/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#ifndef LifePractice_LPWeekday_h
#define LifePractice_LPWeekday_h

enum {
    LPWeekdaySunday     = 1 << 0,
    LPWeekdayMonday     = 1 << 1,
    LPWeekdayTuesday    = 1 << 2,
    LPWeekdayWednesday  = 1 << 3,
    LPWeekdayThursday   = 1 << 4,
    LPWeekdayFriday     = 1 << 5,
    LPWeekdaySaturday   = 1 << 6,
    LPWeekdayNone       = 0,
    LPWeekdayAll        = NSUIntegerMax
};
#endif
