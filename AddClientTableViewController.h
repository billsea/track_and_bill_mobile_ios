//
//  AddClientTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/8/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddClientTableViewController : UITableViewController <UITextFieldDelegate>
@property(strong, nonatomic) NSMutableArray *userData;
@property(nonatomic) NSManagedObjectID *clientObjectId;
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
@end
