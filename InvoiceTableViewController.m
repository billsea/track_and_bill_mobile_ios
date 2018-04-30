//
//  InvoiceTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/17/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "InvoiceTableViewController.h"
#import "AppDelegate.h"
#import "Session+CoreDataClass.h"
#import "Profile+CoreDataClass.h"
#import "TextInputTableViewCell.h"
#import "Client+CoreDataClass.h"
#import "Model.h"

#define kPadding 2
#define kHeaderPadding 5
#define kMarginPadding 25
#define kTableRowHeight 80

@interface InvoiceTableViewController () {
  CGSize _pageSize;
	NSMutableArray* _invoiceFormFields;
	NSNumber* _invoiceNumberSelected;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSArray* _dataFields;
}

@property UIBarButtonItem *previewButton;

@end

@implementation InvoiceTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:NSLocalizedString(@"invoice", nil)];

	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	
	//temp
	NSMutableArray* data = [Model dataForEntity:@"Invoice"];
	NSManagedObject *dataObject = data.count > 0 ? [data objectAtIndex:0] : nil;
	
  // set background image
  [[self view] setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:@"paper_texture_02.png"]]];

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

- (void)loadForm {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MM/dd/yyyy"];

	//new invoice or edit
	bool isEdit = _selectedProject.invoices;

	_invoiceFormFields = [Model loadInvoicesWithSelected:_selectedProject.invoices andProject:_selectedProject andEdit:isEdit];
}

- (NSMutableArray *)userData {
  if (!_userData) {
    _userData = [[NSMutableArray alloc] initWithCapacity:_invoiceFormFields.count];
		for (int i = 0; i < _invoiceFormFields.count; i++)
      [_userData addObject:@""];
    }
  return _userData;
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  // CGPoint location = [recognizer locationInView:[recognizer.view superview]];

  [[self view] endEditing:YES];
}

//- (void)viewWillDisappear:(BOOL)animated {
//  // [self saveInvoice];
//}
//
//- (void)didReceiveMemoryWarning {
//  [super didReceiveMemoryWarning];
//  // Dispose of any resources that can be recreated.
//}
//
//- (bool)removeExistingInvoice:(NSNumber *)projectId {
//  AppDelegate *appDelegate =
//      (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//  NSMutableArray *invoicesToRemove = [[NSMutableArray alloc] init];
//
//  // Remove existing invoice for this project
//  for (Invoice *remInvoice in [appDelegate arrInvoices]) {
//    if (remInvoice.projectID == projectId) {
//      [invoicesToRemove addObject:remInvoice];
//    }
//  }
//
//  for (Invoice *t in invoicesToRemove) {
//    [[appDelegate arrInvoices] removeObjectIdenticalTo:t];
//  }
//
//  return TRUE;
//}

- (BOOL)isNumeric:(NSString *)inputString {
  NSScanner *scanner = [NSScanner scannerWithString:inputString];
  return [scanner scanDouble:NULL] && [scanner isAtEnd];
}

