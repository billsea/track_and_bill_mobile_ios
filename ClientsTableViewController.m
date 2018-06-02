//
//  ClientsTableViewController.m
//  TrackAndBill_iOS
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 William Seaman. All rights reserved.
//

#import "ClientsTableViewController.h"
#import "AppDelegate.h"
#import "ClientsTableViewCell.h"
#import "ProjectsTableViewController.h"
#import "AddClientTableViewController.h"
#import "Client+CoreDataProperties.h"
#import "Project+CoreDataProperties.h"
#import "Model.h"

@interface ClientsTableViewController (){
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSMutableArray* _data;
}
@end


@implementation ClientsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Set the title of the navigation item
  [[self navigationItem] setTitle: NSLocalizedString(@"clients",nil)];

	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:NavBarImage]]];
	
  // add new navigation bar button
  self.addClientButton = [[UIBarButtonItem alloc]
      initWithTitle: NSLocalizedString(@"new",nil)
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(addClient:)];


	self.navigationItem.rightBarButtonItems = @[self.addClientButton, self.editButtonItem];
	
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
}

- (void)viewWillAppear:(BOOL)animated {
	[self fetchData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)fetchData {
	// Fetch data from persistent data store;
	_data = [Model dataForEntity:@"Client" andSortKey:@"name"];
	[[self tableView] reloadData];
}

- (IBAction)addClient:(id)sender {
  AddClientTableViewController *addClientView = [[AddClientTableViewController alloc] init];
	addClientView.clientObjectId = nil;
	
  // show new client view
  [self.navigationController pushViewController:addClientView animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *simpleTableIdentifier = @"ClientsTableViewCell";
  ClientsTableViewCell *cell = (ClientsTableViewCell *)[tableView
      dequeueReusableCellWithIdentifier:simpleTableIdentifier];

  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClientsTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }

	NSManagedObject *dataObject = [_data objectAtIndex:indexPath.row];
  [cell.clientNameLabel setText:[dataObject valueForKey:@"name"]];

  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
		UIAlertController *alert = [UIAlertController
																alertControllerWithTitle:NSLocalizedString(@"really_delete_title", nil)
																message:NSLocalizedString(@"really_delete_message", nil)
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *remove = [UIAlertAction
														 actionWithTitle:NSLocalizedString(@"yes", nil)
														 style:UIAlertActionStyleDefault
														 handler:^(UIAlertAction *action) {
															 //get client
															 Client* client = (Client*)[_data objectAtIndex:indexPath.row];
															 // Remove sessions for the client's projects
															 for(Project* p in client.projects){
																 [p removeSessions:p.sessions];
															 }
															 // Remove projects for the selected client
															 [client removeProjects:client.projects];
															 // Delete the row from the table
															 [_context deleteObject:[_data objectAtIndex:indexPath.row]];
															 [_app saveContext];
															 // Delete the row from
															 [_data removeObjectAtIndex:indexPath.row];
															 [tableView deleteRowsAtIndexPaths:@[ indexPath ]
																								withRowAnimation:UITableViewRowAnimationFade];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ProjectsTableViewController *projectsViewController =
      [[ProjectsTableViewController alloc]
          initWithNibName:@"ProjectsTableViewController"
                   bundle:nil];
	
	projectsViewController.clientObjectId = [_data objectAtIndex:indexPath.row]; //selected client data object id

  // Push the view controller.
  [self.navigationController pushViewController:projectsViewController
                                       animated:YES];
}

@end
