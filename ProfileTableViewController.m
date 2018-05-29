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
#import "Model.h"

@interface ProfileTableViewController () {
  NSArray* _formFields;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSArray* _dataFields;
}

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
	
  [[self navigationItem] setTitle: NSLocalizedString(@"profile",nil)];

	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navbar_bg"]]];
	
	_dataFields = @[@"name",@"address",@"city",@"state",@"country",@"postalcode",@"phone",@"email",@"contact"];
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
  [self fetchData];

  // view has been touched, for dismiss keyboard
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(handleSingleTap:)];

  [self.view addGestureRecognizer:singleFingerTap];
}

- (void)fetchData {
	// Fetch data from persistent data store;;
	NSMutableArray* data = [Model dataForEntity:@"Profile"];
	NSManagedObject *dataObject = data.count > 0 ? [data objectAtIndex:0] : nil;
	
	_formFields = @[
									@{
										@"FieldName" : NSLocalizedString(@"name_company", nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"name"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"address",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"address"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"city",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"city"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"state",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"state"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"country",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"country"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"postal_code",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"postalcode"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"phone",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"phone"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"email",nil),
										@"FieldValue" :  dataObject ? [dataObject valueForKey:@"email"] : @""
										},
									@{
										@"FieldName" :  NSLocalizedString(@"contact_person",nil),
										@"FieldValue" : dataObject ? [dataObject valueForKey:@"contact"] : @""
										}
									
									];
	
	[[self tableView] reloadData];
}

- (void)save {
	// update or create new managed object
	NSMutableArray* data = [Model dataForEntity:@"Profile"];
	
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
