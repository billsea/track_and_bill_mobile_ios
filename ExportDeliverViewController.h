//
//  ExportDeliverViewController.h
//  trackandbill_ios
//
//  Created by Loud on 5/5/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project+CoreDataClass.h"
#import <MessageUI/MessageUI.h>

@interface ExportDeliverViewController : UIViewController <MFMailComposeViewControllerDelegate> {

}
- (IBAction)emailCSV:(id)sender;
@property(nonatomic) Project *selectedProject;
@end
