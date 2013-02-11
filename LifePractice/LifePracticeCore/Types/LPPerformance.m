//
//  LPPerformance.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/28/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "LPPerformance.h"
#import "DDXML.h"

@implementation LPPerformance
@synthesize referenceDate, createdDate;

-(LPPerformance *)init
{
    return [self initWithReferenceDate:[NSDate date]];
}

-(LPPerformance *)initWithReferenceDate:(NSDate *)date
{
    if(self = [super init])
    {
        [self setCreatedDate:[NSDate date]];
        [self setReferenceDate:[DateUtilities getMidnightOfDate:date]];
    }
    
    return self;
}

+(LPPerformance *)performance
{
    return [[LPPerformance alloc] init];
}

+(LPPerformance *)performanceForDate:(NSDate *)referenceDate
{
    return [[LPPerformance alloc] initWithReferenceDate:referenceDate];
}

-(LPPerformance *)initWithXML:(NSString *)xml
{
    DDXMLElement *xmlElement = [[DDXMLElement alloc] initWithXMLString:xml error:NULL];
    if(![[xmlElement name] isEqual: @"Performance"]) return nil;
    NSString *createdDateString = [[xmlElement attributeForName:@"CreatedDate"] stringValue];
    NSString *referenceDateString = [[xmlElement nodesForXPath:@"ReferenceDate" error:NULL][0] stringValue];
    
    NSDate *newCreatedDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[createdDateString doubleValue]];
    NSDate *newReferenceDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[referenceDateString doubleValue]];
    
    if(self = [super init])
    {
        [self setCreatedDate:newCreatedDate];
        [self setReferenceDate:newReferenceDate];
    }
    
    return self;
}

-(BOOL)isEqual:(LPPerformance *)object
{
    return [[self referenceDate] isEqualToDate:[object referenceDate]];
}

-(NSComparisonResult)referenceDateCompare:(LPPerformance *)comparisonPerformance
{
    NSDate *comparisonReferenceDate = [comparisonPerformance referenceDate];
    return [[self referenceDate] compare:comparisonReferenceDate];
}

-(NSComparisonResult)createDateCompare:(LPPerformance *)comparisonPerformance
{
    NSDate *comparisonReferenceDate = [comparisonPerformance referenceDate];
    return [[self referenceDate] compare:comparisonReferenceDate];
}

@end
