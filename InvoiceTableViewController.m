//
//  InvoiceTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/17/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "InvoiceTableViewController.h"
#import "AppDelegate.h"
#import "Session.h"
#import "Profile.h"
#import "TextInputTableViewCell.h"
#import "Client.h"
#define kPadding 2
#define kHeaderPadding 5
#define kMarginPadding 25
#define kTableRowHeight 80

@interface InvoiceTableViewController () {
  CGSize _pageSize;
	NSMutableArray* _invoiceFormFields;
	NSNumber* _invoiceNumberSelected;
}

@property UIBarButtonItem *previewButton;
@property(nonatomic, strong) NSIndexPath *firstDatePickerIndexPath;
@property(nonatomic, strong) NSIndexPath *secondDatePickerIndexPath;
@property(nonatomic, strong) NSIndexPath *thirdDatePickerIndexPath;
@end

@implementation InvoiceTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:@"Invoice"];

  // set background image
  [[self view]
      setBackgroundColor:[UIColor
                             colorWithPatternImage:
                                 [UIImage imageNamed:@"paper_texture_02.png"]]];

  // add help navigation bar button
  self.previewButton = [[UIBarButtonItem alloc]
      // initWithImage:[UIImage imageNamed:@"reload-50.png"]
      initWithTitle:@"Save & Export"
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(exportInvoice:)];
  // self.addClientButton.tintColor = [UIColor blackColor];
  [[self navigationItem] setRightBarButtonItem:self.previewButton];
	
	[self loadForm];
}

- (void)viewDidUnload {

}

- (void)loadForm {
	// input form text fields
	_invoiceFormFields = [[NSMutableArray alloc] init];
	
	// Set form values
	AppDelegate *appDelegate =
	(AppDelegate *)[UIApplication sharedApplication].delegate;
	
	// calculate hours,minutes, seconds from seconds
	NSNumber *hours = [[NSNumber alloc] init];
	NSNumber *minutes = [[NSNumber alloc] init];
	NSNumber *seconds = [[NSNumber alloc] init];
	NSNumber *miles = [[NSNumber alloc] init];
	[self projectTotalsWithHours:&hours andMinutes:&minutes andSeconds:&seconds andMiles:&miles];
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MM/dd/yyyy"];
	
	// initialize table view date picker rows
	// Set indexPathForRow to the row number the date picker should be placed
	self.firstDatePickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
	self.secondDatePickerIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
	self.thirdDatePickerIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
	
	self.datePickerPossibleIndexPaths = @[
																				self.firstDatePickerIndexPath, self.secondDatePickerIndexPath,
																				self.thirdDatePickerIndexPath
																				];
	
	//new invoice or edit
	bool isEdit = (self.selectedInvoice && self.selectedInvoice.invoiceNumber);
	
	// create long string with all notes, materials
	NSString *allNotes = [[NSString alloc] init];
	NSString *allMaterials = [[NSString alloc] init];
	
	if(!isEdit){
		for (Session *s in [appDelegate storedSessions]) {
			if (s.projectIDref == _selectedProject.projectID) {
				allNotes = [allNotes
										stringByAppendingString:
										[NSString stringWithFormat:@"%@:%@\n",
										 [df stringFromDate:s.sessionDate],
										 s.txtNotes]];
				
				if (![s.materials isEqualToString:@""]) {
					allMaterials = [allMaterials
													stringByAppendingString:
													[NSString stringWithFormat:@"%@:%@\n",
													 [df stringFromDate:s.sessionDate],
													 s.materials]];
				}
			}
		}
	}
	
	// set custom date picker
	if(isEdit) {
		[self setDate:[_selectedInvoice invoiceDate]
		 forIndexPath:self.firstDatePickerIndexPath];
		[self setDate:[_selectedInvoice startDate]
		 forIndexPath:self.secondDatePickerIndexPath];
		[self setDate:[_selectedInvoice endDate]
		 forIndexPath:self.thirdDatePickerIndexPath];
	} else {
		[self setDate:[NSDate date] forIndexPath:self.firstDatePickerIndexPath];
		[self setDate:[_selectedProject startDate]
		 forIndexPath:self.secondDatePickerIndexPath];
		[self setDate:[_selectedProject endDate]
		 forIndexPath:self.thirdDatePickerIndexPath];
	}
	
	_invoiceFormFields = [[NSMutableArray alloc] init];
	
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Number", @"FieldName", [NSString stringWithFormat:@"%@", isEdit ? [_selectedInvoice invoiceNumber]: [self createInvoiceNumber]],@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Date", @"FieldName", isEdit ? [df stringFromDate:_selectedInvoice.invoiceDate] : [df stringFromDate:[NSDate date]],@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Client Name", @"FieldName", isEdit ? [_selectedInvoice clientName] : [_selectedProject clientName],@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Project Name", @"FieldName", isEdit ? [_selectedInvoice projectName] : [_selectedProject projectName],@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Start Date", @"FieldName", isEdit ? [df stringFromDate:[_selectedInvoice startDate]] : [df stringFromDate:[_selectedProject startDate]],@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"End Date", @"FieldName", isEdit ? [df stringFromDate:[_selectedInvoice endDate]] : [df stringFromDate:[_selectedProject endDate]],@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Approval Name", @"FieldName", isEdit ? [_selectedInvoice approvalName] : @"",@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Milage", @"FieldName", isEdit ? [NSString stringWithFormat:@"%@", [_selectedInvoice milage]] : [NSString stringWithFormat:@"%@", miles],@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Milage Rate", @"FieldName", isEdit ? [NSString stringWithFormat:@"%@", [_selectedInvoice milageRate]] : @"0",@"FieldValue", nil]];
	
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Notes", @"FieldName", isEdit ? [_selectedInvoice invoiceNotes] : allNotes ,@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Materials", @"FieldName", isEdit ? [_selectedInvoice invoiceMaterials] : allMaterials ,@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Materials Total", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", [_selectedInvoice materialsTotal]] : @"0",@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Total Hours:Minutes:Seconds", @"FieldName",isEdit ? [_selectedInvoice totalTime] : [NSString																																									stringWithFormat:@"%@",																																									[NSString stringWithFormat:@"%2@:%2@:%4@", hours,																																									 minutes, seconds]],@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Terms", @"FieldName", isEdit ? [_selectedInvoice invoiceTerms] : @"",@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Deposit", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", [_selectedInvoice invoiceDeposit]] : @"0",@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice Rate", @"FieldName", isEdit ? [NSString stringWithFormat:@"%.2f", [_selectedInvoice invoiceRate]] : @"0",@"FieldValue", nil]];
	[_invoiceFormFields addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Check #", @"FieldName", isEdit ? [_selectedInvoice checkNumber] : @"",@"FieldValue", nil]];
	
}

