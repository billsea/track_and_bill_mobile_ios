//
//  SessionInfoViewController.h
//  trackandbill_ios
//
//  Created by Loud on 4/27/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session+CoreDataClass.h"

@interface SessionInfoViewController : UIViewController
@property(nonatomic, retain) Session *selectedSession;
@end
