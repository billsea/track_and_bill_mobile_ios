//
//  ExportSelectTableViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/5/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "ExportSelectTableViewController.h"
#import "Session+CoreDataClass.h"
#import "Client+CoreDataClass.h"

#define kTableRowHeight 80

@interface ExportSelectTableViewController (){
	NSMutableArray* _cellData;
	NSString* _csv;
}
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation ExportSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[self navigationItem] setTitle: NSLocalizedString(@"export",nil)];
	
	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:NavBarImage]]];
	
	//Cell item data
	NSMutableDictionary* newSessionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"csv_file", nil),@"title", nil];
	
	_cellData = [[NSMutableArray alloc] initWithObjects:newSessionDict, nil];
	
	//interstitial ad
	self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:GoogleAdMobInterstitialID];
	GADRequest *request = [GADRequest request];
	request.testDevices = @[TestDeviceID, kGADSimulatorID];
	[self.interstitial loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"exportCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
																	reuseIdentifier:CellIdentifier];
	}

	cell.textLabel.numberOfLines = 2;
	[cell.textLabel setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
	cell.textLabel.text = [[_cellData objectAtIndex:indexPath.row] objectForKey:@"title"];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat rowHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
	if (rowHeight == 0) {
		rowHeight = kTableRowHeight; // self.tableView.rowHeight;
	}
	return rowHeight;
}

- (void)createAndSendCSVfile {
	NSString *separator = @", ";
	Client *selClient = _selectedProject.clients;
	
	//Header
	_csv = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@\n", NSLocalizedString(@"client_name", nil),separator, NSLocalizedString(@"project_name", nil), separator, NSLocalizedString(@"date", nil), separator, NSLocalizedString(@"hours", nil), separator, NSLocalizedString(@"minutes", nil), separator, NSLocalizedString(@"seconds", nil),separator,NSLocalizedString(@"milage", nil),separator,NSLocalizedString(@"materials", nil),separator,NSLocalizedString(@"notes", nil)];
	
	//Rows
	for (Session *s in _selectedProject.sessions) {
		_csv = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%hd%@%hd%@%hd%@%f%@%@%@%@\n", _csv, selClient.name, separator,_selectedProject.name, separator, s.start, separator, s.hours, separator, s.minutes, separator, s.seconds,separator,[s milage],separator,s.materials,separator,s.notes];
	}
	
	[self emailCSV];
}

- (void)emailCSV {
	
	if (![MFMailComposeViewController canSendMail]) {
		NSLog(@"Mail services are not available.");
		return;
	}
	
	MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
	composeVC.mailComposeDelegate = self;
	
	//convert string to data for attachment
	NSData* fileAttachmentData = [_csv dataUsingEncoding:NSUTF8StringEncoding];
	
	// Configure the fields of the interface.
	[composeVC setToRecipients:@[@""]];
	[composeVC setSubject:NSLocalizedString(@"csv_email_subject", nil)];
	[composeVC setMessageBody:NSLocalizedString(@"csv_email_body", nil) isHTML:NO];
	[composeVC addAttachmentData:fileAttachmentData mimeType:@"text/csv" fileName:NSLocalizedString(@"csv_export_attach", nil)];
	
	[self presentViewController:composeVC animated:YES completion:nil];
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
				 didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	if (result)
		NSLog(@"Result : %ld",(long)result);
	if (error)
		NSLog(@"Error : %@",error);
	
	[controller	dismissViewControllerAnimated:YES completion:^{
		if(result == MFMailComposeResultSent)
			[self showBigAd];//show add after sending email
	}];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0) {
		[self createAndSendCSVfile];
	}
}

#pragma mark AdMob
- (void)showBigAd {
	if (self.interstitial.isReady) {
		[self.interstitial presentFromRootViewController:self];
	} else {
		NSLog(@"Ad wasn't ready");
	}
}

@end