- (NSMutableArray *)userData {
  if (!_userData) {
    _userData = [[NSMutableArray alloc] initWithCapacity:[_invoiceFormFields count]];
		for (int i = 0; i < [_invoiceFormFields count]; i++)
      [_userData addObject:@""];
    }
  return _userData;
}

- (void)projectTotalsWithHours:(NSNumber **)hours
              andMinutes:(NSNumber **)minutes
              andSeconds:(NSNumber **)seconds
							andMiles:(NSNumber **)miles{
  AppDelegate *appDelegate =
      (AppDelegate *)[UIApplication sharedApplication].delegate;
  int ml = 0;
  int ticks = 0;
  for (Session *s in [appDelegate storedSessions]) {
    if ([s projectIDref] == [_selectedProject projectID]) {

      ticks = ticks + s.sessionHours.intValue * 3600;
      ticks = ticks + s.sessionMinutes.intValue * 60;
      ticks = ticks + s.sessionSeconds.intValue;
      ml = ml + s.milage.intValue;
    }
  }

  double sec = fmod(ticks, 60.0);
  double m = fmod(trunc(ticks / 60.0), 60.0);
  double h = trunc(ticks / 3600.0);

  *hours = [NSNumber numberWithDouble:h];
  *minutes = [NSNumber numberWithDouble:m];
  *seconds = [NSNumber numberWithDouble:sec];
  *miles = [NSNumber numberWithInt:ml];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  // CGPoint location = [recognizer locationInView:[recognizer.view superview]];

  [[self view] endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
  // [self saveInvoice];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (bool)removeExistingInvoice:(NSNumber *)projectId {
  AppDelegate *appDelegate =
      (AppDelegate *)[UIApplication sharedApplication].delegate;

  NSMutableArray *invoicesToRemove = [[NSMutableArray alloc] init];

  // Remove existing invoice for this project
  for (Invoice *remInvoice in [appDelegate arrInvoices]) {
    if (remInvoice.projectID == projectId) {
      [invoicesToRemove addObject:remInvoice];
    }
  }

  for (Invoice *t in invoicesToRemove) {
    [[appDelegate arrInvoices] removeObjectIdenticalTo:t];
  }
	
  return TRUE;
}

// create invoice number based on last invoice number
- (NSNumber *)createInvoiceNumber {
  AppDelegate *appDelegate =
      (AppDelegate *)[UIApplication sharedApplication].delegate;
  int invNumber;
  int tempNumber;
  int i;
  NSNumber *lastNumber;

  if ([[appDelegate arrInvoices] count] == 0) {
    return [NSNumber numberWithInt:1];
  } else {

    Invoice *tInvoice = [[Invoice alloc] init];
    tempNumber = 0;

    for (i = 0; i < [[appDelegate arrInvoices] count]; i++) {

      tInvoice = [[appDelegate arrInvoices] objectAtIndex:i];
      lastNumber = [tInvoice invoiceNumber];
      if ([lastNumber intValue] > tempNumber) {
        tempNumber = [lastNumber intValue];
      }
    }
    // set new invoice number to the highest invoice number found, plus one.
    invNumber = tempNumber;
    invNumber++;
    return [NSNumber numberWithInt:invNumber];
  }
}

- (BOOL)isNumeric:(NSString *)inputString {

  NSScanner *scanner = [NSScanner scannerWithString:inputString];
  return [scanner scanDouble:NULL] && [scanner isAtEnd];
}

- (Invoice *)createInvoice {

  // create the new invoice from form fields
  Invoice *cInvoice = [[Invoice alloc] init];

  // new invoice or update existing?
  if (_selectedProject) {
    // these fields are read only, users cannot change
    [cInvoice setProjectID:_selectedProject.projectID];
    [cInvoice setClientID:_selectedProject.clientID];
  } else {

    [cInvoice setProjectID:_selectedInvoice.projectID];
    [cInvoice setClientID:_selectedInvoice.clientID];
  }

  //    //allow to update the invoice number
  //    NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
  //    NSString * invoiceNumber = [[[[[[self tableView]
  //    cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0]
  //    text];
  //    if(!invoiceNumber)
  //    {
  //        invoiceNumber = [[invoiceFormFields objectAtIndex:0]
  //        objectForKey:@"FieldValue"];
  //    }
  //    [cInvoice setInvoiceNumber:[NSNumber numberWithInt:[invoiceNumber
  //    intValue]]];

  // invoice number is read only
	[cInvoice setInvoiceNumber:_invoiceNumberSelected];

  // invoice date
  NSDate *invoiceDate = [self dateForIndexPath:self.firstDatePickerIndexPath];
  [cInvoice setInvoiceDate:invoiceDate];

  NSIndexPath *iPath = [NSIndexPath indexPathForRow:2 inSection:0];
  //[cInvoice setClientName:_selectedProject.clientName];
  NSString *clientName =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];
  if (!clientName) {
    clientName =
		[[_invoiceFormFields objectAtIndex:2] objectForKey:@"FieldValue"];
  }

  if (clientName && ![clientName isEqualToString:@""]) {
    [cInvoice setClientName:clientName];
  } else {
    [self showMessage:@"Client Name field is empty or not formatted correctly"
            withTitle:@"Client Name"];
    return nil;
  }

  // project name
  iPath = [NSIndexPath indexPathForRow:3 inSection:0];
  NSString *projectName =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];
  if (!projectName) {
    projectName =
		[[_invoiceFormFields objectAtIndex:3] objectForKey:@"FieldValue"];
  }

  if (projectName && ![projectName isEqualToString:@""]) {
    [cInvoice setProjectName:projectName];
  } else {
    [self showMessage:@"Project Name field is empty or not formatted correctly"
            withTitle:@"Project Name"];
    return nil;
  }

  // invoice dates
  NSDate *startDate = [self dateForIndexPath:self.secondDatePickerIndexPath];
  [cInvoice setStartDate:startDate];

  // end date
  NSDate *endDate = [self dateForIndexPath:self.thirdDatePickerIndexPath];
  [cInvoice setEndDate:endDate];

  // approval
  iPath = [NSIndexPath indexPathForRow:6 inSection:0];
  NSString *approvalName =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];
  if (!approvalName) {
    approvalName =
		[[_invoiceFormFields objectAtIndex:6] objectForKey:@"FieldValue"];
  }
  if (approvalName && ![approvalName isEqualToString:@""]) {
    [cInvoice setApprovalName:approvalName];
  } else {
    [cInvoice setApprovalName:@"-"];
    //        [self showMessage:@"Approval Name field is empty or not formatted
    //        correctly" withTitle:@"Approval Name"];
    //        return nil;
  }

  // milage
  iPath = [NSIndexPath indexPathForRow:7 inSection:0];
	NSString *milesInput =[self inputForFieldName:@"Milage"];
	
  NSInteger miles = 0;

  if ([self isNumeric:milesInput]) {

    miles = [milesInput integerValue];

    if (miles) {
      [cInvoice setMilage:[NSNumber numberWithInteger:miles]];
    } else {
      miles = 0;
      [cInvoice setMilage:[NSNumber numberWithInteger:0]];
      //        [self showMessage:@"Milage field is empty or not formatted
      //        correctly" withTitle:@"Milage"];
      //        return nil;
    }
  } else {
    [self showMessage:@"Milage field entry is not a number"
            withTitle:@"Milage"];
    return nil;
  }

  // milage rate, only if miles entered
  if (miles > 0) {
    iPath = [NSIndexPath indexPathForRow:8 inSection:0];
		NSString *milageRateInput = [self inputForFieldName:@"Mileage Rate"];

    if ([self isNumeric:milageRateInput]) {
      float milageRate = [milageRateInput floatValue];
      if (milageRate > 0) {
        [cInvoice setMilageRate:[NSNumber numberWithFloat:milageRate]];
      } else if (![[self.userData objectAtIndex:8] isEqualToString:@""]) {
        [cInvoice setMilageRate:[NSNumber numberWithFloat:[[self.userData
                                                              objectAtIndex:8]
                                                              floatValue]]];
      } else {
        [self
            showMessage:@"Milage rate field is empty or not formatted correctly"
              withTitle:@"Milage Rate"];
        return nil;
      }
    } else {
      [self showMessage:@"Milage rate field entry is not a number"
              withTitle:@"Milage Rate"];
      return nil;
    }
  } else {
    [cInvoice setMilageRate:[NSNumber numberWithFloat:0.00]];
  }

  // notes
  iPath = [NSIndexPath indexPathForRow:9 inSection:0];
  NSString *invNotes =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];
  if (!invNotes) {
		invNotes = [[_invoiceFormFields objectAtIndex:9] objectForKey:@"FieldValue"];
  }
  if (invNotes && ![invNotes isEqualToString:@""]) {
    [cInvoice setInvoiceNotes:invNotes];
  }
  //    else
  //    {
  //        [self showMessage:@"Invoice notes field is empty or not formatted
  //        correctly" withTitle:@"Invoice Notes"];
  //        return nil;
  //    }

  // materials - get from sessions
  iPath = [NSIndexPath indexPathForRow:10 inSection:0];
  NSString *invMaterials =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];
  if (!invMaterials) {
    invMaterials =
		[[_invoiceFormFields objectAtIndex:10] objectForKey:@"FieldValue"];
  }
  [cInvoice setInvoiceMaterials:invMaterials];

  // materials totals
  iPath = [NSIndexPath indexPathForRow:11 inSection:0];
  NSString *materialsTotal =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];

  if ([self isNumeric:materialsTotal]) {
    if (!materialsTotal) {
      materialsTotal =
			[[_invoiceFormFields objectAtIndex:11] objectForKey:@"FieldValue"];
    }
    [cInvoice setMaterialsTotal:[materialsTotal floatValue]];
  } else {
    [self showMessage:@"Materials total field entry is not a number"
            withTitle:@"Materials total"];
    return nil;
  }

  // total time
  iPath = [NSIndexPath indexPathForRow:12 inSection:0];
  NSString *totalTime =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];
  if (!totalTime) {
    totalTime =
		[[_invoiceFormFields objectAtIndex:12] objectForKey:@"FieldValue"];
  }
  if (totalTime && ![totalTime isEqualToString:@""]) {
    [cInvoice setTotalTime:totalTime];
  } else {
    [self showMessage:
              @"Total hours field(HH:MM:SS) is empty or not formatted correctly"
            withTitle:@"Total hours"];
    return nil;
  }

  // terms
  iPath = [NSIndexPath indexPathForRow:13 inSection:0];
  NSString *invTerms =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];
  if (!invTerms) {
    invTerms =
		[[_invoiceFormFields objectAtIndex:13] objectForKey:@"FieldValue"];
  }
  [cInvoice setInvoiceTerms:invTerms];

  // deposit
  iPath = [NSIndexPath indexPathForRow:14 inSection:0];
  NSString *invDeposit =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];

  if ([self isNumeric:invDeposit]) {
    if (!invDeposit) {
      invDeposit =
			[[_invoiceFormFields objectAtIndex:14] objectForKey:@"FieldValue"];
    }
    [cInvoice setInvoiceDeposit:[invDeposit doubleValue]];
  } else {
    [self showMessage:@"Deposit field entry is not a number"
            withTitle:@"Deposit"];
    return nil;
  }

  // rate
  iPath = [NSIndexPath indexPathForRow:15 inSection:0];
  NSString *invRate =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];

  if ([self isNumeric:invRate]) {
    if (!invRate) {
      invRate =
			[[_invoiceFormFields objectAtIndex:15] objectForKey:@"FieldValue"];
    }

    if (invRate && ![invRate isEqualToString:@""]) {
      [cInvoice setInvoiceRate:[invRate doubleValue]];
    } else if (![[self.userData objectAtIndex:15] isEqualToString:@""]) {
      [cInvoice setInvoiceRate:[[self.userData objectAtIndex:15] doubleValue]];
    } else {

      [self
          showMessage:@"Invoice rate field is empty or not formatted correctly"
            withTitle:@"Invoice rate"];
      return nil;
    }
  } else {
    [self showMessage:@"Rate Field entry is not a number" withTitle:@"Rate"];
    return nil;
  }

  iPath = [NSIndexPath indexPathForRow:16 inSection:0];
  NSString *invCheck =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];
  if (!invCheck) {
    invCheck =
		[[_invoiceFormFields objectAtIndex:16] objectForKey:@"FieldValue"];
  }
  [cInvoice setCheckNumber:invCheck];

  return cInvoice;
}