- (void)createInvoice {
  // create the new invoice from form fields
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	
	//add new invoice if one doesnt' exist already
	if(!_selectedProject.invoices){
		NSManagedObject* invoiceObject = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice" inManagedObjectContext:_context];
		[_selectedProject setInvoices:(Invoice*)invoiceObject];
	}

  // invoice number is read only
	[_selectedProject.invoices setNumber:(int)[[_invoiceFormFields objectAtIndex:0] objectForKey:@"FieldValue"]];
	
	// invoice date TODO: Use a date picker for dates
  NSDate *invoiceDate = [df dateFromString:[[_invoiceFormFields objectAtIndex:1] objectForKey:@"FieldValue"]];
  [_selectedProject.invoices setDate:invoiceDate];

	//Mileage rate
	NSString* sMileageRate = [[_invoiceFormFields objectAtIndex:10] objectForKey:@"FieldValue"];
	[_selectedProject.invoices setMilage_rate:sMileageRate.floatValue];

  // materials totals
  NSString *materialsTotal = [[_invoiceFormFields objectAtIndex:9] objectForKey:@"FieldValue"];
//  if (![self isNumeric:materialsTotal]) {
//    [self showMessage:@"Materials total field entry is not a number"
//            withTitle:@"Materials total"];
//    return;
//	} else {
		[_selectedProject.invoices setMaterials_cost:materialsTotal.floatValue];
//	}

  // terms
  NSString *invTerms = [[_invoiceFormFields objectAtIndex:13] objectForKey:@"FieldValue"];
  [_selectedProject.invoices setTerms:invTerms];

  // deposit
  NSString *invDeposit = [[_invoiceFormFields objectAtIndex:12] objectForKey:@"FieldValue"];

//  if (![self isNumeric:invDeposit]) {
//    [self showMessage:@"Deposit field entry is not a number"
//            withTitle:@"Deposit"];
//    return;
//	} else {
		[_selectedProject.invoices setDeposit:invDeposit.floatValue];
//	}

  // rate
	NSString *invRate = [[_invoiceFormFields objectAtIndex:11] objectForKey:@"FieldValue"];

//  if (![self isNumeric:invRate]) {
//    [self showMessage:@"Rate Field entry is not a number" withTitle:@"Rate"];
//    return;
//	} else {
		[_selectedProject.invoices setRate:invRate.floatValue];
//	}

	//Check number
  NSString *invCheck =[[_invoiceFormFields objectAtIndex:15] objectForKey:@"FieldValue"];
  [_selectedProject.invoices setCheck:invCheck];
	
	// approval
	NSString *approvalName = [[_invoiceFormFields objectAtIndex:14] objectForKey:@"FieldValue"];
	
	if (approvalName && ![approvalName isEqualToString:@""]) {
		[_selectedProject.invoices setApprovedby: approvalName];
	} else {
		[_selectedProject.invoices setApprovedby:@"-"];
	}

	// notes
	NSString *invNotes = [[_invoiceFormFields objectAtIndex:16] objectForKey:@"FieldValue"];
	if (invNotes && ![invNotes isEqualToString:@""]) {
		[_selectedProject.invoices setNotes:invNotes];
	}

	
	//save context in appDelegate
	[_app saveContext];

	//create pdf
	[self MakePDF:_selectedProject.invoices];
	
}

- (NSString*)inputForFieldName:(NSString*)name {
	NSString* value = @"";
	for(NSMutableDictionary* obj in _invoiceFormFields){
		if([[obj valueForKey:@"FieldName"] isEqualToString:name]){
			value = [obj valueForKey:@"FieldValue"];
			break;
		}
	}
	return value;
}

