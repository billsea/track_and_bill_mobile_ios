//
//  SessionNotesViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/11/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session+CoreDataClass.h"
#import "SessionInfoViewController.h"

@interface SessionNotesViewController : SessionInfoViewController <UITextInputDelegate>

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
@end
