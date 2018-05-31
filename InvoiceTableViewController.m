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
#import "DateSelectViewController.h"
#import "utility.h"
#import <Photos/Photos.h>

#define kPadding 2
#define kHeaderPadding 5
#define kMarginPadding 85
#define kInvoiceNumberWidth 200
#define kTableRowHeight 80
#define kPdfWidth 850
#define kPdfHeight 1100
#define kEmptyHeaderHeight 175
#define kTopMargin 65

@interface InvoiceTableViewController () {
  CGSize _pageSize;
	NSMutableArray* _invoiceFormFields;
	NSNumber* _invoiceNumberSelected;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSArray* _dataFields;
	NSDateFormatter* _df;
	NSArray* _dateRows;
	NSArray* _readOnlyRows;
	UIImage* _logo_image;
	Profile* _myProfile;
}

@property UIBarButtonItem *previewButton;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation InvoiceTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:NSLocalizedString(@"invoice", nil)];

	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:NavBarImage]]];
	
	_df = [[NSDateFormatter alloc] init];
	[_df setDateFormat:@"MM/dd/yyyy"];
	
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	
	_myProfile = (Profile*)[self MyProfile];
	
	_dateRows = @[@1,@4,@5];
	_readOnlyRows = @[@4,@5,@6];

  // add help navigation bar button
  self.previewButton = [[UIBarButtonItem alloc]
      initWithTitle:NSLocalizedString(@"save_export", nil)
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(exportInvoice:)];
  [[self navigationItem] setRightBarButtonItem:self.previewButton];
	[self loadForm];
	
	//interstitial ad
	self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:GoogleAdMobInterstitialID];
	GADRequest *request = [GADRequest request];
	request.testDevices = @[TestDeviceID, kGADSimulatorID];
	[self.interstitial loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if(_myProfile)
	  [self loadLogo];
}

- (void)loadForm {
	//new invoice or edit
	bool isEdit = _selectedProject.invoices;
	_invoiceFormFields = [Model loadInvoicesWithSelected:_selectedProject.invoices andProject:_selectedProject andEdit:isEdit andArchive:_isArchive];
	[self.tableView reloadData];
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
  [[self view] endEditing:YES];
}

- (BOOL)isNumeric:(NSString *)inputString {
  NSScanner *scanner = [NSScanner scannerWithString:inputString];
  return [scanner scanDouble:NULL] && [scanner isAtEnd];
}

- (NSString*)valueForTextCellWithIndex:(int)rowIndex {
	UIView* cellContent = [[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]] contentView];
	NSString* value = [[[cellContent subviews] objectAtIndex:0] text];
	
	value = value && ![value isEqualToString:@""] ? value :
	[self.userData objectAtIndex:rowIndex] && ![[self.userData objectAtIndex:rowIndex] isEqualToString:@""] ? [self.userData objectAtIndex:rowIndex] :
	[[_invoiceFormFields objectAtIndex:rowIndex] valueForKey:@"FieldValue"] ;
	
	return value;
}

- (float)TotalDue:(NSString*)hms{
	float total = 0.0f;
	float rate = _selectedProject.invoices.rate;
	
	NSArray *time = [hms componentsSeparatedByString:@":"];
	total = ([time[0] floatValue] * rate) + ([time[1] floatValue] * rate/60) + ([time[2] floatValue] * (rate/60)/60);
	
	return total;
}


