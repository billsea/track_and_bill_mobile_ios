//
//  ProjectsTableViewController.m
//  TrackAndBill_iOS
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 William Seaman. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "ProjectsTableViewCell.h"
#import "Project+CoreDataClass.h"
#import "AddProjectTableViewController.h"
#import "AppDelegate.h"
#import "ProjectCollectionViewController.h"
#import "Client+CoreDataProperties.h"
#import "utility.h"

@interface ProjectsTableViewController (){
	Client* _client;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSFetchRequest* _fetchRequest;
	NSArray* _clientProjects;
}
@end

@implementation ProjectsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

	_client = (Client*)_clientObjectId;
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	
  // Set the title of the navigation item
  [[self navigationItem] setTitle:_client.name];

	// add new navigation bar button
	UIBarButtonItem* addClientButton = [[UIBarButtonItem alloc]
													// initWithImage:[UIImage imageNamed:@"reload-50.png"]
													initWithTitle: NSLocalizedString(@"new",nil)
													style:UIBarButtonItemStylePlain
													target:self
													action:@selector(addProject:)];
	
	self.navigationItem.rightBarButtonItems = @[addClientButton, self.editButtonItem];

}

- (void)viewWillAppear:(BOOL)animated {
	[self fetchData];
}

- (void)fetchData {
	_clientProjects = [_client.projects allObjects];
	[self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)addProject:(id)sender {
	// push create new project view
	AddProjectTableViewController *addProjectView = [[AddProjectTableViewController alloc] init];
	[addProjectView setClientObjectId:_clientObjectId];
	[self.navigationController pushViewController:addProjectView animated:YES];
}

// calculate total project time from session data
- (NSString *)totalTimeForProject:(Project *)project {

  int ticks = 0;
	
  for (Session *s in project.sessions) {
		ticks = ticks + s.hours * 3600;
		ticks = ticks + s.minutes * 60;
		ticks = ticks + s.seconds;
  }

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
  return [_client.projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;

  static NSString *CellIdentifier = @"ProjectCell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }

  [cell setBackgroundColor:[UIColor clearColor]];
  cell.accessoryView = nil;

	Project* rProject = [_clientProjects objectAtIndex:indexPath.row];
	
  UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, cell.frame.size.width - 100, 21)];
  [cellLabel setText:rProject.name];

	UILabel *btnTimer = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 90, 8, 100, 30)];
	[btnTimer setText:[self totalTimeForProject:rProject]];

  // clear cell subviews-clears old cells
  if (cell != nil) {
    NSArray *subviews = [cell.contentView subviews];
    for (UIView *view in subviews) {
      [view removeFromSuperview];
    }
  }
  [[cell contentView] addSubview:btnTimer];
  [[cell contentView] addSubview:cellLabel];

  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
		Project* project = (Project*)[_clientProjects objectAtIndex:indexPath.row];
		
		// Remove sessions and invoices
		[project removeSessions:project.sessions];
		//[project removeInvoices:project.invoices];
		
		// Remove projects for the selected client
		[_client removeProjectsObject:project];
		
		// Delete the row from the table
		[_context deleteObject:[_clientProjects objectAtIndex:indexPath.row]];
		
		[_app saveContext];
		
		[self fetchData];

  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
  }
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in
// -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // push the project select/options table view
    ProjectCollectionViewController *projectSelectCollectionVC =
        [[ProjectCollectionViewController alloc]
            initWithNibName:@"ProjectCollectionViewController"
                     bundle:nil];

		projectSelectCollectionVC.projectObjectId = [_clientProjects objectAtIndex:indexPath.row];
	
    [self.navigationController pushViewController:projectSelectCollectionVC animated:YES];

}

@end
