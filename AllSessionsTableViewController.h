//
//  AllSessionsTableViewController.h
//  trackandbill_ios
//
//  Created by William Seaman on 5/4/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h" 

@interface AllSessionsTableViewController : UITableViewController
@property (nonatomic, retain) Project * selectedProject;
@property (nonatomic) NSMutableArray *allProjectSessions;
@end
