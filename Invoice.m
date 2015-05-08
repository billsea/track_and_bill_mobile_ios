//
//  Invoice.m
//  TrackAndBill_OSX
//
//  Created by Bill on 11/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "Invoice.h"


@implementation Invoice

- (id)init
{
	//[super init];
	NSDate *stDate = [NSDate date];
	[self setInvoiceDate:stDate];
	[self setInvoiceDeposit:0.00];
	[self setMaterialsTotal:0.00];
	[self setInvoiceMaterials:@"None"];
	[self setCheckNumber:@"-"];
	[self setInvoiceTerms:@"Net 15"];
    [self setStartDate:stDate];
    [self setEndDate:stDate];
    [self setInvoiceNotes:@""];
	[self setInvoiceMaterials:@""];
    [self setInvoiceTerms:@""];
	
	
	return self;
}
- (NSNumber *)invoiceNumber
{
	return invoiceNumber;
}
- (NSString *)SinvoiceRate;
{
	return SinvoiceRate;
}
- (NSString *)checkNumber
{
	return checkNumber;
}
- (float)totalDue
{
	return totalDue;
}
- (NSString *)StotalDue
{
	return StotalDue;
}
- (double)invoiceRate
{
	return invoiceRate;
}

- (NSNumber *)projectID
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

- (NSString *)approvalName
{
	return approvalName;
}
- (NSString *)invoiceTerms
{
	return invoiceTerms;
}
- (NSString *)invoiceNotes
{
	return invoiceNotes;
}
- (NSString *)invoiceMaterials
{
	return invoiceMaterials;
}
- (NSString *)SmaterialsTotal
{
	return SmaterialsTotal;
}

- (float)materialsTotal
{
	return materialsTotal;
}
- (float)invoiceDeposit
{
	return invoiceDeposit;
}
- (float)grandTotal
{
	return grandTotal;
}
- (NSString *)SgrandTotal
{
	return SgrandTotal;
}
- (NSString *)SinvoiceDeposit
{
	return SinvoiceDeposit;
}
- (NSString *)totalTime
{
	return totalTime;
}

- (NSDate *)startDate
{
	return startDate;
	
}
- (NSDate *)invoiceDate
{
	return invoiceDate;
	
}
- (NSDate *)endDate
{
	return endDate;
}

-(NSNumber *)milage
{
    return milage;
}

/////////// Set variables //////////////////////
- (void)setProjectID:(NSNumber *)pID
{
	pID= [pID copy]; //if passed string is mutable, "copy" converts it to immutable string

	projectID = pID;
}

- (void)setClientID:(NSNumber *)cID
{
	cID= [cID copy];
	
	clientID = cID;
}

- (void)setTotalTime:(NSString *)tTime
{
	tTime= [tTime copy];
	
	totalTime = tTime;
}
- (void)setProjectName:(NSString *)pName
{
	pName = [pName copy]; 
	
	projectName = pName;
	
}
- (void)setClientName:(NSString *)cName
{
	cName= [cName copy];
	
	clientName = cName;
}

- (void)setStartDate:(NSDate *)sDate
{
	sDate = [sDate copy];

	
//	NSDateFormatter *dateFormatter = [NSDateFormatter alloc];
//	@try
//	{
//		if ([self getDateFormatSetting]==1){
//            [dateFormatter setDateFormat:@"%m/%d/%y"];
//			//[dateFormatter initWithDateFormat:@"%d/%m/%y" allowNaturalLanguage:NO];
//		}else{
//            [dateFormatter setDateFormat:@"%m/%d/%y"];
//			//[dateFormatter initWithDateFormat:@"%m/%d/%y" allowNaturalLanguage:NO];
//		}
//		
//		NSString *modString = [[NSString alloc] initWithString: [dateFormatter stringFromDate:sDate]];
//		startDate =[[dateFormatter dateFromString:modString] copy];
//		
//	}@catch (NSException *exception) {
//		NSLog(@"main: Caught %@: %@", [exception name], [exception  reason]);
		startDate = sDate;
//	}

}
- (void)setEndDate:(NSDate *)eDate
{
	eDate = [eDate copy];

//	NSDateFormatter * df = [[NSDateFormatter alloc] init];
//    
//	@try
//	{
//        [df setDateFormat:@"MM/dd/yyyy"];
//        
////		if ([self getDateFormatSetting]==1){
////            [dateFormatter setDateFormat:@"%m/%d/%y"];
////			//[dateFormatter initWithDateFormat:@"%d/%m/%y" allowNaturalLanguage:NO];
////		}else{
////            [dateFormatter setDateFormat:@"%m/%d/%y"];
////			//[dateFormatter initWithDateFormat:@"%m/%d/%y" allowNaturalLanguage:NO];
////		}
//		
//		NSString *modString = [[NSString alloc] initWithString: [df stringFromDate:eDate]];
//		endDate =[[df dateFromString:modString] copy];
//		
//	}@catch (NSException *exception) {
//		NSLog(@"main: Caught %@: %@", [exception name], [exception  reason]);
		endDate = eDate;
	//}
	
	
	
}
- (void)setInvoiceDate:(NSDate *)iDate
{
	iDate = [iDate copy];

    NSDateFormatter * df = [[NSDateFormatter alloc] init];
	@try
	{
    
        [df setDateFormat:@"MM/dd/yyyy"];
    
//get date format preference - TODO
//		if ([self getDateFormatSetting]==1){
//            [dateFormatter setDateFormat:@"%m/%d/%y"];
//			//[dateFormatter initWithDateFormat:@"%d/%m/%y" allowNaturalLanguage:NO];
//		}else{
//            [dateFormatter setDateFormat:@"%m/%d/%y"];
//			//[dateFormatter initWithDateFormat:@"%m/%d/%y" allowNaturalLanguage:NO];
//		}
//		
		NSString *modString = [[NSString alloc] initWithString: [df stringFromDate:iDate]];
		invoiceDate =[[df dateFromString:modString] copy];
		
	}@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception  reason]);
		invoiceDate = iDate;
	}
}


