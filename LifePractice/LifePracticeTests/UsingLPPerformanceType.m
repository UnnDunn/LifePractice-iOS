//
//  UsingLPPerformanceType.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 2/3/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "UsingLPPerformanceType.h"
#import <Security/Security.h>

@implementation UsingLPPerformanceType

-(void)testPerformanceInitializesFromNSXMLElementCorrectly
{
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *inputDates = [[NSMutableDictionary alloc] initWithCapacity:5];
    // create 5 random reference/create date pairs
    for (int i = 0; i < 4; i++) {
        NSTimeInterval randCreateInterval = arc4random_uniform(nowInterval);
        NSTimeInterval randRefInterval = randCreateInterval - arc4random_uniform(randCreateInterval);
        
        NSDate *randCreateDate = [NSDate dateWithTimeIntervalSince1970:randCreateInterval];
        NSDate *randRefDate = [DateUtilities getMidnightOfDate:[NSDate dateWithTimeIntervalSince1970:randRefInterval]];
        
        [inputDates setObject:randCreateDate forKey:randRefDate];
        
        //create an NSXMLElement "Performance" with attribute "createDate" and subelement "ReferenceDate"        
    }
}

-(void)testPerformanceExportsToNSXMLElementCorrectly
{
    
}

-(NSUInteger)random
{
    
}
@end