- (IBAction)exportInvoice:(id)sender {
	[self createInvoice];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _invoiceFormFields.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"TextInputTableViewCell";
	TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}

	//callback when text field is updated, and focus changed
	cell.fieldUpdateCallback = ^(NSString * textInput, NSString * field) {
		for(NSMutableDictionary* obj in _invoiceFormFields){
			if([[obj valueForKey:@"FieldName"] isEqualToString:[field valueForKey:@"FieldName"]]){
				[obj setObject:textInput forKey:@"FieldValue"];
			}
		}
	};

	// set placeholder value for new cell
	[[cell textInput] setText:[[_invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
	[[cell labelCell] setText:[[_invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];

	// set this to save userdata on textinputdidend event
	[[cell textInput] setTag:[indexPath row]];
	[cell setFieldName:[_invoiceFormFields objectAtIndex:[indexPath row]]];

//	// set read only
//	if ([indexPath row] == 12 || [indexPath row] == 0) {
//		[[cell textInput] setEnabled:FALSE]; // total hours
//	}

	// check if user entered text into field, and load it.
	//TOD0: text entered after load is disappearing on scroll only if
	// another text field is selected.
	if (![[self.userData objectAtIndex:indexPath.row] isEqualToString:@""]) {
		cell.textInput.text = [self.userData objectAtIndex:indexPath.row];
	}

	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [cell setBackgroundColor:[UIColor clearColor]];

  return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat rowHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
  if (rowHeight == 0) {
    rowHeight = kTableRowHeight;
  }
  return rowHeight;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//TODO: Show date picker on date row select
}

#pragma mark pdf create methods

- (void)OpenPDF {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileString = [_selectedProject.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	NSString *invoicefile = [NSString stringWithFormat:@"%@.pdf", fileString];
  NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:invoicefile];

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

	NSString *fileString = [_selectedProject.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	NSString *invoicefile = [NSString stringWithFormat:@"%@_%@.pdf", fileString, _selectedProject.name];
  [self setupPDFDocumentNamed:[NSString stringWithFormat:@"%@", fileString] Width:850 Height:1100];

  // get client info
	Client *selClient = _selectedProject.clients;
	Profile* myProfile = (Profile*)[self MyProfile];
	
  if (myProfile) {
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
        [self addText:myProfile.name
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
        [self addText:myProfile.address
            withFrame:CGRectMake(kMarginPadding,
                                 nameRect.origin.y + nameRect.size.height +
                                     kPadding,
                                 _pageSize.width - kHeaderPadding * 2, 4)
             fontSize:24.0f];

    CGRect cityRect = [self
          addText:[NSString stringWithFormat:@"%@, %@ %@",
                                             myProfile.city,
                                             myProfile.state,
                                             myProfile.postalcode]
        withFrame:CGRectMake(kMarginPadding,
                             addressRect.origin.y + addressRect.size.height +
                                 kPadding,
                             _pageSize.width - kPadding, 4)
         fontSize:24.0f];

    CGRect phoneRect =
        [self addText:myProfile.phone
            withFrame:CGRectMake(kMarginPadding,
                                 cityRect.origin.y + cityRect.size.height +
                                     kPadding,
                                 _pageSize.width / 3, 4)
             fontSize:24.0f];

	//TODO
    ///////////////////////////client///////////////////

//    CGRect lineRect = [self
//        addLineWithFrame:CGRectMake(kMarginPadding,
//                                    phoneRect.origin.y + phoneRect.size.height +
//                                        kPadding,
//                                    _pageSize.width - (kMarginPadding * 2), 4)
//               withColor:[UIColor blackColor]];
//
//    // project/client info
//    NSString *clientName =
//        [NSString stringWithFormat:@"Client: %@", selClient.name];
//    CGRect clientRect =
//        [self addText:clientName
//            withFrame:CGRectMake(kMarginPadding,
//                                 lineRect.origin.y + lineRect.size.height +
//                                     kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

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

//    // client column 2
//    NSString *projectName =
//        [NSString stringWithFormat:@"Project: %@", _selectedProject.name];
//    CGRect projectRect =
//        [self addText:projectName
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 clientRect.origin.y,
//                                 _pageSize.width - kPadding * 2, 4)
//             fontSize:21.0f];
//
//    NSString *startDate =
//        [NSString stringWithFormat:@"Start Date: %@",
//                                   [df stringFromDate:_selectedProject.start]];
//    CGRect startRect =
//        [self addText:startDate
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 projectRect.origin.y +
//                                     projectRect.size.height + kPadding,
//                                 _pageSize.width - kPadding * 2, 4)
//             fontSize:21.0f];
//
//    NSString *endDate =
//        [NSString stringWithFormat:@"End Date: %@",
//                                   [df stringFromDate:_selectedProject.end]];
//    CGRect endRect =
//        [self addText:endDate
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 startRect.origin.y + startRect.size.height +
//                                     kPadding,
//                                 _pageSize.width - kPadding * 2, 4)
//             fontSize:21.0f];
//
//    NSString *terms =
//        [NSString stringWithFormat:@"Terms: %@",_selectedInvoice.terms];
//    CGRect termsRect = [self
//          addText:terms
//        withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                             endRect.origin.y + endRect.size.height + kPadding,
//                             _pageSize.width - kPadding * 2, 4)
//         fontSize:21.0f];
//
//    NSString *approval = [NSString
//        stringWithFormat:@"Approved By: %@", _selectedInvoice.approvedby];
//    CGRect approvalRect =
//        [self addText:approval
//            withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
//                                 termsRect.origin.y + termsRect.size.height +
//                                     kPadding,
//                                 _pageSize.width - kPadding * 2, 4)
//             fontSize:21.0f];
//
//    ///////////////////////////services///////////////////
//
//    CGRect servicesLineRect = [self
//        addLineWithFrame:CGRectMake(kMarginPadding,
//                                    approvalRect.origin.y +
//                                        approvalRect.size.height + kPadding +
//                                        15,
//                                    _pageSize.width - (kMarginPadding * 2), 4)
//               withColor:[UIColor blackColor]];
//
//    NSString *serviceLabel = [NSString stringWithFormat:@"%@", @"Services:"];
//    CGRect serviceRect =
//        [self addText:serviceLabel
//            withFrame:CGRectMake(kMarginPadding,
//                                 servicesLineRect.origin.y +
//                                     servicesLineRect.size.height + kPadding,
//                                 _pageSize.width - kPadding * 2, 4)
//             fontSize:26.0f];
//
//    NSString *services =
//        [NSString stringWithFormat:@"%@", _selectedInvoice.notes];
//    CGRect servicesRect =
//        [self addText:services
//            withFrame:CGRectMake(kMarginPadding,
//                                 serviceRect.origin.y +
//                                     serviceRect.size.height + kPadding,
//                                 _pageSize.width - (kMarginPadding * 2), 130)
//             fontSize:18.0f];
//
//    ////////////Totals///////////////
//
//    CGRect totalsLineRect = [self
//        addLineWithFrame:CGRectMake(kMarginPadding,
//                                    servicesRect.origin.y +
//                                        servicesRect.size.height + kPadding +
//                                        15,
//                                    _pageSize.width - (kMarginPadding * 2), 4)
//               withColor:[UIColor blackColor]];
//
//    CGRect doubleLineRect = [self
//        addLineWithFrame:CGRectMake(kMarginPadding,
//                                    totalsLineRect.origin.y +
//                                        totalsLineRect.size.height + kPadding,
//                                    _pageSize.width - (kMarginPadding * 2), 4)
//               withColor:[UIColor blackColor]];
//
//    NSString *materialsLabel = [NSString stringWithFormat:@"%@", @"Materials:"];
//    CGRect materialsLabelRect =
//        [self addText:materialsLabel
//            withFrame:CGRectMake(kMarginPadding,
//                                 doubleLineRect.origin.y +
//                                     doubleLineRect.size.height + kPadding + 10,
//                                 _pageSize.width - kPadding * 2, 4)
//             fontSize:26.0f];
//
//    NSString *materialsList =
//        [NSString stringWithFormat:@"%@", @"todo"];
//    CGRect materialsListRect = [self
//          addText:materialsList
//        withFrame:CGRectMake(kMarginPadding,
//                             materialsLabelRect.origin.y +
//                                 materialsLabelRect.size.height + kPadding,
//                             _pageSize.width / 2 - (kMarginPadding * 2), 100)
//         fontSize:18.0f];
//
//    // break
//    CGRect breakRect =
//        [self addText:@""
//            withFrame:CGRectMake(kMarginPadding,
//                                 materialsListRect.origin.y +
//                                     materialsListRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];
//
//    NSString *milage = [NSString
//        stringWithFormat:@"Milage: %@ total miles", @"todo"];
//    CGRect milageRect =
//        [self addText:milage
//            withFrame:CGRectMake(kMarginPadding,
//                                 breakRect.origin.y + breakRect.size.height +
//                                     kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];
//
//    NSString *milageRate =
//		[NSString stringWithFormat:@"Milage rate: %@", _selectedInvoice.milage_rate];
//    CGRect milageRateRect =
//        [self addText:milageRate
//            withFrame:CGRectMake(kMarginPadding,
//                                 milageRect.origin.y + milageRect.size.height +
//                                     kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

    // break
//    breakRect =
//        [self addText:@""
//            withFrame:CGRectMake(kMarginPadding,
//                                 milageRateRect.origin.y +
//                                     milageRateRect.size.height + kPadding,
//                                 _pageSize.width / 2 - kPadding * 2, 4)
//             fontSize:21.0f];

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
- (NSManagedObject *)MyProfile {
	// Fetch data from persistent data store;
	NSMutableArray* data = [Model dataForEntity:@"Profile"];
	return data.count > 0 ? [data objectAtIndex:0] : nil;
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
   [self dismissViewControllerAnimated:YES completion:nil];
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
