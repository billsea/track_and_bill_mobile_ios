//
//  InlineDateAndNumberPickerViewController.m
//  trackandbill_ios
//
//  Created by William Seaman on 5/25/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import "InlineDateAndNumberPickerViewController.h"

@implementation InlineDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.datePicker = [[UIDatePicker alloc]init];
        self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.datePicker];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_datePicker]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_datePicker)]];
    }
    return self;
}

@end

@implementation InlineNumberPickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.numberPicker = [[UIPickerView alloc]init];
        self.numberPicker.translatesAutoresizingMaskIntoConstraints = NO;
        self.numberPicker.delegate = self;
        
        //add values to picker
        self.pickerData = [[NSMutableArray alloc] init];
        
        for(int i = 0; i<500; i++)
        {
            [_pickerData addObject:[NSString stringWithFormat:@"%d",i]];
        }

        
        [self addSubview:self.numberPicker];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_numberPicker]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_numberPicker)]];
    }
    return self;
}

#pragma mark picker view delegate methods
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}



@end

@interface InlineDateAndNumberPickerViewController ()
@property (nonatomic, strong, readwrite) NSIndexPath *datePickerIndexPath;
@property (nonatomic, strong, readwrite) NSIndexPath *numberPickerIndexPath;
@property (nonatomic, assign) CGFloat pickerCellRowHeight;
@property (nonatomic, assign) CGFloat numberPickerCellRowHeight;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) NSMutableDictionary *dates;   //key is NSIndexPath, value is NSDate
@property (nonatomic, strong) NSMutableDictionary *numbers;
//date picker
- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath;
- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath;
- (NSString *)stringFromIndexPath:(NSIndexPath *)indexPath;

//Number picker
- (NSIndexPath *)calculateIndexPathForNewNumberPicker:(NSIndexPath *)selectedIndexPathNumber;
- (void)showNewNumberPickerAtIndex:(NSIndexPath *)indexPath;
//- (NSString *)stringNumberFromIndexPath:(NSIndexPath *)indexPath;
@end

static NSString *DateCellIdentifier = @"DateCell";
static NSString *NumberCellIdentifier = @"NumberCell";

@implementation InlineDateAndNumberPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.tableViewStyle = style;
    }
    return self;
}

- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:self.tableViewStyle];
    self.view = self.tableView;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //date picker
    [self.tableView registerClass:[InlineDatePickerCell class] forCellReuseIdentifier:DateCellIdentifier];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    self.pickerCellRowHeight = datePicker.frame.size.height;
    
    
    //number picker
    [self.tableView registerClass:[InlineNumberPickerCell class] forCellReuseIdentifier:NumberCellIdentifier];
    UIPickerView *numberPicker = [[UIPickerView alloc]init];
    self.numberPickerCellRowHeight = numberPicker.frame.size.height;
    
    //set background image
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture_02.png"]]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getter/setters

- (NSMutableDictionary *)dates
{
    if (!_dates) {
        _dates = [[NSMutableDictionary alloc]init];
    }
    return _dates;
}

- (NSMutableDictionary *)numbers
{
    if (!_numbers) {
        _numbers = [[NSMutableDictionary alloc]init];
    }
    return _numbers;
}

- (void)setDatePickerPossibleIndexPaths:(NSArray *)datePickerPossibleIndexPaths
{
    if (_datePickerPossibleIndexPaths != datePickerPossibleIndexPaths) {
        _datePickerPossibleIndexPaths = datePickerPossibleIndexPaths;
    }
    
    _dates = nil;
    _datePickerIndexPath = nil;
}

- (void)setNumberPickerPossibleIndexPaths:(NSArray *)numberPickerPossibleIndexPaths
{
    if (_numberPickerPossibleIndexPaths != numberPickerPossibleIndexPaths) {
        _numberPickerPossibleIndexPaths = numberPickerPossibleIndexPaths;
    }
    
    _numbers = nil;
    _numberPickerIndexPath = nil;
}

#pragma mark - date picker

- (void)dateChanged:(UIDatePicker *)sender
{
    NSIndexPath *keyIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row -1 inSection:self.datePickerIndexPath.section];
    [self setDate:sender.date forIndexPath:keyIndexPath];
    
    [self.tableView reloadData];
}


