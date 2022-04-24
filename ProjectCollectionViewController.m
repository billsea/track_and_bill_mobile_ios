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
#import "HelpViewController.h"

@interface ProjectCollectionViewController () <GADBannerViewDelegate>{
	NSMutableArray* _cellData;
	NSManagedObjectContext* _context;
	InvoiceTableViewController *_invoiceViewController;
	Project* _project;
	NSArray* _cellImages;
	AppDelegate* _app;
	GADBannerView* _adView;
}
@end

@implementation ProjectCollectionViewController

static NSString * const reuseIdentifier = @"DashboardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_project = (Project*)_projectObjectId;
	_cellImages = @[@"new_session", @"edit_session",@"invoice", @"export", @"help"];
	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_context = _app.persistentContainer.viewContext;
	
	[[self navigationItem] setTitle:_project.name];
	
	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:NavBarImage]]];
	
	//Cell item data
	NSMutableDictionary* newSessionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"new_session", nil),@"title", nil];
	NSMutableDictionary* allSessionsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"edit_sessions", nil),@"title", nil];
	NSMutableDictionary* invoiceDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"invoice", nil),@"title", nil];
	NSMutableDictionary* exportDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"export", nil),@"title", nil];
		NSMutableDictionary* helpDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"help", nil),@"title", nil];
	
	_cellData = [[NSMutableArray alloc] initWithObjects:newSessionDict, allSessionsDict, invoiceDict, exportDict, helpDict,nil];

    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
		[self.collectionView registerNib:[UINib nibWithNibName:@"DashboardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if(!_adView)
		[self displayAdBanner];
}

- (void)alertView:(UIAlertController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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
	cell.cellImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _cellImages[indexPath.row]]];
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
	} else if([cellTitle isEqualToString: NSLocalizedString(@"help", nil)]){
		[self showHelp];
	}
}

- (void)showHelp {
	HelpViewController* helpVC = [[HelpViewController alloc]
																initWithNibName:@"HelpViewController"
																bundle:nil];
	helpVC.helpUrlString = @"https://loudsoftware.com/?page_id=506#projectdetail";
	[self.navigationController pushViewController:helpVC animated:YES];
}

- (void)CreateSessionForProject {
	NSManagedObject* sessionObject;
	sessionObject = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:_context];
	
	Session* newSession = (Session*)sessionObject;
	newSession.start = [NSDate date];
	[_project addSessionsObject:newSession];
	
	// Session detail
	SessionDetailCollectionViewController *sessionDetailCollectionViewController =
	[[SessionDetailCollectionViewController alloc]
	 initWithNibName:@"SessionDetailCollectionViewController"
	 bundle:nil];
	
	_app.currentSession = newSession;//save backup in app delegate for saving on app termination
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

#pragma mark Ads
- (void)displayAdBanner {
	_adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
	_adView.frame = CGRectMake(0, self.view.window.frame.size.height - _adView.frame.size.height, _adView.frame.size.width, _adView.frame.size.height);
	_adView.backgroundColor = [UIColor clearColor];
	_adView.rootViewController = self;
	_adView.delegate = self;
	_adView.adUnitID = GoogleAdMobBannerID;
	
	[self.view addSubview:_adView]; // Request an ad without any additional targeting information.
	//adds test ads
	[_adView loadRequest:self.request];
}

- (GADRequest *)request {
	GADRequest *request = [GADRequest request];
	//device and simulator test ids
	request.testDevices = @[TestDeviceID, kGADSimulatorID];
	return request;
}
- (void)showAdView {
	//Interstitial ad view
	//[self.navigationController pushViewController:adViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
