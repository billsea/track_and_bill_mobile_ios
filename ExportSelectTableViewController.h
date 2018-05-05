//
//  ExportSelectTableViewController.h
//  trackandbill_ios
//
//  Created by Loud on 5/5/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project+CoreDataClass.h"

@interface ExportSelectTableViewController : UITableViewController
@property(nonatomic) Project *selectedProject;
@end
