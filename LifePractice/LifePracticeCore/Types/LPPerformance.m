//
//  LPPerformance.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/28/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "LPPerformance.h"

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