- (NSString*)inputForFieldName:(NSString*)name {
	NSString* value = @"";
	for(NSMutableDictionary* obj in _invoiceFormFields){
		if([[obj valueForKey:@"FieldName"] isEqualToString:@"Milage"]){
			value = [obj valueForKey:@"FieldValue"];
			break;
		}
	}
	return value;
}
- (IBAction)exportInvoice:(id)sender {
  bool invoiceRemoved = FALSE;
  // remove exisitng invoice - a new one will be created
  if (_selectedInvoice) {
    invoiceRemoved = [self removeExistingInvoice:_selectedInvoice.projectID];
  } else {
    invoiceRemoved = [self removeExistingInvoice:_selectedProject.projectID];
  }

  AppDelegate *appDelegate =
      (AppDelegate *)[UIApplication sharedApplication].delegate;

  if (invoiceRemoved) {
    // show exported pdf view
    Invoice *mInvoice = [self createInvoice];
    if (mInvoice) {
      [[appDelegate arrInvoices] addObject:mInvoice];
      [self MakePDF:mInvoice];
    }
  }
}

//-(void)saveInvoice
//{
//    //save invoice to invoice stack
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication
//    sharedApplication].delegate;
//
//    //add new invoice object to clients list
//    Invoice * mInvoice = [self createInvoice];
//    if(mInvoice)
//    {
//        [[appDelegate arrInvoices] addObject:mInvoice];
//    }
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  NSInteger numberOfRows =
      [super tableView:tableView numberOfRowsInSection:section] +
	[_invoiceFormFields count];
  return numberOfRows;
  // Return the number of rows in the section.
  // return invoiceFormFields.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
  if (cell == nil) {
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
    }

    // clear cell subviews-clears old cells
    if (cell != nil) {
      NSArray *subviews = [cell.contentView subviews];
      for (UIView *view in subviews) {
        [view removeFromSuperview];
      }
    }

    NSIndexPath *adjustedIndexPath = [self adjustedIndexPathForDatasourceAccess:indexPath];
		
    if ([adjustedIndexPath compare:self.firstDatePickerIndexPath] == NSOrderedSame) {
      NSDate *firstDate = [self dateForIndexPath:self.firstDatePickerIndexPath];
      NSString *dateFormatted = [NSDateFormatter localizedStringFromDate:firstDate
                                         dateStyle:NSDateFormatterShortStyle
                                         timeStyle:NSDateFormatterNoStyle];

      // add date label for date
      UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 23, 304, 30)];
      [dateLabel setText:dateFormatted];
      [dateLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
      [dateLabel setTintColor:[UIColor blackColor]];
      [[cell contentView] addSubview:dateLabel];

      // add field label for date
      UILabel *fieldTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 13)];
      [fieldTitle setText:@"Date"];
      [fieldTitle setFont:[UIFont fontWithName:@"Avenir Next" size:14]];
      [fieldTitle setTintColor:[UIColor lightGrayColor]];

      [[cell contentView] addSubview:fieldTitle];
			
    } else if ([adjustedIndexPath compare:self.secondDatePickerIndexPath] == NSOrderedSame) {
      NSDate *secondDate = [self dateForIndexPath:self.secondDatePickerIndexPath];
      NSString *dateFormatted = [NSDateFormatter localizedStringFromDate:secondDate
                                         dateStyle:NSDateFormatterShortStyle
                                         timeStyle:NSDateFormatterNoStyle];
      // add date label for date
      UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 23, 304, 30)];
      [dateLabel setText:dateFormatted];
      [dateLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
      [dateLabel setTintColor:[UIColor blackColor]];
      [[cell contentView] addSubview:dateLabel];

      // add field label for date
      UILabel *fieldTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 13)];
      [fieldTitle setText:@"Start Date"];
      [fieldTitle setFont:[UIFont fontWithName:@"Avenir Next" size:14]];
      [fieldTitle setTintColor:[UIColor lightGrayColor]];

      [[cell contentView] addSubview:fieldTitle];
			
    } else if ([adjustedIndexPath compare:self.thirdDatePickerIndexPath] == NSOrderedSame) {

      NSDate *thirdDate = [self dateForIndexPath:self.thirdDatePickerIndexPath];

      NSString *dateFormatted = [NSDateFormatter localizedStringFromDate:thirdDate
                                         dateStyle:NSDateFormatterShortStyle
                                         timeStyle:NSDateFormatterNoStyle];
      // add date label for date
      UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 23, 304, 30)];
      [dateLabel setText:dateFormatted];
      [dateLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
      [dateLabel setTintColor:[UIColor blackColor]];
      [[cell contentView] addSubview:dateLabel];

      // add field label for date
      UILabel *fieldTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 13)];
      [fieldTitle setText:@"End Date"];
      [fieldTitle setFont:[UIFont fontWithName:@"Avenir Next" size:14]];
      [fieldTitle setTintColor:[UIColor lightGrayColor]];

      [[cell contentView] addSubview:fieldTitle];
			
    } else {
      static NSString *simpleTableIdentifier = @"TextInputTableViewCell";
      TextInputTableViewCell *cellText = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

      if (cellText == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
        cellText = [nib objectAtIndex:0];
      }
			
			//callback when text field is updated, and focus changed
			cellText.fieldUpdateCallback = ^(NSString * textInput, NSString * field) {
				
				for(NSMutableDictionary* obj in _invoiceFormFields){
					if([[obj valueForKey:@"FieldName"] isEqualToString:[field valueForKey:@"FieldName"]]){
						[obj setObject:textInput forKey:@"FieldValue"];
					}
				}
				
			};

      // set placeholder value for new cell
      [[cellText textInput] setText:[[_invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
      [[cellText labelCell] setText:[[_invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];

      // set this to save userdata on textinputdidend event
      [[cellText textInput] setTag:[indexPath row]];
			[cellText setFieldName:[_invoiceFormFields objectAtIndex:[indexPath row]]];
      [[cellText textInput] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
      [[cellText textInput] setTextColor:[UIColor blackColor]];
      [[cell contentView] addSubview:cellText];

      // set read only
      if ([indexPath row] == 12 || [indexPath row] == 0) {
        [[cellText textInput] setEnabled:FALSE]; // total hours
      }

			// check if user entered text into field, and load it.
			//TOD0: text entered after load is disappearing on scroll only if
			// another text field is selected.
			if (![[self.userData objectAtIndex:indexPath.row] isEqualToString:@""]) {
				cellText.textInput.text = [self.userData objectAtIndex:indexPath.row];
			}

      [[cell contentView] addSubview:cellText];
    }
  }

	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [cell setBackgroundColor:[UIColor clearColor]];

  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat rowHeight =
      [super tableView:tableView heightForRowAtIndexPath:indexPath];
  if (rowHeight == 0) {
    rowHeight = kTableRowHeight; // self.tableView.rowHeight;
  }
  return rowHeight;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark pdf create methods

- (void)OpenPDF {

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];

  NSString *invoicefile;
  NSString *fileString;

  if (_selectedInvoice) {
    // remove spaces
    fileString = [[[self selectedInvoice] projectName]
        stringByReplacingOccurrencesOfString:@" "
                                  withString:@"_"];
    invoicefile =
        [NSString stringWithFormat:@"%@_%@.pdf", fileString,
                                   [[self selectedInvoice] projectID]];
  } else {
    fileString = [[[self selectedProject] projectName]
        stringByReplacingOccurrencesOfString:@" "
                                  withString:@"_"];
    invoicefile =
        [NSString stringWithFormat:@"%@_%@.pdf", fileString,
                                   [[self selectedProject] projectID]];
  }

  NSString *pdfPath =
      [documentsDirectory stringByAppendingPathComponent:invoicefile];

  if ([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {

    ReaderDocument *document =
        [ReaderDocument withDocumentFilePath:pdfPath password:nil];

    if (document != nil) {
      ReaderViewController *readerViewController =
          [[ReaderViewController alloc] initWithReaderDocument:document];
      readerViewController.delegate = self;

      readerViewController.modalTransitionStyle =
          UIModalTransitionStyleCrossDissolve;
      readerViewController.modalPresentationStyle =
          UIModalPresentationFullScreen;

      [self presentViewController:readerViewController
                         animated:YES
                       completion:nil];

      // depricated
      //[self presentModalViewController:readerViewController animated:YES];
    }
  }
}

- (void)MakePDF:(Invoice *)newInvoice {

  AppDelegate *appDelegate =
      (AppDelegate *)[UIApplication sharedApplication].delegate;

  // remove spaces
  // NSString * fileString = [[[self selectedInvoice] projectName]
  // stringByReplacingOccurrencesOfString:@" " withString:@"_"];
  NSString *invoicefile;
  NSString *fileString;

  if (_selectedInvoice) {
    // remove spaces
    fileString = [[[self selectedInvoice] projectName]
        stringByReplacingOccurrencesOfString:@" "
                                  withString:@"_"];
    invoicefile =
        [NSString stringWithFormat:@"%@_%@.pdf", fileString,
                                   [[self selectedInvoice] projectID]];
  } else {
    fileString = [[[self selectedProject] projectName]
        stringByReplacingOccurrencesOfString:@" "
                                  withString:@"_"];
    invoicefile =
        [NSString stringWithFormat:@"%@_%@.pdf", fileString,
                                   [[self selectedProject] projectID]];
  }

  [self setupPDFDocumentNamed:[NSString stringWithFormat:@"%@_%@", fileString,
                                                         [newInvoice projectID]]
                        Width:850
                       Height:1100];

  // get client info
  Client *selClient;

  for (Client *c in [appDelegate arrClients]) {
    if (c.clientID == newInvoice.clientID) {
      selClient = c;
      break;
    }
  }

  if ([[self MyProfile] count] > 0) {

    [self beginPDFPage];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];

    // Header
    // Logo image
    //                UIImage *anImage = [UIImage imageNamed:@"bill-32.png"];
    //                CGRect imageRect = [self addImage:anImage
    //                                          atPoint:CGPointMake(kPadding,
    //                                          kPadding)];

    ///////////////////////////my info///////////////////

    CGRect nameRect =
        [self addText:[[[self MyProfile] objectAtIndex:0] profileName]
            withFrame:CGRectMake(kMarginPadding, kPadding + 10,
                                 _pageSize.width / 2, 4)
             fontSize:32.0f];
//    CGRect inoviceRect =
//        [self addText:[NSString stringWithFormat:@"Invoice #%@",
//                                                 newInvoice.invoiceNumber]
//            withFrame:CGRectMake(_pageSize.width / 2 + 140, kPadding + 10,
//                                 _pageSize.width / 3, 4)
//             fontSize:24.0f];

    CGRect addressRect =
        [self addText:[[[self MyProfile] objectAtIndex:0] profileAddress]
            withFrame:CGRectMake(kMarginPadding,
                                 nameRect.origin.y + nameRect.size.height +
                                     kPadding,
                                 _pageSize.width - kHeaderPadding * 2, 4)
             fontSize:24.0f];

    CGRect cityRect = [self
          addText:[NSString stringWithFormat:@"%@, %@ %@",
                                             [[[self MyProfile] objectAtIndex:0]
                                                 profileCity],
                                             [[[self MyProfile] objectAtIndex:0]
                                                 profileState],
                                             [[[self MyProfile] objectAtIndex:0]
                                                 profileZip]]
        withFrame:CGRectMake(kMarginPadding,
                             addressRect.origin.y + addressRect.size.height +
                                 kPadding,
                             _pageSize.width - kPadding, 4)
         fontSize:24.0f];

    CGRect phoneRect =
        [self addText:[[[self MyProfile] objectAtIndex:0] profilePhone]
            withFrame:CGRectMake(kMarginPadding,
                                 cityRect.origin.y + cityRect.size.height +
                                     kPadding,
                                 _pageSize.width / 3, 4)
             fontSize:24.0f];

    ///////////////////////////client///////////////////

    CGRect lineRect = [self
        addLineWithFrame:CGRectMake(kMarginPadding,
                                    phoneRect.origin.y + phoneRect.size.height +
                                        kPadding,
                                    _pageSize.width - (kMarginPadding * 2), 4)
               withColor:[UIColor blackColor]];

    // project/client info
    NSString *clientName =
        [NSString stringWithFormat:@"Client: %@", [newInvoice clientName]];
    CGRect clientRect =
        [self addText:clientName
            withFrame:CGRectMake(kMarginPadding,
                                 lineRect.origin.y + lineRect.size.height +
                                     kPadding,
                                 _pageSize.width / 2 - kPadding * 2, 4)
             fontSize:21.0f];

//    NSString *clientAddress =
//        [NSString stringWithFormat:@"Address: %@", [selClient streetAddress]];
//    CGRect clientAddressRect =
//        [self addText:clientAddress
//            withFrame:CGRectMake(kMarginPadding,
//                                 clientRect.origin.y + clientRect.size.height +
//                                     kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    NSString *clientCity =
//        [NSString stringWithFormat:@"City: %@", [selClient city]];
//    CGRect clientCityRect =
//        [self addText:clientCity
//            withFrame:CGRectMake(kMarginPadding,
//                                 clientAddressRect.origin.y +
//                                     clientAddressRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    NSString *clientState =
//        [NSString stringWithFormat:@"State: %@", [selClient state]];
//    CGRect clientStateRect =
//        [self addText:clientState
//            withFrame:CGRectMake(kMarginPadding,
//                                 clientCityRect.origin.y +
//                                     clientCityRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    NSString *clientZip =
//        [NSString stringWithFormat:@"Postal Code: %@", [selClient postalCode]];
//    CGRect clientZipRect =
//        [self addText:clientZip
//            withFrame:CGRectMake(kMarginPadding,
//                                 clientStateRect.origin.y +
//                                     clientStateRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

    // client column 2
    NSString *projectName =
        [NSString stringWithFormat:@"Project: %@", [newInvoice projectName]];
    CGRect projectRect =
        [self addText:projectName
            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
                                 clientRect.origin.y,
                                 _pageSize.width - kPadding * 2, 4)
             fontSize:21.0f];

    NSString *startDate =
        [NSString stringWithFormat:@"Start Date: %@",
                                   [df stringFromDate:[newInvoice startDate]]];
    CGRect startRect =
        [self addText:startDate
            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
                                 projectRect.origin.y +
                                     projectRect.size.height + kPadding,
                                 _pageSize.width - kPadding * 2, 4)
             fontSize:21.0f];

    NSString *endDate =
        [NSString stringWithFormat:@"End Date: %@",
                                   [df stringFromDate:[newInvoice endDate]]];
    CGRect endRect =
        [self addText:endDate
            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
                                 startRect.origin.y + startRect.size.height +
                                     kPadding,
                                 _pageSize.width - kPadding * 2, 4)
             fontSize:21.0f];

    NSString *terms =
        [NSString stringWithFormat:@"Terms: %@", [newInvoice invoiceTerms]];
    CGRect termsRect = [self
          addText:terms
        withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
                             endRect.origin.y + endRect.size.height + kPadding,
                             _pageSize.width - kPadding * 2, 4)
         fontSize:21.0f];

    NSString *approval = [NSString
        stringWithFormat:@"Approved By: %@", [newInvoice approvalName]];
    CGRect approvalRect =
        [self addText:approval
            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
                                 termsRect.origin.y + termsRect.size.height +
                                     kPadding,
                                 _pageSize.width - kPadding * 2, 4)
             fontSize:21.0f];

    ///////////////////////////services///////////////////

    CGRect servicesLineRect = [self
        addLineWithFrame:CGRectMake(kMarginPadding,
                                    approvalRect.origin.y +
                                        approvalRect.size.height + kPadding +
                                        15,
                                    _pageSize.width - (kMarginPadding * 2), 4)
               withColor:[UIColor blackColor]];

    NSString *serviceLabel = [NSString stringWithFormat:@"%@", @"Services:"];
    CGRect serviceRect =
        [self addText:serviceLabel
            withFrame:CGRectMake(kMarginPadding,
                                 servicesLineRect.origin.y +
                                     servicesLineRect.size.height + kPadding,
                                 _pageSize.width - kPadding * 2, 4)
             fontSize:26.0f];

    NSString *services =
        [NSString stringWithFormat:@"%@", [newInvoice invoiceNotes]];
    CGRect servicesRect =
        [self addText:services
            withFrame:CGRectMake(kMarginPadding,
                                 serviceRect.origin.y +
                                     serviceRect.size.height + kPadding,
                                 _pageSize.width - (kMarginPadding * 2), 130)
             fontSize:18.0f];

    ////////////Totals///////////////

    CGRect totalsLineRect = [self
        addLineWithFrame:CGRectMake(kMarginPadding,
                                    servicesRect.origin.y +
                                        servicesRect.size.height + kPadding +
                                        15,
                                    _pageSize.width - (kMarginPadding * 2), 4)
               withColor:[UIColor blackColor]];

    CGRect doubleLineRect = [self
        addLineWithFrame:CGRectMake(kMarginPadding,
                                    totalsLineRect.origin.y +
                                        totalsLineRect.size.height + kPadding,
                                    _pageSize.width - (kMarginPadding * 2), 4)
               withColor:[UIColor blackColor]];

    NSString *materialsLabel = [NSString stringWithFormat:@"%@", @"Materials:"];
    CGRect materialsLabelRect =
        [self addText:materialsLabel
            withFrame:CGRectMake(kMarginPadding,
                                 doubleLineRect.origin.y +
                                     doubleLineRect.size.height + kPadding + 10,
                                 _pageSize.width - kPadding * 2, 4)
             fontSize:26.0f];

    NSString *materialsList =
        [NSString stringWithFormat:@"%@", [newInvoice invoiceMaterials]];
    CGRect materialsListRect = [self
          addText:materialsList
        withFrame:CGRectMake(kMarginPadding,
                             materialsLabelRect.origin.y +
                                 materialsLabelRect.size.height + kPadding,
                             _pageSize.width / 2 - (kMarginPadding * 2), 100)
         fontSize:18.0f];

    // break
    CGRect breakRect =
        [self addText:@""
            withFrame:CGRectMake(kMarginPadding,
                                 materialsListRect.origin.y +
                                     materialsListRect.size.height + kPadding,
                                 _pageSize.width / 2 - kPadding * 2, 4)
             fontSize:21.0f];

    NSString *milage = [NSString
        stringWithFormat:@"Milage: %@ total miles", [newInvoice milage]];
    CGRect milageRect =
        [self addText:milage
            withFrame:CGRectMake(kMarginPadding,
                                 breakRect.origin.y + breakRect.size.height +
                                     kPadding,
                                 _pageSize.width / 2 - kPadding * 2, 4)
             fontSize:21.0f];

    NSString *milageRate =
        [NSString stringWithFormat:@"Milage rate: %@", [newInvoice milageRate]];
    CGRect milageRateRect =
        [self addText:milageRate
            withFrame:CGRectMake(kMarginPadding,
                                 milageRect.origin.y + milageRect.size.height +
                                     kPadding,
                                 _pageSize.width / 2 - kPadding * 2, 4)
             fontSize:21.0f];

    // break
    breakRect =
        [self addText:@""
            withFrame:CGRectMake(kMarginPadding,
                                 milageRateRect.origin.y +
                                     milageRateRect.size.height + kPadding,
                                 _pageSize.width / 2 - kPadding * 2, 4)
             fontSize:21.0f];

//    NSString *checkNumber = [NSString
//        stringWithFormat:@"Paid Check #: %@", [newInvoice checkNumber]];
//    CGRect checkNumberRect =
//        [self addText:checkNumber
//            withFrame:CGRectMake(kMarginPadding,
//                                 breakRect.origin.y + breakRect.size.height +
//                                     kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:18.0f];

    // Totals column 2

//    NSString *tHours =
//        [NSString stringWithFormat:@"Hours: %@", [newInvoice totalTime]];
//    CGRect hoursRect =
//        [self addText:tHours
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 totalsLineRect.origin.y +
//                                     totalsLineRect.size.height + kPadding + 10,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    NSString *tRate = [NSString
//        stringWithFormat:
//            @"Rate: %@",
//            [self formatNumber:[NSNumber
//                                   numberWithDouble:[newInvoice invoiceRate]]]];
//    CGRect rateRect =
//        [self addText:tRate
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 hoursRect.origin.y + hoursRect.size.height +
//                                     kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    NSString *tSubtotal = [NSString
//        stringWithFormat:@"Sub-total: %@",
//                         [self
//                             formatNumber:[NSNumber
//                                              numberWithDouble:[newInvoice
//                                                                   totalDue]]]];
//    CGRect subtotalRect =
//        [self addText:tSubtotal
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 rateRect.origin.y + rateRect.size.height +
//                                     kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    NSString *materialsTotal = [NSString
//        stringWithFormat:
//            @"Materials: %@",
//            [self
//                formatNumber:[NSNumber numberWithDouble:[newInvoice
//                                                            materialsTotal]]]];
//    CGRect materialsRect =
//        [self addText:materialsTotal
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 subtotalRect.origin.y +
//                                     subtotalRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    float transpoCost = ([[newInvoice milage] floatValue] *
//                         [[newInvoice milageRate] floatValue]);
//    NSString *milageTotal =
//        [NSString stringWithFormat:@"Milage Total: %.2f", transpoCost];
//    CGRect milageTotalRect =
//        [self addText:milageTotal
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 materialsRect.origin.y +
//                                     materialsRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    NSString *deposit = [NSString
//        stringWithFormat:
//            @"Deposit: %@",
//            [self
//                formatNumber:[NSNumber numberWithDouble:[newInvoice
//                                                            invoiceDeposit]]]];
//    CGRect depositRect =
//        [self addText:deposit
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 milageTotalRect.origin.y +
//                                     milageTotalRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

//    NSNumber *grandTotal =
//        [NSNumber numberWithFloat:([newInvoice totalDue] +
//                                   [newInvoice materialsTotal] + transpoCost) -
//                                  [newInvoice invoiceDeposit]];
//    CGRect totalDueRect =
//        [self addText:[NSString stringWithFormat:@"Total Due: %@",
//                                                 [self formatNumber:grandTotal]]
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 depositRect.origin.y +
//                                     depositRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:28.0f];

    [self finishPDF];
  } else {
    [self showMessage:@"You must complete your personal profile before "
                      @"creating an invoice."
            withTitle:@"Missing Profile"];
  }
}

