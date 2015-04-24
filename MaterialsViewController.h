//
//  MaterialsViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/17/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface MaterialsViewController : UIViewController<UITextInputDelegate>
@property (nonatomic, retain) Session * selectedSession;
@end
