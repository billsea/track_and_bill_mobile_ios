//
//  SessionDetailCollectionViewController.h
//  trackandbill_ios
//
//  Created by Loud on 3/26/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session+CoreDataClass.h"
#import "Project+CoreDataClass.h"

@interface SessionDetailCollectionViewController
: UICollectionViewController <UIActionSheetDelegate>
@property(nonatomic, retain) Session *selectedSession;
@property(nonatomic) Project* selectedProject;
- (IBAction)timerToggle:(id)sender;
@end
