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
#import "Session+CoreDataClass.h"
#import "ProjectsTableViewController.h"
#import "utility.h"
#import "SessionInfoViewController.h"
#import "HelpViewController.h"

@interface SessionDetailCollectionViewController () {
	long _ticks;
	NSArray* _cellData;
	AppDelegate* _app;
	NSArray* _cellImages;
	bool _timerOn;
	NSTimer* _sessionTimer;
	MilageViewController* _milageVC;
	NSNumberFormatter *formatter;
}
@end

@implementation SessionDetailCollectionViewController

static NSString * const reuseIdentifier = @"DashboardCell";

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Set the title of the navigation item
	[[self navigationItem] setTitle:_selectedProject.name];
	
	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:NavBarImage]]];
	
	formatter = [[NSNumberFormatter alloc] init];
	
	//Add project start date with first session date
	if(!_selectedProject.start)
		_selectedProject.start = [NSDate date];
	
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_cellImages = @[@"empty", @"milage_track", @"notes", @"materials", @"help"];
	_timerOn = NO;
	
	//init as empty to avoid null
	[_selectedSession setNotes:@""];
	[_selectedSession setMaterials:@""];
	
	//TODO: Add these to cell data
	//@"Save and Remove", @"Delete"
	NSMutableDictionary* timerDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"start_stop_timer",nil),@"title", nil];

	_milageVC = [[MilageViewController alloc]
																		initWithNibName:@"MilageViewController"
																		bundle:nil];
	NSMutableDictionary* milageDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_milageVC, @"vc", NSLocalizedString(@"milage_tracking",nil),@"title", nil];


	SessionNotesViewController* sessionNotesVC = [[SessionNotesViewController alloc]
																								initWithNibName:@"SessionNotesViewController"
																								bundle:nil];
	NSMutableDictionary* sessionNotesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sessionNotesVC, @"vc", NSLocalizedString(@"add_notes", nil),@"title", nil];

	MaterialsViewController *materialsVC = [[MaterialsViewController alloc] initWithNibName:@"MaterialsViewController" bundle:nil];
	NSMutableDictionary* materialsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:materialsVC, @"vc",NSLocalizedString(@"materials", nil),@"title", nil];

	HelpViewController* helpVC = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
	helpVC.helpUrlString = @"https://loudsoftware.com/?page_id=506#sessions";
	NSMutableDictionary* helpDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:helpVC, @"vc", NSLocalizedString(@"help", nil),@"title", nil];
	
	_cellData = @[timerDict, milageDict, sessionNotesDict, materialsDict, helpDict];

	// Register cell classes
	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DashboardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
	
	
	//Override back button
	UIButton* exitButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 40, 80)];
	[exitButton setTitle:NSLocalizedString(@"save_and_exit", nil) forState:UIControlStateNormal];
	[exitButton setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
	[exitButton.imageView setTintColor:[UIColor whiteColor]];
	[exitButton addTarget:self action:@selector(backButtonHit:)
	 forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
																 initWithCustomView:exitButton];
	
	self.navigationItem.leftBarButtonItem = buttonItem;
	
}

- (IBAction)backButtonHit:(id)sender{
	//Check if milage tracking is running
	if(_milageVC.trackMilageSwitch && _milageVC.trackMilageSwitch.on){
		[utility showAlertWithTitle:NSLocalizedString(@"milage_running", nil) andMessage:NSLocalizedString(@"stop_milage", nil) andVC:self];
		return;
	}
	
	//check timer is running
	if (_timerOn) {
		[utility showAlertWithTitle:NSLocalizedString(@"timer_running", nil) andMessage:NSLocalizedString(@"stop_timer", nil) andVC:self];
	} else {
		//save timer ticks and exit
		[self saveSession];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void)saveSession {
	NSArray* hms = [utility hoursMinutesAndSecondsFromTicks:_ticks];
	_selectedSession.hours = [hms[0] intValue];
	_selectedSession.minutes = [hms[1] intValue];
	_selectedSession.seconds = [hms [2] intValue];
	[_app saveContext];
	_app.currentSession = nil;//destroy backup session
}

- (IBAction)updateTicks:(id)sender {
	NSTimeInterval secondsInBackground = [[NSDate date] timeIntervalSinceDate:_app.sessionStartTime];
	_ticks = secondsInBackground;
	
	//update session timer label
	DashboardCollectionViewCell* timerCell = (DashboardCollectionViewCell*)self.collectionView.visibleCells.firstObject;
	NSArray* hms = [utility hoursMinutesAndSecondsFromTicks:_ticks];
	formatter.minimumIntegerDigits = 2;
	timerCell.timeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",[formatter stringFromNumber:hms[0]], [formatter stringFromNumber:hms[1]], [formatter stringFromNumber:hms[2]]];
}

- (IBAction)timerToggle:(id)sender {
	UISwitch *timerSwitch = sender;
	_timerOn = timerSwitch.on;
	
	if(_timerOn){
		_app.sessionStartTime = [NSDate dateWithTimeIntervalSinceNow:-(_ticks)];
		_sessionTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTicks:) userInfo:nil repeats:YES];
	} else {
		[_sessionTimer invalidate];
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

	// Configure the cell
	cell.dashboardLabel.text = [[_cellData objectAtIndex:indexPath.row] objectForKey:@"title"];
	cell.cellImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _cellImages[indexPath.row]]];
	
	//Timer cell
	if([indexPath row] == 0) {
		cell.timerSwitch.hidden = NO;
		[cell.timerSwitch addTarget:self
								action:@selector(timerToggle:)
			forControlEvents:UIControlEventValueChanged];
		
		cell.timeLabel.hidden = NO;
		cell.cellImage.hidden = YES;
	}

	return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	SessionInfoViewController* selVC = [[_cellData objectAtIndex:indexPath.row] objectForKey:@"vc"];

	if(selVC){
		[selVC setSelectedSession:_selectedSession];
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

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
