//
//  Client.m
//  TrackAndBill_OSX
//
//  Created by Bill on 11/8/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "Client.h"


@implementation Client
- (id)init
{
	[self setCompanyName:@"New Company"];
	[self setContactName:@"name"];
	[self setEmail:@"email"];
	[self setStreet:@"street"];
	[self setCity:@"city"];
	[self setCountry:@"country"];
	[self setState:@"state"];
	[self setPostalCode:@"zip"];
	[self setPhoneNumber:@"phone"];

	
	return self;
}


-(NSString *)company;
{
	return company;
}
-(NSString *)contactName
{
	return contactName;
}
-(NSString *)email
{
	return email;
}
-(NSString *)streetAddress
{
	return streetAddress;
}
-(NSString *)city
{
	return city;
}
-(NSString *)country
{
	return country;
}
-(NSString *)state
{
	return state;
}
-(NSString *)postalCode
{
	return postalCode;
}
-(NSString *)phoneNumber
{
	return phoneNumber;
}
-(NSNumber *)clientID;
{
	return clientID;
}

//Methods

- (void)setClientID:(NSNumber *)cID
{
	cID= [cID copy];
	clientID = cID;
}

- (void)setCompanyName:(NSString *)pCompany
{
	pCompany= [pCompany copy];
	company = pCompany;
}
- (void)setContactName:(NSString *)pContact
{
	contactName = pContact;
}
- (void)setEmail:(NSString *)pEmail
{
	pEmail= [pEmail copy];
	email = pEmail;
}
- (void)setStreet:(NSString *)pStreet
{
	pStreet= [pStreet copy];
	streetAddress = pStreet;
}
- (void)setCity:(NSString *)pCity
{
	pCity= [pCity copy];
	city = pCity;
}
- (void)setCountry:(NSString *)pCountry
{
	pCountry= [pCountry copy];
	country = pCountry;
}
- (void)setState:(NSString *)pState
{
	pState= [pState copy];
	state = pState;
}
- (void)setPostalCode:(NSString *)pPostal
{
	pPostal= [pPostal copy];
	postalCode = pPostal;
}
- (void)setPhoneNumber:(NSString *)pPhone
{
	pPhone= [pPhone copy];
	phoneNumber = pPhone;
}

// Saving and loading data
- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: company forKey:@"company"];
	[coder encodeObject: contactName forKey:@"contactName"];
	[coder encodeObject: email forKey:@"email"];
	[coder encodeObject: streetAddress forKey:@"streetAddress"];
	[coder encodeObject: city forKey:@"city"];
	[coder encodeObject: country forKey:@"country"];
	[coder encodeObject: state forKey:@"state"];
	[coder encodeObject: postalCode forKey:@"postalCode"];
	[coder encodeObject: phoneNumber forKey:@"phoneNumber"];
	[coder encodeObject: clientID forKey:@"clientID"];
	
}


- (id) initWithCoder: (NSCoder *)coder
{
	if (self = [super init])
	{

		[self setCompanyName: [coder decodeObjectForKey:@"company"]];
		[self setContactName: [coder decodeObjectForKey:@"contactName"]];
		[self setEmail: [coder decodeObjectForKey:@"email"]];
		[self setStreet: [coder decodeObjectForKey:@"streetAddress"]];
		[self setCity: [coder decodeObjectForKey:@"city"]];
		[self setCountry: [coder decodeObjectForKey:@"country"]];
		[self setState: [coder decodeObjectForKey:@"state"]];
		[self setPostalCode: [coder decodeObjectForKey:@"postalCode"]];
		[self setPhoneNumber: [coder decodeObjectForKey:@"phoneNumber"]];
		[self setClientID: [coder decodeObjectForKey:@"clientID"]];
	}
	return self;
}


- (void)dealloc
{

}

@end
