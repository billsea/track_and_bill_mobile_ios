//
//  AddProjectTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/5/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "AddProjectTableViewController.h"
#import "TextInputTableViewCell.h"
#import "Client+CoreDataProperties.h"
#import "Project+CoreDataClass.h"
#import "DateSelectViewController.h"

#define kTableRowHeight 80

@interface AddProjectTableViewController () {
  NSArray *_projectFormFields;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSFetchRequest* _fetchRequest;
	Client* _client;
	NSDateFormatter* _df;
	bool _dateActive;
	NSArray* _dateRows;
}
@property(nonatomic, strong) NSIndexPath *firstDatePickerIndexPath;
@end

@implementation AddProjectTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:NSLocalizedString(@"new_project",nil)];

	_df = [[NSDateFormatter alloc] init];
	[_df setDateFormat:@"MM/dd/yyyy"];
	
	_dateRows = @[@1];
	
	//data field sequence must match form fields sequence
	_client = (Client*)_clientObjectId;
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	_fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Project"];

  // input form text fields
  _projectFormFields = @[
    @{ @"FieldName" : NSLocalizedString(@"project_name",nil),
       @"FieldValue" : @"" },
    @{
      @"FieldName" : NSLocalizedString(@"start_date",nil),
      @"FieldValue" : [_df stringFromDate:[NSDate date]]
    }
  ];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_dateActive = false;
}
- (void)viewWillDisappear:(BOOL)animated {
	if(!_dateActive)
			[self save];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)save {
	// update or create new managed object
	//[_fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", _clientId]];
	NSMutableArray* data = [[_context executeFetchRequest:_fetchRequest error:nil] mutableCopy];

	NSManagedObject* projectObject;
	if(_projectObjectId) {
		projectObject = [data objectAtIndex:[data indexOfObject:_projectObjectId]];
	} else {
		projectObject = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:_context];
	}

	Project* proj = (Project*)projectObject;
	proj.name = [self valueForTextCellWithIndex:0];
	proj.start = [_df dateFromString:[self valueForTextCellWithIndex:1]];
	
	//add to client projects (one to many relationship)
	[_client addProjectsObject:(Project*)projectObject];
	
	//save context in appDelegate
	[_app saveContext];
}

- (NSString*)valueForTextCellWithIndex:(int)rowIndex {
	UIView* cellContent = [[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]] contentView];
	
	NSString* value;
	for(UIView* sv in cellContent.subviews){
		if([sv isKindOfClass:[UITextField class]]){
			UITextField* tc = (UITextField*)sv;
			value = tc.text;
			break;
		} 
	}
	
	return value;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _projectFormFields.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"TextInputTableViewCell";
	TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	//callback when text field is updated, and focus changed
	cell.fieldUpdateCallback = ^(NSString * textInput, NSString * field) {
		for(NSMutableDictionary* obj in _projectFormFields){
			if([[obj valueForKey:@"FieldName"] isEqualToString:[field valueForKey:@"FieldName"]]){
				[obj setObject:textInput forKey:@"FieldValue"];
			}
		}
	};
	
	// set placeholder value for new cell
	[[cell textInput] setText:[[_projectFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
	[[cell labelCell] setText:[[_projectFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
	[cell setFieldName:[_projectFormFields objectAtIndex:[indexPath row]]];
	cell.textInput.delegate = self;
	
	// set date input to read only
	if(indexPath.row == 1) {
		[[cell textInput] setEnabled:FALSE];
	}
	
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[cell setBackgroundColor:[UIColor clearColor]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat rowHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
  if (rowHeight == 0) {
    rowHeight = kTableRowHeight; // self.tableView.rowHeight;
  }
  return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Show date picker on date row select...
	if([_dateRows containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
		_dateActive = true;
		DateSelectViewController *dateSelectViewController = [[DateSelectViewController alloc] initWithNibName:@"DateSelectViewController" bundle:nil];
		TextInputTableViewCell* textCell = (TextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
		dateSelectViewController.dateSelectedCallback = ^(NSDate* selDate){
			textCell.textInput.text = [_df stringFromDate:selDate];
		};
		[self.navigationController pushViewController:dateSelectViewController animated:YES];
	}
}

@end
