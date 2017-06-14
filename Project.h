//
//  Project.h
//  TrackAndBill_OSX
//
//  Created by Bill on 11/4/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface Project : NSObject <NSCoding> {
  NSString *projectName;
  NSString *clientName;
  NSDate *startDate;
  NSDate *endDate;
  NSString *totalTime;
  NSNumber *projectID;
  NSNumber *clientID;
}

- (NSString *)projectName;
- (NSString *)clientName;
- (NSDate *)startDate;
- (NSDate *)endDate;
- (NSString *)totalTime;
- (NSNumber *)projectID;
- (NSNumber *)clientID;

- (void)setProjectName:(NSString *)pName;
- (void)setClientName:(NSString *)cName;
- (void)setStartDate:(NSDate *)sDate;
- (void)setEndDate:(NSDate *)eDate;
- (void)setTotalTime:(NSString *)tTime;
- (void)setProjectID:(NSNumber *)pID;
- (void)setClientID:(NSNumber *)cID;
- (int)getDateFormatSetting;

@end
