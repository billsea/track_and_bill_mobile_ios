//
//  DashboardCollectionViewController.m
//  trackandbill_ios
//
//  Created by Loud on 3/23/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "DashboardCollectionViewController.h"
#import "ClientsTableViewController.h"
#import "SettingsTableViewController.h"
#import "DashboardCollectionViewCell.h"

@interface DashboardCollectionViewController (){
	NSMutableArray* _cellData;
}

@end

@implementation DashboardCollectionViewController

static NSString * const reuseIdentifier = @"DashboardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	ClientsTableViewController* clientsVC = [[ClientsTableViewController alloc]
															initWithNibName:@"ClientsTableViewController"
															bundle:nil];
	
	NSMutableDictionary* clientsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:clientsVC, @"vc", @"Clients",@"title", nil];
	
	SettingsTableViewController* settingsVC = [[SettingsTableViewController alloc]
																					 initWithNibName:@"SettingsTableViewController"
																					 bundle:nil];
	NSMutableDictionary* settingsDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:settingsVC, @"vc", @"Settings",@"title", nil];
	
	_cellData = [[NSMutableArray alloc] initWithObjects:clientsDict, settingsDict, nil];
	
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

	return cell;
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
