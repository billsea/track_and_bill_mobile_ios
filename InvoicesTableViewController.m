//
//  InvoicesTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/15/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "InvoicesTableViewController.h"
#import "AppDelegate.h"
#import "Model.h"
#import "InvoiceTableViewCell.h"
#import "Invoice+CoreDataClass.h"
#import "InvoiceTableViewController.h"

#define kTableRowHeight 80

@interface InvoicesTableViewController (){
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSMutableArray* _data;
	NSDateFormatter* _df;
}
@end

@implementation InvoicesTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Set the title of the navigation item
  [[self navigationItem] setTitle:NSLocalizedString(@"invoices", nil)];

	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navbar_bg"]]];
	
	_df = [[NSDateFormatter alloc] init];
	[_df setDateFormat:@"MM/dd/yyyy"];
	
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
}

- (void)viewWillAppear:(BOOL)animated {
	[self fetchData];
}

- (void)fetchData {
	// Fetch data from persistent data store;
	_data = [Model dataForEntity:@"Invoice"];
	[[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kTableRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *simpleTableIdentifier = @"InvoiceCell";
	InvoiceTableViewCell *cell = (InvoiceTableViewCell *)[tableView
																												dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InvoiceTableViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	Invoice* inv = (Invoice*)[_data objectAtIndex:indexPath.row];
	[cell.invoiceNumber setText:[NSString stringWithFormat:@"#%lld", inv.number]];
	[cell.invoiceDate setText:[_df stringFromDate:inv.date]];
	[cell.invoiceClient setText:inv.client_name];
	[cell.invoiceProject setText:inv.project_name];
	
	return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
			forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
				UIAlertController *alert = [UIAlertController
																		alertControllerWithTitle:NSLocalizedString(@"really_delete_title", nil)
																		message:NSLocalizedString(@"really_delete_message", nil)
																		preferredStyle:UIAlertControllerStyleAlert];
			
				UIAlertAction *remove = [UIAlertAction
																 actionWithTitle:NSLocalizedString(@"yes", nil)
																 style:UIAlertActionStyleDefault
																 handler:^(UIAlertAction *action) {
																	 //remove invoice
																	 [_context deleteObject:[_data objectAtIndex:indexPath.row]];
																	 [_app saveContext];
																	 [self fetchData];
																	 [alert dismissViewControllerAnimated:YES completion:nil];
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
        // Create a new instance of the appropriate class, insert it into the
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Invoice* inv = (Invoice*)[_data objectAtIndex:indexPath.row];
	InvoiceTableViewController *invoiceVC = [[InvoiceTableViewController alloc] initWithNibName:@"InvoiceTableViewController" bundle:nil];
	invoiceVC.selectedProject = inv.projects;
  [self.navigationController pushViewController:invoiceVC animated:YES];
}

@end

