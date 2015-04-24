//
//  Profile.h
//  TrackAndBill_OSX
//
//  Created by Bill on 12/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>


@interface Profile : NSObject <NSCoding>{
	
	NSString *profileName;
	NSString *profileAddress;
	NSString *profileCity;
	NSString *profileState;
	NSString *profileZip;
	NSString *profilePhone;
	NSString *profileEmail;
	NSString *profileContact;

}


-(NSString *) profileName;
-(NSString *) profileAddress;
-(NSString *) profileCity;
-(NSString *) profileState;
-(NSString *) profileZip;
-(NSString *) profilePhone;
-(NSString *) profileEmail;
-(NSString *) profileContact;

- (void)setProfileName:(NSString *)pName;
- (void)setProfileAddress:(NSString *)pAddress;
- (void)setProfileCity:(NSString *)pCity;
- (void)setProfileState:(NSString *)pState;
- (void)setProfileZip:(NSString *)pZip;
- (void)setProfilePhone:(NSString *)pPhone;
- (void)setProfileEmail:(NSString *)pEmail;
- (void)setProfileContact:(NSString *)pContact;
- (void) encodeWithCoder: (NSCoder *)coder;
- (id) initWithCoder: (NSCoder *)coder;
@end
