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
#import "ClientInvoicesTableViewController.h"
#import "DashboardCollectionViewCell.h"
#import "StylesCollectionViewController.h"

@interface DashboardCollectionViewController (){
	NSMutableArray* _cellData;
	NSArray* _cellImages;
}

@end

@implementation DashboardCollectionViewController

static NSString * const reuseIdentifier = @"DashboardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Dashboard";
	
	_cellImages = @[@"groups", @"mirror", @"administrator"];
	
	ClientsTableViewController* clientsVC = [[ClientsTableViewController alloc]
															initWithNibName:@"ClientsTableViewController"
															bundle:nil];
	
	NSMutableDictionary* clientsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:clientsVC, @"vc", @"Clients",@"title", nil];
	
	StylesCollectionViewController* stylesVC = [[StylesCollectionViewController alloc]
																					 initWithNibName:@"StylesCollectionViewController"
																					 bundle:nil];
	
	NSMutableDictionary* stylesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stylesVC, @"vc", @"Styles",@"title", nil];
	
	ProfileTableViewController* profileVC = [[ProfileTableViewController alloc]
																					 initWithNibName:@"SettingsTableViewController"
																					 bundle:nil];
	NSMutableDictionary* settingsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:profileVC, @"vc", @"Profile",@"title", nil];
	
	_cellData = [[NSMutableArray alloc] initWithObjects:clientsDict, stylesDict, settingsDict, nil];
	
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
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
	[[self navigationController] pushViewController:[[_cellData objectAtIndex:indexPath.row] objectForKey:@"vc"] animated:YES];
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

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