Note: this is not being called - see readmeStatus.txt
- (void)numberPickerChanged:(UIPickerView *)sender
{
    
    UIPickerView * tmpPicker = sender;
    NSIndexPath *keyIndexPath = [NSIndexPath indexPathForRow:self.numberPickerIndexPath.row -1 inSection:self.numberPickerIndexPath.section];
    [self setNumber:[NSNumber numberWithInteger:[tmpPicker selectedRowInComponent:0]] forIndexPath:keyIndexPath];
    
    [self.tableView reloadData];
}


- (BOOL)datePickerIsShown
{
    return self.datePickerIndexPath != nil;
}

- (BOOL)numberPickerIsShown
{
    return self.numberPickerIndexPath != nil;
}

- (InlineDatePickerCell *)createPickerCell:(NSDate *)date
{
    
    InlineDatePickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
    
    cell.datePicker.datePickerMode =  UIDatePickerModeDate;
    
    if (!date) {
        date = [NSDate date];
    }
    
    [cell.datePicker setDate:date animated:NO];
    
    [cell.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (InlineNumberPickerCell *)createNumberPickerCell:(NSNumber *)dollars
{
    InlineNumberPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NumberCellIdentifier];
    
    
    if (!dollars) {
        dollars = 0;
    }
//    if (!cents) {
//        cents = 0;
//    }

    [cell.numberPicker selectRow:[dollars longValue] inComponent:0 animated:NO];
   // [cell.numberPicker selectRow:[cents longValue] inComponent:1 animated:NO];

    [[cell numberPicker]targetForAction:@selector(numberPickerChanged:)  withSender:cell];
    
    
    return cell;
}

- (void)hideExistingPicker {
    
    if (!self.datePickerIsShown) {
        return;
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:self.datePickerIndexPath.section]]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    self.datePickerIndexPath = nil;
    
    [self.tableView endUpdates];
}

- (void)hideExistingNumberPicker {
    
    if (!self.numberPickerIsShown) {
        return;
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.numberPickerIndexPath.row inSection:self.numberPickerIndexPath.section]]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    self.numberPickerIndexPath = nil;
    
    [self.tableView endUpdates];
}

- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath
{
    
    NSIndexPath *newIndexPath;
    
    if (([self datePickerIsShown]) && (self.datePickerIndexPath.row < selectedIndexPath.row)){
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:selectedIndexPath.section];
        
    }else {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row  inSection:selectedIndexPath.section];
        
    }
    
    return newIndexPath;
}

- (NSIndexPath *)calculateIndexPathForNewNumberPicker:(NSIndexPath *)selectedIndexPath
{
    
    NSIndexPath *newIndexPath;
    
    if (([self numberPickerIsShown]) && (self.numberPickerIndexPath.row < selectedIndexPath.row)){
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:selectedIndexPath.section];
        
    }else {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row  inSection:selectedIndexPath.section];
        
    }
    
    return newIndexPath;
}

- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (void)showNewNumberPickerAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [self.dates objectForKey:[self stringFromIndexPath:indexPath]];
    return date;
}

- (NSNumber *)numberForIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *nbr = [self.numbers objectForKey:[self stringFromIndexPath:indexPath]];
    return nbr;
}

- (void)setDate:(NSDate *)date forIndexPath:(NSIndexPath *)indexPath
{
    [self.dates setObject:date forKey:[self stringFromIndexPath:indexPath]];
}

- (void)setNumber:(NSNumber *)number forIndexPath:(NSIndexPath *)indexPath
{
    [self.numbers setObject:number forKey:[self stringFromIndexPath:indexPath]];
}


