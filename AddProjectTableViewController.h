//
//  AddProjectTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/5/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddProjectTableViewController : UITableViewController <UITextFieldDelegate>
@property(nonatomic) NSManagedObjectID *clientObjectId;
@property(nonatomic) NSManagedObjectID *projectObjectId;
@end