- (NSString *)formatNumber:(NSNumber *)number {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];

  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  [formatter setMaximumFractionDigits:2];
  [formatter setMinimumFractionDigits:2];
  [formatter setRoundingMode:NSNumberFormatterRoundUp];

  NSString *numberString = [formatter stringFromNumber:number];

  return numberString;
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title {
  [[[UIAlertView alloc] initWithTitle:title
                              message:text
                             delegate:self
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil] show];
}

- (void)setupPDFDocumentNamed:(NSString *)name
                        Width:(float)width
                       Height:(float)height {
  _pageSize = CGSizeMake(width, height);

  NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];

  NSString *pdfPath =
      [documentsDirectory stringByAppendingPathComponent:newPDFName];

  UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage {
  UIGraphicsBeginPDFPageWithInfo(
      CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}

- (void)finishPDF {
  UIGraphicsEndPDFContext();

  [self OpenPDF];
}

- (CGRect)addText:(NSString *)text
        withFrame:(CGRect)frame
         fontSize:(float)fontSize {
  // UIFont *font = [UIFont systemFontOfSize:fontSize];
  UIFont *font = [UIFont fontWithName:@"Avenir Next Medium" size:fontSize];

  //    CGSize stringSize = [text sizeWithFont:font
  //    constrainedToSize:CGSizeMake(_pageSize.width - 2*20-2*20,
  //    _pageSize.height - 2*20 - 2*20) lineBreakMode:UILineBreakModeWordWrap];

  CGRect stringSize =
      [text boundingRectWithSize:CGSizeMake(frame.size.width, frame.size.height)
                         options:NSStringDrawingUsesLineFragmentOrigin |
                                 NSLineBreakByWordWrapping
                      attributes:@{
                        NSFontAttributeName : font
                      }
                         context:nil];

  float textWidth = frame.size.width;

  if (textWidth < stringSize.size.width)
    textWidth = stringSize.size.width;
  if (textWidth > frame.size.width)
    textWidth = frame.size.width - frame.origin.x;

  // CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y,
  // frame.size.width,frame.size.height);

  CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth,
                                    stringSize.size.height);

  /// Make a copy of the default paragraph style
  NSMutableParagraphStyle *paragraphStyle =
      [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  /// Set line break mode
  paragraphStyle.lineBreakMode =
      NSLineBreakByWordWrapping; // NSLineBreakByTruncatingTail;
  /// Set text alignment
  paragraphStyle.alignment = NSTextAlignmentLeft;

  NSDictionary *attributes = @{
    NSFontAttributeName : font,
    NSParagraphStyleAttributeName : paragraphStyle
  };

  [text drawInRect:renderingRect withAttributes:attributes];

  // depricated
  //
  //    [text drawInRect:renderingRect
  //            withFont:font
  //       lineBreakMode:UILineBreakModeWordWrap
  //           alignment:UITextAlignmentLeft];

  frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth,
                     stringSize.size.height);

  return frame;
}

