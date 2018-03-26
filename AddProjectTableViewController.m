//
//  AddProjectTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/5/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "AddProjectTableViewController.h"
#import "TextInputTableViewCell.h"
#import "Project.h"
#import "AppDelegate.h"
#import "Session.h"

#define kTableRowHeight 80

@interface AddProjectTableViewController () {
  NSArray *_projectFormFields;
}
@property(nonatomic, strong) NSIndexPath *firstDatePickerIndexPath;
@end

@implementation AddProjectTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  [[self navigationItem] setTitle:@"New Project"];

  // initialize table view date picker rows
  // Set indexPathForRow to the row number the date picker should be placed
  self.firstDatePickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
  self.datePickerPossibleIndexPaths = @[ self.firstDatePickerIndexPath ];
  [self setDate:[NSDate date] forIndexPath:self.firstDatePickerIndexPath];

  // input form text fields
  _projectFormFields = @[
    @{ @"FieldName" : @"Project Name",
       @"FieldValue" : @"" },
    @{
      @"FieldName" : @"Start Date",
      @"FieldValue" : [NSString stringWithFormat:@"%@", [NSDate date]]
    }
  ];
  // set background image
  [[self view]
      setBackgroundColor:[UIColor
                             colorWithPatternImage:
                                 [UIImage imageNamed:@"paper_texture_02.png"]]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self newProjectSubmit];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

// create project ID
- (NSNumber *)createProjectID {
  AppDelegate *appDelegate =
      (AppDelegate *)[UIApplication sharedApplication].delegate;

  NSNumber *newId = [[NSNumber alloc] initWithLong:0];

  if ([[appDelegate allProjects] count] > 0) {
    for (Project *proj in [appDelegate allProjects]) {
      NSLog(@"ProjectID: %@", proj.projectID);
      if (proj.projectID >= newId) {
        newId = [NSNumber numberWithLong:proj.projectID.intValue + 1];
      }
    }
  }
  return newId;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows =
      [super tableView:tableView numberOfRowsInSection:section] +
      [_projectFormFields count];
  return numberOfRows;
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
      [dateLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
      [dateLabel setTintColor:[UIColor blackColor]];
      [[cell contentView] addSubview:dateLabel];

      // add field label for date
      UILabel *fieldTitle =
          [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 13)];
      [fieldTitle setText:@"Date"];
      [fieldTitle setFont:[UIFont fontWithName:@"Avenir Next" size:14]];
      [fieldTitle setTintColor:[UIColor lightGrayColor]];

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
      [[cellText textInput]
          setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
      [[cellText textInput] setTextColor:[UIColor blackColor]];
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

- (void)newProjectSubmit {
  AppDelegate *appDelegate =
      (AppDelegate *)[UIApplication sharedApplication].delegate;

  // todo: handle form validation

  Project *nProject = [[Project alloc] init];

  NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0];
  NSString *projName =
      [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] textInput] text];

  if (![projName isEqualToString:@""]) {
    // set new project with form value, and generate id
    [nProject setProjectName:projName];
    [nProject setClientName:[_selectedClient company]];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];

    iPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSString *projStart = [[[[[[self tableView] cellForRowAtIndexPath:iPath]
        contentView] subviews] objectAtIndex:0] text];
    NSDate *startDate = [df dateFromString:projStart];

    if (!startDate) {
      [nProject setStartDate:[NSDate date]];
    } else {
      [nProject setStartDate:startDate];
    }

    [nProject setEndDate:[NSDate date]];
    [nProject setClientID:[[self selectedClient] clientID]];
    [nProject setProjectID:[self createProjectID]];

    // add projects to all projects list
    [[appDelegate allProjects] addObject:nProject];

    // save to archive file
		[appDelegate saveProjectsToDisk];
  }
  [[self view] endEditing:YES];
}
@end
