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

	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Number", @"FieldName", [NSString stringWithFormat:@"%d", isEdit ? selectedInvoice.number : [self createInvoiceNumber]],@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Date", @"FieldName", isEdit ? [df stringFromDate:selectedInvoice.date] : [df stringFromDate:[NSDate date]],@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Client Name", @"FieldName", selClient.name,@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Project Name", @"FieldName",selectedProject.name, @"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Approval Name", @"FieldName", selectedInvoice.approvedby ,@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Milage", @"FieldName",  [NSString stringWithFormat:@"%@", miles], @"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Milage Rate", @"FieldName", isEdit ? [NSString stringWithFormat:@"%f", selectedInvoice.milage_rate] : @"0",@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Notes", @"FieldName", isEdit ? selectedInvoice.notes : allNotes , @"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Materials", @"FieldName", allMaterials ,@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Materials Total", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", selectedInvoice.materials_cost] : @"0",@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Total Hours:Minutes:Seconds", @"FieldName",[NSString	stringWithFormat:@"%@",[NSString stringWithFormat:@"%2@:%2@:%4@", hours, minutes, seconds]],@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Terms", @"FieldName", isEdit ? selectedInvoice.terms : @"",@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Deposit", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", selectedInvoice.deposit] : @"0",@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Rate", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", selectedInvoice.rate] : @"0",@"FieldValue", nil]];
	[invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Check #", @"FieldName", isEdit ? selectedInvoice.check : @"",@"FieldValue", nil]];

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
+ (int)createInvoiceNumber {
	int invNumber;
	int tempNumber;

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
