//
//  UsingHabitEntity.m
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/25/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import "UsingHabitEntity.h"
#import "DDXML.h"

@implementation UsingHabitEntity

NSDateFormatter *dateFormatter = nil;

-(void)testNewHabitIsProperlyInitialized
{
    LPHabit *habit = [[LPHabit alloc] init];
    STAssertTrue([[habit habitName] isEqualToString: NSLocalizedString(@"Habit_Name_Default", "The default name for a new habit, e.g. 'Do Something'")], @"Habit name should be the default.");
    STAssertTrue([[habit habitDescription] length] == 0, @"Habit Description should be nil.");
    NSTimeInterval dateCreatedInterval = [[habit createdDate] timeIntervalSinceNow];
    STAssertTrue(abs((int)dateCreatedInterval) < 1, @"Habit Created date should be set to within 1 second of current time.");
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *hourComponent = [gregorian components:(NSHourCalendarUnit) fromDate:today];
    NSUInteger currentHour = [hourComponent hour];
    STAssertTrue([habit timeOfDay].startHour <= currentHour, @"Habit time of day should start before current time of day");
    STAssertTrue([habit timeOfDay].endHour > currentHour, @"Habit time of day should end after current time of day");
    STAssertTrue(([habit skippedDays] & LPWeekdayNone) == LPWeekdayNone , @"Habit Skipped Days should be nil.");
    STAssertTrue([[habit listPerformances] count] == 0, @"Habit performances list should be nil");
}

-(void)testNewHabitWithNameIsProperlyInitialized
{
    NSString *initalizationString = @"Wake up early";
    LPHabit *habit = [[LPHabit alloc] initWithName:initalizationString];
    STAssertTrue([[habit habitName] isEqualToString:initalizationString], @"Habit name should be equal to the initalization string");
    STAssertTrue([[habit habitDescription] length] == 0, @"Habit Description should be nil.");
    NSTimeInterval dateCreatedInterval = [[habit createdDate] timeIntervalSinceNow];
    STAssertTrue(abs((int)dateCreatedInterval) < 1, @"Habit Created date should be set to within 1 second of current time.");
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *hourComponent = [gregorian components:(NSHourCalendarUnit) fromDate:today];
    NSUInteger currentHour = [hourComponent hour];
    STAssertTrue([habit timeOfDay].startHour <= currentHour, @"Habit time of day should start before current time of day");
    STAssertTrue([habit timeOfDay].endHour > currentHour, @"Habit time of day should end after current time of day");
    STAssertTrue(([habit skippedDays] & LPWeekdayNone) == LPWeekdayNone , @"Habit Skipped Days should be nil.");
    STAssertTrue([[habit listPerformances] count] == 0, @"Habit performances list should be nil");
}

-(void)testAddPerformanceMethodHandlesDatesCorrectly
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    LPHabit *habit = [[LPHabit alloc] initWithName:@"Test Habit"];
    
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24 * -1];
    NSDate *today = [NSDate date];
    NSDate *twoDaysAgo = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 48 * -1];
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24];
    
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSDate *todayMidnight = [gregorian dateFromComponents:todayComponents];
    NSDateComponents *yesterdayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:yesterday];
    NSDate *yesterdayMidnight = [gregorian dateFromComponents:yesterdayComponents];

    STAssertTrue([habit addPerformance], @"Adding first performance for today should succeed"); // should succeed with performance date added now and reference date today
    STAssertFalseNoThrow([habit addPerformance:today], @"Adding second performance for today should fail"); // should fail because you can't have two performances on the same date
    STAssertTrue([habit addPerformance:yesterday], @"Adding performance for yesterday should succeed"); // should succeed with reference date yesterday and created date today
    STAssertFalseNoThrow([habit addPerformance:twoDaysAgo], @"Adding performance for two days ago should fail"); // should fail, you can't add a performance for more than 1 day ago
    STAssertFalseNoThrow([habit addPerformance:tomorrow], @"Adding performance for future date should fail"); // should fail, you can't add a performance for a date in the future
    
    NSArray *performances = [habit listPerformances];
    
    // performances should have two entries, one with date=now and reference date today, and one with date=now and reference date yesterday
    STAssertTrue([performances count] == 2, @"Performances array should have 2 entries.");
    
    // test first performance
    LPPerformance *performance1 = [performances objectAtIndex:0];
    NSTimeInterval performance1CreatedInterval = [[performance1 createdDate] timeIntervalSinceDate:today];
    STAssertTrue(abs((int)performance1CreatedInterval) < 1, @"Performance1 created date should be within 1 second of current time.");
    STAssertTrue([[performance1 referenceDate] isEqualToDate:yesterdayMidnight], @"Performance1 reference date should be midnight of today");
    
    // test second performance
    LPPerformance *performance2 = [performances objectAtIndex:1];
    NSTimeInterval performance2CreatedInterval = [[performance2 createdDate] timeIntervalSinceDate:today];
    STAssertTrue(abs((int)performance2CreatedInterval) < 1, @"Performance2 created date must be within 1 second of current date.");
    STAssertTrue([[performance2 referenceDate] isEqualToDate:todayMidnight], @"Performance2 created date should be midnight yesterday");
    
    
}