#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;

    if (self.datePickerIndexPath.section == section) {
        if([self datePickerIsShown])
        {
            (numberOfRows = 1);
        }
        else
        {
           (numberOfRows = 0);
        }

    }
    

    if(numberOfRows == 0)
    {
        if (self.numberPickerIndexPath.section == section) {
            [self numberPickerIsShown] ? (numberOfRows = 1) :  (numberOfRows = 0);
        }
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    //InlineDatePickerCell *cell = nil;
    
    if ([self datePickerIsShown] && ([self.datePickerIndexPath compare:indexPath] == NSOrderedSame)) {
        
        NSIndexPath *keyIndexPath = [NSIndexPath indexPathForRow:indexPath.row -1 inSection:indexPath.section];
        NSDate *date = [self dateForIndexPath:keyIndexPath];
        cell = (InlineDatePickerCell *)[self createPickerCell:date];
    }
    
   //number picker
   // InlineNumberPickerCell *numberCell = nil;
    
    
    else if ([self numberPickerIsShown] && ([self.numberPickerIndexPath compare:indexPath] == NSOrderedSame)) {
        
        NSIndexPath *keyIndexPath = [NSIndexPath indexPathForRow:indexPath.row -1 inSection:indexPath.section];
        NSNumber * nbr = [self numberForIndexPath:keyIndexPath];
        cell = (InlineNumberPickerCell * )[self createNumberPickerCell:nbr];
        
    }
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    
    if ([self datePickerIsShown] && ([self.datePickerIndexPath compare:indexPath] == NSOrderedSame)){
        rowHeight = self.pickerCellRowHeight;
    }
    
    if ([self numberPickerIsShown] && ([self.numberPickerIndexPath compare:indexPath] == NSOrderedSame)){
        rowHeight = self.pickerCellRowHeight;
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //date picker
    for (NSIndexPath *possibleIndexPath in self.datePickerPossibleIndexPaths) {
        if ([self datePickerIsShown]) {
            if (possibleIndexPath.section == indexPath.section && (indexPath.row == possibleIndexPath.row || indexPath.row == possibleIndexPath.row +1) ) {
                [self.tableView beginUpdates];
                
                [self hideExistingPicker];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                [self.tableView endUpdates];
                
                break;
            }
        }
        else if ([possibleIndexPath compare:indexPath] == NSOrderedSame) {
            [tableView beginUpdates];
            
            NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
            
            if ([self datePickerIsShown]){
                
                [self hideExistingPicker];
                
            }
            
            [self.view endEditing:YES];
            [self showNewPickerAtIndex:newPickerIndexPath];
            
            self.datePickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:newPickerIndexPath.section];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [tableView endUpdates];
            break;
        }
    }
    
    
    //number picker
    for (NSIndexPath *possibleIndexPath in self.numberPickerPossibleIndexPaths) {
        if ([self numberPickerIsShown]) {
            if (possibleIndexPath.section == indexPath.section && (indexPath.row == possibleIndexPath.row || indexPath.row == possibleIndexPath.row +1) ) {
                [self.tableView beginUpdates];
                
                [self hideExistingNumberPicker];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                [self.tableView endUpdates];
                
                break;
            }
        }
        else if ([possibleIndexPath compare:indexPath] == NSOrderedSame) {
            [tableView beginUpdates];
            
            NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewNumberPicker:indexPath];
            
            if ([self numberPickerIsShown]){
                
                [self hideExistingNumberPicker];
                
            }
            
            [self.view endEditing:YES];
            [self showNewNumberPickerAtIndex:newPickerIndexPath];
            
            NSLog(@"row:%ld",(long)newPickerIndexPath.row);
            
            self.numberPickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:newPickerIndexPath.section];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [tableView endUpdates];
            break;
        }
    }
}



#pragma mark - utils

- (NSIndexPath *)adjustedIndexPathForDatasourceAccess:(NSIndexPath *)indexPath
{
    NSIndexPath *keyIndexPath = indexPath;
    if ([self datePickerIsShown] &&
        (indexPath.section == self.datePickerIndexPath.section) &&
        (indexPath.row > self.datePickerIndexPath.row)) {
        keyIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    
    _Bool numShow = [self numberPickerIsShown];
    
    if ([self numberPickerIsShown] &&
        (indexPath.section == self.numberPickerIndexPath.section) &&
        (indexPath.row > self.numberPickerIndexPath.row)) {
        keyIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    
    return keyIndexPath;
}

//- (NSIndexPath *)adjustedNumberIndexPathForDatasourceAccess:(NSIndexPath *)indexPath
//{
//    NSIndexPath *keyIndexPath = indexPath;
//    if ([self numberPickerIsShown] &&
//        (indexPath.section == self.numberPickerIndexPath.section) &&
//        (indexPath.row > self.numberPickerIndexPath.row)) {
//        keyIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
//    }
//    return keyIndexPath;
//}

- (NSString *)stringFromIndexPath:(NSIndexPath *)indexPath
{
    NSString *iPathString = [NSString stringWithFormat:@"%li-%li", (long)indexPath.section, (long)indexPath.row];
    return iPathString;
}
//- (NSString *)stringNumberFromIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *iPathString = [NSString stringWithFormat:@"%li-%li", (long)indexPath.section, (long)indexPath.row];
//    return iPathString;
//}


@end
