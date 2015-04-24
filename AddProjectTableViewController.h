//
//  AddProjectTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/5/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface AddProjectTableViewController : UITableViewController<UITextFieldDelegate>


@property (nonatomic, retain) NSMutableArray *arrFormText;
@property Client * selectedClient;


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;

- (IBAction)newProjectSubmit:(id)sender;

@end