- (void)setInvoiceNumber:(NSNumber *)iNumber;
{
	iNumber = [iNumber copy];

	invoiceNumber = iNumber;
}
- (void)setTotalDue:(float)totDue;
{
	totalDue = totDue;
	[self setStotalDue:[NSString stringWithFormat:@"%1.2f",totalDue]];
	[self setGrandTotal];
}

- (void)setStotalDue:(NSString *)Sdue

{

	StotalDue = Sdue;
}
//compute rate * total hours
- (void)computeTotalDue
{
	NSRange aRange1;
	NSRange aRange2;
	float tDue;
	int h,m,s;
	
	NSString *subStr = @":";
	aRange1=[totalTime rangeOfString:subStr];
	aRange2=[totalTime rangeOfString:subStr options:(NSBackwardsSearch)];
	
	
	NSString *sH =[[NSString alloc] init];
	sH =  [totalTime substringToIndex:aRange1.location];
	h = [sH intValue];
	
	NSString *sS =[[NSString alloc] init];
	sS = [totalTime substringFromIndex:aRange2.location + 1];
	s=[sS intValue];
	
	NSString *sTemp =[[NSString alloc] init];
	sTemp = [totalTime substringToIndex:aRange2.location];
	
	NSString *sM =[[NSString alloc] init];
	sM=  [sTemp substringFromIndex:aRange1.location + 1];
	m = [sM intValue];
	
	
	tDue = invoiceRate * h;
	tDue = tDue + ((invoiceRate/60) * m);
	tDue = tDue + ((invoiceRate/3600) * s);
	
	[self setTotalDue:tDue];
}

- (void)setInvoiceRate:(double)sRate;
{
	invoiceRate = sRate;
	[self computeTotalDue];
	[self setSinvoiceRate:[NSString stringWithFormat:@"%1.2f",invoiceRate]];
}
- (void)setSinvoiceRate:(NSString *)Srate
{
	SinvoiceRate = Srate;
}
- (void)setCheckNumber:(NSString *)checkNum;
{
	checkNum = [checkNum copy];

	checkNumber = checkNum;
}
- (void)setApprovalName:(NSString *)appName
{
	appName = [appName copy];
	
	approvalName = appName;
}
- (void)setInvoiceTerms:(NSString *)iTerms
{
	iTerms = [iTerms copy];

	invoiceTerms = iTerms;	
}
- (void)setInvoiceNotes:(NSString *)iNotes
{
	iNotes = [iNotes copy];

	invoiceNotes = iNotes;	
}
- (void)setInvoiceMaterials:(NSString *)iMaterials
{
	iMaterials = [iMaterials copy];

	invoiceMaterials = iMaterials;	
}
- (void)setMaterialsTotal:(double)mTotal
{
	materialsTotal = mTotal;
	[self setSmaterialsTotal:[NSString stringWithFormat:@"%1.2f",materialsTotal]];
}
- (void)setSmaterialsTotal:(NSString *)SmatTotal
{

	SmaterialsTotal = SmatTotal;
}

- (void)setMilage:(NSNumber *)miles
{
    miles = [miles copy];
    milage = miles;
}

