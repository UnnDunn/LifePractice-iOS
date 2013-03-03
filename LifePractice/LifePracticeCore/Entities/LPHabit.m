//
//  LPHabit.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/26/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "LPHabit.h"
#import "DDXML.h"

@implementation LPHabit
@synthesize habitName, habitDescription, createdDate, skippedDays, timeOfDay, performances;

- init
{
    if(self = [super init])
    {
        habitName = [[NSString alloc] initWithString:NSLocalizedString(@"Habit_Name_Default", @"Default name for 'Habit' entity")];
        [self initializeProperties];
    }
    
    return self;
}

- (id)initWithName:(NSString *)initName
{
    if(self = [super init])
    {
        habitName = [[NSString alloc] initWithString:initName];
        [self initializeProperties];
    }
    
    return self;
}

-(id)initWithXML:(NSString *)xml
{
    NSLog(@"XML is %@", xml);
    NSError *error = nil;
    DDXMLDocument *xmlDocument = [[DDXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    DDXMLElement *root = [xmlDocument rootElement];
    if(self = [super init])
    {
        [self setHabitName:[[root nodesForXPath:@"Title" error:nil][0] stringValue]];
        [self setHabitDescription:[[root nodesForXPath:@"Description" error:nil][0] stringValue]];
        
        DDXMLElement *timeOfDayElement = [root nodesForXPath:@"TimeFrame" error:nil][0];
        NSString *startHour = [[timeOfDayElement attributeForName:@"StartHour"] stringValue];
        NSString *endHour = [[timeOfDayElement attributeForName:@"EndHour"] stringValue];
        timeOfDay.startHour = [startHour integerValue];
        timeOfDay.endHour = [endHour integerValue];
        
        DDXMLElement *skipDaysContainer = [root nodesForXPath:@"SkipDays" error:nil][0];
        NSArray *skipDaysElements = [skipDaysContainer children];
        
        NSIndexSet *skippedDayElements = [skipDaysElements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            DDXMLElement *skippedDay = (DDXMLElement *)obj;
            NSString *value = [[skippedDay stringValue] lowercaseString];
            return [value isEqualToString:@"true"];
        }];
        
        NSArray *daysToSkip = [skipDaysElements objectsAtIndexes:skippedDayElements];
        
        NSUInteger skippedDaysValue = 0;
        
        for (DDXMLElement *element in daysToSkip) {
            NSString *elementName = [[element name] lowercaseString];
            if ([elementName isEqualToString:@"sunday"]) {
                skippedDaysValue |= LPWeekdaySunday;
                continue;
            }
            if ([elementName isEqualToString:@"monday"]) {
                skippedDaysValue |= LPWeekdayMonday;
                continue;
            }
            if ([elementName isEqualToString:@"tuesday"]) {
                skippedDaysValue |= LPWeekdayTuesday;
                continue;
            }
            if ([elementName isEqualToString:@"wednesday"]) {
                skippedDaysValue |= LPWeekdayWednesday;
                continue;
            }
            if ([elementName isEqualToString:@"thursday"]) {
                skippedDaysValue |= LPWeekdayThursday;
                continue;
            }
            if ([elementName isEqualToString:@"friday"]) {
                skippedDaysValue |= LPWeekdayFriday;
                continue;
            }
            if ([elementName isEqualToString:@"saturday"]) {
                skippedDaysValue |= LPWeekdaySaturday;
                continue;
            }
        }
        [self setSkippedDays:skippedDaysValue];
        
        [self setPerformances:[[NSMutableDictionary alloc] init]];
        NSArray *performanceElements = [root nodesForXPath:@"Performances/Performance" error:nil];
        for (DDXMLElement *performanceElement in performanceElements) {
            LPPerformance *newPerformance = [[LPPerformance alloc] initWithXML:[performanceElement XMLString]];
            [[self performances] setObject:newPerformance forKey:[newPerformance referenceDate]];
        }
    }
    
    return self;    
}

-(NSString *)exportToXML
{
    DDXMLElement *titleElement = [DDXMLElement elementWithName:@"Title" stringValue:[self habitName]];
    DDXMLElement *descriptionElement = [DDXMLElement elementWithName:@"Description" stringValue:[self habitDescription]];
    DDXMLElement *timeFrameElement = [DDXMLElement elementWithName:@"TimeFrame"];
    [timeFrameElement addAttribute:[DDXMLNode attributeWithName:@"StartHour" stringValue:[NSString stringWithFormat:@"%d", [self timeOfDay].startHour]]];
    [timeFrameElement addAttribute:[DDXMLNode attributeWithName:@"EndHour" stringValue:[NSString stringWithFormat:@"%d", [self timeOfDay].endHour]]];
    
    NSMutableArray *skipDayElements = [NSMutableArray arrayWithCapacity:7];
    NSDictionary *skipDayMapping = [NSDictionary dictionaryWithObjectsAndKeys:@"Sunday", [NSNumber numberWithInteger:LPWeekdaySunday], @"Monday", [NSNumber numberWithInteger:LPWeekdayMonday], @"Tuesday", [NSNumber numberWithInteger:LPWeekdayTuesday], @"Wednesday", [NSNumber numberWithInteger:LPWeekdayWednesday], @"Thursday", [NSNumber numberWithInteger:LPWeekdayThursday], @"Friday", [NSNumber numberWithInteger:LPWeekdayFriday], @"Saturday", [NSNumber numberWithInteger:LPWeekdaySaturday], nil];
    int skippedDaysValue = (int)[self skippedDays];
    [skipDayMapping enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        int internalKey = [key integerValue];
        int mask = skippedDaysValue & internalKey;
        NSString *skipDayValue = (mask == internalKey) ? @"True" : @"False";
        [skipDayElements addObject:[DDXMLElement elementWithName:(NSString *)obj stringValue:skipDayValue]];
    }];
    DDXMLElement *skipDayElement = [DDXMLElement elementWithName:@"SkipDays" children:skipDayElements attributes:nil];
    
    NSMutableArray *performanceElements = [NSMutableArray arrayWithCapacity:[performances count]];
    [performances enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSError *error = nil;
        NSString *performanceXML = [(LPPerformance *)obj exportToXML];
        [performanceElements addObject:[[DDXMLElement alloc] initWithXMLString:performanceXML error:&error]];
    }];
    DDXMLElement *performanceElement = [DDXMLElement elementWithName:@"Performances" children:performanceElements attributes:nil];
    
    DDXMLElement *rootElement = [[DDXMLElement alloc] initWithName:@"Habit"];
    [rootElement addAttribute:[DDXMLNode attributeWithName:@"CreatedDate" stringValue:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]]];
    [rootElement setChildren:[NSArray arrayWithObjects:titleElement, descriptionElement, timeFrameElement, skipDayElement, performanceElement, nil]];
    DDXMLDocument *exportXMLDocument = [[DDXMLDocument alloc] initWithRootElement:rootElement];
    
    return [exportXMLDocument XMLString];
}

