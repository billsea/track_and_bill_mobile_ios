//
//  ExportSelectTableViewController.h
//  trackandbill_ios
//
//  Created by Loud on 5/5/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project+CoreDataClass.h"
#import <MessageUI/MessageUI.h>

@interface ExportSelectTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>
@property(nonatomic) Project *selectedProject;
@end
