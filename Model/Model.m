//
//  Model.m
//  trackandbill_ios
//
//  Created by Loud on 3/27/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "Model.h"
#import "AppDelegate.h"


@implementation Model

//TODO DATA
+ (NSMutableArray*)loadInvoicesWithSelected:(Invoice*)selectedInvoice andProject:(Project*)selectedProject andEdit:(BOOL)isEdit{
	NSMutableArray* invoiceFormFields = [[NSMutableArray alloc] init];
//
//	NSDateFormatter *df = [[NSDateFormatter alloc] init];
//	[df setDateFormat:@"MM/dd/yyyy"];
//
//
//	// calculate hours,minutes, seconds from seconds
//	NSNumber *hours = [[NSNumber alloc] init];
//	NSNumber *minutes = [[NSNumber alloc] init];
//	NSNumber *seconds = [[NSNumber alloc] init];
//	NSNumber *miles = [[NSNumber alloc] init];
//	[self projectTotalsWithProject:selectedProject andHours:&hours andMinutes:&minutes andSeconds:&seconds andMiles:&miles];
//
//	// create long string with all notes, materials
//	AppDelegate *appDelegate =
//	(AppDelegate *)[UIApplication sharedApplication].delegate;
//
//	NSString *allNotes = [[NSString alloc] init];
//	NSString *allMaterials = [[NSString alloc] init];
//
//	if(!isEdit){
//		for (Session *s in [appDelegate storedSessions]) {
//			if (s.projectIDref == selectedProject.projectID) {
//				allNotes = [allNotes
//										stringByAppendingString:
//										[NSString stringWithFormat:@"%@:%@\n",
//										 [df stringFromDate:s.sessionDate],
//										 s.txtNotes]];
//
//				if (![s.materials isEqualToString:@""]) {
//					allMaterials = [allMaterials
//													stringByAppendingString:
//													[NSString stringWithFormat:@"%@:%@\n",
//													 [df stringFromDate:s.sessionDate],
//													 s.materials]];
//				}
//			}
//		}
//	}
//
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Number", @"FieldName", [NSString stringWithFormat:@"%@", isEdit ? [selectedInvoice invoiceNumber]: [self createInvoiceNumber]],@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Date", @"FieldName", isEdit ? [df stringFromDate:selectedInvoice.invoiceDate] : [df stringFromDate:[NSDate date]],@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Client Name", @"FieldName", isEdit ? [selectedInvoice clientName] : [selectedProject clientName],@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Project Name", @"FieldName", isEdit ? [selectedInvoice projectName] : [selectedProject projectName],@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Start Date", @"FieldName", isEdit ? [df stringFromDate:[selectedInvoice startDate]] : [df stringFromDate:[selectedProject startDate]],@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"End Date", @"FieldName", isEdit ? [df stringFromDate:[selectedInvoice endDate]] : [df stringFromDate:[selectedProject endDate]],@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Approval Name", @"FieldName", isEdit ? [selectedInvoice approvalName] : @"",@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Milage", @"FieldName", isEdit ? [NSString stringWithFormat:@"%@", [selectedInvoice milage]] : [NSString stringWithFormat:@"%@", miles],@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Milage Rate", @"FieldName", isEdit ? [NSString stringWithFormat:@"%@", [selectedInvoice milageRate]] : @"0",@"FieldValue", nil]];
//
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Notes", @"FieldName", isEdit ? [selectedInvoice invoiceNotes] : allNotes ,@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Materials", @"FieldName", isEdit ? [selectedInvoice invoiceMaterials] : allMaterials ,@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Materials Total", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", [selectedInvoice materialsTotal]] : @"0",@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Total Hours:Minutes:Seconds", @"FieldName",isEdit ? [selectedInvoice totalTime] : [NSString																																									stringWithFormat:@"%@",																																									[NSString stringWithFormat:@"%2@:%2@:%4@", hours,																																									 minutes, seconds]],@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Terms", @"FieldName", isEdit ? [selectedInvoice invoiceTerms] : @"",@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Deposit", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", [selectedInvoice invoiceDeposit]] : @"0",@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Rate", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", [selectedInvoice invoiceRate]] : @"0",@"FieldValue", nil]];
//	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Check #", @"FieldName", isEdit ? [selectedInvoice checkNumber] : @"",@"FieldValue", nil]];
//
	return invoiceFormFields;
}
//
+ (void)projectTotalsWithProject:(Project*)selectedProject
//										andHours:(NSNumber **)hours
										andMinutes:(NSNumber **)minutes
										andSeconds:(NSNumber **)seconds
											andMiles:(NSNumber **)miles{
//	AppDelegate *appDelegate =
//	(AppDelegate *)[UIApplication sharedApplication].delegate;
//	int ml = 0;
//	int ticks = 0;
//	for (Session *s in [appDelegate storedSessions]) {
//		if ([s projectIDref] == [selectedProject projectID]) {
//
//			ticks = ticks + s.sessionHours.intValue * 3600;
//			ticks = ticks + s.sessionMinutes.intValue * 60;
//			ticks = ticks + s.sessionSeconds.intValue;
//			ml = ml + s.milage.intValue;
//		}
//	}
//
//	double sec = fmod(ticks, 60.0);
//	double m = fmod(trunc(ticks / 60.0), 60.0);
//	double h = trunc(ticks / 3600.0);
//
//	*hours = [NSNumber numberWithDouble:h];
//	*minutes = [NSNumber numberWithDouble:m];
//	*seconds = [NSNumber numberWithDouble:sec];
//	*miles = [NSNumber numberWithInt:ml];
}

// create invoice number based on last invoice number
+ (NSNumber *)createInvoiceNumber {
//	AppDelegate *appDelegate =
//	(AppDelegate *)[UIApplication sharedApplication].delegate;
//	int invNumber;
//	int tempNumber;
//	int i;
//	NSNumber *lastNumber;
//
//	if ([[appDelegate arrInvoices] count] == 0) {
//		return [NSNumber numberWithInt:1];
//	} else {
//
//		Invoice *tInvoice = [[Invoice alloc] init];
//		tempNumber = 0;
//
//		for (i = 0; i < [[appDelegate arrInvoices] count]; i++) {
//
//			tInvoice = [[appDelegate arrInvoices] objectAtIndex:i];
//			lastNumber = [tInvoice invoiceNumber];
//			if ([lastNumber intValue] > tempNumber) {
//				tempNumber = [lastNumber intValue];
//			}
//		}
//		// set new invoice number to the highest invoice number found, plus one.
//		invNumber = tempNumber;
//		invNumber++;
//		return [NSNumber numberWithInt:invNumber];
//	}
	
	return [NSNumber numberWithInt:0];
}

@end
