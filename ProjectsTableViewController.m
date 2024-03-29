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
#import "ProjectsTableViewCell.h"

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

	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:NavBarImage]]];
	
	// add new navigation bar button
	UIBarButtonItem* addClientButton = [[UIBarButtonItem alloc]
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
	NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"start" ascending:NO];
	_clientProjects = [[_client.projects allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSort]];
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
	static NSString *simpleTableIdentifier = @"ProjectTableViewCell";
	ProjectsTableViewCell *cell = (ProjectsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProjectsTableViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}

	Project* rProject = [_clientProjects objectAtIndex:indexPath.row];
	cell.projectNameLabel.text = rProject.name;
	cell.projectTimeLabel.text = [self totalTimeForProject:rProject];
	
  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
		UIAlertController *alert = [UIAlertController
																alertControllerWithTitle:NSLocalizedString(@"really_delete_title", nil)
																message:NSLocalizedString(@"really_delete_message", nil)
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *remove = [UIAlertAction
														 actionWithTitle:NSLocalizedString(@"yes", nil)
														 style:UIAlertActionStyleDefault
														 handler:^(UIAlertAction *action) {
															 // Delete the row from the data source
															 Project* project = (Project*)[_clientProjects objectAtIndex:indexPath.row];
															 // Remove sessions
															 [project removeSessions:project.sessions];
															 // Remove projects for the selected client
															 [_client removeProjectsObject:project];
															 // Delete the row from the table
															 [_context deleteObject:[_clientProjects objectAtIndex:indexPath.row]];
															 [_app saveContext];
															 [self fetchData];
														 }];
		
		UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
																										 style:UIAlertActionStyleDefault
																									 handler:^(UIAlertAction *action) {
																										 [alert dismissViewControllerAnimated:YES completion:nil];
																										 //do nothing
																									 }];
		
		[alert addAction:remove];
		[alert addAction:cancel];
		[self presentViewController:alert animated:YES completion:nil];
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
