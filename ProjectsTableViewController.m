//
//  ProjectsTableViewController.m
//  TrackAndBill_iOS
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 William Seaman. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "project.h"
#import "ProjectsTableViewCell.h"
#import "SessionsTableViewController.h"
#import "AddProjectTableViewController.h"
#import "InvoiceTableViewController.h"
#import "Session.h"
#import "AppDelegate.h"
#import "ProjectSelectTableViewController.h"

@interface ProjectsTableViewController ()

@end

@implementation ProjectsTableViewController

@synthesize selectedClient = _selectedClient;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title of the navigation item
    [[self navigationItem] setTitle:[_selectedClient company]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
   [self RetrieveProjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)RetrieveProjects
{

    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //clear projects array
    [[appDelegate clientProjects] removeAllObjects];
    
    //add new project row
    Project * newProjectRow = [[Project alloc] init];
    newProjectRow.projectName = @"Add Project";
    newProjectRow.clientID = nil;
    
    [[appDelegate clientProjects] addObject:newProjectRow];
    
    
    for(Project * proj in [appDelegate allProjects])
    {
        if([proj.clientID isEqual:_selectedClient.clientID])
        {
            [[appDelegate clientProjects] addObject:proj];
        }
        
    }
    
    [[self tableView] reloadData];
    
}



#pragma mark i/o routines

- (NSString *)pathForProjectsFile
{
    //Accessible files are stored in the devices "Documents" directory
    NSArray*	documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*	path = nil;
    
    if (documentDir) {
        path = [documentDir objectAtIndex:0];
    }
    
    
    NSLog(@"path....%@",[NSString stringWithFormat:@"%@/%@", path, @"projects.tbd"]);
    
    return [NSString stringWithFormat:@"%@/%@", path, @"projects.tbd"];
}

- (void) saveDataToDisk
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary * rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue:[appDelegate allProjects] forKey:@"project"];
    
    BOOL success =  [NSKeyedArchiver archiveRootObject: rootObject toFile:[self pathForProjectsFile]];
    
}


//calculate total project time from session data
- (NSString *)totalTimeForProjectId:(NSNumber *)projectId
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    int ticks = 0;
    
    for(Session * s in [appDelegate storedSessions])
    {
        if(s.projectIDref == projectId)
        {
            ticks = ticks + s.sessionHours.intValue * 3600;
            ticks = ticks + s.sessionMinutes.intValue * 60;
            ticks = ticks + s.sessionSeconds.intValue;
        }
    }
    
    double seconds = fmod(ticks, 60.0);
    double minutes = fmod(trunc(ticks / 60.0), 60.0);
    double hours = trunc(ticks / 3600.0);
    
    return [NSString stringWithFormat:@"%02.0f:%02.0f:%04.1f", hours, minutes, seconds];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // Return the number of rows in the section.
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return [[appDelegate clientProjects] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    static NSString *CellIdentifier = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView =nil;
    
    Project *rProject = (Project *)[[appDelegate clientProjects] objectAtIndex:[indexPath row]];
    
    
    UILabel * cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,11, cell.frame.size.width - 100, 21)];
    [cellLabel setText:[rProject projectName]];
    [cellLabel setFont:[UIFont systemFontOfSize:20.0]];
    
    //UILabel * timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 95, 8, 100, 30)];
    
    UILabel * btnTimer;
    
    if(indexPath.row == 0)
    {
        [cellLabel setTextColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    }
    else
    {
        btnTimer=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 105, 8, 100, 30)];
        [btnTimer setText:[self totalTimeForProjectId:[rProject projectID]]];
    }
    
    //clear cell subviews-clears old cells
    if (cell != nil)
    {
        NSArray* subviews = [cell.contentView subviews];
        for (UIView* view in subviews)
        {
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
       
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if([indexPath row] > 0)
        {
            //determine project id in allProjects array, and remove
            Project * projRemove = [[appDelegate clientProjects] objectAtIndex:[indexPath row]];
           
            for(Project * proj in [appDelegate allProjects])
            {
                if(proj.projectID == projRemove.projectID && proj.clientID == projRemove.clientID)
                {
                    //remove associated sessions
                    [appDelegate removeSessionsForProjectId:proj.projectID];
                    [[appDelegate allProjects] removeObjectIdenticalTo:proj];
                    
                     break;
                }
            }
            
            [[appDelegate clientProjects] removeObjectIdenticalTo:projRemove];
            
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
            //save updated projects to disk
            [self saveDataToDisk];
        }
        
        
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
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Navigation logic
    Project * selProject = [[appDelegate clientProjects] objectAtIndex:[indexPath row]];
    
    if(!selProject.clientID && indexPath.row == 0)
    {
        //push create new project view
        AddProjectTableViewController * addProjectView = [[AddProjectTableViewController alloc] init];
        
        [addProjectView setSelectedClient:_selectedClient];

        [self.navigationController pushViewController:addProjectView animated:YES];
    }
    else
    {

        //push the project select/options table view
        ProjectSelectTableViewController *projectSelectViewController = [[ProjectSelectTableViewController alloc] initWithNibName:@"ProjectSelectTableViewController" bundle:nil];
        
        // Pass the selected object to the new view controller.
       
        [projectSelectViewController setSelectedProject: selProject];
        
        // Push the view controller.
        [self.navigationController pushViewController:projectSelectViewController animated:YES];
    }
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
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