- (void)createInvoice {
  // create the new invoice from form fields
	
	//add new invoice if one doesnt' exist already
	if(!_selectedProject.invoices){
		NSManagedObject* invoiceObject = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice" inManagedObjectContext:_context];
		[_selectedProject setInvoices:(Invoice*)invoiceObject];
	}

	//Set project info in invoice, so invoice can be viewed if project is removed
	[_selectedProject.invoices setClient_name:[self valueForTextCellWithIndex:2]];
	[_selectedProject.invoices setProject_name:[self valueForTextCellWithIndex:3]];
	[_selectedProject.invoices setStart:[_df dateFromString:[self valueForTextCellWithIndex:4]]];
	[_selectedProject.invoices setEnd:[_df dateFromString:[self valueForTextCellWithIndex:5]]];
	[_selectedProject.invoices setMaterials:[self valueForTextCellWithIndex:7]];
	[_selectedProject.invoices setMileage:[self valueForTextCellWithIndex:9].floatValue];
	[_selectedProject.invoices setTotal_time:[self valueForTextCellWithIndex:6]];
	
  // invoice number is read only
	[_selectedProject.invoices setNumber:(int)[[self valueForTextCellWithIndex:0] intValue]];
	
	// invoice date
  NSDate *invoiceDate = [_df dateFromString:[self valueForTextCellWithIndex:1]];
  [_selectedProject.invoices setDate:invoiceDate];

  // materials totals
  NSString *materialsTotal = [self valueForTextCellWithIndex:8];
	[_selectedProject.invoices setMaterials_cost:materialsTotal.floatValue];

	//Mileage rate
	NSString* sMileageRate = [self valueForTextCellWithIndex:10];
	[_selectedProject.invoices setMilage_rate:sMileageRate.floatValue];

	// rate
	NSString *invRate = [self valueForTextCellWithIndex:11];
	[_selectedProject.invoices setRate:invRate.floatValue];

  // deposit
  NSString *invDeposit = [self valueForTextCellWithIndex:12];
	[_selectedProject.invoices setDeposit:invDeposit.floatValue];

	// terms
	NSString *invTerms = [self valueForTextCellWithIndex:13];
	[_selectedProject.invoices setTerms:invTerms];
	
	// approval
	NSString *approvalName = [self valueForTextCellWithIndex:14];
	
	if (approvalName && ![approvalName isEqualToString:@""]) {
		[_selectedProject.invoices setApprovedby: approvalName];
	} else {
		[_selectedProject.invoices setApprovedby:@"-"];
	}

	//Check number
	NSString *invCheck =[self valueForTextCellWithIndex:15];
	[_selectedProject.invoices setCheck:invCheck];
	
	// notes - if this isn't an archive invoice, then use the notes from sessions
	NSString *invNotes = [self valueForTextCellWithIndex:16];
	if ((!_isArchive || invNotes) && ![invNotes isEqualToString:@""]) {
		[_selectedProject.invoices setNotes:invNotes];
	}

	[_selectedProject.invoices setTotal_due:[self TotalDue:_selectedProject.invoices.total_time]];
	
	//save context in appDelegate
	[_app saveContext];

	//create pdf
	[self MakePDF:_selectedProject.invoices];
	
	[self loadForm];//reload form
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

#pragma mark text field delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	self.userData[textField.tag] = textField.text;
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	// save text input in user data. workaround for disappearing text entry issue
	// on scroll
	[textField resignFirstResponder];
	self.userData[textField.tag] = textField.text;
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

	// set date input to read only
	for(int i = 0; i<_dateRows.count;i++){
		if(indexPath.row == [_dateRows[i] intValue]) {
			[[cell textInput] setEnabled:FALSE];
			break;
		}
	}
	
	//check if the text input is read only
	for(int i = 0; i<_readOnlyRows.count;i++){
		if(indexPath.row == [_readOnlyRows[i] intValue]) {
			[[cell textInput] setEnabled:FALSE];
			break;
		}
	}

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
  return kTableRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Show date picker on date row select...
	//only invoice date is editable
		if([_dateRows containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
			DateSelectViewController *dateSelectViewController = [[DateSelectViewController alloc] initWithNibName:@"DateSelectViewController" bundle:nil];
			TextInputTableViewCell* textCell = (TextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
			dateSelectViewController.dateSelectedCallback = ^(NSDate* selDate){
				textCell.textInput.text = [_df stringFromDate:selDate];
			};
			[self.navigationController pushViewController:dateSelectViewController animated:YES];
		}
}

#pragma mark pdf create methods
- (void)OpenPDF {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileString = [_selectedProject.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	NSString *invoicefile = [NSString stringWithFormat:@"%@.pdf", fileString];
  NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:invoicefile];

  if ([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPath password:nil];
    if (document != nil) {
      ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
      readerViewController.delegate = self;
      readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
      readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;

      [self presentViewController:readerViewController animated:YES completion:nil];
    }
  }
}

- (void)loadLogo {
	// Logo image
	NSURL *asssetURL = [NSURL URLWithString:[_myProfile logo_url]];
	
	if(asssetURL) {
		PHImageManager *manager = [PHImageManager defaultManager];
		NSArray* imageURLS = @[asssetURL];
		PHFetchResult* fRes = [PHAsset fetchAssetsWithALAssetURLs:imageURLS options:nil];
		
		for(PHAsset* fass in fRes){
			[manager requestImageForAsset:fass
												 targetSize:PHImageManagerMaximumSize
												contentMode:PHImageContentModeDefault
														options:nil
											resultHandler:^void(UIImage *image, NSDictionary *info) {
												//[info valueForKey:@"PHImageFileURLKey"]
												_logo_image = image;
											}];
		}
	}
}

- (void)MakePDF:(Invoice *)newInvoice {
	NSString *fileString = [_selectedProject.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
  [self setupPDFDocumentNamed:[NSString stringWithFormat:@"%@", fileString] Width:kPdfWidth Height:kPdfHeight];

  // get client info
	Client *selClient = _selectedProject.clients;
	
  if ((_myProfile && ![_myProfile.name isEqualToString:@""]) || !_myProfile.show_invoice_header) {
    [self beginPDFPage];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];

    // Header
    // Logo image
		[self addImage:_logo_image atPoint:CGPointMake(0, 0)];

		CGRect beginRect;
		CGRect phoneRect;
///////////////////////////Profile info///////////////////
if(_myProfile.show_invoice_header){
	beginRect = CGRectMake(kMarginPadding, kTopMargin, _pageSize.width / 2, 4);
	
	CGRect nameRect = [self addText:_myProfile.name withFrame:beginRect
					 fontSize:InvoiceFontHeading andAlignment: NSTextAlignmentLeft];
	CGRect addressRect = [self addText:_myProfile.address
					withFrame:CGRectMake(kMarginPadding, nameRect.origin.y + nameRect.size.height +
																	 kPadding,
															 _pageSize.width - kHeaderPadding * 2, 4) fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];
  CGRect cityRect = [self addText:[NSString stringWithFormat:@"%@, %@ %@",
																					 _myProfile.city,
																					 _myProfile.state,
																					 _myProfile.postalcode]
			withFrame:CGRectMake(kMarginPadding, addressRect.origin.y + addressRect.size.height + kPadding,
													 _pageSize.width - kPadding, 4) fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];
	phoneRect = [self addText:_myProfile.phone withFrame:CGRectMake(kMarginPadding, cityRect.origin.y + cityRect.size.height + kPadding, _pageSize.width / 3, 4) fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];
} else {
	phoneRect = CGRectMake(kMarginPadding, kEmptyHeaderHeight, _pageSize.width / 2, 4);
}

	CGRect invoiceRect = [self addText:[NSString stringWithFormat:@"%@ #%lld", NSLocalizedString(@"invoice", nil), _selectedProject.invoices.number]
														 withFrame:CGRectMake(_pageSize.width - kMarginPadding - kInvoiceNumberWidth, kTopMargin + kPadding, kInvoiceNumberWidth, 4)
															fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentRight];
		
///////////////////////////client///////////////////

	CGRect lineRect = [self
			addLineWithFrame:CGRectMake(kMarginPadding,
																	phoneRect.origin.y + phoneRect.size.height +
																			kPadding + 3,
																	_pageSize.width - (kMarginPadding * 2), 1)
						 withColor:[UIColor blackColor]];

	// project/client info
	NSString *clientName =
			[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"client_name", nil), _selectedProject.invoices.client_name];
	CGRect clientRect =
			[self addText:clientName
					withFrame:CGRectMake(kMarginPadding,
															 lineRect.origin.y + lineRect.size.height +
																	 kPadding + 5,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *clientAddress =
			[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"address", nil), selClient.address];
	CGRect clientAddressRect =
			[self addText:clientAddress
					withFrame:CGRectMake(kMarginPadding,
															 clientRect.origin.y + clientRect.size.height +
																	 kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *clientCity =
			[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"city", nil), [selClient city]];
	CGRect clientCityRect =
			[self addText:clientCity
					withFrame:CGRectMake(kMarginPadding,
															 clientAddressRect.origin.y +
																	 clientAddressRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *clientState =
			[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"state", nil), selClient.state];
	CGRect clientStateRect =
			[self addText:clientState
					withFrame:CGRectMake(kMarginPadding,
															 clientCityRect.origin.y +
																	 clientCityRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *clientZip =
			[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"postal_code", nil), selClient.postalcode];
	CGRect clientZipRect =
			[self addText:clientZip
					withFrame:CGRectMake(kMarginPadding,
															 clientStateRect.origin.y +
																	 clientStateRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	// client column 2
	NSString *projectName =
			[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"project_name", nil), _selectedProject.invoices.project_name];
	CGRect projectRect =
			[self addText:projectName
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 clientRect.origin.y,
															 _pageSize.width - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *startDate =
			[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"start_date", nil),
																 [df stringFromDate:_selectedProject.invoices.start]];
	CGRect startRect =
			[self addText:startDate
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 projectRect.origin.y +
																	 projectRect.size.height + kPadding,
															 _pageSize.width - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *endDate =
			[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"complete_date", nil),
																 [df stringFromDate:_selectedProject.invoices.end]];
	CGRect endRect =
			[self addText:endDate
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 startRect.origin.y + startRect.size.height +
																	 kPadding,
															 _pageSize.width - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *terms =
			[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"terms_of_payment", nil), _selectedProject.invoices.terms];
	CGRect termsRect = [self
				addText:terms
			withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
													 endRect.origin.y + endRect.size.height + kPadding,
													 _pageSize.width - kPadding * 2, 4)
			 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *approval = [NSString
			stringWithFormat:@"%@: %@", NSLocalizedString(@"approved_by", nil), _selectedProject.invoices.approvedby];
	CGRect approvalRect =
			[self addText:approval
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 termsRect.origin.y + termsRect.size.height +
																	 kPadding,
															 _pageSize.width - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	///////////////////////////services///////////////////

	CGRect servicesLineRect = [self
			addLineWithFrame:CGRectMake(kMarginPadding,
																	approvalRect.origin.y +
																			approvalRect.size.height + kPadding +
																			15,
																	_pageSize.width - (kMarginPadding * 2), 1)
						 withColor:[UIColor blackColor]];

	NSString *serviceLabel = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"services", nil)];
	CGRect serviceRect =
			[self addText:serviceLabel
					withFrame:CGRectMake(kMarginPadding,
															 servicesLineRect.origin.y +
																	 servicesLineRect.size.height + kPadding,
															 _pageSize.width - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *services =
			[NSString stringWithFormat:@"%@", _selectedProject.invoices.notes];
	CGRect servicesRect =
			[self addText:services
					withFrame:CGRectMake(kMarginPadding,
															 serviceRect.origin.y +
																	 serviceRect.size.height + kPadding,
															 _pageSize.width - (kMarginPadding * 2), 130)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	////////////Totals///////////////

	CGRect totalsLineRect = [self
			addLineWithFrame:CGRectMake(kMarginPadding,
																	servicesRect.origin.y +
																			servicesRect.size.height + kPadding +
																			15,
																	_pageSize.width - (kMarginPadding * 2), 2)
						 withColor:[UIColor blackColor]];

	CGRect doubleLineRect = [self
			addLineWithFrame:CGRectMake(kMarginPadding,
																	totalsLineRect.origin.y +
																			totalsLineRect.size.height + kPadding,
																	_pageSize.width - (kMarginPadding * 2), 1)
						 withColor:[UIColor blackColor]];

	NSString *materialsLabel = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"materials", nil)];
	CGRect materialsLabelRect =
			[self addText:materialsLabel
					withFrame:CGRectMake(kMarginPadding,
															 doubleLineRect.origin.y +
																	 doubleLineRect.size.height + kPadding + 10,
															 _pageSize.width - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *materialsList =
	[NSString stringWithFormat:@"%@",_selectedProject.invoices.materials];
	CGRect materialsListRect = [self
				addText:materialsList
			withFrame:CGRectMake(kMarginPadding,
													 materialsLabelRect.origin.y +
															 materialsLabelRect.size.height + kPadding,
													 _pageSize.width / 2 - (kMarginPadding * 2), 100)
			 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	// break line
	CGRect breakRect =
			[self addText:@""
					withFrame:CGRectMake(kMarginPadding,
															 materialsListRect.origin.y +
																	 materialsListRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

		NSString *milage = [NSString stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"milage", nil), [self formatNumber:[NSNumber numberWithFloat:_selectedProject.invoices.mileage]],NSLocalizedString(@"total_miles", nil)];
	CGRect milageRect =
			[self addText:milage
					withFrame:CGRectMake(kMarginPadding,
															 breakRect.origin.y + breakRect.size.height +
																	 kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *milageRate =
		[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"milage_rate", nil), [self formatNumber:[NSNumber numberWithFloat:_selectedProject.invoices.milage_rate]]];
	CGRect milageRateRect =
			[self addText:milageRate
					withFrame:CGRectMake(kMarginPadding,
															 milageRect.origin.y + milageRect.size.height +
																	 kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	// break line
	breakRect =
			[self addText:@""
					withFrame:CGRectMake(kMarginPadding,
															 milageRateRect.origin.y +
																	 milageRateRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *checkNumber = [NSString
			stringWithFormat:@"%@: %@", NSLocalizedString(@"check_num", nil),_selectedProject.invoices.check];
	CGRect checkNumberRect =
			[self addText:checkNumber
					withFrame:CGRectMake(kMarginPadding,
															 breakRect.origin.y + breakRect.size.height +
																	 kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	// Totals column 2

	NSString *tHours =
			[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"hours", nil),_selectedProject.invoices.total_time];
	CGRect hoursRect =
			[self addText:tHours
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 totalsLineRect.origin.y +
																	 totalsLineRect.size.height + kPadding + 10,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *tRate = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"invoice_rate", nil),
					[self formatNumber:[NSNumber numberWithFloat:_selectedProject.invoices.rate]]];
	CGRect rateRect =
			[self addText:tRate
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 hoursRect.origin.y + hoursRect.size.height +
																	 kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *tSubtotalHours = [NSString
			stringWithFormat:@"%@: %@", NSLocalizedString(@"total_hours", nil),[self formatNumber:[NSNumber numberWithFloat:_selectedProject.invoices.total_due]]];
	CGRect subtotalHoursRect =
			[self addText:tSubtotalHours
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 rateRect.origin.y + rateRect.size.height +
																	 kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSString *materialsTotal = [NSString stringWithFormat: @"%@: %@", NSLocalizedString(@"materials", nil),[self
							formatNumber:[NSNumber numberWithFloat:_selectedProject.invoices.materials_cost]]];
	CGRect materialsRect =
			[self addText:materialsTotal
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 subtotalHoursRect.origin.y +
																	 subtotalHoursRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	float transpoCost = (_selectedProject.invoices.mileage *
											 _selectedProject.invoices.milage_rate);
	NSString *milageTotal =
			[NSString stringWithFormat:@"%@: %.2f", NSLocalizedString(@"milage_total", nil),transpoCost];
	CGRect milageTotalRect =
			[self addText:milageTotal
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 materialsRect.origin.y +
																	 materialsRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

		
		
		NSString *tSubtotal = [NSString
													 stringWithFormat:@"%@: %@", NSLocalizedString(@"sub_total", nil), [self formatNumber:[NSNumber numberWithFloat:_selectedProject.invoices.total_due + transpoCost + _selectedProject.invoices.materials_cost]]];
		CGRect subtotalRect =
		[self addText:tSubtotal
				withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
														 milageTotalRect.origin.y + milageTotalRect.size.height +
														 kPadding,
														 _pageSize.width / 2 - kPadding * 2, 4)
				 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];
		
		
	NSString *deposit = [NSString
			stringWithFormat:
					@"%@: %@",NSLocalizedString(@"deposit", nil),
					[self
							formatNumber:[NSNumber numberWithFloat:_selectedProject.invoices.deposit]]];
	CGRect depositRect =
			[self addText:deposit
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 subtotalRect.origin.y +
																	 subtotalRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontMedium andAlignment: NSTextAlignmentLeft];

	NSNumber *grandTotal =
			[NSNumber numberWithFloat:(_selectedProject.invoices.total_due +
																 _selectedProject.invoices.materials_cost + transpoCost) -
																_selectedProject.invoices.deposit];
	CGRect totalDueRect =
			[self addText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"total_due", nil),
																							 [self formatNumber:grandTotal]]
					withFrame:CGRectMake(_pageSize.width / 2 + kPadding,
															 depositRect.origin.y +
																	 depositRect.size.height + kPadding,
															 _pageSize.width / 2 - kPadding * 2, 4)
					 fontSize:InvoiceFontLarge andAlignment: NSTextAlignmentLeft];

	[self finishPDF];
  } else {
		[utility showAlertWithTitle:NSLocalizedString(@"profile_missing", nil) andMessage:NSLocalizedString(@"profile_alert", nil) andVC:self];
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

- (void)setupPDFDocumentNamed:(NSString *)name Width:(float)width Height:(float)height {
  _pageSize = CGSizeMake(width, height);
  NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
  UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage {
  UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}

- (void)finishPDF {
  UIGraphicsEndPDFContext();
  [self OpenPDF];
}

- (CGRect)addText:(NSString *)text withFrame:(CGRect)frame fontSize:(float)fontSize andAlignment:(NSTextAlignment)alignment {
  UIFont *font = [UIFont fontWithName:MainFontName size:fontSize];
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

  CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.size.height);

  // Make a copy of the default paragraph style
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	
  // Set line break mode
  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	
  // Set text alignment
	paragraphStyle.alignment = alignment;

  NSDictionary *attributes = @{
    NSFontAttributeName : font,
    NSParagraphStyleAttributeName : paragraphStyle
  };

  [text drawInRect:renderingRect withAttributes:attributes];
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

- (void)addImage:(UIImage *)image atPoint:(CGPoint)point {
  CGRect imageFrame = CGRectMake(point.x, point.y, kPdfWidth, kPdfHeight);
  [image drawInRect:imageFrame];
}

#pragma mark methods
- (NSManagedObject *)MyProfile {
	// Fetch data from persistent data store;
	NSMutableArray* data = [Model dataForEntity:@"Profile"];
	return data.count > 0 ? [data objectAtIndex:0] : nil;
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
	[self dismissViewControllerAnimated:YES completion:nil];
	[self showBigAd];
}

#pragma mark AdMob
- (void)showBigAd {
	if (self.interstitial.isReady) {
		[self.interstitial presentFromRootViewController:self];
	} else {
		NSLog(@"Ad wasn't ready");
	}
}

@end
