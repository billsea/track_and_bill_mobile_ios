//
//  SessionDetailTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/11/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface SessionDetailTableViewController : UITableViewController<UIActionSheetDelegate>

- (IBAction)timerToggle:(id)sender;
@property (nonatomic, retain) Session * selectedSession;


@end
