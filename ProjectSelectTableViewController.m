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

@interface ProjectSelectTableViewController ()

@end

@implementation ProjectSelectTableViewController

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

- (void)invoiceProject
{
  
    //push inovices view controller
    InvoiceTableViewController * invoiceViewController = [[InvoiceTableViewController alloc] init];
    
    [invoiceViewController setSelectedProject:_selectedProject];
    
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
    //[cellLabel setText:[rProject projectName]];
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
