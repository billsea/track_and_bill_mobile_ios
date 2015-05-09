//
//  ProjectSelectTableViewController.m
//  trackandbill_ios
//
//  Created by William Seaman on 5/4/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import "ProjectSelectTableViewController.h"
#import "InvoiceTableViewController.h"
#import "SessionsTableViewController.h" 
#import "AllSessionsTableViewController.h"
#import "Invoice.h"
#import "AppDelegate.h"

@interface ProjectSelectTableViewController ()

@end

@implementation ProjectSelectTableViewController


InvoiceTableViewController * invoiceViewController;

@synthesize selectedProject = _selectedProject;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Set the title of the navigation item
    [[self navigationItem] setTitle:[_selectedProject projectName]];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //looks like a good place to save all data
    [appDelegate saveProjectsToDisk];
    [appDelegate saveClientsToDisk];
    [appDelegate saveSessionsToDisk];
    [appDelegate saveInvoicesToDisk];
}

- (void)invoiceProject
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //push inovices view controller
    invoiceViewController = [[InvoiceTableViewController alloc] init];
    
    //see if there is an exisiting invoice for this project
    for(Invoice * invoice in [appDelegate arrInvoices])
    {
        if((invoice.projectID == _selectedProject.projectID) && invoice.invoiceNumber)
        {
            [invoiceViewController setSelectedInvoice:invoice];
            break;
        }
    }
    
    if([invoiceViewController selectedInvoice])
    {
        //alert - An invoice exists for this project. Edit existing or create new invoice?
        if ([UIAlertController class])
        {
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Invoice Exists"
                                          message:@"Edit the existing invoice or create a new one?"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* editInvoice = [UIAlertAction
                                     actionWithTitle:@"Edit Invoice"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                          [self.navigationController pushViewController:invoiceViewController animated:YES];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            UIAlertAction* newInvoice = [UIAlertAction
                                     actionWithTitle:@"New Invoice"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [invoiceViewController setSelectedInvoice:nil];
                                         [invoiceViewController setSelectedProject:_selectedProject];
                                         
                                          [self.navigationController pushViewController:invoiceViewController animated:YES];
                                         
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [alert addAction:editInvoice];
            [alert addAction:newInvoice];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            // use UIAlertView
            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Invoice Exists"
                                                             message:@"Edit the existing invoice or create a new one?"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Yes",@"No",nil];
            
            dialog.alertViewStyle = UIAlertControllerStyleActionSheet;
            [dialog show];
        }
    }
    else
    {
        //no invoice exists for project, so create a new one
        [invoiceViewController setSelectedInvoice:nil];
        [invoiceViewController setSelectedProject:_selectedProject];
        [self.navigationController pushViewController:invoiceViewController animated:YES];
        
    }
    
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            //invoice already set
            break;
        case 2:
            [invoiceViewController setSelectedInvoice:nil];
            [invoiceViewController setSelectedProject:_selectedProject];
            break;
        default:
            break;
    }
    
     [self.navigationController pushViewController:invoiceViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView =nil;
    

    UILabel * cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,11, cell.frame.size.width - 100, 21)];
  
    [cellLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
    [cellLabel setTextColor:[UIColor blackColor]];

    
    
    //clear cell subviews-clears old cells
    if (cell != nil)
    {
        NSArray* subviews = [cell.contentView subviews];
        for (UIView* view in subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    switch (indexPath.row) {
        case 0:
            [cellLabel setText:@"New Session"];
            break;
        case 1:
            [cellLabel setText:@"Invoice"];
            break;
        case 2:
            [cellLabel setText:@"All Project Sessions"];
            break;
        default:
            break;
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
    
    
    switch (indexPath.row) {
        case 0:
            [self CreateSessionForProject];
            break;
        case 1:
            [self invoiceProject];
            break;
        case 2:
            [self AllSessions];
            break;
        default:
            break;
    }
    

}



-(void)CreateSessionForProject
{
 
    //push the sessions table view
    SessionsTableViewController *sessionsViewController = [[SessionsTableViewController alloc] initWithNibName:@"SessionsTableViewController" bundle:nil];
    
    // Pass the selected project object to the new view controller.
    [sessionsViewController setSelectedProject:_selectedProject];
    
    // Push the view controller.
    [self.navigationController pushViewController:sessionsViewController animated:YES];
}

-(void)AllSessions
{
    //push the all sessions table view
    AllSessionsTableViewController *allSessionsViewController = [[AllSessionsTableViewController alloc] initWithNibName:@"AllSessionsTableViewController" bundle:nil];
    
    // Pass the selected project object to the new view controller.
    [allSessionsViewController setSelectedProject:_selectedProject];
    
    // Push the view controller.
    [self.navigationController pushViewController:allSessionsViewController animated:YES];
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
