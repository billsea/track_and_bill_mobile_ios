//
//  DateSelectViewController.h
//  trackandbill_ios
//
//  Created by Loud on 4/30/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property(nonatomic) void (^dateSelectedCallback)(NSDate*);
- (IBAction)pickerUpdated:(id)sender;
@end
