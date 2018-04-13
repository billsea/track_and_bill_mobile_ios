//
//  ProjectsTableViewController.m
//  TrackAndBill_iOS
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 William Seaman. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "ProjectsTableViewCell.h"
#import "SessionsTableViewController.h"
#import "AddProjectTableViewController.h"
#import "InvoiceTableViewController.h"
#import "AppDelegate.h"
#import "ProjectCollectionViewController.h"
#import "Client+CoreDataProperties.h"

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

  // Set the title of the navigation item
  [[self navigationItem] setTitle:_client.name];

	// add new navigation bar button
	UIBarButtonItem* addClientButton = [[UIBarButtonItem alloc]
													// initWithImage:[UIImage imageNamed:@"reload-50.png"]
													initWithTitle: NSLocalizedString(@"New",nil)
													style:UIBarButtonItemStylePlain
													target:self
													action:@selector(addProject:)];
	
	// set background image
	[[self view] setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:@"paper_texture_02.png"]]];
	
	self.navigationItem.rightBarButtonItems = @[addClientButton, self.editButtonItem];

  // set background image
  [[self view]
      setBackgroundColor:[UIColor
                             colorWithPatternImage:
                                 [UIImage imageNamed:@"paper_texture_02.png"]]];
}

- (void)viewWillAppear:(BOOL)animated {
	[self fetchData];
}

- (void)fetchData {
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
	_context = _app.persistentContainer.viewContext;
	NSMutableArray* _data = [[_context executeFetchRequest:_fetchRequest error:nil] mutableCopy];
	
	_clientProjects = [_client.projects allObjects];
	[self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)addProject:(id)sender {
		// push create new project view
		AddProjectTableViewController *addProjectView =
		[[AddProjectTableViewController alloc] init];
		
		//[addProjectView setSelectedClient:_selectedClient];
		
		[self.navigationController pushViewController:addProjectView animated:YES];
}

//// calculate total project time from session data
//- (NSString *)totalTimeForProjectId:(NSNumber *)projectId {
//
//  int ticks = 0;
//
//  for (Session *s in [appDelegate storedSessions]) {
//    if (s.projectIDref == projectId) {
//      ticks = ticks + s.sessionHours.intValue * 3600;
//      ticks = ticks + s.sessionMinutes.intValue * 60;
//      ticks = ticks + s.sessionSeconds.intValue;
//    }
//  }
//
//  double seconds = fmod(ticks, 60.0);
//  double minutes = fmod(trunc(ticks / 60.0), 60.0);
//  double hours = trunc(ticks / 3600.0);
//
//  return [NSString
//      stringWithFormat:@"%02.0f:%02.0f:%02.0f", hours, minutes, seconds];
//}

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
	
//  [cellLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
//  [cellLabel setTextColor:[UIColor blackColor]];

  // UILabel * timerLabel = [[UILabel alloc]
  // initWithFrame:CGRectMake(screenWidth - 95, 8, 100, 30)];

  UILabel *btnTimer;

  if (indexPath.row == 0) {
    [cellLabel setTextColor:[UIColor colorWithRed:0.0
                                            green:122.0 / 255.0
                                             blue:1.0
                                            alpha:1.0]];
  } else {
    btnTimer = [[UILabel alloc]
        initWithFrame:CGRectMake(screenWidth - 90, 8, 100, 30)];
    //[btnTimer setText:[self totalTimeForProjectId:[rProject projectID]]];//TODO
    [btnTimer setFont:[UIFont fontWithName:@"Avenir Next Medium" size:18]];
    [btnTimer setTextColor:[UIColor blackColor]];
  }

  // clear cell subviews-clears old cells
  if (cell != nil) {
    NSArray *subviews = [cell.contentView subviews];
    for (UIView *view in subviews) {
      [view removeFromSuperview];
    }
  }
  [[cell contentView] addSubview:btnTimer];
  [[cell contentView] addSubview:cellLabel];
  //[[cell contentView] addSubview:timerLabel];

  return cell;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source

//    AppDelegate *appDelegate =
//        (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    if ([indexPath row] > 0) {
//      // determine project id in allProjects array, and remove
//      Project *projRemove =
//          [[appDelegate clientProjects] objectAtIndex:[indexPath row]];
//
//      for (Project *proj in [appDelegate allProjects]) {
//        if (proj.projectID == projRemove.projectID &&
//            proj.clientID == projRemove.clientID) {
//          // remove associated sessions
//          [appDelegate removeSessionsForProjectId:proj.projectID];
//          // remove associated invoices
//          [appDelegate removeInvoicesForProjectId:proj.projectID];
//          [[appDelegate allProjects] removeObjectIdenticalTo:proj];
//
//          break;
//        }
//      }
//
//      [[appDelegate clientProjects] removeObjectIdenticalTo:projRemove];
//
//      [tableView deleteRowsAtIndexPaths:@[ indexPath ]
//                       withRowAnimation:UITableViewRowAnimationFade];
//
//      // save updated projects to disk
//      [self saveDataToDisk];
//    }

  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array,
    // and add a new row to the table view
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

    // Pass the selected object to the new view controller.
    //[projectSelectCollectionVC setSelectedProject:selProject];

    // Push the view controller.
    [self.navigationController pushViewController:projectSelectCollectionVC
                                         animated:YES];

}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title {
  [[[UIAlertView alloc] initWithTitle:title
                              message:text
                             delegate:self
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil] show];
}

@end
