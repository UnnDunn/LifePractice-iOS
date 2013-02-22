//
//  UsingLPPerformanceType.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 2/3/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "UsingLPPerformanceType.h"
#import <Security/Security.h>
#import "DDXML.h"

@implementation UsingLPPerformanceType

NSDateFormatter *performanceTestDateFormatter = nil;

-(void)testPerformanceInitializesFromXMLCorrectly
{
    NSBundle *testBundle = [NSBundle bundleWithIdentifier:@"com.unndunn.LifePracticeTests"];
    NSString *performanceSamplePath = [testBundle pathForResource:@"performance_sample" ofType:@"xml"];
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

-(void)testPerformanceExportsToXMLCorrectly
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *todayComponents, *yesterdayComponents;
    NSDate *now = [NSDate date];
    todayComponents = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24 * -1];
    yesterdayComponents = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:yesterday];
    
    LPPerformance *testPerformance1 = [LPPerformance performanceForDate:now];
    LPPerformance *testPerformance2 = [LPPerformance performanceForDate:yesterday];
    
    NSString *performanceXML1 = [testPerformance1 exportToXML];
    NSString *performanceXML2 = [testPerformance2 exportToXML];
    
    DDXMLElement *p1XMLElement = [[DDXMLElement alloc] initWithXMLString:performanceXML1 error:NULL];
    DDXMLElement *p2XMLElement = [[DDXMLElement alloc] initWithXMLString:performanceXML2 error:NULL];
    
    // Test Performance 1
    STAssertTrue([[p1XMLElement name] isEqualToString:@"Performance"], @"Name of element for performance 1 should be 'Performance'");
    NSDate *p1CreatedDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[[[p1XMLElement attributeForName:@"CreatedDate"] stringValue] doubleValue]];
    NSTimeInterval performance1CreatedInterval = [p1CreatedDate timeIntervalSinceDate:now];
    if(performanceTestDateFormatter == nil) {
        performanceTestDateFormatter = [[NSDateFormatter alloc] init];
        [performanceTestDateFormatter setDateFormat:@"MM-dd-yyyy"];
    }
    NSDate *p1RefDate = [performanceTestDateFormatter dateFromString:[[p1XMLElement nodesForXPath:@"ReferenceDate" error:NULL][0] stringValue]];
    NSDate *today = [DateUtilities getMidnightOfDate:now];
    STAssertTrue([today isEqualToDate:p1RefDate], @"Performance 1 reference date should be midnight of today");
    STAssertTrue(abs(performance1CreatedInterval) < 1, @"Performance 1 create date should be within 1 seconds of current date");
    
    // Test Performance 2
    STAssertTrue([[p2XMLElement name] isEqualToString:@"Performance"], @"Name of element for performance 2 should be 'Performance'");
    NSDate *p2CreatedDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[[[p2XMLElement attributeForName:@"CreatedDate"] stringValue] doubleValue]];
    NSTimeInterval performance2CreatedInterval = [p2CreatedDate timeIntervalSinceDate:now];
    if(performanceTestDateFormatter == nil) {
        performanceTestDateFormatter = [[NSDateFormatter alloc] init];
        [performanceTestDateFormatter setDateFormat:@"MM-dd-yyyy"];
    }
    NSDate *p2RefDate = [performanceTestDateFormatter dateFromString:[[p2XMLElement nodesForXPath:@"ReferenceDate" error:NULL][0] stringValue]];
    NSDate *yesterdayMidnight = [DateUtilities getMidnightOfDate:yesterday];
    STAssertTrue([yesterdayMidnight isEqualToDate:p2RefDate], @"Performance 2 reference date should be midnight of yesterday");
    STAssertTrue(abs(performance2CreatedInterval) < 1, @"Performance 2 create date should be within 1 seconds of current date");
    
    
}
@end
