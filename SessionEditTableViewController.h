//
//  SessionEditTableViewController.h
//  trackandbill_ios
//
//  Created by William Seaman on 5/5/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "ALEInlineDatePickerViewController.h"

@interface SessionEditTableViewController : ALEInlineDatePickerViewController

@property (nonatomic,retain) Session * selectedSession;

@end
