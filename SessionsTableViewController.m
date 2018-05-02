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
#import "Session+CoreDataClass.h"
#import "Project+CoreDataClass.h"
#import "SessionDetailCollectionViewController.h"

@interface SessionsTableViewController (){
	Project* _project;
	AppDelegate* _app;
	NSManagedObjectContext* _context;
	NSFetchRequest* _fetchRequest;
}
@end

@implementation SessionsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Set the title of the navigation item
  [[self navigationItem] setTitle:@"Sessions"];

  _project = (Project*)_projectObjectId;
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  self.navigationItem.rightBarButtonItem = self.editButtonItem;

  // refreshes the timer label in each sessison row
  _sessionRefreshTimer =
      [NSTimer scheduledTimerWithTimeInterval:1
                                       target:self
                                     selector:@selector(updateTimerLabel)
                                     userInfo:nil
                                      repeats:YES];

  [self addNewSessionForSelectedProject];
}

// update the timer label for each session when timer ticks
- (void)updateTimerLabel {
  NSInteger index = 0;
  UITableViewCell *sessionCell = [[UITableViewCell alloc] init];
  UILabel *timerLabel = [[UILabel alloc] init];
  NSIndexPath *iPath = [[NSIndexPath alloc] init];

	//TODO: Add timer label
//  for (Session *curSession in [appDelegate currentSessions]) {
//    iPath = [NSIndexPath indexPathForRow:index inSection:0];
//
//    sessionCell = [self.tableView cellForRowAtIndexPath:iPath];
//
//    // doesn't like a zero value, so start at 1
//    timerLabel = (UILabel *)[sessionCell viewWithTag:index + 1];
//
//    [timerLabel setText:[curSession timerValue]];
//
//    index++;
//  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)addNewSessionForSelectedProject {

	NSManagedObject* sessionObject;
	sessionObject = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:_context];
	
	Session* newSession = (Session*)sessionObject;
	newSession.sessiondate = [NSDate date];
	newSession.start = [NSDate date];
	[_project addSessionsObject:newSession];

	//TODO:Check for duplicates(allow only one session for each project)
  [_app.currentSessions addObject:newSession];

  [[self tableView] reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"appDelegate.currentSessions count:%lu",
        (unsigned long)[[_app currentSessions] count]);
	
  return [[_app currentSessions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;

  static NSString *CellIdentifier = @"SessionsCell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }

  [cell setBackgroundColor:[UIColor clearColor]];
  cell.accessoryView = nil;

  Session *rSession = [[_app currentSessions] objectAtIndex:[indexPath row]];

  UILabel *cellLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(10, 11, cell.frame.size.width - 100, 21)];
  [cellLabel setText:_project.name];

  UILabel *timerLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 90, 8, 100, 30)];
	//[timerLabel setText:[rSession timerValue]];//TODO: Timer counter value
  timerLabel.tag = [indexPath row] + 1; // need to start tag at one, NOT ZERO


  // clear cell subviews-clears old cells
  if (cell != nil) {
    NSArray *subviews = [cell.contentView subviews];
    for (UIView *view in subviews) {
      [view removeFromSuperview];
    }
  }

  [[cell contentView] addSubview:cellLabel];
  [[cell contentView] addSubview:timerLabel];

  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    if ([UIAlertController class]) {

      UIAlertController *alert = [UIAlertController
          alertControllerWithTitle:@"Save Session Data?"
                           message:@"Would you like save session data to disk?"
                    preferredStyle:UIAlertControllerStyleAlert];

      UIAlertAction *remove = [UIAlertAction
          actionWithTitle:@"Yes"
                    style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction *action) {

										//TODO?
                    //Session *thisSession = (Session *)[[_app currentSessions] objectAtIndex:[indexPath row]];
                   // [thisSession stopTimer];

                    // save to stored projects
                    [[_app storedSessions] addObject:[[_app currentSessions]
                                      objectAtIndex:[indexPath row]]];

                    // remove session from current sessions
                    [[_app currentSessions] removeObjectAtIndex:[indexPath row]];

                    // remove from table view
                    [tableView
                        deleteRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationFade];

                    [alert dismissViewControllerAnimated:YES completion:nil];

                  }];
      UIAlertAction *delete = [UIAlertAction actionWithTitle:@"No"
                    style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction *action) {
                    // remove session from current sessions
                    [[_app currentSessions]
                        removeObjectAtIndex:[indexPath row]];

                    // remove from table view
                    [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                              withRowAnimation:UITableViewRowAnimationFade];

                    [alert dismissViewControllerAnimated:YES completion:nil];
                  }];
      UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                    style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction *action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];

                  }];

      [alert addAction:remove];
      [alert addAction:delete];
      [alert addAction:cancel];

      [self presentViewController:alert animated:YES completion:nil];
    } else {
      // use UIAlertView
      UIAlertView *dialog = [[UIAlertView alloc]
              initWithTitle:@"Save Session Data?"
                    message:@"Would you like save session data to disk?"
                   delegate:self
          cancelButtonTitle:@"Cancel"
          otherButtonTitles:@"Yes", @"No", nil];

      dialog.alertViewStyle = UIAlertControllerStyleActionSheet;
      dialog.tag = [indexPath row];
      [dialog show];
    }

  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array,
    // and add a new row to the table view
  }
}

