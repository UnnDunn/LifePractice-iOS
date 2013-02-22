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

NSDateFormatter *USDateFormatter = nil;

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
    
    if(USDateFormatter == nil) {
        USDateFormatter = [[NSDateFormatter alloc] init];
        [USDateFormatter setDateFormat:@"MM-dd-yyyy"];
    }
    NSDate *newReferenceDate = [USDateFormatter dateFromString:referenceDateString];
    
    if(self = [super init])
    {
        [self setCreatedDate:newCreatedDate];
        [self setReferenceDate:newReferenceDate];
    }
    
    return self;
}

-(NSString *)exportToXML
{
    DDXMLElement *xmlElement = [[DDXMLElement alloc] initWithName:@"Performance"];
    DDXMLElement *refDateElement = [[DDXMLElement alloc] initWithName:@"ReferenceDate"];
    if(USDateFormatter == nil) {
        USDateFormatter = [[NSDateFormatter alloc] init];
        [USDateFormatter setDateFormat:@"MM-dd-yyyy"];
    }
    NSString *refDateString = [USDateFormatter stringFromDate:[self referenceDate]];
    [refDateElement setStringValue:refDateString];
    [xmlElement insertChild:refDateElement atIndex:0];
    
    DDXMLNode *createDateAttribute = [DDXMLNode attributeWithName:@"CreatedDate" stringValue:[[NSString alloc] initWithFormat:@"%f", [[self createdDate] timeIntervalSince1970]]];
    [xmlElement addAttribute:createDateAttribute];
    
    return [xmlElement XMLString];
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

-(NSComparisonResult)createdDateCompare:(LPPerformance *)comparisonPerformance
{
    NSDate *comparisonCreatedDate = [comparisonPerformance createdDate];
    return [[self createdDate] compare:comparisonCreatedDate];
}

@end