-(void)initializeProperties
{
    habitDescription = [[NSString alloc] init];
    createdDate = [NSDate date];
    skippedDays = LPWeekdayNone;
    performances = [[NSMutableDictionary alloc] init];
    timeOfDay.startHour = 0;
    timeOfDay.endHour = 24;    
}

-(BOOL)addPerformance
{
    return [self addPerformance:[NSDate date]];
}

-(BOOL)addPerformance:(NSDate *)forDate
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *dateDifference = [gregorian components:(NSDayCalendarUnit) fromDate:forDate toDate:[NSDate date] options:0];
    if ([now compare:forDate] == NSOrderedAscending || [dateDifference day] >= 2) {
        return false;
    }
    LPPerformance *currentPerformance = [self getPerformance:forDate];
    if (currentPerformance != Nil) {
        return false;
    }
    
    currentPerformance = [LPPerformance performanceForDate:forDate];
    [performances setObject:currentPerformance forKey:[currentPerformance referenceDate]];
    return true;
}

-(BOOL)removePerformance:(NSDate *)forDate
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateDifference = [gregorian components:(NSDayCalendarUnit) fromDate:forDate toDate:[NSDate date] options:0];
    if ([dateDifference day] >= 2) {
        return false;
    }
    LPPerformance *currentPerformance = [self getPerformance:forDate];
    if (currentPerformance == Nil) {
        return false;
    }
    
    [performances removeObjectForKey:[currentPerformance referenceDate]];
    return true;
    
}

-(NSArray *)listPerformances
{
    return [[performances allValues] sortedArrayUsingSelector:@selector(referenceDateCompare:)];
}

-(LPPerformance *)getPerformance:(NSDate *)forDate
{    
    NSDate *referenceDate = [DateUtilities getMidnightOfDate:forDate];
    return [performances objectForKey:referenceDate];
}
@end

