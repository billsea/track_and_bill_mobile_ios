//
//  SessionDetailCollectionViewController.m
//  trackandbill_ios
//
//  Created by Loud on 3/26/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "SessionDetailCollectionViewController.h"
#import "SessionNotesViewController.h"
#import "MilageViewController.h"
#import "MaterialsViewController.h"
#import "DashboardCollectionViewCell.h"
#import "AppDelegate.h"
#import "Session.h"

@interface SessionDetailCollectionViewController () {
	float _ticks;
	NSArray* _cellData;
}
@end

@implementation SessionDetailCollectionViewController

static NSString * const reuseIdentifier = @"DashboardCell";

- (void)viewDidLoad {
	[super viewDidLoad];
	// Set the title of the navigation item
	[[self navigationItem] setTitle:[_selectedSession projectName]];

	// set background image
	[[self view]
	 setBackgroundColor:[UIColor
											 colorWithPatternImage:
											 [UIImage imageNamed:@"paper_texture_02.png"]]];
	//TODO: Add these to cell data
	//@"Save and Remove", @"Delete"
	NSMutableDictionary* timerDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Start/Stop Timer",@"title", nil];
	
	MilageViewController *milageVC = [[MilageViewController alloc]
																		initWithNibName:@"MilageViewController"
																		bundle:nil];
	NSMutableDictionary* milageDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:milageVC, @"vc", @"Log Milage",@"title", nil];
	
	
	SessionNotesViewController* sessionNotesVC = [[SessionNotesViewController alloc]
																								initWithNibName:@"SessionNotesViewController"
																								bundle:nil];
	NSMutableDictionary* sessionNotesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sessionNotesVC, @"vc", @"Add Notes",@"title", nil];
	
	MaterialsViewController *materialsVC = [[MaterialsViewController alloc] initWithNibName:@"MaterialsViewController" bundle:nil];
	NSMutableDictionary* materialsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:materialsVC, @"vc", @"Materials",@"title", nil];
	
	_cellData = @[timerDict, milageDict, sessionNotesDict, materialsDict];
	
	// Register cell classes
	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DashboardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)saveSessionToStored {
	AppDelegate *appDelegate =
	(AppDelegate *)[UIApplication sharedApplication].delegate;
	
	for (Session *stored in [appDelegate storedSessions]) {
		if (_selectedSession.sessionID == stored.sessionID) {
			[[appDelegate storedSessions] removeObjectIdenticalTo:stored];
			break;
		}
	}
	
	[[appDelegate storedSessions] addObject:_selectedSession];
}

- (IBAction)timerToggle:(id)sender {
	AppDelegate *appDelegate =
	(AppDelegate *)[UIApplication sharedApplication].delegate;
	
	UISwitch *timerSwitch = sender;
	
	if (timerSwitch.on) {
		// start session instance timer
		[_selectedSession startTimer];
		[appDelegate setActiveSession:_selectedSession];
	} else {
		// stop instance timer
		[_selectedSession stopTimer];
		[appDelegate setActiveSession:nil];
	}
}

#pragma mark - collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	DashboardCollectionViewCell* cell = (DashboardCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	if([indexPath row] == 0) {
		float switchWidth = 49.0f;
		float switchHeight = 31.0f;
		UISwitch *tSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width/2 - switchWidth/2, cell.frame.size.height/2 - switchHeight/2, switchWidth, switchHeight)];
		
		[tSwitch addTarget:self
								action:@selector(timerToggle:)
			forControlEvents:UIControlEventValueChanged];
		
		// set timer toggle state using session instance timer status
		if ([_selectedSession TimerRunning]) {
			[tSwitch setOn:TRUE];
		}
		[cell.cellImage setHidden:YES];
		[cell addSubview:tSwitch];
		
	}
	
	// Configure the cell
	cell.dashboardLabel.text = [[_cellData objectAtIndex:indexPath.row] objectForKey:@"title"];
	
	return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UIViewController* selVC = [[_cellData objectAtIndex:indexPath.row] objectForKey:@"vc"];
	
	if(selVC){
		//[selVC setSelectedSession:_selectedSession];
		[[self navigationController] pushViewController:[[_cellData objectAtIndex:indexPath.row] objectForKey:@"vc"] animated:YES];
	}
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	int cellCount = 2;
	float cellWidth = 120;
	float spacing = 40;
	NSInteger viewWidth = self.view.window.frame.size.width;
	NSInteger totalCellWidth = cellWidth * cellCount;
	NSInteger totalSpacingWidth = spacing * (cellCount - 1);
	
	NSInteger leftInset = (viewWidth - (totalCellWidth + totalSpacingWidth)) / 2;
	NSInteger rightInset = leftInset;
	
	return UIEdgeInsetsMake(0, leftInset, 0, rightInset);
}

//-(void)RemoveSession
//{
//
//        if ([UIAlertController class])
//        {
//
//            UIAlertController * alert=   [UIAlertController
//                                          alertControllerWithTitle:@"Remove
//                                          Session?"
//                                          message:@"Would you like to Remove
//                                          the selected session from the
//                                          Sessions list?"
//                                          preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction* remove = [UIAlertAction
//                                     actionWithTitle:@"Remove from List"
//                                     style:UIAlertActionStyleDefault
//                                     handler:^(UIAlertAction * action)
//                                     {
//                                         //remove session from current
//                                         sessions
//
//                                         [self removeCurrentSession];
//
//                                         [alert
//                                         dismissViewControllerAnimated:YES
//                                         completion:nil];
//
//                                     }];
//
//            UIAlertAction* cancel = [UIAlertAction
//                                     actionWithTitle:@"Cancel"
//                                     style:UIAlertActionStyleDefault
//                                     handler:^(UIAlertAction * action)
//                                     {
//                                         [alert
//                                         dismissViewControllerAnimated:YES
//                                         completion:nil];
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
//            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Remove
//            Session?"
//                                                             message:@"Would
//                                                             you like to
//                                                             Remove the
//                                                             selected session
//                                                             from the list?"
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
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication
//    sharedApplication].delegate;
//
//    for(Session * s in [appDelegate currentSessions])
//    {
//        if(s.sessionID == _selectedSession.sessionID)
//        {
//            [[appDelegate currentSessions] removeObject:s];
//            [appDelegate setRemovedSession:s];//track removed session for
//            session table view reload
//            break;
//        }
//    }
//
//    //back to sessions
//    [[self navigationController] popViewControllerAnimated:YES];
//}
//
//- (void)alertView:(UIAlertView *)alertView
//clickedButtonAtIndex:(NSInteger)buttonIndex
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
 
 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end