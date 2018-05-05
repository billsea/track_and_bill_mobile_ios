//
//  Model.m
//  trackandbill_ios
//
//  Created by Loud on 3/27/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "Model.h"
#import "AppDelegate.h"
#import "Client+CoreDataClass.h"

@implementation Model

+ (NSMutableArray* )dataForEntity:(NSString*)entityString {
	AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = app.persistentContainer.viewContext;
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityString];
	NSMutableArray* data = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
	return data;
}

+ (NSMutableArray*)loadInvoicesWithSelected:(Invoice*)selectedInvoice andProject:(Project*)selectedProject andEdit:(BOOL)isEdit{
	NSMutableArray* invoiceFormFields = [[NSMutableArray alloc] init];

	Client *selClient = selectedProject.clients;
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MM/dd/yyyy"];

	// calculate hours,minutes, seconds from seconds
	NSNumber *hours = [[NSNumber alloc] init];
	NSNumber *minutes = [[NSNumber alloc] init];
	NSNumber *seconds = [[NSNumber alloc] init];
	NSNumber *miles = [[NSNumber alloc] init];
	
	[self projectTotalsWithProject:selectedProject andHours:&hours andMinutes:&minutes andSeconds:&seconds andMiles:&miles];

	NSString *allNotes = [[NSString alloc] init];
	NSString *allMaterials = [[NSString alloc] init];

	if(!isEdit){
		for (Session *s in selectedProject.sessions) {
				allNotes = [allNotes
										stringByAppendingString:
										[NSString stringWithFormat:@"%@:%@\n",
										 [df stringFromDate:s.start],
										 s.notes]];

				if (![s.materials isEqualToString:@""]) {
					allMaterials = [allMaterials
													stringByAppendingString:
													[NSString stringWithFormat:@"%@:%@\n",
													 [df stringFromDate:s.start],
													 s.materials]];
				}

		}
	}

	
	//get project end date
	NSArray* allSessions = selectedProject.sessions.allObjects;
	if(allSessions.count > 0) {
		Session* lastSession = allSessions[allSessions.count-1];
		selectedProject.end = lastSession.start;
	}
	
	//0
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"invoice_number", nil), @"FieldName", [NSString stringWithFormat:@"%lld", isEdit ? [selectedInvoice number] : [self createInvoiceNumber]],@"FieldValue", nil]];
	//1
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"invoice_date", nil), @"FieldName", isEdit ? [df stringFromDate:[selectedInvoice date]] : [df stringFromDate:[NSDate date]],@"FieldValue", nil]];
	//2
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"client_name", nil), @"FieldName", isEdit ? selectedInvoice.client_name: selClient.name, @"FieldValue", nil]];
	//3
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"project_name", nil), @"FieldName", isEdit ? selectedInvoice.project_name : selectedProject.name, @"FieldValue", nil]];
	//4
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"start_date", nil), @"FieldName",[df stringFromDate:selectedProject.start], @"FieldValue", nil]];
	//5
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"complete_date", nil), @"FieldName", [df stringFromDate:selectedProject.end], @"FieldValue", nil]];
	//6
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"total_hours_mins_secs", nil), @"FieldName",[NSString	stringWithFormat:@"%@",[NSString stringWithFormat:@"%2@:%2@:%4@", hours, minutes, seconds]],@"FieldValue", nil]];
	//7
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"materials", nil), @"FieldName", allMaterials ,@"FieldValue", nil]];
	//8
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"materials_cost", nil), @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", selectedInvoice.materials_cost] : @"0",@"FieldValue", nil]];
	//9
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"milage", nil), @"FieldName",  [NSString stringWithFormat:@"%@", miles], @"FieldValue", nil]];
	//10
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"milage_rate", nil), @"FieldName", isEdit ? [NSString stringWithFormat:@"%f", selectedInvoice.milage_rate] : @"0",@"FieldValue", nil]];
	//11
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"invoice_rate", nil), @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", selectedInvoice.rate] : @"0",@"FieldValue", nil]];
	//12
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"deposit", nil), @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", selectedInvoice.deposit] : @"0",@"FieldValue", nil]];
	//13
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"terms_of_payment", nil), @"FieldName", isEdit ? selectedInvoice.terms : @"",@"FieldValue", nil]];
	//14
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"approved_by", nil), @"FieldName", selectedInvoice.approvedby ,@"FieldValue", nil]];
	//15
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"check_num", nil), @"FieldName", isEdit ? selectedInvoice.check : @"",@"FieldValue", nil]];
	//16
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"notes", nil), @"FieldName", isEdit ? selectedInvoice.notes : allNotes , @"FieldValue", nil]];

	return invoiceFormFields;
}
//
+ (void)projectTotalsWithProject:(Project*)selectedProject
										andHours:(NSNumber **)hours
										andMinutes:(NSNumber **)minutes
										andSeconds:(NSNumber **)seconds
										andMiles:(NSNumber **)miles{

	int ml = 0;
	int ticks = 0;
	for (Session *s in selectedProject.sessions) {
			ticks = ticks + s.hours * 3600;
			ticks = ticks + s.minutes * 60;
			ticks = ticks + s.seconds;
			ml = ml + s.milage;
	}

	double sec = fmod(ticks, 60.0);
	double m = fmod(trunc(ticks / 60.0), 60.0);
	double h = trunc(ticks / 3600.0);

	*hours = [NSNumber numberWithDouble:h];
	*minutes = [NSNumber numberWithDouble:m];
	*seconds = [NSNumber numberWithDouble:sec];
	*miles = [NSNumber numberWithInt:ml];
}

// create invoice number based on last invoice number
+ (long)createInvoiceNumber {
	long invNumber;
	long tempNumber;

	NSMutableArray* invoices =  [self dataForEntity:@"Invoice"];

	if (invoices.count == 0) {
		return 1;
	} else {
		tempNumber = 0;
		Invoice* lastInvoice = (Invoice*)invoices.lastObject;
		
		if (lastInvoice.number > tempNumber) {
			tempNumber = lastInvoice.number;
		}

		// set new invoice number to the highest invoice number found, plus one.
		invNumber = tempNumber;
		invNumber++;
		return invNumber;
	}
	
	return 0;
}

@end
