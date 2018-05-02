//
//  MilageViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/11/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "MilageViewController.h"

@interface MilageViewController ()
@property(nonatomic) UIPickerView *milagePicker;
@end

@implementation MilageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.

  // Set the title of the navigation item
  [[self navigationItem] setTitle:NSLocalizedString(@"miles_driven", nil)];

  _pickerData = [[NSMutableArray alloc] init];

  for (int i = 0; i < 3000; i++) {
    [_pickerData addObject:[NSString stringWithFormat:@"%d", i]];
  }

  [self loadMilagePicker];
}

- (void)viewWillAppear:(BOOL)animated {
  [_milagePicker selectRow:self.selectedSession.milage
               inComponent:0
                  animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  // save milage selection
  [self.selectedSession
      setMilage:[_milagePicker selectedRowInComponent:0]];
}

- (void)loadMilagePicker {
  // set pickerview
  CGRect screenRect = [[UIScreen mainScreen] bounds];

  _milagePicker = [[UIPickerView alloc]
      initWithFrame:CGRectMake(10, 10, screenRect.size.width - 10,
                               screenRect.size.height - 50)];
  _milagePicker.delegate = self;
  _milagePicker.showsSelectionIndicator = YES;

  [[self view] addSubview:_milagePicker];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark picker view delegate methods
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component {
  return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  return _pickerData[row];
}

@end
