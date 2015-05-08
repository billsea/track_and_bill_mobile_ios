//
//  SessionsTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/15/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "SessionsTableViewController.h"
#import "AppDelegate.h"
#import "SessionsTableViewCell.h"
#import "Session.h"
#import "SessionDetailTableViewController.h"

@interface SessionsTableViewController ()

@end

@implementation SessionsTableViewController

@synthesize selectedProject = _selectedProject;
@synthesize sessionRefreshTimer = _sessionRefreshTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title of the navigation item
    [[self navigationItem] setTitle:@"Sessions"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //refreshes the timer label in each sessison row
    _sessionRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];
   
    [self loadSessionsList];
}


-(void)viewWillAppear:(BOOL)animated
{

    
    
}

- (void)loadSessionsList
{
    //check duplicates and if session was recently removed
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    bool supressSession = false;
    

    for(Session * s in appDelegate.currentSessions)
    {
        if(s.projectIDref == _selectedProject.projectID)
        {
            supressSession = true;
        }
    }
    if(supressSession == false)
    {
        [self addNewSessionForSelectedProject];
    }
    
//    if(_selectedProject == nil)
//    {
//        [[self tableView] reloadData];
//    }
    
}

//update the timer label for each session when timer ticks
- (void)updateTimerLabel
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSInteger index = 0;
    UITableViewCell * sessionCell = [[UITableViewCell alloc] init];
    UILabel * timerLabel = [[UILabel alloc] init];
    NSIndexPath *iPath = [[NSIndexPath alloc] init];
    
    for(Session * curSession in [appDelegate currentSessions])
    {
        iPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        sessionCell = [self.tableView cellForRowAtIndexPath:iPath];
        
        //doesn't like a zero value, so start at 1
        timerLabel = (UILabel *)[sessionCell viewWithTag:index+1];
        
        [timerLabel setText:[curSession timerValue]];
        
        index++;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewSessionForSelectedProject
{

    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    Session * newSession = [[Session alloc] init];
    newSession.projectName = [_selectedProject projectName];
    newSession.projectIDref = [_selectedProject projectID];
    newSession.clientName = [_selectedProject clientName];
    newSession.sessionDate = [NSDate date];
    newSession.startTime = [NSDate date];
    newSession.sessionID = [self newSessionId];
    [[appDelegate currentSessions] addObject:newSession];
    
    [[self tableView] reloadData];
}

//generate new session id using the stored sessions
-(NSNumber *)newSessionId
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSNumber * newId = [[NSNumber alloc] initWithLong:0];
    
    if([[appDelegate storedSessions] count] > 0)
    {
        for(Session * sess in [appDelegate storedSessions])
        {
            if(sess.sessionID >= newId)
            {
                newId = [NSNumber numberWithLong:sess.sessionID.intValue + 1];
            }
        }
    }
    
    
    return newId;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
      NSLog(@"appDelegate.currentSessions count:%lu",(unsigned long)[[appDelegate currentSessions] count]);
    
    // Return the number of rows in the section.
    return [[appDelegate currentSessions] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    static NSString *CellIdentifier = @"SessionsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView =nil;
    
    Session  * rSession = (Session *)[[appDelegate currentSessions] objectAtIndex:[indexPath row]];

    UILabel * cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,11, cell.frame.size.width - 100, 21)];
    [cellLabel setText:[rSession projectName]];
    [cellLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:18]];
    [cellLabel setTextColor:[UIColor blackColor]];

    UILabel * timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 105, 8, 100, 30)];
    [timerLabel setText:[rSession timerValue]];
    timerLabel.tag = [indexPath row] + 1;//need to start tag at one, NOT ZERO
    [timerLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:18]];
    [timerLabel setTextColor:[UIColor blackColor]];
    
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
    [[cell contentView] addSubview:timerLabel];
    
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
        
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([UIAlertController class])
        {
           
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Save Session Data?"
                                          message:@"Would you like save session data to disk?"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* remove = [UIAlertAction
                                 actionWithTitle:@"Yes"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                   
                                     Session * thisSession = (Session *)[[appDelegate currentSessions] objectAtIndex:[indexPath row]];
                                     
                                     [thisSession stopTimer];
                                     
                                     //save to stored projects
                                     [[appDelegate storedSessions] addObject:[[appDelegate currentSessions] objectAtIndex:[indexPath row]]];
                                     
                                     //remove session from current sessions
                                      [[appDelegate currentSessions] removeObjectAtIndex:[indexPath row]];
                                     
                                     //remove from table view
                                     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            UIAlertAction* delete = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //remove session from current sessions
                                     [[appDelegate currentSessions] removeObjectAtIndex:[indexPath row]];
                                     
                                     //remove from table view
                                     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [alert addAction:remove];
            [alert addAction:delete];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            // use UIAlertView
            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Save Session Data?"
                                                             message:@"Would you like save session data to disk?"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Yes",@"No",nil];
            
            dialog.alertViewStyle = UIAlertControllerStyleActionSheet;
            dialog.tag = [indexPath row];
            [dialog show];
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


//-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(![_sessionRefreshTimer isValid])
//    {
//        _sessionRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];
//    }
//}
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
    
    // Navigation logic may go here, for example:
    // Create the next view controller.
    SessionDetailTableViewController *sessionDetailTableViewController = [[SessionDetailTableViewController alloc] initWithNibName:@"SessionDetailTableViewController" bundle:nil];
    
    // Pass the selected object to the new view controller.
    [sessionDetailTableViewController setSelectedSession:[[appDelegate currentSessions] objectAtIndex:[indexPath row]]];

    
    // Push the view controller.
    [self.navigationController pushViewController:sessionDetailTableViewController animated:YES];
}


-(void)deleteSessionForRow:(NSInteger)row
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //remove session from all sessions array
    for(Session * stored in [appDelegate storedSessions])
    {
        if(stored.sessionID==[[[appDelegate currentSessions] objectAtIndex:row] sessionID])
        {
            //replace session with updated object
            [[appDelegate storedSessions] removeObjectIdenticalTo:stored];
            
        }
    }
    
    //remove session from current sessions
    [[appDelegate currentSessions] removeObjectAtIndex:row];
    
    
}

-(void)saveSession:(NSInteger)row
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    Session * thisSession = (Session *)[[appDelegate currentSessions] objectAtIndex:row];
    
    [thisSession stopTimer];
    
    //save to stored projects
    [[appDelegate storedSessions] addObject:[[appDelegate currentSessions] objectAtIndex:row]];
    
    //remove session from current sessions
    [[appDelegate currentSessions] removeObjectAtIndex:row];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    switch (buttonIndex) {
        case 1:
            [self saveSession:alertView.tag];
            break;
        case 2:
            [[appDelegate currentSessions] removeObjectAtIndex:alertView.tag];
            break;
        default:
            break;
    }
    
    [[self tableView] reloadData];
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
