//
//  Session.h
//  TrackAndBill_OSX
//
//  Created by Bill on 11/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface Session : NSObject <NSCoding> {

  NSString *projectName;
  NSString *clientName;
  NSDate *sessionDate;
  NSDate *startTime;
  NSDate *endTime;
  // NSButtonCell *startClock;
  // NSButtonCell *textNotes; //for text and audio notes
  NSString *txtNotes;
  NSNumber *milage;
  NSNumber *projectIDref;
  NSNumber *sessionID;

  NSNumber *sessionHours;
  NSNumber *sessionMinutes;
  NSNumber *sessionSeconds;

  NSString *materials;

  float _ticks;
}

@property(weak) NSTimer *sessionTimer;
@property BOOL TimerRunning;
@property NSString *timerValue;

- (NSString *)projectName;
- (NSString *)clientName;
- (NSDate *)sessionDate;
- (NSString *)startTime;
- (NSString *)endTime;
- (NSString *)txtNotes;
- (NSNumber *)milage;
- (NSNumber *)projectIDref;
- (NSNumber *)sessionID;
- (NSNumber *)sessionHours;
- (NSNumber *)sessionMinutes;
- (NSNumber *)sessionSeconds;
- (NSString *)materials;
- (float)ticks;

- (void)setProjectName:(NSString *)pName;
- (void)setClientName:(NSString *)cName;
- (void)setSessionDate:(NSDate *)sDate;
- (void)setStartTime:(NSDate *)sTime;
- (void)setEndTime:(NSDate *)eTime;
- (void)setTxtNotes:(NSString *)tNotes;
- (void)setMilage:(NSNumber *)sMilage;
- (void)setProjectIDref:(NSNumber *)pIDref;
- (void)setSessionID:(NSNumber *)sID;
- (int)getDateFormatSetting;
- (void)setSessionHours:(NSNumber *)hours;
- (void)setSessionMinutes:(NSNumber *)minutes;
- (void)setSessionSeconds:(NSNumber *)seconds;
- (void)setMaterials:(NSString *)pMaterials;
- (void)startTimer;
- (void)stopTimer;
- (void)setTicks:(float)nTicks;
@end
