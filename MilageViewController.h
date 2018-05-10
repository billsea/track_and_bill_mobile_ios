//
//  MilageViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/11/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session+CoreDataClass.h"
#import "SessionInfoViewController.h"

@interface MilageViewController
    : SessionInfoViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *trackMilageSwitch;
@property (weak, nonatomic) IBOutlet UIPickerView *milagePicker;
- (IBAction)trackMilage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@end
