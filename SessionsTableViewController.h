//
//  SessionsTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/15/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface SessionsTableViewController
    : UITableViewController <UIActionSheetDelegate>
@property(weak) NSTimer *sessionRefreshTimer;
@property(nonatomic, retain) Project *selectedProject;
@end