-(void)testRemovePerformanceMethodHandlesDatesCorrectly
{    
    LPHabit *habit = [[LPHabit alloc] initWithName:@"Test Habit"];
    
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24 * -1];
    NSDate *today = [NSDate date];
    NSDate *twoDaysAgo = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 48 * -1];
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24];
        
    [habit addPerformance:today];
    [habit addPerformance:yesterday];
    
    STAssertTrue([[habit listPerformances] count] == 2, @"Number of performances should be 2");
    
    STAssertTrue([habit removePerformance:today], @"Deleting performance for today should succeed.");
    
    NSArray *performances = [habit listPerformances];
    STAssertTrue([performances count] == 1, @"Number of performances should be 1.");
    STAssertTrue([[[performances objectAtIndex:0] referenceDate] isEqualToDate:[DateUtilities getMidnightOfDate:yesterday]], @"Reference date for performance 0 should be midnight yesterday.");
    
    [habit addPerformance];
    STAssertTrue([[habit listPerformances] count] == 2, @"Number of performances should be 2");
    
    STAssertFalseNoThrow([habit removePerformance:tomorrow], @"Deleting performance for tomorrow should fail, for obvious reasons");
    STAssertFalseNoThrow([habit removePerformance:twoDaysAgo], @"Deleting performance for two days ago should fail");
    
    [habit removePerformance:yesterday];
    performances = [habit listPerformances];
    STAssertTrue([performances count] == 1, @"Number of performances should be 1.");
    STAssertTrue([[[performances objectAtIndex:0] referenceDate] isEqualToDate:[DateUtilities getMidnightOfDate:today]], @"Reference date for performance 0 should be midnight today.");
}

-(void)testHabitImportsFromXMLCorrectly
{
    NSBundle *testBundle = [NSBundle bundleWithIdentifier:@"com.unndunn.LifePracticeTests"];
    NSString *habitSamplePath = [testBundle pathForResource:@"habit_sample" ofType:@"xml"];
    NSString *habitXML = [NSString stringWithContentsOfFile:habitSamplePath encoding:NSUTF8StringEncoding error:NULL];
    
    LPHabit *testHabit = [[LPHabit alloc] initWithXML:habitXML];
    STAssertTrue([[testHabit habitName] isEqualToString:@"Sample Habit"], @"Habit Name should be 'Sample Habit'.");
    STAssertTrue([[testHabit habitDescription] isEqualToString:@"Sample description."], @"Habit Description should be 'Sample description.'");
    STAssertTrue([testHabit timeOfDay].startHour == 0, @"Start hour should be 00");
    STAssertTrue([testHabit timeOfDay].endHour == 23, @"End hour should be 23");
    NSUInteger testDays = LPWeekdayThursday | LPWeekdayFriday;
    STAssertTrue(([testHabit skippedDays] & testDays) == testDays, @"Skipped days should be Thursday and Friday");
    
    NSArray *testPerformances = [testHabit listPerformances];
    STAssertTrue([testPerformances count] == 4, @"There should be 4 performances in the array");
    if(dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    }
    
    NSArray *testPerformanceCreatedDates = [NSArray arrayWithObjects:[NSDate dateWithTimeIntervalSince1970:1359644430], [NSDate dateWithTimeIntervalSince1970:1359644400], [NSDate dateWithTimeIntervalSince1970:1359990044], [NSDate dateWithTimeIntervalSince1970:1360076444], nil];
    NSArray *testPerformanceReferenceDates = [NSArray arrayWithObjects:[dateFormatter dateFromString:@"01-30-2013"], [dateFormatter dateFromString:@"01-31-2013"], [dateFormatter dateFromString:@"02-04-2013"], [dateFormatter dateFromString:@"02-05-2013"], nil];
    NSUInteger count = 0;
    for (LPPerformance *testPerformance in testPerformances) {
        STAssertTrue([[testPerformance createdDate] isEqualToDate:testPerformanceCreatedDates[count]], [NSString stringWithFormat:@"Created date of performance %d should be %@.", count, testPerformanceCreatedDates[count]]);
        STAssertTrue([[testPerformance referenceDate] isEqualToDate:testPerformanceReferenceDates[count]], [NSString stringWithFormat:@"Reference date of performance %d should be %@.", count, testPerformanceReferenceDates[count]]);
        count++;
    }
}

