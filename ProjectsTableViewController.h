//
//  ProjectsTableViewController.h
//  TrackAndBill_iOS
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 William Seaman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client+CoreDataClass.h"

@interface ProjectsTableViewController : UITableViewController
@property(nonatomic, retain) Client *selectedClient;

- (NSString *)pathForProjectsFile;
- (void)RetrieveProjects;

@end
