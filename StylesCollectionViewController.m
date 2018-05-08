//
//  StylesCollectionViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/1/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "StylesCollectionViewController.h"
#import "DashboardCollectionViewCell.h"
#import "Profile+CoreDataClass.h"
#import "Model.h"
#import "utility.h"
#import "AppDelegate.h"

@interface StylesCollectionViewController (){
	NSMutableArray* _cellData;
	NSArray* _cellImages;
	Profile* _myProfile;
	AppDelegate* _app;
}

@end

@implementation StylesCollectionViewController

static NSString * const reuseIdentifier = @"DashboardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = NSLocalizedString(@"styles", nil);

	_app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	_myProfile = (Profile*)[self MyProfile];
	
	_cellImages = @[@"xlarge_icons"];

	StylesCollectionViewController* stylesVC = [[StylesCollectionViewController alloc]
																						initWithNibName:@"StylesCollectionViewController"
																						bundle:nil];

	NSMutableDictionary* stylesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stylesVC, @"vc",NSLocalizedString(@"logo", nil),@"title", nil];

	_cellData = [[NSMutableArray alloc] initWithObjects:stylesDict, nil];

	// Register cell classes
	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DashboardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSManagedObject *)MyProfile {
	// Fetch data from persistent data store;
	NSMutableArray* data = [Model dataForEntity:@"Profile"];
	return data.count > 0 ? [data objectAtIndex:0] : nil;
}

-(void)showPhotoLibrary{
	if(_myProfile){
		UIImagePickerController * picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		[self.navigationController showViewController:picker sender:self];
		} else {
		 [utility showAlertWithTitle:NSLocalizedString(@"profile_missing", nil) andMessage:NSLocalizedString(@"style_profile_alert", nil) andVC:self];
	  }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSURL *picURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
	NSString *stringUrl = picURL.absoluteString;

	[_myProfile setLogo_url:stringUrl];
	[_app saveContext];
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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
	
	if([cellTitle isEqualToString: NSLocalizedString(@"logo", nil)]){
		[self showPhotoLibrary];
	}
}

@end
