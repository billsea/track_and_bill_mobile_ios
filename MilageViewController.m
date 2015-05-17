//
//  MilageViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/11/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "MilageViewController.h"

@interface MilageViewController ()

@end

@implementation MilageViewController

UIPickerView * milagePicker;
@synthesize selectedSession = _selectedSession;
@synthesize pickerData = _pickerData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the title of the navigation item
    [[self navigationItem] setTitle:@"Mile Driven"];
    
    //set background image
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture_02.png"]]];
    
    _pickerData = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<3000; i++)
    {
        [_pickerData addObject:[NSString stringWithFormat:@"%d",i]];
    }
    //_pickerData = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    
    [self loadMilagePicker];
}

-(void)viewWillAppear:(BOOL)animated
{
    [milagePicker selectRow:[[_selectedSession milage] longValue] inComponent:0 animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //save milage selection
    [_selectedSession setMilage:[NSNumber numberWithInteger:[milagePicker selectedRowInComponent:0]]];
}

- (void)loadMilagePicker
{
    //set pickerview
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    milagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(10,10, screenRect.size.width - 10, screenRect.size.height - 50)];
    milagePicker.delegate = self;
    milagePicker.showsSelectionIndicator = YES;
    
    [[self view] addSubview:milagePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark picker view delegate methods
// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
