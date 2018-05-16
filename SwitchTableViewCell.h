//
//  SwitchTableViewCell.h
//  trackandbill_ios
//
//  Created by Loud on 5/15/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell
@property(nonatomic) void (^switchUpdateCallback)(BOOL);
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *rowSwitch;
- (IBAction)switchToggled:(id)sender;

@end
