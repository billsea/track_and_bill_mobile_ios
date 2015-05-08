//
//  AllSessionsTableViewController.m
//  trackandbill_ios
//
//  Created by William Seaman on 5/4/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import "AllSessionsTableViewController.h"
#import "Session.h"
#import "Project.h"
#import "AppDelegate.h"
#import "SessionEditTableViewController.h"

@interface AllSessionsTableViewController ()

@end

@implementation AllSessionsTableViewController

@synthesize selectedProject = _selectedProject;
@synthesize allProjectSessions = _allProjectSessions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Set the title of the navigation item
    [[self navigationItem] setTitle:[_selectedProject projectName]];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadAllSessionsForProject];
}


-(void)loadAllSessionsForProject
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _allProjectSessions = [[NSMutableArray alloc] init];
    
    for(Session * s in [appDelegate storedSessions])
    {
        if(s.projectIDref == [_selectedProject projectID])
        {
            [_allProjectSessions addObject:s];
        }
    }
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_allProjectSessions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SessionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView =nil;
    
    Session *rSession = [_allProjectSessions objectAtIndex:[indexPath row]];
    
    UILabel * cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,11, cell.frame.size.width - 100, 21)];
    [cellLabel setText:[NSString stringWithFormat:@"%@",rSession.sessionDate]];
    [cellLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:18]];
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

    [[cell contentView] addSubview:cellLabel];

    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        Session *removeSession = [_allProjectSessions objectAtIndex:[indexPath row]];
        
        //remove session from stored sessions array
        [[appDelegate storedSessions] removeObjectIdenticalTo:removeSession];
        
        // Delete the row from the data source
       // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self loadAllSessionsForProject];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    // Navigation logic may go here, for example:
    // Create the next view controller.
    SessionEditTableViewController *editViewController = [[SessionEditTableViewController alloc] initWithNibName:@"SessionEditTableViewController" bundle:nil];
    
    // Pass the selected object to the new view controller.
    [editViewController setSelectedSession:(Session*)[_allProjectSessions objectAtIndex:indexPath.row]];
    // Push the view controller.
    [self.navigationController pushViewController:editViewController animated:YES];
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
