//
//  ProjectCollectionViewController.m
//  trackandbill_ios
//
//  Created by Loud on 3/25/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "ProjectCollectionViewController.h"
#import "InvoiceTableViewController.h"
#import "SessionDetailCollectionViewController.h"
#import "AllSessionsTableViewController.h"
#import "DashboardCollectionViewCell.h"
#import "Project+CoreDataClass.h"
#import "AppDelegate.h"
#import "ProjectsTableViewController.h"
#import "utility.h"
#import "ExportSelectTableViewController.h"

@interface ProjectCollectionViewController (){
	NSMutableArray* _cellData;
	NSManagedObjectContext* _context;
	InvoiceTableViewController *_invoiceViewController;
	Project* _project;
	NSArray* _cellImages;
	AppDelegate* _app;
}
@end

@implementation ProjectCollectionViewController

static NSString * const reuseIdentifier = @"DashboardCell";

- (void)viewDidLoad {
    [super viewDidLoad];

	[[self navigationItem] setTitle:_project.name];
	
	_project = (Project*)_projectObjectId;
	_cellImages = @[@"stopwatch", @"surgical_scissors",@"invoice", @"cargo_ship"];
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	
	//Cell item data
	NSMutableDictionary* newSessionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"new_session", nil),@"title", nil];
	NSMutableDictionary* allSessionsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"edit_sessions", nil),@"title", nil];
	NSMutableDictionary* invoiceDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"invoice", nil),@"title", nil];
	NSMutableDictionary* exportDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"export", nil),@"title", nil];
	
	_cellData = [[NSMutableArray alloc] initWithObjects:newSessionDict, allSessionsDict, invoiceDict, exportDict, nil];

    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
		[self.collectionView registerNib:[UINib nibWithNibName:@"DashboardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 1:
			// invoice already set
			[self.navigationController pushViewController:_invoiceViewController
																					 animated:YES];
			break;
		case 2:
			_invoiceViewController.projectObjectId = _projectObjectId;
			[self.navigationController pushViewController:_invoiceViewController
																					 animated:YES];
			break;
		default:
			break;
	}
}


#pragma mark UICollectionViewDataSource

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
	cell.cellImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-50.png", _cellImages[indexPath.row]]];
	return cell;
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

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString* cellTitle = [[_cellData objectAtIndex:indexPath.row] objectForKey:@"title"];
	
	if([cellTitle isEqualToString: NSLocalizedString(@"new_session", nil)]){
		[self CreateSessionForProject];
	} else if([cellTitle isEqualToString: NSLocalizedString(@"edit_sessions", nil)]){
		[self AllSessions];
	} else if([cellTitle isEqualToString: NSLocalizedString(@"invoice", nil)]){
		[self invoiceProject];
	} else if([cellTitle isEqualToString: NSLocalizedString(@"export", nil)]){
		[self exportProject];
	}
}

- (void)CreateSessionForProject {
	NSManagedObject* sessionObject;
	sessionObject = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:_context];
	
	Session* newSession = (Session*)sessionObject;
	newSession.start = [NSDate date];
	[_project addSessionsObject:newSession];
	
	//keep track of current sessions
	[_app.currentSessions addObject:newSession];
	
	// Session detail
	SessionDetailCollectionViewController *sessionDetailCollectionViewController =
	[[SessionDetailCollectionViewController alloc]
	 initWithNibName:@"SessionDetailCollectionViewController"
	 bundle:nil];
	
	sessionDetailCollectionViewController.selectedSession = newSession;
	sessionDetailCollectionViewController.selectedProject = _project;
	
	[self.navigationController pushViewController:sessionDetailCollectionViewController
																			 animated:YES];
}

- (void)AllSessions {
	// push the all sessions table view
	AllSessionsTableViewController *allSessionsViewController =
	[[AllSessionsTableViewController alloc]
	 initWithNibName:@"AllSessionsTableViewController"
	 bundle:nil];

	allSessionsViewController.selectedProject = _project;

	[self.navigationController pushViewController:allSessionsViewController
																			 animated:YES];
}

- (void)invoiceProject {
	_invoiceViewController = [[InvoiceTableViewController alloc] init];
	[_invoiceViewController setSelectedProject:_project];
	[self.navigationController pushViewController:_invoiceViewController
																			 animated:YES];
}

- (void)exportProject {
	ExportSelectTableViewController* exportSelectVC = [[ExportSelectTableViewController alloc] initWithNibName:@"ExportSelectTableViewController"
	 bundle:nil];
	
	[exportSelectVC setSelectedProject:_project];
	
	[self.navigationController pushViewController:exportSelectVC
																			 animated:YES];
	
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
