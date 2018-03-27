//
//  SessionDetailCollectionViewController.h
//  trackandbill_ios
//
//  Created by Loud on 3/26/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface SessionDetailCollectionViewController
: UICollectionViewController <UIActionSheetDelegate>
@property(nonatomic, retain) Session *selectedSession;
- (IBAction)timerToggle:(id)sender;
@end
