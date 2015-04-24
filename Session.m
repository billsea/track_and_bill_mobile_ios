//
//  Session.m
//  TrackAndBill_OSX
//
//  Created by Bill on 11/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "Session.h"


@implementation Session

@synthesize sessionTimer = _sessionTimer;
@synthesize TimerRunning = _TimerRunning;
@synthesize timerValue = _timerValue;



- (id)init
{
	//[super init];
	[self setProjectName:@""];
	[self setClientName:@""];
	
	NSDate *stTime = nil; //[NSDate date];
	[self setSessionDate:[NSDate date]];
	[self setStartTime:stTime];
	[self setEndTime:stTime];
	[self setTxtNotes:@""];
    [self setSessionHours:[NSNumber numberWithInt:0]];
    [self setSessionMinutes:[NSNumber numberWithInt:0]];
    [self setSessionSeconds:[NSNumber numberWithInt:0]];
    [self setMaterials:@""];
    
     self.timerValue = [NSString stringWithFormat:@"%02.0f:%02.0f:%04.1f",0.0, 0.0, 0.0];
    _TimerRunning = FALSE;
	
	return self;
}

- (NSString *)projectName
{
	return projectName;
}
- (NSNumber *)milage
{
    return milage;
}
- (NSNumber *)projectIDref
{
	return projectIDref;
}
- (NSNumber *)sessionID
{
	return sessionID;
}

- (NSString *)clientName
{
	return clientName;
}

- (NSString *)txtNotes
{
	return txtNotes;
}

- (NSDate *)sessionDate
{
	return sessionDate;
}

- (NSDate *)startTime
{
	return startTime;
}
- (NSDate *)endTime
{
	return endTime;
}

- (NSNumber *)sessionHours
{
    return sessionHours;
}

- (NSNumber *)sessionMinutes
{
    return sessionMinutes;
}

- (NSNumber *)sessionSeconds
{
    return sessionSeconds;
}
- (NSString *)materials
{
    return materials;
}
//- (NSButtonCell *)startClock
//{
//	return startClock;
//}
//- (NSButtonCell *)textNotes
//{
//	return textNotes;
//}


//////// Methods ////////
- (void)setProjectName:(NSString *)pName
{
	pName = [pName copy];

	projectName = pName;
}

- (void)setMilage:(NSNumber *)sMilage
{
    sMilage = [sMilage copy];
    milage = sMilage;
}

- (void)setProjectIDref:(NSNumber *)pIDref
{
	pIDref = [pIDref copy];

	projectIDref = pIDref;
}
- (void)setClientName:(NSString *)cName
{
	cName = [cName copy];

	clientName = cName;
}

- (void)setMaterials:(NSString *)pMaterials
{
    pMaterials = [pMaterials copy];
    
    materials = pMaterials;
}

- (void)setSessionDate:(NSDate *)sDate
{	
	sDate = [sDate copy];

	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	@try
	{
		if ([self getDateFormatSetting]==1){
            [dateFormatter setDateFormat:@"%m/%d/%y"];
			//[dateFormatter initWithDateFormat:@"%d/%m/%y" allowNaturalLanguage:NO];
		}else{
            [dateFormatter setDateFormat:@"%m/%d/%y"];
			//[dateFormatter initWithDateFormat:@"%m/%d/%y" allowNaturalLanguage:NO];
		}
		
		NSString *modString = [[NSString alloc] initWithString: [dateFormatter stringFromDate:sDate]];
		sessionDate =[[dateFormatter dateFromString:modString] copy];
		
	}@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception  reason]);
		sessionDate = sDate;
	}
	
}

- (void)setStartTime:(NSDate *)sTime
{
	sTime = [sTime copy];

	startTime = sTime;
}
- (void)setEndTime:(NSDate *)eTime
{
	eTime = [eTime copy];

	endTime = eTime;
}
- (void)setTxtNotes:(NSString *)tNotes
{
	tNotes = [tNotes copy];

	txtNotes = tNotes;
}
- (void)setSessionID:(NSNumber *)sID
{
	sID = [sID copy];

	sessionID = sID;
}

-(void)setSessionHours:(NSNumber *)hours
{
    hours=[hours copy];
    sessionHours = hours;
}

