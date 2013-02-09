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
    NSString *samplePerformance;
    LPPerformance *performance = [[LPPerformance alloc] initWithXML:samplePerformance];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *targetReferenceDateComponents;
    NSDate *targetReferenceDate, *targetCreatedDate;
    targetReferenceDateComponents = [[NSDateComponents alloc] init];
    [targetReferenceDateComponents setYear:2012];
    [targetReferenceDateComponents setMonth:2];
    [targetReferenceDateComponents setDay:5];
    targetReferenceDate = [gregorian dateFromComponents:targetReferenceDateComponents];
    [targetReferenceDateComponents setHour:10];
    [targetReferenceDateComponents setMinute:0];
    [targetReferenceDateComponents setSecond:0];
    targetCreatedDate = [gregorian dateFromComponents:targetReferenceDateComponents];
    
    
}

-(void)testPerformanceExportsToNSXMLElementCorrectly
{
    
}

-(NSUInteger)random
{
    
}
@end
