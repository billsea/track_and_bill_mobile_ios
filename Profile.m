//
//  Profile.m
//  TrackAndBill_OSX
//
//  Created by Bill on 12/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "Profile.h"


@implementation Profile

- (id)init
{
	//[super init];
	[self setProfileName:@""];
	[self setProfileAddress:@""];
	[self setProfileCity:@""];
	[self setProfileState:@""];
	[self setProfileZip:@""];
	[self setProfilePhone:@""];
	[self setProfileEmail:@""];
	[self setProfileContact:@""];
	return self;
}



-(NSString *)profileName
{
	return profileName;	
}
-(NSString *)profileAddress
{
	return profileAddress;	
}
- (NSString *)profileCity
{
	return profileCity;	
}
- (NSString *)profileState
{
	return profileState;	
}
- (NSString *)profileZip
{
	return profileZip;	
}
- (NSString *)profilePhone
{
	return profilePhone;	
}
- (NSString *)profileEmail
{
	return profileEmail;	
}
- (NSString *)profileContact
{
	return profileContact;	
}


- (void)setProfileName:(NSString *)pName
{
	pName = [pName copy]; 
	
	profileName = pName;
}
- (void)setProfileAddress:(NSString *)pAddress
{
	pAddress = [pAddress copy]; 
	
	profileAddress = pAddress;
}
- (void)setProfileCity:(NSString *)pCity
{
	pCity = [pCity copy]; 
	
	profileCity = pCity;
}
- (void)setProfileState:(NSString *)pState
{
	pState = [pState copy]; 
	
	profileState = pState;
}
- (void)setProfileZip:(NSString *)pZip
{
	pZip = [pZip copy]; 
	
	profileZip = pZip;
}
- (void)setProfilePhone:(NSString *)pPhone
{
	pPhone = [pPhone copy]; 
	
	profilePhone = pPhone;
}
- (void)setProfileEmail:(NSString *)pEmail
{
	pEmail = [pEmail copy]; 
	
	profileEmail= pEmail;
}
- (void)setProfileContact:(NSString *)pContact
{
	pContact = [pContact copy]; 
	
	profileContact = pContact;
}

// Saving and loading data

//save
- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: profileName forKey:@"profileName"];
	[coder encodeObject: profileAddress forKey:@"profileAddress"];
	[coder encodeObject: profileCity forKey:@"profileCity"];
	[coder encodeObject: profileState forKey:@"profileState"];
	[coder encodeObject: profileZip forKey:@"profileZip"];
	[coder encodeObject: profilePhone forKey:@"profilePhone"];
	[coder encodeObject: profileEmail forKey:@"profileEmail"];
	[coder encodeObject: profileContact forKey:@"profileContact"];

}

//load from file
- (id) initWithCoder: (NSCoder *)coder
{
	if (self = [super init])
	{
		
		[self setProfileName: [coder decodeObjectForKey:@"profileName"]];
		[self setProfileAddress: [coder decodeObjectForKey:@"profileAddress"]];
		[self setProfileCity: [coder decodeObjectForKey:@"profileCity"]];
		[self setProfileState: [coder decodeObjectForKey:@"profileState"]];
		[self setProfileZip: [coder decodeObjectForKey:@"profileZip"]];
		[self setProfilePhone: [coder decodeObjectForKey:@"profilePhone"]];
		[self setProfileEmail: [coder decodeObjectForKey:@"profileEmail"]];
		[self setProfileContact: [coder decodeObjectForKey:@"profileContact"]];
		
	}
	return self;
}
@end