-(void)setSessionMinutes:(NSNumber *)minutes
{
    minutes = [minutes copy];
    sessionMinutes = minutes;
}

-(void)setSessionSeconds:(NSNumber *)seconds
{
    seconds = [seconds copy];
    sessionSeconds = seconds;
}

- (int)getDateFormatSetting
{
	NSString *settingsPath = [[NSBundle bundleWithIdentifier: @"com.loudsoftware.TrackAndBill"] pathForResource:@"tbSettings" ofType:@"plist"];
	NSMutableDictionary * settingsDict;
	settingsDict = [NSMutableDictionary dictionaryWithContentsOfFile:settingsPath];
	
	//NSLog(@"date format is = %d",[[settingsDict objectForKey:@"dateFormat"] intValue] );
	
	return [[settingsDict objectForKey:@"dateFormat"] intValue] ;
	
}

-(void)startTimer
{
    //start timer. 24 hours = 86400 seconds
    //one second interval
    if(![_sessionTimer isValid])
    {
        _sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
    }
    
    _TimerRunning = TRUE;

}

//update seconds, and format as hours:minutes:seconds
-(void)updateClock
{
    _ticks += 1;
    double seconds = fmod(_ticks, 60.0);
    double minutes = fmod(trunc(_ticks / 60.0), 60.0);
    double hours = trunc(_ticks / 3600.0);
    self.timerValue = [NSString stringWithFormat:@"%02.0f:%02.0f:%04.1f", hours, minutes, seconds];
    
    //update class objects
    [self setSessionSeconds:[NSNumber numberWithDouble:seconds]];
    [self setSessionMinutes:[NSNumber numberWithDouble:minutes]];
    [self setSessionHours:[NSNumber numberWithDouble:hours]];
    
   // NSLog(@"%@",[self clientName]);
   // NSLog(@"timer: %@",[NSString stringWithFormat:@"%02.0f:%02.0f:%04.1f", hours, minutes, seconds]);
}

-(void)stopTimer
{

    //stop timer
    [[self sessionTimer] invalidate];
    [self setEndTime:[NSDate date]];
    
    _TimerRunning = FALSE;

}

// Saving and loading data

//save
- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: projectName forKey:@"projectName"];
	[coder encodeObject: clientName forKey:@"clientName"];
	[coder encodeObject: sessionDate forKey:@"sessionDate"];
	[coder encodeObject: startTime forKey:@"startTime"];
	[coder encodeObject: endTime forKey:@"endTime"];
    [coder encodeObject:milage forKey:@"milage"];
	[coder encodeObject: txtNotes forKey:@"txtNotes"];
	[coder encodeObject: projectIDref forKey:@"projectIDref"];
	[coder encodeObject: sessionID forKey:@"sessionID"];
    [coder encodeObject: sessionHours forKey:@"sessionHours"];
    [coder encodeObject: sessionMinutes forKey:@"sessionMinutes"];
    [coder encodeObject: sessionSeconds forKey:@"sessionSeconds"];
	[coder encodeObject: materials forKey:@"materials"];
}

//load from file
- (id) initWithCoder: (NSCoder *)coder
{
	if (self = [super init])
	{
		
		[self setProjectName: [coder decodeObjectForKey:@"projectName"]];
		[self setClientName: [coder decodeObjectForKey:@"clientName"]];
		[self setSessionDate: [coder decodeObjectForKey:@"sessionDate"]];
		[self setStartTime: [coder decodeObjectForKey:@"startTime"]];
		[self setEndTime: [coder decodeObjectForKey:@"endTime"]];
        [self setMilage:[coder decodeObjectForKey:@"milage"]];
		[self setTxtNotes: [coder decodeObjectForKey:@"txtNotes"]];
		[self setProjectIDref: [coder decodeObjectForKey:@"projectIDref"]];
		[self setSessionID: [coder decodeObjectForKey:@"sessionID"]];
        [self setSessionHours: [coder decodeObjectForKey:@"sessionHours"]];
        [self setSessionMinutes: [coder decodeObjectForKey:@"sessionMinutes"]];
        [self setSessionSeconds: [coder decodeObjectForKey:@"sessionSeconds"]];
        [self setMaterials: [coder decodeObjectForKey:@"materials"]];

	}
	return self;
}

- (void)dealloc
{
	
	//[super dealloc];
}
@end
