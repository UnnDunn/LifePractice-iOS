//
//  LPPerformance.h
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/28/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateUtilities.h"

@interface LPPerformance : NSObject
{
    NSDate *referenceDate;
    NSDate *createdDate;
}
@property NSDate *referenceDate;
@property NSDate *createdDate;

-(LPPerformance *)init;
-(LPPerformance *)initWithReferenceDate:(NSDate *)referenceDate;
-(LPPerformance *)initWithXML:(NSString *)xml;
+(LPPerformance *)performance;
+(LPPerformance *)performanceForDate:(NSDate *)referenceDate;

-(NSString *)exportToXML;


-(BOOL)isEqual:(LPPerformance *)object;
-(NSComparisonResult)referenceDateCompare:(LPPerformance *)comparisonPerformance;
-(NSComparisonResult)createdDateCompare:(LPPerformance *)comparisonPerformance;
@end
