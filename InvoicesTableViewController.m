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
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

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
	
	//NSManagedObject *dataObject = [_data objectAtIndex:indexPath.row];
	Invoice* inv = (Invoice*)[_data objectAtIndex:indexPath.row];
	[cell.invoiceNumber setText:[NSString stringWithFormat:@"#%lld", inv.number]];
	[cell.invoiceDate setText:[_df stringFromDate:inv.date]];
	[cell.invoiceClient setText:inv.client_name];
	[cell.invoiceProject setText:inv.project_name];
	
	return cell;
}

///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
//*)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView
//commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath]
//withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the
//array, and add a new row to the table view
//    }
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
//*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
//*)indexPath {
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
//#pragma mark - Table view delegate
//
//// In a xib-based application, navigation from a table can be handled in
//// -tableView:didSelectRowAtIndexPath:
//- (void)tableView:(UITableView *)tableView
//    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  // Navigation logic may go here, for example:
//  // Create the next view controller.
//
//  AppDelegate *appDelegate =
//      (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//  ClientInvoicesTableViewController *clientInvoicesController =
//      [[ClientInvoicesTableViewController alloc]
//          initWithNibName:@"ClientInvoicesTableViewController"
//                   bundle:nil];
//
//  // Pass the selected object to the new view controller.
//  Client *selClient = [[appDelegate arrClients] objectAtIndex:indexPath.row];
//
//  [clientInvoicesController setSelClient:selClient];
//
//  // Push the view controller.
//  [self.navigationController pushViewController:clientInvoicesController
//                                       animated:YES];
//}

@end

