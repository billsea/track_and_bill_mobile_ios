//
//  AllSessionsTableViewController.m
//  trackandbill_ios
//
//  Created by William Seaman on 5/4/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import "AllSessionsTableViewController.h"
#import "Session+CoreDataClass.h"
#import "SessionEditTableViewController.h"

@interface AllSessionsTableViewController (){
	NSArray* _data;
}
@end

@implementation AllSessionsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:_selectedProject.name];
	_data = _selectedProject.sessions.allObjects;
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadData{
	_data = _selectedProject.sessions.allObjects;
	[self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"MM/dd/yyyy"];

  static NSString *CellIdentifier = @"SessionCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }

  [cell setBackgroundColor:[UIColor clearColor]];
	Session *rSession = (Session*)_data[indexPath.row];

  UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, cell.frame.size.width - 100, 21)];
  [cellLabel setText:[df stringFromDate:rSession.start]];

  [[cell contentView] addSubview:cellLabel];

  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
		[_selectedProject removeSessionsObject:(Session*)_data[indexPath.row]];
    [self loadData];

  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array,
    // and add a new row to the table view
  }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SessionEditTableViewController *editViewController = [[SessionEditTableViewController alloc]
          initWithNibName:@"SessionEditTableViewController"
                   bundle:nil];

  Session *selSession = (Session *)[_data objectAtIndex:[indexPath row]];
  [editViewController setSelectedSession:selSession];
  [self.navigationController pushViewController:editViewController animated:YES];
}


@end
