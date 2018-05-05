//
//  DateSelectViewController.m
//  trackandbill_ios
//
//  Created by Loud on 4/30/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "DateSelectViewController.h"

@interface DateSelectViewController ()

@end

@implementation DateSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[_datePicker setDatePickerMode:UIDatePickerModeDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pickerUpdated:(id)sender {
	self.dateSelectedCallback(_datePicker.date);
}
@end
