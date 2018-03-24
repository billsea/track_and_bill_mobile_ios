//
//  SessionViewController.h
//  TrackAndBill_iOS
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 William Seaman. All rights reserved.
//

#import "Session.h"

@interface SessionViewController : UIViewController <UITextInputDelegate>
@property(weak, nonatomic) IBOutlet UILabel *sessionProjectName;
@property(weak, nonatomic) IBOutlet UIButton *timerButton;
@property(nonatomic, retain) Session *selectedSession;

- (IBAction)timerToggle:(id)sender;
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
@end