//-(void)tableView:(UITableView *)tableView
//didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(![_sessionRefreshTimer isValid])
//    {
//        _sessionRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1
//        target:self selector:@selector(updateTimerLabel) userInfo:nil
//        repeats:YES];
//    }
//}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in
// -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  // Navigation logic may go here, for example:
  // Create the next view controller.
  SessionDetailCollectionViewController *sessionDetailCollectionViewController =
      [[SessionDetailCollectionViewController alloc]
          initWithNibName:@"SessionDetailCollectionViewController"
                   bundle:nil];

	sessionDetailCollectionViewController.selectedSession = (Session*)[[_app currentSessions] objectAtIndex:[indexPath row]];
	sessionDetailCollectionViewController.selectedProject = _project;

  [self.navigationController pushViewController:sessionDetailCollectionViewController
                                       animated:YES];
}

//- (void)deleteSessionForRow:(NSInteger)row {
//  AppDelegate *appDelegate =
//      (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//  // remove session from all sessions array
//  for (Session *stored in [appDelegate storedSessions]) {
//    if (stored.sessionID ==
//        [[[appDelegate currentSessions] objectAtIndex:row] sessionID]) {
//      // replace session with updated object
//      [[appDelegate storedSessions] removeObjectIdenticalTo:stored];
//    }
//  }
//
//  // remove session from current sessions
//  [[appDelegate currentSessions] removeObjectAtIndex:row];
//}
//
//- (void)saveSession:(NSInteger)row {
//  AppDelegate *appDelegate =
//      (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//  Session *thisSession =
//      (Session *)[[appDelegate currentSessions] objectAtIndex:row];
//
//  [thisSession stopTimer];
//
//  // save to stored projects
//  [[appDelegate storedSessions]
//      addObject:[[appDelegate currentSessions] objectAtIndex:row]];
//
//  // remove session from current sessions
//  [[appDelegate currentSessions] removeObjectAtIndex:row];
//}
//- (void)alertView:(UIAlertView *)alertView
//    clickedButtonAtIndex:(NSInteger)buttonIndex {
//  AppDelegate *appDelegate =
//      (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//  switch (buttonIndex) {
//  case 1:
//    [self saveSession:alertView.tag];
//    break;
//  case 2:
//    [[appDelegate currentSessions] removeObjectAtIndex:alertView.tag];
//    break;
//  default:
//    break;
//  }
//
//  [[self tableView] reloadData];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
