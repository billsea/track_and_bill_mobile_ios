//
//  DashboardCollectionViewController.m
//  trackandbill_ios
//
//  Created by Loud on 3/23/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "DashboardCollectionViewController.h"
#import "ClientsTableViewController.h"
#import "ProfileTableViewController.h"
#import "InvoicesTableViewController.h"
#import "DashboardCollectionViewCell.h"
#import "StylesCollectionViewController.h"
#import "HelpViewController.h"
#import <FirebaseAnalytics/FIRAnalytics.h>

@interface DashboardCollectionViewController (){
	NSMutableArray* _cellData;
	NSArray* _cellImages;
}

@end

@implementation DashboardCollectionViewController

static NSString * const reuseIdentifier = @"DashboardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"dashboard", nil);
	
	_cellImages = @[@"clients", @"styles", @"invoices", @"profile",@"help"];
	
	ClientsTableViewController* clientsVC = [[ClientsTableViewController alloc]
															initWithNibName:@"ClientsTableViewController"
															bundle:nil];
	
	NSMutableDictionary* clientsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:clientsVC, @"vc", NSLocalizedString(@"clients", nil),@"title", nil];
	
	StylesCollectionViewController* stylesVC = [[StylesCollectionViewController alloc]
																					 initWithNibName:@"StylesCollectionViewController"
																					 bundle:nil];
	
	NSMutableDictionary* stylesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stylesVC, @"vc",NSLocalizedString(@"styles", nil),@"title", nil];
	
	InvoicesTableViewController* invoicesVC = [[InvoicesTableViewController alloc] initWithNibName:@"InvoicesTableViewController" bundle:nil];
	
	NSMutableDictionary* invoicesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:invoicesVC, @"vc", NSLocalizedString(@"invoices", nil),@"title", nil];
	
	
	ProfileTableViewController* profileVC = [[ProfileTableViewController alloc]
																					 initWithNibName:@"SettingsTableViewController"
																					 bundle:nil];
	NSMutableDictionary* profileDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:profileVC, @"vc", NSLocalizedString(@"profile", nil),@"title", nil];
	
	
	
	HelpViewController* helpVC = [[HelpViewController alloc]
																					 initWithNibName:@"HelpViewController"
																					 bundle:nil];
	NSMutableDictionary* helpDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:helpVC, @"vc", NSLocalizedString(@"help", nil),@"title", nil];
	
	
	_cellData = [[NSMutableArray alloc] initWithObjects:clientsDict, stylesDict, invoicesDict, profileDict, helpDict, nil];
	

    // Register cell classes
    [self.collectionView registerClass:[DashboardCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	
		[self.collectionView registerNib:[UINib nibWithNibName:@"DashboardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
	
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	DashboardCollectionViewCell* cell = (DashboardCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
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
	[[self navigationController] pushViewController:[[_cellData objectAtIndex:indexPath.row] objectForKey:@"vc"] animated:YES];
	
	//test log event - log image name for selection
	[FIRAnalytics logEventWithName:kFIREventSelectContent
											parameters:@{
																	 kFIRParameterItemID:[NSString stringWithFormat:@"dashboard_select-%@", [_cellImages objectAtIndex:indexPath.row]],
																	 kFIRParameterItemName:[_cellImages objectAtIndex:indexPath.row],
																	 kFIRParameterContentType:@"text"
																	 }];
}

@end
