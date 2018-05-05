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
}

@end

@implementation SessionEditTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:NSLocalizedString(@"edit_session", nil)];

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

//- (void)viewWillDisappear:(BOOL)animated {
//
//  // must close date picker row to avoid crash
//  [super hideExistingPicker];
//
//  // save all but client and project info
//  NSIndexPath *iPath = [NSIndexPath indexPathForRow:3 inSection:0];
//
//  NSDateFormatter *df = [[NSDateFormatter alloc] init];
//  [df setDateFormat:@"MM/dd/yyyy"];
//
//  // date -
//  NSDate *firstDate = [self dateForIndexPath:self.firstDatePickerIndexPath];
//  [_selectedSession setSessionDate:firstDate];
//
//  // hours
//  iPath = [NSIndexPath indexPathForRow:3 inSection:0];
//  NSString *hours =
//      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
//          objectAtIndex:0] textInput] text];
//
//  [_selectedSession
//      setSessionHours:[NSNumber numberWithFloat:[hours floatValue]]];
//
//  // minutes
//  iPath = [NSIndexPath indexPathForRow:4 inSection:0];
//  NSString *minutes =
//      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
//          objectAtIndex:0] textInput] text];
//  [_selectedSession
//      setSessionMinutes:[NSNumber numberWithFloat:[minutes floatValue]]];
//
//  // seconds
//  iPath = [NSIndexPath indexPathForRow:5 inSection:0];
//  NSString *seconds =
//      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
//          objectAtIndex:0] textInput] text];
//  [_selectedSession
//      setSessionSeconds:[NSNumber numberWithFloat:[seconds floatValue]]];
//
//  // materials
//  iPath = [NSIndexPath indexPathForRow:6 inSection:0];
//  [_selectedSession
//      setMaterials:[[[[[[[self tableView] cellForRowAtIndexPath:iPath]
//                       contentView] subviews] objectAtIndex:0] textInput]
//                       text]];
//
//  // milage
//  iPath = [NSIndexPath indexPathForRow:7 inSection:0];
//  NSString *milage =
//      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
//          objectAtIndex:0] textInput] text];
//  [_selectedSession setMilage:[NSNumber numberWithFloat:[milage floatValue]]];
//
//  // notes
//  iPath = [NSIndexPath indexPathForRow:8 inSection:0];
//  [_selectedSession
//      setTxtNotes:[[[[[[[self tableView] cellForRowAtIndexPath:iPath]
//                      contentView] subviews] objectAtIndex:0] textInput] text]];
//}

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
		[self.navigationController pushViewController:dateSelectViewController animated:YES];
	}
}

@end
