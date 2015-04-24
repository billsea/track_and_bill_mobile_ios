//
//  AddClientTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/8/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface AddClientTableViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, retain) NSMutableArray *arrFormText;


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (IBAction)newClientSubmit:(id)sender;


@end
