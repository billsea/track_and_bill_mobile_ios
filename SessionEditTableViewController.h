//
//  SessionEditTableViewController.h
//  trackandbill_ios
//
//  Created by William Seaman on 5/5/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface SessionEditTableViewController : UITableViewController

@property (nonatomic,retain) Session * selectedSession;

@end
