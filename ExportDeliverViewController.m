//
//  ExportDeliverViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/5/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "ExportDeliverViewController.h"
#import "Session+CoreDataClass.h"

@interface ExportDeliverViewController (){
	NSString* _csvFilePath;
}
@end

@implementation ExportDeliverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createCSVfile];
}

- (void)createCSVfile {
	NSString *separator = @", ";
	NSString* cvs = @"";

	cvs = [NSString stringWithFormat:@"Date,Hours,Minutes,Seconds,Milage,Materials,Notes\n"];
				 
	for (Session *s in _selectedProject.sessions) {
		cvs = [NSString stringWithFormat:@"%@%@%@%hd%@%hd%@%hd%@%hd%@%@%@%@\n", cvs, s.start, separator, s.hours, separator, s.minutes, separator, s.seconds,separator,s.milage,separator,s.materials,separator,s.notes];
	}
	
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	//make a file name to write the data to using the documents directory:
	_csvFilePath = [NSString stringWithFormat:@"%@/track_sessions.csv",
												documentsDirectory];
	//create content - four lines of text
	NSString *content = cvs;
	//save content to the documents directory
	[content writeToFile:_csvFilePath
						atomically:NO
							encoding:NSUTF8StringEncoding
								 error:nil];
	
}

- (IBAction)emailCSV:(id)sender {
	
	if (![MFMailComposeViewController canSendMail]) {
		NSLog(@"Mail services are not available.");
		return;
	}
	
	MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
	composeVC.mailComposeDelegate = self;
	
	//convert file to data
	NSData* fileAttachmentData =  [NSData dataWithContentsOfFile:_csvFilePath options:NSDataReadingMappedIfSafe error:nil];
	
	// Configure the fields of the interface.
	[composeVC setToRecipients:@[@""]];
	[composeVC setSubject:@"Sessions CSV Export"];
	[composeVC setMessageBody:@"Sessions export attached" isHTML:NO];
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
	
	//TODO: Delete the csv file from ios device!
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
