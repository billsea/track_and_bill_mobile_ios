//
//  AddClientTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/8/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "AddClientTableViewController.h"
#import "TextInputTableViewCell.h"


@interface AddClientTableViewController () {
	NSArray* _formFields;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSFetchRequest* _fetchRequest;
	NSArray* _dataFields;
}

@end

@implementation AddClientTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  [[self navigationItem] setTitle: NSLocalizedString(@"New Client",nil)];

	//data field sequence must match form fields sequence
	_dataFields = @[@"name",@"contact",@"address",@"city",@"state",@"country",@"postalcode",@"phone",@"email"];
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	_fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Client"];
	[self fetchData];

  // view has been touched, for dismiss keyboard
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(handleSingleTap:)];

  [self.view addGestureRecognizer:singleFingerTap];

  // set background image
  [[self view]
      setBackgroundColor:[UIColor
                             colorWithPatternImage:
                                 [UIImage imageNamed:@"paper_texture_02.png"]]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self save];
}

- (void)fetchData {
	// Fetch data from persistent data store;
	NSMutableArray* data = [[_context executeFetchRequest:_fetchRequest error:nil] mutableCopy];
	NSManagedObject *dataObject = data.count > 0 ? [data objectAtIndex:0] : nil;
	
	_formFields = @[
									@{
										@"FieldName" :  NSLocalizedString(@"Client Name",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"name"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"Contact Person",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"contact"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"Address",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"address"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"City",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"city"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"State",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"state"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"Country",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"country"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"Postal Code",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"postalcode"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"Phone",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"phone"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"Email",nil),
										@"FieldValue" :  dataObject ? [dataObject valueForKey:@"email"] : @""
										}
									];
	
	[[self tableView] reloadData];
}

- (void)save {
	// update or create new managed object
	//[_fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", _clientId]];
	NSMutableArray* data = [[_context executeFetchRequest:_fetchRequest error:nil] mutableCopy];
	
	
	NSManagedObject* clientObject;
	if(_clientObjectId) {
		clientObject = [data objectAtIndex:[data indexOfObject:_clientObjectId]];
	} else {
		clientObject = [NSEntityDescription insertNewObjectForEntityForName:@"Client" inManagedObjectContext:_context];
	}
	
	// save form values
	for(int i = 0; i < _dataFields.count; i++){
		[clientObject setValue:[self valueForTextCellWithIndex:i] forKey:_dataFields[i]];
	}
	
	//save context in appDelegate
	[_app saveContext];
}

- (NSString*)valueForTextCellWithIndex:(int)rowIndex {
	UIView* cellContent = [[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]] contentView];
	NSString* value = [[[cellContent subviews] objectAtIndex:0] text];
	
	value = value && ![value isEqualToString:@""] ? value : [self.userData objectAtIndex:rowIndex] ? [self.userData objectAtIndex:rowIndex] : @"";
	
	return value;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  [[self view] endEditing:YES];
}

//- (NSNumber *)createClientID {
//  AppDelegate *appDelegate =
//      (AppDelegate *)[UIApplication sharedApplication].delegate;
//  NSNumber *newId = [[NSNumber alloc] initWithLong:0];
//
//  if ([[appDelegate arrClients] count] > 0) {
//    Client *lastClient = (Client *)[[appDelegate arrClients]
//        objectAtIndex:[[appDelegate arrClients] count] - 1];
//    newId = [NSNumber numberWithLong:lastClient.clientID.longValue + 1];
//  }
//  return newId;
//}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _formFields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *simpleTableIdentifier = @"TextInputTableViewCell";
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView
      dequeueReusableCellWithIdentifier:simpleTableIdentifier];

  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }

  // set placeholder value for new cell
  [[cell labelCell] setText:[[_formFields objectAtIndex:[indexPath row]]
                                valueForKey:@"FieldName"]];
  [[cell textInput] setTag:[indexPath row]]; // for scrolling workaround
  [cell setTag:[indexPath row]];
  [cell setFieldName:[_formFields objectAtIndex:[indexPath row]]];
  cell.textInput.delegate = self;

  // check if user entered text into field, and load it. this fixes problem with
  // scrolling, and text field input disappearing
  if (![[self.userData objectAtIndex:indexPath.row] isEqualToString:@""]) {
    cell.textInput.text = [self.userData objectAtIndex:indexPath.row];
  }
  return cell;
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

- (NSMutableArray *)userData {
  if (!_userData) {
    _userData =
        [[NSMutableArray alloc] initWithCapacity:[_formFields count]];
    for (int i = 0; i < [_formFields count]; i++)
      [_userData addObject:@""];
  }
  return _userData;
}

@end