-(void)testHabitExportsToXMLCorrectly
{
    NSError *error = nil;
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24 * -1];
    LPHabit *testHabit = [[LPHabit alloc] initWithName:@"Test Habit"];
    [testHabit setHabitDescription:@"Test Description."];
    [testHabit addPerformance:[NSDate date]];
    [testHabit addPerformance:yesterday];
    testHabit.skippedDays |= LPWeekdayFriday | LPWeekdaySaturday;
    
    NSString *testXML = [testHabit exportToXML];
    
    DDXMLDocument *testXMLDocument = [[DDXMLDocument alloc] initWithXMLString:testXML options:0 error:&error];
    STAssertTrue(error == nil, @"No errors should result from parsing XML into NSXMLDocument");
    
    DDXMLElement *rootElement = [testXMLDocument rootElement];
    NSString *rootElementName = [rootElement name];
    NSUInteger rootCreatedInterval = [[[rootElement attributeForName:@"CreatedDate"] stringValue] integerValue];
    
    STAssertTrue([rootElementName isEqualToString:@"Habit"], @"Name of root element should be 'Habit'");
    STAssertTrue(abs([[NSDate date] timeIntervalSince1970] - rootCreatedInterval) < 1, @"Created date should be within one second of now");
    
    NSString *testTitle = [[rootElement nodesForXPath:@"Title" error:&error][0] stringValue];
    NSString *testDescription = [[rootElement nodesForXPath:@"Description" error:&error][0] stringValue];
    DDXMLElement *testTimeFrame = [rootElement nodesForXPath:@"TimeFrame" error:&error][0];
    DDXMLNode *testStartHour = [testTimeFrame attributeForName:@"StartHour"];
    DDXMLNode *testEndHour = [testTimeFrame attributeForName:@"EndHour"];
    NSArray *testSkippedDays = [[rootElement nodesForXPath:@"SkipDays" error:&error][0] children];
    NSArray *testPerformances = [rootElement nodesForXPath:@"Performances/Performance" error:&error];
    
    STAssertTrue([testTitle isEqualToString:@"Test Habit"], @"The title element should be 'Test Title'");
    STAssertTrue([testDescription isEqualToString:@"Test Description."], @"The description element should be 'Test description.'");
    STAssertTrue([[testStartHour stringValue] integerValue] == 0, @"Start Hour should be 0.");
    STAssertTrue([[testEndHour stringValue] integerValue] == 24, @"End Hour should be 24.");
    NSDictionary *skippedDays = [NSDictionary dictionaryWithObjectsAndKeys:@"false", @"sunday", @"false", @"monday", @"false", @"tuesday", @"false", @"wednesday", @"false", @"thursday", @"true", @"friday", @"true", @"saturday", nil];
    for (DDXMLElement *skipDayElement in testSkippedDays) {
        NSString *elementName = [[skipDayElement name] lowercaseString];
        NSString *elementValue = [[skipDayElement stringValue] lowercaseString];
        STAssertTrue([[skippedDays objectForKey:elementName] isEqualToString:elementValue], [NSString stringWithFormat:@"Value for Skip Day %@ should be %@.", elementName, [skippedDays objectForKey:elementName]]);
    }
    STAssertTrue([testSkippedDays count] == 7, @"There should be 7 Skipped Day elements.");
    
    STAssertTrue([testPerformances count] == 2, @"There should be 2 Performance entries");
    NSMutableArray *refDateStrings, *createDateStrings;
    refDateStrings = [NSMutableArray arrayWithCapacity:2];
    createDateStrings = [NSMutableArray arrayWithCapacity:2];
    for (DDXMLElement *testPerformance in testPerformances) {
        NSString *createDateString = [[testPerformance attributeForName:@"CreatedDate"] stringValue];
        NSString *refDateString = [[testPerformance nodesForXPath:@"ReferenceDate" error:&error][0] stringValue];
        [refDateStrings addObject:refDateString];
        [createDateStrings addObject:createDateString];
    }
    NSDictionary *testPerformanceDictionary = [NSDictionary dictionaryWithObjects:createDateStrings forKeys:refDateStrings];
    NSArray *realPerformances = [testHabit listPerformances];
    if (dateFormatter == NULL) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    }
    for (LPPerformance *performance in realPerformances) {
        NSString *realCreateDateString = [NSString stringWithFormat:@"%f",[[performance createdDate] timeIntervalSince1970]];
        NSString *realRefDateString = [dateFormatter stringFromDate:[performance referenceDate]];
        STAssertTrue([[testPerformanceDictionary objectForKey:realRefDateString] isEqualToString:realCreateDateString], [NSString stringWithFormat:@"%@ reference date should map to %@ created date", realRefDateString, [testPerformanceDictionary objectForKey:realRefDateString]]);
    }
}

