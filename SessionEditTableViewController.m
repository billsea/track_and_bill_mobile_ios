//
//  SessionEditTableViewController.m
//  trackandbill_ios
//
//  Created by William Seaman on 5/5/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import "SessionEditTableViewController.h"
#import "TextInputTableViewCell.h"
#import "AppDelegate.h"
#import "DateSelectViewController.h"

#define kTableRowHeight 80

@interface SessionEditTableViewController () {
  NSArray *_sessionFormFields;
	NSDateFormatter* _df;
	NSArray* _dateRows;
	AppDelegate* _app;
	bool _dateActive;
}

@end

@implementation SessionEditTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:NSLocalizedString(@"edit_session", nil)];

	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
  _df = [[NSDateFormatter alloc] init];
  [_df setDateFormat:@"MM/dd/yyyy"];
	
	_dateRows = @[@0];
	
  // input form text fields
  _sessionFormFields = [[NSMutableArray alloc] init];
  _sessionFormFields = @[
    @{
      @"FieldName" : NSLocalizedString(@"date", nil),
      @"FieldValue" : [_df stringFromDate:_selectedSession.start]
    },
    @{
      @"FieldName" : NSLocalizedString(@"hours", nil),
      @"FieldValue" :
				[NSString stringWithFormat:@"%hd", _selectedSession.hours]
    },
    @{
      @"FieldName" : NSLocalizedString(@"minutes", nil),
      @"FieldValue" :
				[NSString stringWithFormat:@"%hd", _selectedSession.minutes]
    },
    @{
      @"FieldName" :NSLocalizedString(@"seconds", nil),
			@"FieldValue" : [NSString stringWithFormat:@"%hd", _selectedSession.seconds]
    },
    @{
      @"FieldName" : NSLocalizedString(@"materials", nil),
      @"FieldValue" :
          [NSString stringWithFormat:@"%@", _selectedSession.materials]
    },
    @{
      @"FieldName" : NSLocalizedString(@"milage", nil),
			@"FieldValue" : [NSString stringWithFormat:@"%hd", _selectedSession.milage]
    },
    @{
      @"FieldName" : NSLocalizedString(@"notes", nil),
      @"FieldValue" :
          [NSString stringWithFormat:@"%@", _selectedSession.notes]
    },

  ];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_dateActive = false;
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

- (void)viewWillDisappear:(BOOL)animated {
	if(!_dateActive)
		[self save];
}

- (void)save {
	[_selectedSession setStart:[_df dateFromString:[self valueForTextCellWithIndex:0]]];
	[_selectedSession setHours:[self valueForTextCellWithIndex:1].intValue];
	[_selectedSession setMinutes:[self valueForTextCellWithIndex:2].intValue];
	[_selectedSession setSeconds:[self valueForTextCellWithIndex:3].intValue];
	[_selectedSession setMaterials:[self valueForTextCellWithIndex:4]];
	[_selectedSession setMilage:[self valueForTextCellWithIndex:5].floatValue];
	[_selectedSession setNotes:[self valueForTextCellWithIndex:6]];
	
	//save context in appDelegate
	[_app saveContext];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sessionFormFields.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"TextInputTableViewCell";

	TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView
			dequeueReusableCellWithIdentifier:simpleTableIdentifier];

	if (cell == nil) {
		NSArray *nib =
				[[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell"
																			owner:self
																		options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	//callback when text field is updated, and focus changed
	cell.fieldUpdateCallback = ^(NSString * textInput, NSString * field) {
		for(NSMutableDictionary* obj in _sessionFormFields){
			if([[obj valueForKey:@"FieldName"] isEqualToString:[field valueForKey:@"FieldName"]]){
				[obj setObject:textInput forKey:@"FieldValue"];
			}
		}
	};
	
	// set date input to read only
	for(int i = 0; i<_dateRows.count;i++){
		if(indexPath.row == [_dateRows[i] intValue]) {
			[[cell textInput] setEnabled:FALSE];
			break;
		}
	}

	[[cell labelCell] setText:[[_sessionFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
	[[cell textInput] setText:[[_sessionFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
	
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kTableRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Show date picker on date row select
	if([_dateRows containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
		DateSelectViewController *dateSelectViewController = [[DateSelectViewController alloc] initWithNibName:@"DateSelectViewController" bundle:nil];
		TextInputTableViewCell* textCell = (TextInputTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
		dateSelectViewController.dateSelectedCallback = ^(NSDate* selDate){
			textCell.textInput.text = [_df stringFromDate:selDate];
		};
		_dateActive = true;
		[self.navigationController pushViewController:dateSelectViewController animated:YES];
	}
}

@end
