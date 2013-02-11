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
    NSString *performanceSamplePath = [[NSBundle mainBundle] pathForResource:@"performance_sample" ofType:@"xml"];
    NSString *samplePerformance = [NSString stringWithContentsOfFile:performanceSamplePath encoding:NSUTF8StringEncoding error:NULL];
    
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
    
    STAssertTrue([[performance referenceDate] isEqualToDate:targetReferenceDate], @"Performance reference date should be Feb 5, 2012");
    STAssertTrue([[performance createdDate] isEqualToDate:targetCreatedDate], @"Created Date should be Feb 5, 2012, 10am");
}

-(void)testPerformanceExportsToNSXMLElementCorrectly
{
    
}

-(NSUInteger)random
{
    
}
@end
