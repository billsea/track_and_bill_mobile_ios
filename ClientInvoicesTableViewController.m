//
//  ClientInvoicesTableViewController.m
//  trackandbill_ios
//
//  Created by William Seaman on 5/3/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import "ClientInvoicesTableViewController.h"
#import "Invoice.h"
#include "AppDelegate.h"
#include "InvoiceTableViewController.h"

@interface ClientInvoicesTableViewController ()

@end

@implementation ClientInvoicesTableViewController

@synthesize selClient = _selClient;
@synthesize invoicesForClient = _invoicesForClient;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Set the title of the navigation item
    [[self navigationItem] setTitle:[_selClient company]];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_invoicesForClient removeAllObjects];
    [self loadInvoicesForSelectedClient];
}

-(void)loadInvoicesForSelectedClient
{
     AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _invoicesForClient = [[NSMutableArray alloc] init];
    
    for(Invoice * aInvoice in [appDelegate arrInvoices])
    {
        if(aInvoice.clientID == _selClient.clientID)
        {
            [_invoicesForClient addObject:aInvoice];
        }
    }
    
    [[self tableView] reloadData];
    
}

- (void)invoiceProjectWithIndex:(NSInteger)index
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //push inovices view controller
    InvoiceTableViewController * invoiceViewController = [[InvoiceTableViewController alloc] init];
    
    [invoiceViewController setSelectedProject:[[appDelegate clientProjects] objectAtIndex:index]];
    
    [self.navigationController pushViewController:invoiceViewController animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_invoicesForClient count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView =nil;
    
    Invoice *rInvoice = (Invoice *)[_invoicesForClient objectAtIndex:[indexPath row]];
    
    
    UILabel * cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,11, cell.frame.size.width - 100, 21)];
    [cellLabel setText:[rInvoice projectName]];
    [cellLabel setFont:[UIFont systemFontOfSize:20.0]];
    
    
    //clear cell subviews-clears old cells
    if (cell != nil)
    {
        NSArray* subviews = [cell.contentView subviews];
        for (UIView* view in subviews)
        {
            [view removeFromSuperview];
        }
    }
 
    [[cell contentView] addSubview:cellLabel];
  
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [self invoiceProjectWithIndex:[indexPath row]];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
