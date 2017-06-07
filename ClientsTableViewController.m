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
#import "Client.h"
#import "ProjectsTableViewController.h"
#import "AddClientTableViewController.h"
#import "Project.h"

@interface ClientsTableViewController ()
@property UIBarButtonItem * addClientButton;
@end

@implementation ClientsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.dataSource = self;
    
    // Set the title of the navigation item
    [[self navigationItem] setTitle:@"Clients"];
    
    //add new navigation bar button
    self.addClientButton = [[UIBarButtonItem alloc]
                                     //initWithImage:[UIImage imageNamed:@"reload-50.png"]
                                     initWithTitle:@"New"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(addClient:)];
    //self.addClientButton.tintColor = [UIColor blackColor];
    [[self navigationItem] setLeftBarButtonItem:self.addClientButton];
    
    //set background image
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture_02.png"]]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addClient:(id)sender
{
    AddClientTableViewController * addClientView = [[AddClientTableViewController alloc] init];
    //show new client view
    [self.navigationController pushViewController:addClientView animated:YES];
}



#pragma mark i/o routines

- (NSString *)pathForClientsFile
{
    //Accessible files are stored in the devices "Documents" directory
    NSArray*	documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*	path = nil;
    
    if (documentDir) {
        path = [documentDir objectAtIndex:0];
    }
    
    
    NSLog(@"path....%@",[NSString stringWithFormat:@"%@/%@", path, @"clients.tbd"]);
    
    return [NSString stringWithFormat:@"%@/%@", path, @"clients.tbd"];
}


- (void) saveDataToDisk
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary * rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue:[appDelegate arrClients] forKey:@"client"];
    
    BOOL success =  [NSKeyedArchiver archiveRootObject: rootObject toFile:[self pathForClientsFile]];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    return [[appDelegate arrClients] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    static NSString *simpleTableIdentifier = @"ClientsTableViewCell";
    
    ClientsTableViewCell *cell = (ClientsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClientsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
  
    Client * rClient = (Client *)[[appDelegate arrClients] objectAtIndex:[indexPath row]];
    
    //set client id for table row
    [cell setTag: [[rClient clientID] integerValue]];
     
    [[cell clientNameLabel] setText:[rClient company]];
    [[cell clientNameLabel] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
    [[cell clientNameLabel] setTextColor:[UIColor blackColor]];
    
    
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
        // Delete the row from the data source
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        //remove projects for the deleted client
        [self removeProjectsForClient:[[appDelegate arrClients] objectAtIndex:[indexPath row]]];
        
        [[appDelegate arrClients] removeObjectAtIndex:[indexPath row]];

        //save updated clients array
        [self saveDataToDisk];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

//remove projects for selected deleted client
- (void)removeProjectsForClient:(Client *)client
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableArray * projectsToRemove = [[NSMutableArray alloc] init];
    
    for(Project * rProj in [appDelegate allProjects])
    {
        if(rProj.clientID.integerValue == client.clientID.integerValue)
        {
            [appDelegate removeSessionsForProjectId:rProj.projectID];
            [projectsToRemove addObject:rProj]; 
        }
    }
    
    for(Project * dProj in projectsToRemove)
    {
          [[appDelegate allProjects] removeObjectIdenticalTo:dProj];
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
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    ProjectsTableViewController *projectsViewController = [[ProjectsTableViewController alloc] initWithNibName:@"ProjectsTableViewController" bundle:nil];
    
    // Pass the selected client id to the new view controller.
    [projectsViewController setSelectedClient: [[appDelegate arrClients] objectAtIndex:[indexPath row]]];
    
    // Push the view controller.
    [self.navigationController pushViewController:projectsViewController animated:YES];
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
