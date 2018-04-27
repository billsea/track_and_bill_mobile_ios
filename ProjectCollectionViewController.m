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

	_project = (Project*)_projectObjectId;
	_cellImages = @[@"stopwatch", @"surgical_scissors",@"invoice"];
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	
	// Set the title of the navigation item
	[[self navigationItem] setTitle:_project.name];


	NSMutableDictionary* newSessionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"New Session",@"title", nil];
	NSMutableDictionary* allSessionsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"Edit Sessions",@"title", nil];
	NSMutableDictionary* invoiceDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Invoice",@"title", nil];
	
	_cellData = [[NSMutableArray alloc] initWithObjects:newSessionDict, allSessionsDict, invoiceDict, nil];

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
			[_invoiceViewController setSelectedInvoice:nil];
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
	
	if([cellTitle isEqualToString: @"New Session"]){
		[self CreateSessionForProject];
	} else if([cellTitle isEqualToString: @"Edit Sessions"]){
		[self AllSessions];
	} else if([cellTitle isEqualToString: @"Invoice"]){
		[self invoiceProject];
	}
}

- (void)CreateSessionForProject {
	NSManagedObject* sessionObject;
	sessionObject = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:_context];
	
	Session* newSession = (Session*)sessionObject;
	newSession.sessiondate = [NSDate date];
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

	allSessionsViewController.projectObjectId = _projectObjectId;

	[self.navigationController pushViewController:allSessionsViewController
																			 animated:YES];
}

- (void)invoiceProject {

	// push inovices view controller
	_invoiceViewController = [[InvoiceTableViewController alloc] init];

	// no invoice exists for project, so create a new one
	_invoiceViewController.projectObjectId = _projectObjectId;
	[self.navigationController pushViewController:_invoiceViewController
																			 animated:YES];
	//TODO
//	// see if there is an exisiting invoice for this project
//	for (Invoice *invoice in [appDelegate arrInvoices]) {
//		if ((invoice.projectID == _selectedProject.projectID) &&
//				invoice.invoiceNumber) {
//			[_invoiceViewController setSelectedInvoice:invoice];
//			break;
//		}
//	}
//
//	if ([_invoiceViewController selectedInvoice]) {
//		// alert - An invoice exists for this project. Edit existing or create new
//		// invoice?
//		if ([UIAlertController class]) {
//
//			UIAlertController *alert = [UIAlertController
//																	alertControllerWithTitle:@"Invoice Exists"
//																	message:
//																	@"Edit the existing invoice or create a new one?"
//																	preferredStyle:UIAlertControllerStyleAlert];
//
//			UIAlertAction *editInvoice = [UIAlertAction
//																		actionWithTitle:@"Edit"
//																		style:UIAlertActionStyleDefault
//																		handler:^(UIAlertAction *action) {
//																			[self.navigationController
//																			 pushViewController:_invoiceViewController
//																			 animated:YES];
//																			[alert dismissViewControllerAnimated:YES completion:nil];
//
//																		}];
//			UIAlertAction *newInvoice = [UIAlertAction
//																	 actionWithTitle:@"New"
//																	 style:UIAlertActionStyleDefault
//																	 handler:^(UIAlertAction *action) {
//																		 [_invoiceViewController setSelectedInvoice:nil];
//																		 [_invoiceViewController
//																			setSelectedProject:_selectedProject];
//
//																		 [self.navigationController
//																			pushViewController:_invoiceViewController
//																			animated:YES];
//
//																		 [alert dismissViewControllerAnimated:YES completion:nil];
//																	 }];
//			UIAlertAction *cancel = [UIAlertAction
//															 actionWithTitle:@"Cancel"
//															 style:UIAlertActionStyleDefault
//															 handler:^(UIAlertAction *action) {
//																 [alert dismissViewControllerAnimated:YES completion:nil];
//
//															 }];
//
//			[alert addAction:editInvoice];
//			[alert addAction:newInvoice];
//			[alert addAction:cancel];
//
//			[self presentViewController:alert animated:YES completion:nil];
//		} else {
//			// use UIAlertView
//			UIAlertView *dialog = [[UIAlertView alloc]
//														 initWithTitle:@"Invoice Exists"
//														 message:@"Edit the existing invoice or create a new one?"
//														 delegate:self
//														 cancelButtonTitle:@"Cancel"
//														 otherButtonTitles:@"Edit", @"New", nil];
//
//			dialog.alertViewStyle = UIAlertControllerStyleActionSheet;
//			[dialog show];
//		}
//	} else {
//		// no invoice exists for project, so create a new one
//		[_invoiceViewController setSelectedInvoice:nil];
//		[_invoiceViewController setSelectedProject:_selectedProject];
//		[self.navigationController pushViewController:_invoiceViewController
//																				 animated:YES];
//	}
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
