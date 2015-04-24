//
//  Project.m
//  TrackAndBill_OSX
//
//  Created by Bill on 11/4/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "Project.h"


@implementation Project

- (id)init
{
	//[super init];
	[self setProjectName:@"New Project"];
	[self setClientName:@"The Client"];
	
	NSDate *stDate = [NSDate date];
	
	[self setStartDate:stDate];
	[self setEndDate:stDate];
	
	[self setTotalTime:@"0"];
	
	return self;
}

- (NSNumber * )projectID
{
	return projectID;
}
- (NSNumber *)clientID
{
	return clientID;
}
- (NSString *)projectName
{
	return projectName;
	
}
- (NSString *)clientName
{
	return clientName;
	
}

- (NSString *)totalTime
{
	return totalTime;
	
}

- (NSDate *)startDate
{
	
return startDate;	

}



- (NSDate *)endDate
{
	return endDate;
}

/////////// Set variables //////////////////////
- (void)setProjectID:(NSNumber *)pID
{
    pID= [pID copy];
	projectID = pID;
}

- (void)setClientID:(NSNumber *)cID
{
	cID= [cID copy];
	//[clientID release];
	clientID = cID;
}
- (void)setTotalTime:(NSString *)tTime
{
	tTime= [tTime copy];
	//[totalTime release];
	totalTime = tTime;
}
- (void)setProjectName:(NSString *)pName
{
	pName = [pName copy]; //if passed string is mutable, "copy" converts it to immutable string
	//[projectName release];
	projectName = pName;
	
}
- (void)setClientName:(NSString *)cName
{
	cName= [cName copy];
	//[clientName release];
	clientName = cName;
	
}


- (void)setStartDate:(NSDate *)sDate
{
	sDate = [sDate copy];
	//[startDate release];

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//	@try
//	{
//		if ([self getDateFormatSetting]==1){
//             [dateFormatter setDateFormat:@"d/m/y"];
//			//[dateFormatter initWithDateFormat:@"%d/%m/%y" allowNaturalLanguage:NO];
//		}else{
//            [dateFormatter setDateFormat:@"m/d/y"];
//			//[dateFormatter initWithDateFormat:@"%m/%d/%y" allowNaturalLanguage:NO];
//		}
//		
//		NSString *modString = [[NSString alloc] initWithString: [dateFormatter stringFromDate:sDate]];
//		startDate =[[dateFormatter dateFromString:modString] copy];
//		
//	}@catch (NSException *exception) {
//		NSLog(@"main: Caught %@: %@", [exception name], [exception  reason]);
//		startDate = sDate;
//	}
    
    startDate = sDate;


}

- (void)setEndDate:(NSDate *)eDate
{
	eDate = [eDate copy];
	//[endDate release];

//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	@try
//	{
//		if ([self getDateFormatSetting]==1){
//            [dateFormatter setDateFormat:@"d/m/y"];
//			//[dateFormatter initWithDateFormat:@"%d/%m/%y" allowNaturalLanguage:NO];
//		}else{
//            [dateFormatter setDateFormat:@"m/d/y"];
//			//[dateFormatter initWithDateFormat:@"%m/%d/%y" allowNaturalLanguage:NO];
//		}
//		
//		NSString *modString = [[NSString alloc] initWithString: [dateFormatter stringFromDate:eDate]];
//		endDate =[[dateFormatter dateFromString:modString] copy];
//		
//	}@catch (NSException *exception) {
//		NSLog(@"main: Caught %@: %@", [exception name], [exception  reason]);
//		endDate = eDate;
//	}
    
    endDate = eDate;
	
}

- (int)getDateFormatSetting
{
	NSString *settingsPath = [[NSBundle bundleWithIdentifier: @"com.primomedia.TrackAndBill"] pathForResource:@"tbSettings" ofType:@"plist"];
	NSMutableDictionary * settingsDict;
	settingsDict = [NSMutableDictionary dictionaryWithContentsOfFile:settingsPath];
	
	NSLog(@"date format is = %d",[[settingsDict objectForKey:@"dateFormat"] intValue] );
	
	return [[settingsDict objectForKey:@"dateFormat"] intValue] ;
	
}


// Saving and loading data
- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: projectName forKey:@"projectName"];
	[coder encodeObject: clientName forKey:@"clientName"];
	[coder encodeObject: startDate forKey:@"startDate"];
	[coder encodeObject: endDate forKey:@"endDate"];
	[coder encodeObject: totalTime forKey:@"totalTime"];
	[coder encodeObject: projectID forKey:@"projectID"];
	[coder encodeObject: clientID forKey:@"clientID"];

}


- (id) initWithCoder: (NSCoder *)coder
{
	if (self = [super init])
	{
		[self setProjectName: [coder decodeObjectForKey:@"projectName"]];
		[self setClientName:[coder decodeObjectForKey:@"clientName"]];
		[self setStartDate:[coder decodeObjectForKey:@"startDate"]];
		[self setEndDate:[coder decodeObjectForKey:@"endDate"]];
		[self setTotalTime:[coder decodeObjectForKey:@"totalTime"]];
		[self setProjectID:[coder decodeObjectForKey:@"projectID"]];
		[self setClientID:[coder decodeObjectForKey:@"clientID"]];
	}
	return self;
}


- (void)dealloc
{

	//[super dealloc];
}

@end