- (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor *)color {
  CGContextRef currentContext = UIGraphicsGetCurrentContext();

  CGContextSetStrokeColorWithColor(currentContext, color.CGColor);

  // this is the thickness of the line
  CGContextSetLineWidth(currentContext, frame.size.height);

  CGPoint startPoint = frame.origin;
  CGPoint endPoint =
      CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);

  CGContextBeginPath(currentContext);
  CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
  CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);

	CGContextDrawPath(currentContext, kCGPathFillStroke);
  CGContextClosePath(currentContext);
	

  return frame;
}

- (CGRect)addImage:(UIImage *)image atPoint:(CGPoint)point {
  CGRect imageFrame =
      CGRectMake(point.x, point.y, image.size.width, image.size.height);
  [image drawInRect:imageFrame];

  return imageFrame;
}

#pragma mark methods
- (NSMutableArray *)MyProfile {
  // TODO: May need to test if file exists to avoid error
  NSDictionary *rootObject;
  rootObject =
      [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile]];

  NSMutableArray *oProfile = [[NSMutableArray alloc]
      initWithArray:[rootObject valueForKey:@"profile"]];

  return oProfile;
}

- (NSString *)pathForDataFile {
  // Accessible files are stored in the devices "Documents" directory
  NSArray *documentDir = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = nil;

  if (documentDir) {
    path = [documentDir objectAtIndex:0];
  }

  NSLog(@"path....%@",
        [NSString stringWithFormat:@"%@/%@", path, @"profiles.tbd"]);

  return [NSString stringWithFormat:@"%@/%@", path, @"profiles.tbd"];
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
  // [self dismissViewControllerAnimated:NO completion:nil];
  // [self dismissModalViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