-(LPHabit *)returnSampleHabit
{
    NSBundle *testBundle = [NSBundle bundleWithIdentifier:@"com.unndunn.LifePracticeTests"];
    NSString *habitSamplePath = [testBundle pathForResource:@"habit_sample" ofType:@"xml"];
    NSString *habitXML = [NSString stringWithContentsOfFile:habitSamplePath encoding:NSUTF8StringEncoding error:NULL];
    
    LPHabit *testHabit = [[LPHabit alloc] initWithXML:habitXML];
    return testHabit;
}

-(void)testWasPerformedReturnsValidResults
{
    LPHabit *testHabit = [self returnSampleHabit];
    
    if(dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    }
    
    BOOL testResult1 = [testHabit wasPerformedOn:[dateFormatter dateFromString:@"02-05-2013"]];
    BOOL testResult2 = [testHabit wasPerformedOn:[dateFormatter dateFromString:@"02-04-2013"]];
    BOOL testResult3 = [testHabit wasPerformedOn:[dateFormatter dateFromString:@"01-31-2013"]];
    BOOL testResult4 = [testHabit wasPerformedOn:[dateFormatter dateFromString:@"01-30-2013"]];
    
    STAssertTrue(testResult1 && testResult2 && testResult3 && testResult4 == true, @"First 4 tests should all evaluate to true.");
    
    BOOL testResult5 = [testHabit wasPerformedOn:[NSDate date]];
    BOOL testResult6 = [testHabit wasPerformedOn:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 5]];
    BOOL testResult7 = [testHabit wasPerformedOn:[dateFormatter dateFromString:@"01-01-2013"]];
    BOOL testResult8 = [testHabit wasPerformedOn:[dateFormatter dateFromString:@"02-01-2013"]];
    
    STAssertTrue(testResult5 || testResult6 || testResult7 || testResult8 == false, @"Tests 5-8 should all evaluate to false");
}

-(void)testCurrentStreakReturnsCorrectResults
{
    LPHabit *testHabit = [self returnSampleHabit];
    STAssertTrue([testHabit currentStreak] == 0, @"Current streak should return 0 by default.");
    
    [testHabit addPerformance:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * -1]];
    STAssertTrue([testHabit currentStreak] == 1, @"Current streak should return 1 after one performance posted.");
    
    [testHabit addPerformance:[NSDate date]];
    STAssertTrue([testHabit currentStreak] == 2, @"Current streak should return 2 after two performances posted.");
}

-(void)testLongestStreakReturnsCorrectResults
{
    LPHabit *testHabit = [self returnSampleHabit];
    STAssertTrue([testHabit longestStreak] == 2, @"Longest streak should be 2 for standard sample habit");
}
@end
