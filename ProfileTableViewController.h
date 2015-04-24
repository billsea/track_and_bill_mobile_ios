//
//  ProfileTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/16/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, retain) NSMutableArray *arrProfiles;
@property (nonatomic, retain) NSMutableArray *arrFormText;

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (IBAction)handleProfileSubmit:(id)sender;
- (void) saveDataToDisk;

@end
