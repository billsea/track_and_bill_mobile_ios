//
//  SessionDetailTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/11/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "SessionDetailTableViewController.h"
#import "SessionNotesViewController.h"
#import "MilageViewController.h"
#import "MaterialsViewController.h"
#import "AppDelegate.h"
#import "Session.h"

@interface SessionDetailTableViewController ()

@end

@implementation SessionDetailTableViewController

float _ticks;

@synthesize selectedSession = _selectedSession;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Set the title of the navigation item
    [[self navigationItem] setTitle:[_selectedSession projectName]];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self saveSessionToStored];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveSessionToStored
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for(Session * stored in [appDelegate storedSessions])
    {
        if(_selectedSession.sessionID == stored.sessionID)
        {
            [[appDelegate storedSessions] removeObjectIdenticalTo:stored];
            break;
        }
    }

    [[appDelegate storedSessions] addObject:_selectedSession];
}

- (IBAction)timerToggle:(id)sender {
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UISwitch * timerSwitch = sender;
    
    
    if(timerSwitch.on)
    {
        //start session instance timer
        [_selectedSession startTimer];
        [appDelegate setActiveSession:_selectedSession];
    }
    else
    {
        //stop instance timer
        [_selectedSession stopTimer];
        [appDelegate setActiveSession:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    static NSString *CellIdentifier = @"SessionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   // [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView =nil;
    
    UILabel * cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(11,11, cell.frame.size.width - 100, 21)];

    [cellLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
    [cellLabel setTextColor:[UIColor blackColor]];
    
    UISwitch * tSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(screenWidth - 65, 6, 30, 30)];

    //set timer toggle state using session instance timer status
    if([_selectedSession TimerRunning])
    {
        [tSwitch setOn:TRUE];
    }
    
    switch ([indexPath row]) {
        case 0:
            [tSwitch addTarget:self action:@selector(timerToggle:) forControlEvents:UIControlEventValueChanged];
            [cellLabel setText:@"Start/Stop Timer"];
            [cell addSubview: cellLabel];
            [cell addSubview:tSwitch];
            break;
        case 1:
            [cellLabel setText:@"Log Milage"];
            [cell addSubview: cellLabel];
            break;
        case 2:
            [cellLabel setText:@"Add Notes"];
            [cell addSubview: cellLabel];
            break;
        case 3:
            [cellLabel setText:@"Materials"];
            [cell addSubview: cellLabel];
            break;
//        case 3:
//            [cellLabel setText:@"Save & Remove"];
//            [cell addSubview: cellLabel];
//            [cell setBackgroundColor:[UIColor greenColor]];
//            break;
//        case 4:
//            [cellLabel setText:@"Delete"];
//            [cell addSubview: cellLabel];
//            [cell setBackgroundColor:[UIColor grayColor]];
//            break;
        default:
            break;
    }
    
    
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
    // Navigation logic may go here, for example:
    // Create the next view controller.

    SessionNotesViewController *notesViewController;
    MilageViewController *milageViewController;
    MaterialsViewController * materialsViewController;
    
    switch (indexPath.row) {
        case 1:
            // Pass the selected object to the new view controller.
            milageViewController = [[MilageViewController alloc] initWithNibName:@"MilageViewController" bundle:nil];
            [milageViewController setSelectedSession:_selectedSession];
            [self.navigationController pushViewController:milageViewController animated:YES];
            break;
        case 2:
            // Pass the selected object to the new view controller.
            notesViewController = [[SessionNotesViewController alloc] initWithNibName:@"SessionNotesViewController" bundle:nil];
            [notesViewController setSelectedSession:_selectedSession];
            [self.navigationController pushViewController:notesViewController animated:YES];
            break;
        case 3:
            // Pass the selected object to the new view controller.
            materialsViewController = [[MaterialsViewController alloc] initWithNibName:@"MaterialsViewController" bundle:nil];
            [materialsViewController setSelectedSession:_selectedSession];
            [self.navigationController pushViewController:materialsViewController animated:YES];
            break;
//        case 3:
//            // Remove Session
//            [self RemoveSession];
//            break;
//        case 4:
//            // Delete Session
        default:
            break;
    }
    
}

//-(void)RemoveSession
//{
//  
//        if ([UIAlertController class])
//        {
//            
//            UIAlertController * alert=   [UIAlertController
//                                          alertControllerWithTitle:@"Remove Session?"
//                                          message:@"Would you like to Remove the selected session from the Sessions list?"
//                                          preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* remove = [UIAlertAction
//                                     actionWithTitle:@"Remove from List"
//                                     style:UIAlertActionStyleDefault
//                                     handler:^(UIAlertAction * action)
//                                     {
//                                         //remove session from current sessions
//                                         
//                                         [self removeCurrentSession];
//
//                                         [alert dismissViewControllerAnimated:YES completion:nil];
//                                         
//                                     }];
//
//            UIAlertAction* cancel = [UIAlertAction
//                                     actionWithTitle:@"Cancel"
//                                     style:UIAlertActionStyleDefault
//                                     handler:^(UIAlertAction * action)
//                                     {
//                                         [alert dismissViewControllerAnimated:YES completion:nil];
//                                         
//                                     }];
//            
//            [alert addAction:remove];
//            [alert addAction:cancel];
//            
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//        else
//        {
//            // use UIAlertView
//            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Remove Session?"
//                                                             message:@"Would you like to Remove the selected session from the list?"
//                                                            delegate:self
//                                                   cancelButtonTitle:@"Cancel"
//                                                   otherButtonTitles:@"Remove",nil];
//            
//            dialog.alertViewStyle = UIAlertControllerStyleActionSheet;
//            //dialog.tag = [indexPath row];
//            [dialog show];
//        }
//         
//
//}
//
//-(void)removeCurrentSession
//{
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    
//    for(Session * s in [appDelegate currentSessions])
//    {
//        if(s.sessionID == _selectedSession.sessionID)
//        {
//            [[appDelegate currentSessions] removeObject:s];
//            [appDelegate setRemovedSession:s];//track removed session for session table view reload
//            break;
//        }
//    }
//    
//    //back to sessions
//    [[self navigationController] popViewControllerAnimated:YES];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//  
//    switch (buttonIndex) {
//        case 1:
//            [self removeCurrentSession];
//            break;
//        default:
//            break;
//    }
//    
//
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