- (void)setInvoiceDeposit:(double)iDeposit
{
	invoiceDeposit = iDeposit;
	[self setSinvoiceDeposit:[NSString stringWithFormat:@"%1.2f", invoiceDeposit]];
}
- (void)setSinvoiceDeposit:(NSString *)Sdep
{

	SinvoiceDeposit = Sdep;
}
- (void)setGrandTotal
{
	grandTotal = (totalDue + materialsTotal) - invoiceDeposit;
	[self setSgrandTotal:[NSString stringWithFormat:@"%1.2f", grandTotal]];
}
- (void)setSgrandTotal:(NSString *)grdTotal
{
	SgrandTotal = grdTotal;
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
	[coder encodeObject: invoiceNumber forKey:@"invoiceNumber"];
	[coder encodeObject: projectName forKey:@"projectName"];
	[coder encodeObject: clientName forKey:@"clientName"];
	[coder encodeObject: startDate forKey:@"startDate"];
	[coder encodeObject: endDate forKey:@"endDate"];
	[coder encodeObject: invoiceDate forKey:@"invoiceDate"];
	[coder encodeObject: totalTime forKey:@"totalTime"];
	[coder encodeObject: projectID forKey:@"projectID"];
	[coder encodeObject: clientID forKey:@"clientID"];
	[coder encodeObject: checkNumber forKey:@"checkNumber"];
	[coder encodeObject: approvalName forKey:@"approvalName"];
	[coder encodeObject: invoiceTerms forKey:@"invoiceTerms"];
	[coder encodeObject: invoiceNotes forKey:@"invoiceNotes"];
	[coder encodeObject: invoiceMaterials forKey:@"invoiceMaterials"];
	[coder encodeObject: [NSString stringWithFormat:@"%1.2f",materialsTotal] forKey:@"materialsTotal"];
	[coder encodeObject: [NSString stringWithFormat:@"%1.2f",invoiceDeposit] forKey:@"invoiceDeposit"];
	[coder encodeObject: [NSString stringWithFormat:@"%1.2f",totalDue] forKey:@"totalDue"];
	[coder encodeObject: [NSString stringWithFormat:@"%1.2f",invoiceRate] forKey:@"invoiceRate"];
		
}


- (id) initWithCoder: (NSCoder *)coder
{
	if (self = [super init])
	{
		double sRate1;
		
		[self setInvoiceNumber: [coder decodeObjectForKey:@"invoiceNumber"]];
		[self setProjectName: [coder decodeObjectForKey:@"projectName"]];
		[self setClientName: [coder decodeObjectForKey:@"clientName"]];
		[self setStartDate: [coder decodeObjectForKey:@"startDate"]];
		[self setEndDate: [coder decodeObjectForKey:@"endDate"]];
		[self setInvoiceDate: [coder decodeObjectForKey:@"invoiceDate"]];
		[self setTotalTime: [coder decodeObjectForKey:@"totalTime"]];
		[self setProjectID: [coder decodeObjectForKey:@"projectID"]];
		[self setClientID: [coder decodeObjectForKey:@"clientID"]];
		[self setCheckNumber: [coder decodeObjectForKey:@"checkNumber"]];
		[self setApprovalName: [coder decodeObjectForKey:@"approvalName"]];
		[self setInvoiceTerms: [coder decodeObjectForKey:@"invoiceTerms"]];
		[self setInvoiceNotes: [coder decodeObjectForKey:@"invoiceNotes"]];
		[self setInvoiceMaterials: [coder decodeObjectForKey:@"invoiceMaterials"]];
		
		if ([coder decodeObjectForKey:@"materialsTotal"] != nil){
			NSString *sM =[[NSString alloc] initWithString:[coder decodeObjectForKey:@"materialsTotal"]];
			sRate1 = [sM floatValue];
			[self setMaterialsTotal: sRate1];
		}

		if ([coder decodeObjectForKey:@"invoiceDeposit"] != nil){
			NSString *sI =[[NSString alloc] initWithString:[coder decodeObjectForKey:@"invoiceDeposit"]];
			sRate1 = [sI floatValue];
			[self setInvoiceDeposit: sRate1];
		}
		
		if ([coder decodeObjectForKey:@"totalDue"] != nil){
			NSString *sT =[[NSString alloc] initWithString:[coder decodeObjectForKey:@"totalDue"]];
			sRate1 = [sT floatValue];
			[self setTotalDue: sRate1];
		}
		
		if ([coder decodeObjectForKey:@"invoiceRate"] != nil){
			NSString *sH =[[NSString alloc] initWithString:[coder decodeObjectForKey:@"invoiceRate"]];
			sRate1 = [sH floatValue];
			[self setInvoiceRate:  sRate1];
		}

	}
	return self;
}
@end
