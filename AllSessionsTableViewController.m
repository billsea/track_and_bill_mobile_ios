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
#import "SessionsTableViewCell.h"

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

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self loadData];
}

- (void)loadData{
	_data = _selectedProject.sessions.allObjects;
	[self.tableView reloadData];
}

- (NSString *)totalTimeForSession:(Session *)s {
	int ticks = 0;

	ticks = ticks + s.hours * 3600;
	ticks = ticks + s.minutes * 60;
	ticks = ticks + s.seconds;

	double seconds = fmod(ticks, 60.0);
	double minutes = fmod(trunc(ticks / 60.0), 60.0);
	double hours = trunc(ticks / 3600.0);
	
	return [NSString
					stringWithFormat:@"%02.0f:%02.0f:%02.0f", hours, minutes, seconds];
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

	static NSString *simpleTableIdentifier = @"SessionTableViewCell";
	SessionsTableViewCell *cell = (SessionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SessionsTableViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	Session *rSession = (Session*)_data[indexPath.row];
	cell.sessionNameLabel.text = [df stringFromDate:rSession.start];
	cell.sessionTimeLabel.text = [self totalTimeForSession:rSession];

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
