//
//  ProfileTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/16/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "TextInputTableViewCell.h"
#import "AppDelegate.h"

@interface ProfileTableViewController () {
  NSArray* _formFields;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSFetchRequest* _fetchRequest;
	NSArray* _dataFields;
}

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
	
  [[self navigationItem] setTitle:@"Profile"];

	_dataFields = @[@"name",@"address",@"city",@"state",@"country",@"postalcode",@"phone",@"email",@"contact"];
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	_fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Profile"];
	
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

- (void)fetchData {
	// Fetch data from persistent data store;;
	NSMutableArray* data = [[_context executeFetchRequest:_fetchRequest error:nil] mutableCopy];
	NSManagedObject *dataObject = data.count > 0 ? [data objectAtIndex:0] : nil;
	
	_formFields = @[
									@{
										@"FieldName" : @"Your Name or Company",
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"name"] : @""
										},
									@{
										@"FieldName" : @"Address",
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"address"] : @""
										},
									@{
										@"FieldName" : @"City",
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"city"] : @""
										},
									@{
										@"FieldName" : @"State",
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"state"] : @""
										},
									@{
										@"FieldName" : @"Country",
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"country"] : @""
										},
									@{
										@"FieldName" : @"Postal Code",
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"postalcode"] : @""
										},
									@{
										@"FieldName" : @"Phone",
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"phone"] : @""
										},
									@{
										@"FieldName" : @"Email",
										@"FieldValue" :  dataObject ? [dataObject valueForKey:@"email"] : @""
										},
									@{
										@"FieldName" : @"Contact Person",
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"contact"] : @""
										}
									
									];
	
	[[self tableView] reloadData];
}

- (void)save {
	// update or create new managed object
	NSMutableArray* data = [[_context executeFetchRequest:_fetchRequest error:nil] mutableCopy];
	
	NSManagedObject* userProfile;
	if(data.count > 0) {
		userProfile = [data objectAtIndex:0];
	} else {
		userProfile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:_context];
	}

  // save form values
	for(int i = 0; i < _dataFields.count; i++){
		[userProfile setValue:[self valueForTextCellWithIndex:i] forKey:_dataFields[i]];
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

- (void)viewWillDisappear:(BOOL)animated {
	[self save];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
  [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_formFields count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *simpleTableIdentifier = @"TextInputTableViewCell";

  TextInputTableViewCell* cell = (TextInputTableViewCell *)[tableView
      dequeueReusableCellWithIdentifier:simpleTableIdentifier];

  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }

	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // set placeholder value for new cell
	NSString* fieldName = [[_formFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"];
	if(fieldName)
		[[cell labelCell] setText:fieldName];

  [[cell textInput] setTag:[indexPath row]]; // for scrolling workaround

	NSString* fieldValue = [[_formFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"];
	if(fieldValue)
		[[cell textInput] setText:fieldValue];

  [cell setTag:[indexPath row]];
  [cell setFieldName:[_formFields objectAtIndex:[indexPath row]]];
  [[cell textInput] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
  [[cell textInput] setTextColor:[UIColor blackColor]];
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
    _userData = [[NSMutableArray alloc] initWithCapacity:[_formFields count]];
    for (int i = 0; i < [_formFields count]; i++)
      [_userData addObject:@""];
  }
  return _userData;
}

@end
