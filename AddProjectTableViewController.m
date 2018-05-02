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

#define kTableRowHeight 80

@interface AddProjectTableViewController () {
  NSArray *_projectFormFields;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSFetchRequest* _fetchRequest;
	NSArray* _dataFields;
	Client* _client;
}
@property(nonatomic, strong) NSIndexPath *firstDatePickerIndexPath;
@end

@implementation AddProjectTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:NSLocalizedString(@"New Project",nil)];

	//data field sequence must match form fields sequence
	_client = (Client*)_clientObjectId;
	
	_dataFields = @[@"name"/*,@"start",@"end"*/];//TODO: date picker
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	_fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
	
  // initialize table view date picker rows
  // Set indexPathForRow to the row number the date picker should be placed
  self.firstDatePickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  self.datePickerPossibleIndexPaths = @[ self.firstDatePickerIndexPath ];
  [self setDate:[NSDate date] forIndexPath:self.firstDatePickerIndexPath];

  // input form text fields
  _projectFormFields = @[
    @{ @"FieldName" : NSLocalizedString(@"Project Name",nil),
       @"FieldValue" : @"" },
    @{
      @"FieldName" : NSLocalizedString(@"Start Date",nil),
      @"FieldValue" : [NSString stringWithFormat:@"%@", [NSDate date]]
    }
  ];

}

- (void)viewWillDisappear:(BOOL)animated {
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
		//This doesn't add to the current client project??
		projectObject = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:_context];
	}

	// save form values
	for(int i = 0; i < _dataFields.count; i++){
		[projectObject setValue:[self valueForTextCellWithIndex:i] forKey:_dataFields[i]];
	}
	
	//add to client projects (one to many relationship)
	[_client addProjectsObject:(Project*)projectObject];
	
	//save context in appDelegate
	[_app saveContext];
}

- (NSString*)valueForTextCellWithIndex:(int)rowIndex {
	UIView* cellContent = [[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]] contentView];
	
	NSString* value;
	for(UIView* sv in cellContent.subviews){
		if([sv isKindOfClass:[TextInputTableViewCell class]]){
			TextInputTableViewCell* tc = (TextInputTableViewCell*)sv;
			value = tc.textInput.text;
			break;
		} 
	}
	
	value = value && ![value isEqualToString:@""] ? value : [self.userData objectAtIndex:rowIndex] ? [self.userData objectAtIndex:rowIndex] : @"";
	
	return value;
}

//// create project ID
//- (NSNumber *)createProjectID {
//  AppDelegate *appDelegate =
//      (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//  NSNumber *newId = [[NSNumber alloc] initWithLong:0];
//
//  if ([[appDelegate allProjects] count] > 0) {
//    for (Project *proj in [appDelegate allProjects]) {
//      NSLog(@"ProjectID: %@", proj.projectID);
//      if (proj.projectID >= newId) {
//        newId = [NSNumber numberWithLong:proj.projectID.intValue + 1];
//      }
//    }
//  }
//  return newId;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _projectFormFields.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
  UITableViewCell *cell =
      [super tableView:tableView cellForRowAtIndexPath:indexPath];
  ;
  if (cell == nil) {
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
    }

    NSIndexPath *adjustedIndexPath =
        [self adjustedIndexPathForDatasourceAccess:indexPath];
    if ([adjustedIndexPath compare:self.firstDatePickerIndexPath] ==
        NSOrderedSame) {

      // clear cell subviews-clears old cells
      if (cell != nil) {
        NSArray *subviews = [cell.contentView subviews];
        for (UIView *view in subviews) {
          [view removeFromSuperview];
        }
      }

      NSDate *firstDate = [self dateForIndexPath:self.firstDatePickerIndexPath];
      NSString *dateFormatted =
          [NSDateFormatter localizedStringFromDate:firstDate
                                         dateStyle:NSDateFormatterShortStyle
                                         timeStyle:NSDateFormatterNoStyle];

      // add date label for date
      UILabel *dateLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(8, 23, 304, 30)];
      [dateLabel setText:dateFormatted];
//      [dateLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
//      [dateLabel setTintColor:[UIColor blackColor]];
      [[cell contentView] addSubview:dateLabel];

      // add field label for date
      UILabel *fieldTitle =
          [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 13)];
      [fieldTitle setText:@"Date"];
//      [fieldTitle setFont:[UIFont fontWithName:@"Avenir Next" size:14]];
//      [fieldTitle setTintColor:[UIColor lightGrayColor]];

      [[cell contentView] addSubview:fieldTitle];

    } else {
      static NSString *simpleTableIdentifier = @"TextInputTableViewCell";

      TextInputTableViewCell *cellText = (TextInputTableViewCell *)[tableView
          dequeueReusableCellWithIdentifier:simpleTableIdentifier];

      if (cellText == nil) {
        NSArray *nib =
            [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell"
                                          owner:self
                                        options:nil];
        cellText = [nib objectAtIndex:0];
      }

      // set placeholder value for new cell
      [[cellText textInput]
          setText:[[_projectFormFields objectAtIndex:[indexPath row]]
                      valueForKey:@"FieldValue"]];
      [[cellText labelCell]
          setText:[[_projectFormFields objectAtIndex:[indexPath row]]
                      valueForKey:@"FieldName"]];
      [cellText setTag:[indexPath row]];

      // set this if we need to save save userdata on textinputdidend event
      [cellText
          setFieldName:[_projectFormFields objectAtIndex:[indexPath row]]];
//      [[cellText textInput]
//          setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
//      [[cellText textInput] setTextColor:[UIColor blackColor]];
      cellText.textInput.delegate = self;

      [[cell contentView] addSubview:cellText];
    }
  }

  cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
  [cell setBackgroundColor:[UIColor clearColor]];

  return cell;
}

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

//- (void)newProjectSubmit {
//  AppDelegate *appDelegate =
//      (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//  // todo: handle form validation
//
//  Project *nProject = [[Project alloc] init];
//
//  NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0];
//  NSString *projName =
//      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
//          objectAtIndex:0] textInput] text];
//
//  if (![projName isEqualToString:@""]) {
//    // set new project with form value, and generate id
//    [nProject setProjectName:projName];
//    [nProject setClientName:[_selectedClient company]];
//
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"MM/dd/yyyy"];
//
//    iPath = [NSIndexPath indexPathForRow:1 inSection:0];
//    NSString *projStart = [[[[[[self tableView] cellForRowAtIndexPath:iPath]
//        contentView] subviews] objectAtIndex:0] text];
//    NSDate *startDate = [df dateFromString:projStart];
//
//    if (!startDate) {
//      [nProject setStartDate:[NSDate date]];
//    } else {
//      [nProject setStartDate:startDate];
//    }
//
//    [nProject setEndDate:[NSDate date]];
//    [nProject setClientID:[[self selectedClient] clientID]];
//    [nProject setProjectID:[self createProjectID]];
//
//    // add projects to all projects list
//    [[appDelegate allProjects] addObject:nProject];
//
//    // save to archive file
//		[appDelegate saveProjectsToDisk];
//  }
//  [[self view] endEditing:YES];
//}
@end
