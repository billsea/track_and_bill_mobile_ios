//
//  utility.m
//  vrMobile
//
//  Created by Loud on 6/3/17.
//
//

#import "utility.h"

@implementation utility

+ (void)showAlertWithTitle:(NSString *)message_title
                andMessage:(NSString *)message
                     andVC:(UIViewController *)vc {

    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:message_title
                         message:message
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){
                               }];

    [alert addAction:defaultAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (NSArray*)hoursMinutesAndSecondsFromTicks:(long)ticks {
		double sec = fmod(ticks, 60.0);
		double m = fmod(trunc(ticks / 60.0), 60.0);
		double h = trunc(ticks / 3600.0);
	
		NSNumber* hours = [NSNumber numberWithDouble:h];
		NSNumber* minutes = [NSNumber numberWithDouble:m];
		NSNumber* seconds = [NSNumber numberWithDouble:sec];
	
	return @[hours, minutes, seconds];
}

//- (void)saveAlert {
//	UIAlertController *alert = [UIAlertController
//															alertControllerWithTitle:@"Stop Session?"
//															message:@"Would you like to stop the session?"
//															preferredStyle:UIAlertControllerStyleAlert];
//
//	UIAlertAction *stop = [UIAlertAction
//													 actionWithTitle:@"Yes"
//													 style:UIAlertActionStyleDefault
//													 handler:^(UIAlertAction *action) {
//														 //stop timer and go to project collection view
//														 [self removeCurrentSession];
//														 [alert dismissViewControllerAnimated:YES completion:nil];
//
//													 }];
//	UIAlertAction *noStop = [UIAlertAction actionWithTitle:@"No"
//																									 style:UIAlertActionStyleDefault
//																								 handler:^(UIAlertAction *action) {
//																									 //Go to ProjectsTableViewController(don't pop back to collection view)
//																									 ProjectsTableViewController *projectsViewController =
//																									 [[ProjectsTableViewController alloc]
//																										initWithNibName:@"ProjectsTableViewController"
//																										bundle:nil];
//
//																									 projectsViewController.clientObjectId = [_selectedProject clients]; //selected client data object id
//
//																									 // Push the view controller.
//																									 [self.navigationController pushViewController:projectsViewController
//																																												animated:YES];
//
//																								 }];
//	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
//																									 style:UIAlertActionStyleDefault
//																								 handler:^(UIAlertAction *action) {
//																									 [alert dismissViewControllerAnimated:YES completion:nil];
//																									 //do nothing
//																								 }];
//
//	[alert addAction:stop];
//	[alert addAction:noStop];
//	[alert addAction:cancel];
//
//	[self presentViewController:alert animated:YES completion:nil];
//}

//-(void)RemoveSession
//{
//	if ([UIAlertController class])
//	{
//
//			UIAlertController * alert=   [UIAlertController
//																		alertControllerWithTitle:@"Remove Session?"
//																		message:@"Would you like to Remove the selected session from the Sessions list?"
//																		preferredStyle:UIAlertControllerStyleAlert];
//
//			UIAlertAction* remove = [UIAlertAction
//															 actionWithTitle:@"Remove from List"
//															 style:UIAlertActionStyleDefault
//															 handler:^(UIAlertAction * action)
//															 {
//																	 //remove session from current sessions
//																	 [self removeCurrentSession];
//
//																	 [alert dismissViewControllerAnimated:YES
//																	 completion:nil];
//															 }];
//
//			UIAlertAction* cancel = [UIAlertAction
//															 actionWithTitle:@"Cancel"
//															 style:UIAlertActionStyleDefault
//															 handler:^(UIAlertAction * action)
//															 {
//																	 [alert
//																	 dismissViewControllerAnimated:YES
//																	 completion:nil];
//															 }];
//
//			[alert addAction:remove];
//			[alert addAction:cancel];
//			[self presentViewController:alert animated:YES completion:nil];
//	}
//	else
//	{
//			// use UIAlertView
//			UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Remove Session?"
//																											 message:@"Would you like to Remove the selected session from the list?"
//																											delegate:self
//																						 cancelButtonTitle:@"Cancel"
//																						 otherButtonTitles:@"Remove",nil];
//
//			dialog.alertViewStyle = UIAlertControllerStyleActionSheet;
//			//dialog.tag = [indexPath row];
//			[dialog show];
//	}
//}

@end
