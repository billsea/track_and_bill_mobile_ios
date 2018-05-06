//
//  ExportSelectTableViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/5/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "ExportSelectTableViewController.h"
#import "Session+CoreDataClass.h"

#define kTableRowHeight 80

@interface ExportSelectTableViewController (){
	NSMutableArray* _cellData;
	NSString* _csv;
}

@end

@implementation ExportSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[self navigationItem] setTitle: NSLocalizedString(@"export",nil)];
	
	//Cell item data
	NSMutableDictionary* newSessionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"csv_file", nil),@"title", nil];
	
	_cellData = [[NSMutableArray alloc] initWithObjects:newSessionDict, nil];
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
	_csv = [NSString stringWithFormat:@"Date,Hours,Minutes,Seconds,Milage,Materials,Notes\n"];
	
	for (Session *s in _selectedProject.sessions) {
		_csv = [NSString stringWithFormat:@"%@%@%@%hd%@%hd%@%hd%@%hd%@%@%@%@\n", _csv, s.start, separator, s.hours, separator, s.minutes, separator, s.seconds,separator,s.milage,separator,s.materials,separator,s.notes];
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
	
	[controller	dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0) {
		[self createAndSendCSVfile];
	}
}


@end
